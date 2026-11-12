import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_role.dart';
import '../models/city_model.dart';
import '../models/trade_model.dart';
import '../models/booking_model.dart';
import '../models/artisan_profile_model.dart';
import '../models/telemetry_model.dart';
import '../services/telemetry_service.dart';
import '../config/app_data_service.dart';
import '../config/app_constants.dart';

/// Current Active User Role (Customer vs Artisan)
final userRoleProvider = StateProvider<UserRole>((ref) => UserRole.customer);

/// Regional Launch Districts List (7 Districts: Nanded, Parbhani, Latur, Hingoli, Sambhajinagar, Nagpur, Nizamabad)
final regionalDistrictsProvider = FutureProvider<List<CityConfigModel>>((ref) async {
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
final nandedLocalitiesProvider = FutureProvider<List<LocalityModel>>((ref) async {
  final district = ref.watch(selectedDistrictProvider);
  return district.localities;
});

/// 10 Launch Trades List
final launchTradesProvider = FutureProvider<List<TradeModel>>((ref) async {
  return AppDataService.loadTrades();
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

/// Sample Nanded Verified Master Craftsmen
/// Sample Regional Corridor Verified Master Craftsmen
final topArtisansProvider = Provider<List<ArtisanProfileModel>>((ref) {
  final selectedDistrict = ref.watch(selectedDistrictProvider);
  return AppDataService.getArtisansForDistrict(selectedDistrict.cityId);
});

/// Artisan Profile by ID Provider
final artisanByIdProvider = Provider.family<ArtisanProfileModel, String>((ref, id) {
  final all = AppDataService.getAllSampleArtisans();
  return all.firstWhere(
    (a) => a.artisanId == id,
    orElse: () => all.first,
  );
});

/// Artisan Cleared Available Wallet Balance
final artisanWalletBalanceProvider = StateProvider<double>((ref) => 4620.00);

/// Artisan Duty Status Toggle (Active vs Paused)
final artisanDutyOnlineProvider = StateProvider<bool>((ref) => true);

/// 45-Second Radar Countdown Timer Notifier for Artisan
class RadarCountdownNotifier extends StateNotifier<int> {
  Timer? _timer;

  RadarCountdownNotifier() : super(AppConstants.radarCountdownSeconds);

  void startTimer() {
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

  void cancelTimer() {
    _timer?.cancel();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    state = AppConstants.radarCountdownSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final radarCountdownProvider =
    StateNotifierProvider.autoDispose<RadarCountdownNotifier, int>((ref) {
  return RadarCountdownNotifier();
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
    createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
  );
});

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
final artisanTelemetryStatusProvider =
    StateProvider<ArtisanTelemetryStatus>((ref) => const ArtisanTelemetryStatus());
