import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/city_model.dart';
import 'package:karigaar_app/core/models/radar_broadcast_model.dart';
import 'package:karigaar_app/core/services/api_service.dart';
import 'package:karigaar_app/core/services/radar_broadcast_service.dart';

void main() {
  group('Ticket T-07: Contract 2 - Model Serialization Tests', () {
    test('JobRadarBroadcastModel parses Contract 2 JOB_RADAR_BROADCAST envelope', () {
      final contract2Envelope = {
        'event': 'JOB_RADAR_BROADCAST',
        'timestamp': '2026-11-06T14:35:10.000Z',
        'data': {
          'broadcastId': 'bc_998124',
          'bookingId': 'KG-8842',
          'category': 'ELECTRICIAN',
          'isEmergency': true,
          'title': 'Emergency Short Circuit & MCB Trip',
          'customer': {
            'firstName': 'Vikram',
            'locality': 'Sector 42 Green Valley, Gurugram',
            'distanceKm': 1.8,
            'reachTimeMinutes': 8,
          },
          'payout': {
            'currency': 'INR',
            'guaranteedBase': 480.00,
            'partsReimbursementAllowed': true,
          },
          'attachments': {
            'photoUrl': 'https://cdn.karigaar.in/jobs/KG-8842/mcb_spark.jpg',
            'voiceMemoUrl': 'https://cdn.karigaar.in/jobs/KG-8842/voice_14s.aac',
            'voiceMemoDurationSeconds': 14,
          },
          'telephonyBridgeEndpoint': '/api/v1/telephony/bridge-call',
          'secureChatChannelId': 'ch_kg8842_masked',
          'maskedContactVirtualNumber': '+91-11-4084XXXX',
          'acceptanceCountdownSeconds': 45,
          'expiresAt': '2026-11-06T14:35:55.000Z',
        },
      };

      final model = JobRadarBroadcastModel.fromJson(contract2Envelope);

      expect(model.broadcastId, 'bc_998124');
      expect(model.bookingId, 'KG-8842');
      expect(model.category, 'ELECTRICIAN');
      expect(model.isEmergency, isTrue);
      expect(model.title, 'Emergency Short Circuit & MCB Trip');
      expect(model.customer.firstName, 'Vikram');
      expect(model.customer.locality, 'Sector 42 Green Valley, Gurugram');
      expect(model.customer.distanceKm, 1.8);
      expect(model.customer.reachTimeMinutes, 8);
      expect(model.payout.currency, 'INR');
      expect(model.payout.guaranteedBase, 480.00);
      expect(model.payout.partsReimbursementAllowed, isTrue);
      expect(model.attachments.hasPhoto, isTrue);
      expect(model.attachments.photoUrl, 'https://cdn.karigaar.in/jobs/KG-8842/mcb_spark.jpg');
      expect(model.attachments.hasVoiceMemo, isTrue);
      expect(model.attachments.voiceMemoDurationSeconds, 14);
      expect(model.telephonyBridgeEndpoint, '/api/v1/telephony/bridge-call');
      expect(model.secureChatChannelId, 'ch_kg8842_masked');
      expect(model.maskedContactVirtualNumber, '+91-11-4084XXXX');
      expect(model.acceptanceCountdownSeconds, 45);
      expect(model.radiusTier, RadarRadiusTier.tier1Local);
      expect(model.state, RadarDispatchState.broadcastActive);
    });

    test('JobRadarBroadcastModel.toJson serializes all fields conforming to Contract 2 schema', () {
      final sample = KarigaarRadarBroadcastService.createSampleBroadcast(
        broadcastId: 'bc_custom_1',
        bookingId: 'BK_NANDED_101',
        category: 'PLUMBER',
        isEmergency: false,
        title: 'Bathroom Pipe Leakage',
        distanceKm: 2.4,
        guaranteedBase: 350.0,
      );

      final json = sample.toJson();

      expect(json['broadcastId'], 'bc_custom_1');
      expect(json['bookingId'], 'BK_NANDED_101');
      expect(json['category'], 'PLUMBER');
      expect(json['isEmergency'], isFalse);
      expect(json['title'], 'Bathroom Pipe Leakage');
      expect(json['radiusTier'], 'tier1Local');
      expect(json['customer']['distanceKm'], 2.4);
      expect(json['payout']['guaranteedBase'], 350.0);
    });

    test('JobRadarBroadcastModel.copyWith updates fields immutably', () {
      final original = KarigaarRadarBroadcastService.createSampleBroadcast();
      final updated = original.copyWith(
        radiusTier: RadarRadiusTier.tier2Expanded,
        state: RadarDispatchState.claimed,
      );

      expect(original.radiusTier, RadarRadiusTier.tier1Local);
      expect(original.state, RadarDispatchState.broadcastActive);
      expect(updated.radiusTier, RadarRadiusTier.tier2Expanded);
      expect(updated.state, RadarDispatchState.claimed);
      expect(updated.broadcastId, original.broadcastId);
    });

    test('RadarUnfulfilledEvent parses Contract 2 JOB_RADAR_UNFULFILLED envelope', () {
      final unfulfilledEnvelope = {
        'event': 'JOB_RADAR_UNFULFILLED',
        'timestamp': '2026-11-06T14:35:55.000Z',
        'data': {
          'broadcastId': 'bc_998124',
          'bookingId': 'KG-8842',
          'state': 'DISPATCH_UNFULFILLED',
          'reason': 'RADAR_45S_TIMER_EXPIRED_NO_ACCEPTANCE',
          'fallbackAction': 'AUTO_RETRY_EXPANDED_RADIUS',
          'expandedRadiusKm': 6.0,
          'customerNotification': 'Searching expanded radius (6 km) for available Master Electricians.',
        },
      };

      final event = RadarUnfulfilledEvent.fromJson(unfulfilledEnvelope);

      expect(event.broadcastId, 'bc_998124');
      expect(event.bookingId, 'KG-8842');
      expect(event.state, 'DISPATCH_UNFULFILLED');
      expect(event.reason, 'RADAR_45S_TIMER_EXPIRED_NO_ACCEPTANCE');
      expect(event.fallbackAction, 'AUTO_RETRY_EXPANDED_RADIUS');
      expect(event.expandedRadiusKm, 6.0);
      expect(event.customerNotification, contains('Searching expanded radius (6 km)'));
    });

    test('RadarUnfulfilledEvent.toJson serializes accurately', () {
      final event = RadarUnfulfilledEvent(
        broadcastId: 'bc_123',
        bookingId: 'BK_999',
        timestamp: DateTime.parse('2026-11-06T14:35:55.000Z'),
      );

      final json = event.toJson();
      expect(json['broadcastId'], 'bc_123');
      expect(json['bookingId'], 'BK_999');
      expect(json['expandedRadiusKm'], 6.0);
      expect(json['fallbackAction'], 'AUTO_RETRY_EXPANDED_RADIUS');
    });

    test('BroadcastAcceptResult parses Partner Accept Job Response', () {
      final responseMap = {
        'status': 'SUCCESS',
        'data': {
          'bookingId': 'KG-8842',
          'state': 'ARTISAN_DISPATCHED',
          'assignedArtisanId': 'art_7721',
          'navigationCoordinates': {
            'destinationLatitude': 28.4722,
            'destinationLongitude': 77.0381,
            'addressText': '42 Green Valley, Sector 4, Gurugram',
          },
          'startOtpVerificationRequired': true,
          'doorstepStartOtpExpected': '4921',
        },
      };

      final result = BroadcastAcceptResult.fromJson(responseMap);

      expect(result.bookingId, 'KG-8842');
      expect(result.state, 'ARTISAN_DISPATCHED');
      expect(result.assignedArtisanId, 'art_7721');
      expect(result.navigationCoordinates.latitude, 28.4722);
      expect(result.navigationCoordinates.longitude, 77.0381);
      expect(result.navigationCoordinates.addressText, '42 Green Valley, Sector 4, Gurugram');
      expect(result.startOtpVerificationRequired, isTrue);
      expect(result.doorstepStartOtpExpected, '4921');
    });
  });

  group('Ticket T-07: Domain Service - Broadcast Engine & 45s Cascading Tests', () {
    late KarigaarRadarBroadcastService service;

    setUp(() {
      service = KarigaarRadarBroadcastService(apiService: const KarigaarApiService());
      service.reset();
    });

    tearDown(() {
      service.dispose();
    });

    test('startBroadcast emits incoming broadcast and initializes countdown to 45s', () async {
      final sample = KarigaarRadarBroadcastService.createSampleBroadcast();

      JobRadarBroadcastModel? receivedBroadcast;
      int? receivedCountdown;

      final sub1 = service.broadcastStream.listen((b) => receivedBroadcast = b);
      final sub2 = service.countdownStream.listen((c) => receivedCountdown = c);

      service.startBroadcast(sample);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(service.activeBroadcast, isNotNull);
      expect(service.activeBroadcast?.broadcastId, sample.broadcastId);
      expect(service.currentCountdown, 45);
      expect(service.currentRadiusTier, RadarRadiusTier.tier1Local);
      expect(receivedBroadcast?.broadcastId, sample.broadcastId);
      expect(receivedCountdown, 45);

      await sub1.cancel();
      await sub2.cancel();
    });

    test('simulateCountdownTick emits decremented seconds', () async {
      final sample = KarigaarRadarBroadcastService.createSampleBroadcast();
      service.startBroadcast(sample);

      final ticks = <int>[];
      final sub = service.countdownStream.listen((t) => ticks.add(t));

      service.simulateCountdownTick(44);
      service.simulateCountdownTick(43);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(service.currentCountdown, 43);
      expect(ticks, containsAllInOrder([44, 43]));
      await sub.cancel();
    });

    test('Auto-cascading: Tier 1 (2km) expiry automatically escalates to Tier 2 (6km)', () async {
      final sample = KarigaarRadarBroadcastService.createSampleBroadcast();
      service.startBroadcast(sample);

      expect(service.currentRadiusTier, RadarRadiusTier.tier1Local);

      RadarUnfulfilledEvent? unfulfilledEvent;
      final sub = service.unfulfilledStream.listen((e) => unfulfilledEvent = e);

      // Trigger expiry of Tier 1
      service.simulateExpiry();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(service.currentRadiusTier, RadarRadiusTier.tier2Expanded);
      expect(service.activeBroadcast?.radiusTier, RadarRadiusTier.tier2Expanded);
      expect(unfulfilledEvent, isNotNull);
      expect(unfulfilledEvent?.expandedRadiusKm, 6.0);
      expect(unfulfilledEvent?.fallbackAction, 'AUTO_RETRY_EXPANDED_RADIUS');
      expect(unfulfilledEvent?.customerNotification, contains('Searching expanded radius (6 km)'));
      expect(service.currentCountdown, 45); // Re-armed for Tier 2
      await sub.cancel();
    });

    test('Terminal Fallback: Tier 2 (6km) expiry marks broadcast unfulfilled', () async {
      final sample = KarigaarRadarBroadcastService.createSampleBroadcast();
      service.startBroadcast(sample);

      // First expiry: Tier 1 -> Tier 2
      service.simulateExpiry();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(service.currentRadiusTier, RadarRadiusTier.tier2Expanded);

      RadarUnfulfilledEvent? terminalEvent;
      final sub = service.unfulfilledStream.listen((e) => terminalEvent = e);

      // Second expiry: Tier 2 -> Terminal unfulfilled
      service.simulateExpiry();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(service.activeBroadcast?.state, RadarDispatchState.unfulfilled);
      expect(service.isBroadcasting, isFalse);
      expect(terminalEvent, isNotNull);
      expect(terminalEvent?.fallbackAction, 'MANUAL_RETRY_OR_ESCALATE');
      expect(terminalEvent?.customerNotification, contains('No available Master Electricians found in 6 km corridor'));
      await sub.cancel();
    });

    test('acceptBroadcastJob claims job, cancels timer, and returns navigation coordinates', () async {
      final sample = KarigaarRadarBroadcastService.createSampleBroadcast(
        bookingId: 'BK_NANDED_8821',
        broadcastId: 'bc_998124',
      );
      service.startBroadcast(sample);

      final result = await service.acceptBroadcastJob(
        broadcastId: 'bc_998124',
        artisanId: 'art_nanded_01',
        currentLocation: const GeoPointModel(latitude: 19.1383, longitude: 77.3210),
      );

      expect(result.bookingId, 'BK_NANDED_8821');
      expect(result.state, 'ARTISAN_DISPATCHED');
      expect(result.assignedArtisanId, 'art_nanded_01');
      expect(result.navigationCoordinates.latitude, 19.1415);
      expect(result.navigationCoordinates.longitude, 77.3242);
      expect(result.navigationCoordinates.addressText, contains('Anand Nagar, Nanded'));
      expect(service.activeBroadcast?.state, RadarDispatchState.claimed);
      expect(service.isBroadcasting, isFalse);
    });

    test('Partner offline duty suppresses active broadcast alerts', () {
      service.setArtisanDutyOnline(false);
      expect(service.isDutyOnline, isFalse);

      final sample = KarigaarRadarBroadcastService.createSampleBroadcast();
      service.startBroadcast(sample);

      expect(service.activeBroadcast?.state, RadarDispatchState.pending);
      expect(service.isBroadcasting, isFalse);
    });

    test('Attachment info parses photos and voice note attachments correctly', () {
      const attachments = RadarAttachments(
        photoUrl: 'https://cdn.karigaar.in/spark.jpg',
        voiceMemoUrl: 'https://cdn.karigaar.in/memo.aac',
        voiceMemoDurationSeconds: 22,
      );

      expect(attachments.hasPhoto, isTrue);
      expect(attachments.hasVoiceMemo, isTrue);
      expect(attachments.voiceMemoDurationSeconds, 22);

      const empty = RadarAttachments();
      expect(empty.hasPhoto, isFalse);
      expect(empty.hasVoiceMemo, isFalse);
      expect(empty.voiceMemoDurationSeconds, isNull);
    });

    test('reset clears active broadcast, radius tier, and restores default state', () {
      final sample = KarigaarRadarBroadcastService.createSampleBroadcast();
      service.startBroadcast(sample);
      service.simulateExpiry(); // Escalated to Tier 2

      service.reset();

      expect(service.activeBroadcast, isNull);
      expect(service.currentRadiusTier, RadarRadiusTier.tier1Local);
      expect(service.currentCountdown, 45);
      expect(service.isDutyOnline, isTrue);
    });
  });
}
