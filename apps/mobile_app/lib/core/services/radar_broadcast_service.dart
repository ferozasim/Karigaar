import 'dart:async';
import '../models/city_model.dart';
import '../models/radar_broadcast_model.dart';
import 'api_service.dart';

/// Pure Dart stream-based broadcast broker and automated cascading engine.
/// Conforms strictly to PROJECT.md Contract 2.
class KarigaarRadarBroadcastService {
  static KarigaarRadarBroadcastService? _instance;
  static KarigaarRadarBroadcastService get instance =>
      _instance ??= KarigaarRadarBroadcastService();
  static set instance(KarigaarRadarBroadcastService service) => _instance = service;

  final KarigaarApiService _apiService;

  final _broadcastController = StreamController<JobRadarBroadcastModel?>.broadcast();
  final _unfulfilledController = StreamController<RadarUnfulfilledEvent>.broadcast();
  final _countdownController = StreamController<int>.broadcast();

  Timer? _timer;
  JobRadarBroadcastModel? _activeBroadcast;
  RadarRadiusTier _currentRadiusTier = RadarRadiusTier.tier1Local;
  int _currentCountdown = 45;
  bool _isDutyOnline = true;

  KarigaarRadarBroadcastService({KarigaarApiService? apiService})
      : _apiService = apiService ?? KarigaarApiService.instance;

  /// Stream of active broadcast updates.
  Stream<JobRadarBroadcastModel?> get broadcastStream => _broadcastController.stream;

  /// Stream of unfulfilled fallback events (e.g. radius escalation alerts).
  Stream<RadarUnfulfilledEvent> get unfulfilledStream => _unfulfilledController.stream;

  /// Stream of countdown ticks from 45 down to 0.
  Stream<int> get countdownStream => _countdownController.stream;

  /// Current active broadcast, if any.
  JobRadarBroadcastModel? get activeBroadcast => _activeBroadcast;

  /// Current search radius tier (Tier 1: 2 km vs Tier 2: 6 km).
  RadarRadiusTier get currentRadiusTier => _currentRadiusTier;

  /// Current countdown remaining in seconds.
  int get currentCountdown => _currentCountdown;

  /// Whether partner is online and ready to receive broadcasts.
  bool get isDutyOnline => _isDutyOnline;

  /// Whether a broadcast countdown is actively ticking.
  bool get isBroadcasting =>
      _timer != null &&
      _activeBroadcast != null &&
      _activeBroadcast!.state == RadarDispatchState.broadcastActive;

  /// Toggles partner duty online/offline.
  /// When offline, incoming broadcasts are suppressed or kept in standby.
  void setArtisanDutyOnline(bool isOnline) {
    _isDutyOnline = isOnline;
    if (!isOnline) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Initiates or updates a broadcast with automated 45s cascading.
  void startBroadcast(JobRadarBroadcastModel broadcast) {
    if (!_isDutyOnline) {
      _activeBroadcast = broadcast.copyWith(state: RadarDispatchState.pending);
      _broadcastController.add(_activeBroadcast);
      return;
    }

    _timer?.cancel();
    _currentRadiusTier = broadcast.radiusTier;
    _activeBroadcast = broadcast.copyWith(state: RadarDispatchState.broadcastActive);
    _currentCountdown = broadcast.acceptanceCountdownSeconds;
    _broadcastController.add(_activeBroadcast);
    _countdownController.add(_currentCountdown);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onTick();
    });
  }

  void _onTick() {
    if (_currentCountdown > 0) {
      _currentCountdown--;
      _countdownController.add(_currentCountdown);
    }
    if (_currentCountdown <= 0) {
      _handleCountdownExpiry();
    }
  }

  void _handleCountdownExpiry() {
    if (_activeBroadcast == null) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    if (_currentRadiusTier == RadarRadiusTier.tier1Local) {
      // Auto-Cascade from Tier 1 (2.0 km) to Tier 2 (6.0 km)
      _currentRadiusTier = RadarRadiusTier.tier2Expanded;
      final unfulfilledEvent = RadarUnfulfilledEvent(
        broadcastId: _activeBroadcast!.broadcastId,
        bookingId: _activeBroadcast!.bookingId,
        state: 'DISPATCH_UNFULFILLED',
        reason: 'RADAR_45S_TIMER_EXPIRED_NO_ACCEPTANCE',
        fallbackAction: 'AUTO_RETRY_EXPANDED_RADIUS',
        expandedRadiusKm: 6.0,
        customerNotification: 'Searching expanded radius (6 km) for available Master Electricians.',
        timestamp: DateTime.now().toUtc(),
      );
      _unfulfilledController.add(unfulfilledEvent);

      _activeBroadcast = _activeBroadcast!.copyWith(
        radiusTier: RadarRadiusTier.tier2Expanded,
      );
      _broadcastController.add(_activeBroadcast);

      // Re-arm 45-second circular timer for Tier 2
      _currentCountdown = 45;
      _countdownController.add(_currentCountdown);
    } else {
      // Tier 2 (6.0 km) expired without acceptance -> Final unfulfilled
      _timer?.cancel();
      _timer = null;
      final finalUnfulfilledEvent = RadarUnfulfilledEvent(
        broadcastId: _activeBroadcast!.broadcastId,
        bookingId: _activeBroadcast!.bookingId,
        state: 'DISPATCH_UNFULFILLED',
        reason: 'RADAR_45S_TIMER_EXPIRED_NO_ACCEPTANCE',
        fallbackAction: 'MANUAL_RETRY_OR_ESCALATE',
        expandedRadiusKm: 6.0,
        customerNotification: 'No available Master Electricians found in 6 km corridor. Tap to retry.',
        timestamp: DateTime.now().toUtc(),
      );
      _unfulfilledController.add(finalUnfulfilledEvent);

      _activeBroadcast = _activeBroadcast!.copyWith(
        state: RadarDispatchState.unfulfilled,
      );
      _broadcastController.add(_activeBroadcast);
    }
  }

  /// Claims active broadcast, cancels timer, and returns navigation coordinates per Contract 2.
  Future<BroadcastAcceptResult> acceptBroadcastJob({
    required String broadcastId,
    required String artisanId,
    GeoPointModel? currentLocation,
    double? latitude,
    double? longitude,
  }) async {
    _timer?.cancel();
    _timer = null;

    final bookingId = _activeBroadcast?.bookingId ?? 'BK_NANDED_8821';
    final lat = latitude ?? currentLocation?.latitude ?? 19.1383;
    final lng = longitude ?? currentLocation?.longitude ?? 77.3210;

    final response = await _apiService.acceptJob(
      bookingId: bookingId,
      broadcastId: broadcastId,
      artisanId: artisanId,
      latitude: lat,
      longitude: lng,
    );

    final result = BroadcastAcceptResult.fromJson(response);

    _activeBroadcast = _activeBroadcast?.copyWith(
      state: RadarDispatchState.claimed,
    );
    _broadcastController.add(_activeBroadcast);

    return result;
  }

  /// Deterministic test helper to inject an incoming broadcast.
  void simulateIncomingBroadcast(JobRadarBroadcastModel broadcast) {
    startBroadcast(broadcast);
  }

  /// Deterministic test helper to tick timer down.
  void simulateCountdownTick([int? remainingSeconds]) {
    if (remainingSeconds != null) {
      _currentCountdown = remainingSeconds;
    } else if (_currentCountdown > 0) {
      _currentCountdown--;
    }
    _countdownController.add(_currentCountdown);
    if (_currentCountdown <= 0) {
      _handleCountdownExpiry();
    }
  }

  /// Deterministic test helper to immediately trigger expiry.
  void simulateExpiry() {
    _currentCountdown = 0;
    _countdownController.add(0);
    _handleCountdownExpiry();
  }

  /// Resets broker state for a clean test run.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _activeBroadcast = null;
    _currentRadiusTier = RadarRadiusTier.tier1Local;
    _currentCountdown = 45;
    _isDutyOnline = true;
    _broadcastController.add(null);
    _countdownController.add(45);
  }

  /// Cancels active periodic countdown timer without clearing broadcast state.
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes internal resources.
  void dispose() {
    _timer?.cancel();
    _broadcastController.close();
    _unfulfilledController.close();
    _countdownController.close();
  }

  /// Helper generating sample Nanded broadcast adhering to Contract 2.
  static JobRadarBroadcastModel createSampleBroadcast({
    String broadcastId = 'bc_998124',
    String bookingId = 'BK_NANDED_8821',
    String category = 'ELECTRICIAN',
    bool isEmergency = true,
    String title = 'Emergency Short Circuit & MCB Trip',
    double distanceKm = 1.2,
    double guaranteedBase = 480.0,
    RadarRadiusTier radiusTier = RadarRadiusTier.tier1Local,
  }) {
    return JobRadarBroadcastModel(
      broadcastId: broadcastId,
      bookingId: bookingId,
      category: category,
      isEmergency: isEmergency,
      title: title,
      customer: RadarCustomerInfo(
        firstName: 'Asim Ji',
        locality: 'Anand Nagar, Nanded',
        distanceKm: distanceKm,
        reachTimeMinutes: 8,
      ),
      payout: RadarPayoutInfo(
        currency: 'INR',
        guaranteedBase: guaranteedBase,
        partsReimbursementAllowed: true,
      ),
      attachments: const RadarAttachments(
        photoUrl: 'https://cdn.karigaar.in/jobs/BK_NANDED_8821/mcb_spark.jpg',
        voiceMemoUrl: 'https://cdn.karigaar.in/jobs/BK_NANDED_8821/voice_14s.aac',
        voiceMemoDurationSeconds: 14,
      ),
      telephonyBridgeEndpoint: '/api/v1/telephony/bridge-call',
      secureChatChannelId: 'ch_kg8842_masked',
      maskedContactVirtualNumber: '+91-11-4084-2190',
      acceptanceCountdownSeconds: 45,
      expiresAt: DateTime.now().add(const Duration(seconds: 45)),
      radiusTier: radiusTier,
      state: RadarDispatchState.broadcastActive,
    );
  }
}
