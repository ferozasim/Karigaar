import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_role.dart';
import '../models/city_model.dart';
import '../models/trade_model.dart';
import '../models/booking_model.dart';
import '../models/artisan_profile_model.dart';
import '../models/wallet_settlement_entry.dart';
import '../models/telemetry_model.dart';
import '../models/radar_broadcast_model.dart';
import '../models/audio_memo_model.dart';
import '../models/arrival_slot_model.dart';
import '../models/preventive_bundle_model.dart';
import 'package:karigaar_app/core/services/audio_service.dart';
import 'package:karigaar_app/core/services/api_service.dart';
import 'package:karigaar_app/core/services/telemetry_service.dart';
import 'package:karigaar_app/core/services/whatsapp_telephony_service.dart';
import 'package:karigaar_app/core/services/radar_broadcast_service.dart';
import '../config/app_data_service.dart';
import '../config/app_constants.dart';
import 'repository_providers.dart';

/// Current Active User Role (Customer vs Artisan)
final userRoleProvider = StateProvider<UserRole>((ref) => UserRole.customer);

/// Regional Launch Districts List (7 Districts: Nanded, Parbhani, Latur, Hingoli, Sambhajinagar, Nagpur, Nizamabad)
final regionalDistrictsProvider =
    FutureProvider<List<CityConfigModel>>((ref) async {
  return AppDataService.loadRegionalDistricts();
});

/// Currently Selected District (Defaults to Nanded)
final selectedDistrictProvider = StateProvider<CityConfigModel>((ref) {
  return AppDataService.defaultNandedConfig;
});

/// Pilot City / Active District Configuration
final pilotCityProvider = FutureProvider<CityConfigModel>((ref) async {
  return ref.watch(selectedDistrictProvider);
});

/// Active District Localities List Provider
final nandedLocalitiesProvider =
    FutureProvider<List<LocalityModel>>((ref) async {
  final district = ref.watch(selectedDistrictProvider);
  return district.localities;
});

/// 10 Launch Trades List
final launchTradesProvider = FutureProvider<List<TradeModel>>((ref) async {
  return AppDataService.loadTrades();
});

/// Curated Preventive Maintenance Bundles Catalog (F-08)
final curatedBundlesProvider = Provider<List<PreventiveBundleModel>>((ref) {
  return AppDataService.getCuratedBundles();
});

/// Selected Locality in Pilot City (Nanded)
final selectedLocalityProvider = StateProvider<LocalityModel>((ref) {
  return const LocalityModel(
    localityId: 'loc_anand_nagar',
    name: 'Anand Nagar',
    marathiName: 'आनंद नगर',
    pincode: '431602',
    center: GeoPointModel(latitude: 19.1685, longitude: 77.3090),
    radiusKm: 2.0,
    density: 'HIGH_RESIDENTIAL',
    emergencyHub: true,
  );
});

/// Partner Portal Language Toggle ('en' | 'hi' | 'mr')
final partnerLanguageProvider = StateProvider<String>((ref) => 'en');

/// Mutable District Directory Overrides/Additions synced from Partner Onboarding & Profile Edits.
/// Initially empty so default per-district sample counts remain unchanged until edited/registered.
class ArtisanDirectoryNotifier
    extends StateNotifier<Map<String, ArtisanProfileModel>> {
  ArtisanDirectoryNotifier(this._ref) : super(const {});

  final Ref _ref;

  void upsertArtisan(ArtisanProfileModel profile) {
    state = {
      ...state,
      profile.artisanId: profile,
    };
    unawaited(_persist(profile));
  }

  Future<void> _persist(ArtisanProfileModel profile) async {
    try {
      await _ref.read(artisanRepositoryProvider).updateProfile(profile);
    } catch (_) {
      // Repository errors must not discard a local profile edit. In cloud mode
      // the caller can surface retry UI once T-12 adds sync error telemetry.
    }
  }

  void reset() {
    state = const {};
  }
}

final artisanDirectoryOverridesProvider = StateNotifierProvider<
    ArtisanDirectoryNotifier, Map<String, ArtisanProfileModel>>((ref) {
  return ArtisanDirectoryNotifier(ref);
});

/// Sample Regional Corridor Verified Master Craftsmen + Live Synced Partner Overrides
final topArtisansProvider = Provider<List<ArtisanProfileModel>>((ref) {
  final selectedDistrict = ref.watch(selectedDistrictProvider);
  final overrides = ref.watch(artisanDirectoryOverridesProvider);
  final baseList =
      AppDataService.getArtisansForDistrict(selectedDistrict.cityId);

  if (overrides.isEmpty) {
    return baseList;
  }

  final merged = <ArtisanProfileModel>[];
  final seenIds = <String>{};

  for (final artisan in baseList) {
    final override = overrides[artisan.artisanId];
    if (override != null) {
      if (override.cityId == selectedDistrict.cityId) {
        merged.add(override);
      }
      seenIds.add(artisan.artisanId);
    } else {
      merged.add(artisan);
      seenIds.add(artisan.artisanId);
    }
  }

  for (final entry in overrides.values) {
    if (!seenIds.contains(entry.artisanId) &&
        entry.cityId == selectedDistrict.cityId) {
      merged.add(entry);
    }
  }

  return merged;
});

/// Artisan Profile by ID Provider (checks live directory overrides & current partner first)
final artisanByIdProvider =
    Provider.family<ArtisanProfileModel, String>((ref, id) {
  final overrides = ref.watch(artisanDirectoryOverridesProvider);
  if (overrides.containsKey(id)) {
    return overrides[id]!;
  }
  final currentPartner = ref.watch(currentArtisanProfileProvider);
  if (currentPartner.artisanId == id) {
    return currentPartner;
  }
  final all = AppDataService.getAllSampleArtisans();
  return all.firstWhere(
    (a) => a.artisanId == id,
    orElse: () => all.first,
  );
});

/// Artisan Cleared Available Wallet Balance
final artisanWalletBalanceProvider = StateProvider<double>((ref) => 4620.00);

/// Artisan Duty Status Toggle (Active vs Paused)
final artisanDutyOnlineProvider = StateProvider<bool>((ref) {
  return true;
});

/// Karigaar Radar Broadcast Broker Service Provider (Contract 2)
final radarBroadcastServiceProvider =
    Provider<KarigaarRadarBroadcastService>((ref) {
  final service = KarigaarRadarBroadcastService.instance;
  final duty = ref.watch(artisanDutyOnlineProvider);
  service.setArtisanDutyOnline(duty);
  return service;
});

/// Active Incoming Radar Broadcast State
class ActiveRadarBroadcastNotifier
    extends StateNotifier<JobRadarBroadcastModel?> {
  final KarigaarRadarBroadcastService _service;
  StreamSubscription<JobRadarBroadcastModel?>? _sub;

  ActiveRadarBroadcastNotifier(this._service)
      : super(_service.activeBroadcast) {
    _sub = _service.broadcastStream.listen((broadcast) {
      state = broadcast;
    });
  }

  void setBroadcast(JobRadarBroadcastModel? broadcast) {
    state = broadcast;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final activeRadarBroadcastProvider = StateNotifierProvider<
    ActiveRadarBroadcastNotifier, JobRadarBroadcastModel?>((ref) {
  final service = ref.watch(radarBroadcastServiceProvider);
  return ActiveRadarBroadcastNotifier(service);
});

/// Current Search Radius Tier Notifier
class RadarRadiusTierNotifier extends StateNotifier<RadarRadiusTier> {
  final KarigaarRadarBroadcastService _service;
  StreamSubscription<JobRadarBroadcastModel?>? _sub;

  RadarRadiusTierNotifier(this._service) : super(_service.currentRadiusTier) {
    _sub = _service.broadcastStream.listen((broadcast) {
      if (broadcast != null) {
        state = broadcast.radiusTier;
      }
    });
  }

  void setTier(RadarRadiusTier tier) {
    state = tier;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final radarRadiusTierProvider =
    StateNotifierProvider<RadarRadiusTierNotifier, RadarRadiusTier>((ref) {
  final service = ref.watch(radarBroadcastServiceProvider);
  return RadarRadiusTierNotifier(service);
});

/// Latest Unfulfilled Expiry / Escalation Event Notifier
class RadarUnfulfilledNotifier extends StateNotifier<RadarUnfulfilledEvent?> {
  final KarigaarRadarBroadcastService _service;
  StreamSubscription<RadarUnfulfilledEvent>? _sub;

  RadarUnfulfilledNotifier(this._service) : super(null) {
    _sub = _service.unfulfilledStream.listen((event) {
      state = event;
    });
  }

  void clear() {
    state = null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final radarUnfulfilledEventProvider =
    StateNotifierProvider<RadarUnfulfilledNotifier, RadarUnfulfilledEvent?>(
        (ref) {
  final service = ref.watch(radarBroadcastServiceProvider);
  return RadarUnfulfilledNotifier(service);
});

/// 45-Second Radar Countdown Timer Notifier for Artisan
class RadarCountdownNotifier extends StateNotifier<int> {
  final KarigaarRadarBroadcastService? _service;
  StreamSubscription<int>? _sub;
  Timer? _timer;

  RadarCountdownNotifier([this._service])
      : super(
            _service?.currentCountdown ?? AppConstants.radarCountdownSeconds) {
    if (_service != null) {
      _sub = _service.countdownStream.listen((count) {
        state = count;
      });
    }
  }

  void startTimer() {
    if (_service != null) {
      if (_service.activeBroadcast == null) {
        _service.startBroadcast(
            KarigaarRadarBroadcastService.createSampleBroadcast());
      } else {
        _service.startBroadcast(_service.activeBroadcast!);
      }
    } else {
      _timer?.cancel();
      state = AppConstants.radarCountdownSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (state > 0) {
          state--;
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
    _service?.cancelTimer();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _service?.cancelTimer();
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    state = AppConstants.radarCountdownSeconds;
    _service?.reset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _sub?.cancel();
    _service?.cancelTimer();
    super.dispose();
  }
}

final radarCountdownProvider =
    StateNotifierProvider.autoDispose<RadarCountdownNotifier, int>((ref) {
  final service = ref.watch(radarBroadcastServiceProvider);
  return RadarCountdownNotifier(service);
});

/// Audio Recording & Preview Service Provider (Ticket T-08 F-10)
final audioServiceProvider = Provider<KarigaarAudioService>((ref) {
  return KarigaarAudioService.instance;
});

/// Customer-recorded Audio Memo for the active scoping session
final recordedAudioMemoProvider = StateProvider<AudioMemoModel?>((ref) => null);

/// Selected Arrival Date for Service Scoping (Defaults to Today)
final selectedArrivalDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Selected Arrival Slot for Service Scoping (Ticket T-08 F-11)
final selectedArrivalSlotProvider = StateProvider<ScheduledArrivalSlot?>((ref) {
  final now = DateTime.now();
  final defaultSlots = ArrivalSlotModel.defaultSlotsForDate(now);
  // Default to first available slot (or morning if available)
  return defaultSlots.firstWhere(
    (s) => s.isAvailable && !s.isEmergency,
    orElse: () => defaultSlots.first,
  );
});

/// Available Arrival Slots for Selected Date
final arrivalSlotsForDateProvider =
    FutureProvider.family<List<ScheduledArrivalSlot>, DateTime>(
        (ref, date) async {
  return ArrivalSlotModel.defaultSlotsForDate(date);
});

/// Active Live Booking State
final activeBookingProvider = StateProvider<BookingModel?>((ref) {
  return BookingModel(
    bookingId: 'BK_NANDED_8821',
    customerId: 'cust_01',
    customerName: 'Asim Farooqui',
    customerPhone: '+919822199882',
    assignedArtisanId: 'art_nanded_01',
    assignedArtisanName: 'Ganesh Kadam',
    assignedArtisanPhone: '+919822012345',
    tradeId: 'trade_electrician',
    tradeName: 'Electrician',
    localityId: 'loc_anand_nagar',
    localityName: 'Anand Nagar, Nanded',
    address: 'Plot 14, Near Water Tank, Anand Nagar',
    status: BookingStatus.artisanEnRoute,
    startOtp: '4921',
    completionOtp: '7294',
    baseInspectionFee: 199,
    laborFee: 249,
    safetyShieldFee: 29,
    parts: const [
      BillPartItem(
        id: 'part_01',
        name: 'Havells 32A Double Pole MCB',
        unitPrice: 380,
        quantity: 1,
        isApproved: true,
      ),
    ],
    audioMemoUrl: 'https://cdn.karigaar.in/audio/memo_8821.aac',
    audioMemoDurationSeconds: 14,
    audioMemoWaveform: const [
      0.15,
      0.42,
      0.68,
      0.85,
      0.92,
      0.74,
      0.61,
      0.88,
      0.95,
      0.72,
      0.54,
      0.38,
      0.22,
      0.10
    ],
    audioMemoTranscript:
        'MCB switch sparks when turning on AC. Need 32A replacement.',
    scheduledDate: DateTime.now(),
    scheduledSlot: 'Morning (9:00 AM - 12:00 PM)',
    scheduledSlotId: 'slot_morning',
    isEmergencyDispatch: false,
    createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
  );
});

/// Mirrors the active workflow booking into the selected T-11 repository.
/// Existing screen code can retain its StateProvider API while the booking is
/// now persisted in local mode and ready for Firestore when Firebase is live.
final activeBookingRepositoryMirrorProvider = Provider<void>((ref) {
  ref.listen<BookingModel?>(activeBookingProvider, (previous, next) {
    if (next == null) return;
    unawaited(_saveActiveBooking(ref, next));
  }, fireImmediately: true);
});

Future<void> _saveActiveBooking(Ref ref, BookingModel booking) async {
  try {
    await ref.read(bookingRepositoryProvider).save(booking);
  } catch (_) {
    // Keep the interactive workflow usable offline. Repository streams retain
    // the last consistent state and a later T-12 sync layer will retry cloud
    // failures with an idempotency key.
  }
}

/// Karigaar Telemetry & Geospatial Service Provider (Contract 3)
final telemetryServiceProvider = Provider<KarigaarTelemetryService>((ref) {
  final service = KarigaarTelemetryService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Live Tracking Feed Provider streaming real-time telemetry updates for a booking
final liveTrackingFeedProvider =
    StreamProvider.family<LiveTrackingFeed, String>((ref, bookingId) {
  final service = ref.watch(telemetryServiceProvider);
  return service.subscribeToLiveTracking(bookingId);
});

/// Artisan En-Route Telemetry HUD Status Provider (Foreground vs Background toggle)
final artisanTelemetryStatusProvider = StateProvider<ArtisanTelemetryStatus>(
    (ref) => const ArtisanTelemetryStatus());

/// WhatsApp & Telephony Cloud Proxy Service Provider (Ticket T-06)
final whatsappTelephonyServiceProvider =
    Provider<KarigaarWhatsAppTelephonyService>((ref) {
  return KarigaarWhatsAppTelephonyService.instance;
});

/// Feature F-35: Contact Unlock State for Path A Monetization
class ContactUnlockState {
  final Set<String> unlockedArtisanIds;
  final bool hasDirectoryPass;

  const ContactUnlockState({
    this.unlockedArtisanIds = const {},
    this.hasDirectoryPass = false,
  });

  bool isUnlocked(String artisanId) =>
      hasDirectoryPass || unlockedArtisanIds.contains(artisanId);

  ContactUnlockState copyWith({
    Set<String>? unlockedArtisanIds,
    bool? hasDirectoryPass,
  }) {
    return ContactUnlockState(
      unlockedArtisanIds: unlockedArtisanIds ?? this.unlockedArtisanIds,
      hasDirectoryPass: hasDirectoryPass ?? this.hasDirectoryPass,
    );
  }
}

class ContactUnlockNotifier extends StateNotifier<ContactUnlockState> {
  ContactUnlockNotifier() : super(const ContactUnlockState());

  void unlockPayPerLead(String artisanId) {
    state = state.copyWith(
      unlockedArtisanIds: {...state.unlockedArtisanIds, artisanId},
    );
  }

  void activateDirectoryPass() {
    state = state.copyWith(hasDirectoryPass: true);
  }

  void reset() {
    state = const ContactUnlockState();
  }
}

final contactUnlockProvider =
    StateNotifierProvider<ContactUnlockNotifier, ContactUnlockState>((ref) {
  return ContactUnlockNotifier();
});

/// Feature F-24: Guild Elite Partner Subscription Provider
final guildEliteSubscriptionProvider = StateProvider<bool>((ref) => false);

/// Default authenticated Partner Profile for `/artisan/profile` & live directory sync (Ticket T-10)
const ArtisanProfileModel defaultCurrentPartnerProfile = ArtisanProfileModel(
  artisanId: 'art_partner_self',
  guildId: 'KG-ND-2026-089',
  name: 'Ramesh Chandra Sharma',
  phone: '+919822012345',
  primaryTradeId: 'trade_electrician',
  tradeTitle: 'Master Electrician',
  roleType: KarigaarRoleType.headMistry,
  yearsExperience: 8,
  experienceTierLabel: '5 - 10 Years',
  rating: 4.9,
  reviewCount: 142,
  distanceKm: 1.0,
  policeVerified: true,
  toolAuditPassed: true,
  aadhaarVerified: true,
  kycBadgeLabel: 'Aadhaar & Police Verified',
  tier: GuildTier.masterGuildsman,
  isGuildElite: false,
  bio:
      'Aadhaar & police verified Master Wireman specializing in 3-phase DB wiring, inverter backups & MCB fault diagnostics.',
  inspectionFee: 249,
  dailyDihadiRate: 900,
  workMode: 'Both Visit & Daily Dihadi',
  cityId: 'city_nanded_01',
  localityId: 'loc_anand_nagar',
  serviceLocalityIds: ['loc_anand_nagar', 'loc_vazirabad', 'loc_cidco'],
  specialties: [
    '3-Phase Wiring',
    'Inverter Setup',
    'MCB Fault Diagnostics',
    'Concealed Copper Conduit',
    'Earthing Audit',
  ],
  verifiedTools: [
    'True-RMS Multimeter',
    '1000V Insulated Toolset',
    'Rotary Hammer Drill',
    'Canvas Drop-Cloth & Sawdust Vacuum',
  ],
  portfolioItems: [
    PortfolioWorkItem(
      id: 'pf_01',
      title: '32A 3-Phase Distribution Board',
      location: 'Anand Nagar, Nanded',
      badge: 'Commercial Grade',
      duration: 'Completed in 3 hrs',
    ),
    PortfolioWorkItem(
      id: 'pf_02',
      title: 'Pure Sine Inverter & Battery Hub',
      location: 'Vazirabad, Nanded',
      badge: 'Zero Downtime',
      duration: 'Completed in 2 hrs',
    ),
    PortfolioWorkItem(
      id: 'pf_03',
      title: 'Concealed Conduit & Earthing Pit',
      location: 'CIDCO New Nanded',
      badge: 'Laser Aligned',
      duration: 'Completed in 1 Day',
    ),
  ],
  isOnline: true,
  totalJobsCompleted: 142,
  cleanlinessScore: 4.9,
  onTimeArrivalPercent: 98,
  bankName: 'HDFC Bank',
  maskedAccountNumber: '•••• 2104',
  ifscCode: 'HDFC0002104',
  upiId: 'ramesh.karigaar@okaxis',
  securityReserveAmount: 2000.0,
);

/// Notifier managing the Partner's own profile & syncing edits live to district directory
class CurrentArtisanProfileNotifier extends StateNotifier<ArtisanProfileModel> {
  final Ref _ref;

  CurrentArtisanProfileNotifier(this._ref)
      : super(
          _ref.read(guildEliteSubscriptionProvider)
              ? defaultCurrentPartnerProfile.copyWith(
                  isGuildElite: true,
                  tier: GuildTier.guildElite,
                )
              : defaultCurrentPartnerProfile,
        ) {
    _ref.listen<bool>(guildEliteSubscriptionProvider, (prev, next) {
      if (state.isGuildElite != next) {
        final updated = state.copyWith(
          isGuildElite: next,
          tier: next ? GuildTier.guildElite : GuildTier.masterGuildsman,
        );
        state = updated;
        _syncToDirectory(updated);
      }
    });
  }

  void _syncToDirectory(ArtisanProfileModel updated) {
    _ref
        .read(artisanDirectoryOverridesProvider.notifier)
        .upsertArtisan(updated);
  }

  void updateProfileAndRateCard({
    String? name,
    String? primaryTradeId,
    String? tradeTitle,
    KarigaarRoleType? roleType,
    int? yearsExperience,
    String? experienceTierLabel,
    int? inspectionFee,
    int? dailyDihadiRate,
    String? workMode,
    String? cityId,
    String? localityId,
    List<String>? serviceLocalityIds,
    List<String>? specialties,
    String? bio,
  }) {
    final updated = state.copyWith(
      name: name,
      primaryTradeId: primaryTradeId,
      tradeTitle: tradeTitle,
      roleType: roleType,
      yearsExperience: yearsExperience,
      experienceTierLabel: experienceTierLabel,
      inspectionFee: inspectionFee,
      dailyDihadiRate: dailyDihadiRate,
      workMode: workMode,
      cityId: cityId,
      localityId: localityId ??
          (serviceLocalityIds != null && serviceLocalityIds.isNotEmpty
              ? serviceLocalityIds.first
              : state.localityId),
      serviceLocalityIds: serviceLocalityIds,
      specialties: specialties,
      bio: bio,
    );
    state = updated;
    _syncToDirectory(updated);
  }

  void addPortfolioPhoto(PortfolioWorkItem item) {
    final updated = state.copyWith(
      portfolioItems: [item, ...state.portfolioItems],
    );
    state = updated;
    _syncToDirectory(updated);
  }

  void toggleGuildElite(bool active) {
    final updated = state.copyWith(
      isGuildElite: active,
      tier: active ? GuildTier.guildElite : GuildTier.masterGuildsman,
    );
    state = updated;
    _ref.read(guildEliteSubscriptionProvider.notifier).state = active;
    _syncToDirectory(updated);
  }

  void syncFromRegistration({
    required String name,
    required String phone,
    required String primaryTradeId,
    required String tradeTitle,
    required KarigaarRoleType roleType,
    required String experienceTierLabel,
    int? yearsExperience,
    int? inspectionFee,
    int? dailyDihadiRate,
    String? workMode,
    required String cityId,
    required String localityId,
    List<String>? serviceLocalityIds,
    List<String>? specialties,
    List<String>? verifiedTools,
    String? bankName,
    String? maskedAccountNumber,
    String? ifscCode,
    String? upiId,
    String? bio,
  }) {
    final updated = state.copyWith(
      name: name,
      phone: phone,
      primaryTradeId: primaryTradeId,
      tradeTitle: tradeTitle,
      roleType: roleType,
      experienceTierLabel: experienceTierLabel,
      yearsExperience: yearsExperience,
      inspectionFee: inspectionFee,
      dailyDihadiRate: dailyDihadiRate,
      workMode: workMode,
      cityId: cityId,
      localityId: localityId,
      serviceLocalityIds: serviceLocalityIds ?? [localityId],
      specialties: specialties,
      verifiedTools: verifiedTools,
      bankName: bankName,
      maskedAccountNumber: maskedAccountNumber,
      ifscCode: ifscCode,
      upiId: upiId,
      bio: bio,
    );
    state = updated;
    _syncToDirectory(updated);
  }
}

final currentArtisanProfileProvider =
    StateNotifierProvider<CurrentArtisanProfileNotifier, ArtisanProfileModel>(
        (ref) {
  return CurrentArtisanProfileNotifier(ref);
});

/// Completed Job Settlement Ledger & IMPS Withdrawal History (Ticket T-10)
class WalletSettlementLedgerNotifier
    extends StateNotifier<List<WalletSettlementEntry>> {
  WalletSettlementLedgerNotifier() : super(_initialLedgerEntries);

  static const List<WalletSettlementEntry> _initialLedgerEntries = [
    WalletSettlementEntry(
      id: 'stl_01',
      bookingId: 'BK_NANDED_8819',
      jobTitle: '3-Phase MCB Distribution Box Upgrade',
      customerLocality: 'Anand Nagar, Nanded',
      completedAtLabel: 'Today, 2:15 PM',
      laborAmount: 900.0,
      partsPassThrough: 640.0,
      commissionRate: 0.05,
      commissionAmount: 45.0,
      netPayout: 1495.0,
      isCredit: true,
      isImpsWithdrawal: false,
      statusLabel: 'Settled (5% Elite)',
      isToday: true,
      isThisWeek: true,
    ),
    WalletSettlementEntry(
      id: 'stl_02',
      bookingId: 'BK_NANDED_8814',
      jobTitle: 'Inverter Battery Backup & Relay Fix',
      customerLocality: 'Vazirabad, Nanded',
      completedAtLabel: 'Today, 10:30 AM',
      laborAmount: 400.0,
      partsPassThrough: 0.0,
      commissionRate: 0.05,
      commissionAmount: 20.0,
      netPayout: 380.0,
      isCredit: true,
      isImpsWithdrawal: false,
      statusLabel: 'Settled (5% Elite)',
      isToday: true,
      isThisWeek: true,
    ),
    WalletSettlementEntry(
      id: 'stl_03',
      bookingId: 'BK_NANDED_8792',
      jobTitle: 'Concealed Copper Conduit & Earthing',
      customerLocality: 'CIDCO New Nanded',
      completedAtLabel: 'Yesterday, 5:45 PM',
      laborAmount: 1500.0,
      partsPassThrough: 820.0,
      commissionRate: 0.12,
      commissionAmount: 180.0,
      netPayout: 2140.0,
      isCredit: true,
      isImpsWithdrawal: false,
      statusLabel: 'Settled (12% Pro)',
      isToday: false,
      isThisWeek: true,
    ),
    WalletSettlementEntry(
      id: 'stl_04',
      bookingId: 'PAYOUT_8801',
      jobTitle: 'Instant IMPS Transfer to HDFC •••• 2104',
      customerLocality: 'Guild Vault Payout',
      completedAtLabel: '2 days ago',
      laborAmount: 0.0,
      partsPassThrough: 0.0,
      commissionRate: 0.0,
      commissionAmount: 0.0,
      netPayout: 2100.0,
      isCredit: false,
      isImpsWithdrawal: true,
      statusLabel: 'IMPS Transferred',
      bankReference: 'RRN6194028810',
      isToday: false,
      isThisWeek: true,
    ),
    WalletSettlementEntry(
      id: 'stl_05',
      bookingId: 'BK_NANDED_8760',
      jobTitle: 'Smart Sub-Meter & Voltage Stabilizer',
      customerLocality: 'Taroda Naka, Nanded',
      completedAtLabel: '3 days ago',
      laborAmount: 1000.0,
      partsPassThrough: 450.0,
      commissionRate: 0.12,
      commissionAmount: 120.0,
      netPayout: 1330.0,
      isCredit: true,
      isImpsWithdrawal: false,
      statusLabel: 'Settled (12% Pro)',
      isToday: false,
      isThisWeek: true,
    ),
  ];

  void recordImpsWithdrawal({
    required double amount,
    required String bankLabel,
    required String bankReference,
  }) {
    final entry = WalletSettlementEntry(
      id: 'imps_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: 'PAYOUT_${DateTime.now().millisecondsSinceEpoch % 10000}',
      jobTitle: 'Instant IMPS Transfer to $bankLabel',
      customerLocality: 'Guild Vault Payout',
      completedAtLabel: 'Just now',
      laborAmount: 0.0,
      partsPassThrough: 0.0,
      commissionRate: 0.0,
      commissionAmount: 0.0,
      netPayout: amount,
      isCredit: false,
      isImpsWithdrawal: true,
      statusLabel: 'IMPS Transferred',
      bankReference: bankReference,
      isToday: true,
      isThisWeek: true,
    );
    state = [entry, ...state];
  }

  void recordJobSettlement(WalletSettlementEntry entry) {
    state = [entry, ...state];
  }
}

final walletSettlementLedgerProvider = StateNotifierProvider<
    WalletSettlementLedgerNotifier, List<WalletSettlementEntry>>((ref) {
  return WalletSettlementLedgerNotifier();
});

/// Demo reserve ledger in paise; live accounting is authoritative on backend.
class WarrantyReserveNotifier extends StateNotifier<int> {
  WarrantyReserveNotifier() : super(1250000);

  void recordPlatformLaborTakeRate(int takeRatePaise) {
    final contribution =
        KarigaarApiService.instance.calculateWarrantyReserveContributionPaise(
      takeRatePaise,
    );
    state += contribution;
  }
}

final warrantyReservePoolProvider =
    StateNotifierProvider<WarrantyReserveNotifier, int>(
  (ref) => WarrantyReserveNotifier(),
);

final warrantyClaimsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => const []);

final postJobCsatProvider =
    StateProvider<Map<String, Map<String, dynamic>>>((ref) => const {});

/// Derived Today's Earnings from Completed Job Credits
final todayEarningsProvider = Provider<double>((ref) {
  final entries = ref.watch(walletSettlementLedgerProvider);
  return entries
      .where((e) => e.isCredit && e.isToday)
      .fold<double>(0.0, (sum, e) => sum + e.netPayout);
});

/// Derived Weekly Earnings from Completed Job Credits
final weeklyEarningsProvider = Provider<double>((ref) {
  final entries = ref.watch(walletSettlementLedgerProvider);
  return entries
      .where((e) => e.isCredit && e.isThisWeek)
      .fold<double>(0.0, (sum, e) => sum + e.netPayout);
});
