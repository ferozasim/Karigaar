import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/city_model.dart';
import 'package:karigaar_app/core/models/telemetry_model.dart';
import 'package:karigaar_app/core/services/telemetry_service.dart';

void main() {
  group('Ticket T-04: Telemetry & Geospatial Service Unit Tests', () {
    late KarigaarTelemetryService service;

    setUp(() {
      service = KarigaarTelemetryService();
    });

    tearDown(() {
      service.dispose();
    });

    // 1. JSON Round-Trip: TelemetryCoordinates
    test('1. TelemetryCoordinates serializes and deserializes cleanly via toJson/fromJson', () {
      const coords = TelemetryCoordinates(latitude: 19.1685, longitude: 77.3090);
      final json = coords.toJson();
      expect(json['latitude'], 19.1685);
      expect(json['longitude'], 77.3090);

      final restored = TelemetryCoordinates.fromJson(json);
      expect(restored.latitude, coords.latitude);
      expect(restored.longitude, coords.longitude);
      expect(restored, equals(coords));
      expect(coords.toGeoPoint().latitude, 19.1685);
      expect(coords.toGeoPoint().longitude, 77.3090);

      final fromGeo = TelemetryCoordinates.fromGeoPoint(
        const GeoPointModel(latitude: 28.4650, longitude: 77.0310),
      );
      expect(fromGeo.latitude, 28.4650);
      expect(fromGeo.longitude, 77.0310);
    });

    // 2. JSON Round-Trip: ArtisanLocationPing (flat & Contract 3 envelope)
    test('2. ArtisanLocationPing serializes and deserializes in flat and Contract 3 envelope formats', () {
      final now = DateTime.parse('2026-11-06T14:38:22.000Z');
      final ping = ArtisanLocationPing(
        bookingId: 'KG-8842',
        artisanId: 'art_7721',
        coordinates: const TelemetryCoordinates(latitude: 28.4650, longitude: 77.0310),
        headingDegrees: 45.2,
        speedKmph: 28.4,
        batteryLevelPercent: 82,
        isForeground: true,
        timestamp: now,
      );

      final flatJson = ping.toJson();
      expect(flatJson['bookingId'], 'KG-8842');
      expect(flatJson['artisanId'], 'art_7721');
      expect(flatJson['speedKmph'], 28.4);
      expect(flatJson['batteryLevelPercent'], 82);
      expect(flatJson['isForeground'], isTrue);

      final restoredFromFlat = ArtisanLocationPing.fromJson(flatJson);
      expect(restoredFromFlat.bookingId, ping.bookingId);
      expect(restoredFromFlat.artisanId, ping.artisanId);
      expect(restoredFromFlat.coordinates.latitude, 28.4650);
      expect(restoredFromFlat.headingDegrees, 45.2);
      expect(restoredFromFlat.timestamp, now);

      // Contract 3 envelope validation
      final envelopeJson = ping.toEnvelopeJson();
      expect(envelopeJson['event'], 'ARTISAN_LOCATION_UPDATE');
      expect(envelopeJson['timestamp'], '2026-11-06T14:38:22.000Z');
      expect(envelopeJson['data'], isA<Map<String, dynamic>>());

      final restoredFromEnvelope = ArtisanLocationPing.fromJson(envelopeJson);
      expect(restoredFromEnvelope.bookingId, 'KG-8842');
      expect(restoredFromEnvelope.artisanId, 'art_7721');
      expect(restoredFromEnvelope.speedKmph, 28.4);
    });

    // 3. JSON Round-Trip: LiveTrackingFeed (flat & Contract 3 envelope)
    test('3. LiveTrackingFeed serializes and deserializes in flat and Contract 3 broadcast formats', () {
      final now = DateTime.parse('2026-11-06T14:38:25.000Z');
      final feed = LiveTrackingFeed(
        bookingId: 'KG-8842',
        milestone: 'ON_THE_WAY',
        milestoneStepIndex: 3,
        etaMinutes: 14,
        remainingDistanceKm: 1.8,
        currentLocationLabel: 'Passing Cyber Hub',
        securityStartCode: '4921',
        cannedQuickChips: const [
          'Gate code is 8842',
          'Visitor parking spot #4',
          'Ring the doorbell twice',
        ],
        artisanLocation: const TelemetryCoordinates(latitude: 28.4650, longitude: 77.0310),
        isGeofenceTriggered: false,
        geofenceDistanceMeters: 1380.0,
        timestamp: now,
      );

      final flatJson = feed.toJson();
      expect(flatJson['bookingId'], 'KG-8842');
      expect(flatJson['milestone'], 'ON_THE_WAY');
      expect(flatJson['etaMinutes'], 14);
      expect(flatJson['remainingDistanceKm'], 1.8);
      expect(flatJson['cannedQuickChips'], hasLength(3));
      expect(flatJson['isGeofenceTriggered'], isFalse);

      final restored = LiveTrackingFeed.fromJson(flatJson);
      expect(restored.bookingId, 'KG-8842');
      expect(restored.etaMinutes, 14);
      expect(restored.remainingDistanceKm, 1.8);
      expect(restored.cannedQuickChips.first, 'Gate code is 8842');
      expect(restored.artisanLocation?.latitude, 28.4650);

      // Contract 3 broadcast envelope
      final envelopeJson = feed.toEnvelopeJson();
      expect(envelopeJson['event'], 'LIVE_TRACKING_FEED');
      expect(envelopeJson['data']['currentLocationLabel'], 'Passing Cyber Hub');

      final restoredEnvelope = LiveTrackingFeed.fromJson(envelopeJson);
      expect(restoredEnvelope.bookingId, 'KG-8842');
      expect(restoredEnvelope.milestone, 'ON_THE_WAY');
    });

    // 4. JSON Round-Trip: GeofenceEvent
    test('4. GeofenceEvent serializes and deserializes with timestamp and 200m flag', () {
      final now = DateTime.now();
      final event = GeofenceEvent(
        bookingId: 'BK_NANDED_8821',
        artisanId: 'art_nanded_01',
        distanceMeters: 142.5,
        triggeredAt: now,
        isInside200m: true,
      );

      final json = event.toJson();
      expect(json['bookingId'], 'BK_NANDED_8821');
      expect(json['artisanId'], 'art_nanded_01');
      expect(json['distanceMeters'], 142.5);
      expect(json['isInside200m'], isTrue);

      final restored = GeofenceEvent.fromJson(json);
      expect(restored.bookingId, 'BK_NANDED_8821');
      expect(restored.distanceMeters, 142.5);
      expect(restored.isInside200m, isTrue);
    });

    // 5. Haversine Distance Accuracy against ground-truth coordinates
    test('5. Haversine distance accuracy returns 0m for identical coords and ~2040m for Nanded landmarks', () {
      const p1 = GeoPointModel(latitude: 19.1685, longitude: 77.3090); // Anand Nagar
      const p2 = GeoPointModel(latitude: 19.1530, longitude: 77.3195); // Vazirabad

      // Identical coordinates must return exactly 0.0 meters
      final zeroDistance = service.calculateHaversineDistance(p1, p1);
      expect(zeroDistance, 0.0);

      // Anand Nagar to Vazirabad is ~2.04 km (2000 - 2100m)
      final distanceMeters = service.calculateHaversineDistance(p1, p2);
      expect(distanceMeters, greaterThan(2000.0));
      expect(distanceMeters, lessThan(2100.0));
      expect(distanceMeters, closeTo(2040.0, 30.0));

      // Symmetry check: dist(p1, p2) == dist(p2, p1)
      final reverseDistance = service.calculateHaversineDistance(p2, p1);
      expect(reverseDistance, closeTo(distanceMeters, 0.001));
    });

    // 6. 1.3x Urban Road Network Tortuosity Multiplier
    test('6. calculateRoadDistanceKm applies 1.3x tortuosity multiplier accurately', () {
      expect(service.calculateRoadDistanceKm(0.0), 0.0);
      expect(service.calculateRoadDistanceKm(1000.0), closeTo(1.3, 0.0001));
      expect(service.calculateRoadDistanceKm(2000.0), closeTo(2.6, 0.0001));
      expect(service.calculateRoadDistanceKm(5000.0), closeTo(6.5, 0.0001));
      expect(service.calculateRoadDistanceKm(10000.0), closeTo(13.0, 0.0001));
    });

    // 7. Dynamic ETA: Stationary speed (< 5 km/h) applies 22 km/h + 1 min buffer
    test('7. calculateEtaMinutes for stationary speed (< 5 km/h) applies 22 km/h benchmark + 1 min buffer', () {
      // 1.8 km at 0 km/h: (1.8 / 22.0 * 60) + 1 = 4.909 + 1 = 5.909 -> ceil = 6 mins
      final etaStationary = service.calculateEtaMinutes(1.8, 0.0);
      expect(etaStationary, 6);

      // 1.8 km at 4 km/h (< 5 km/h benchmark)
      final etaLowSpeed = service.calculateEtaMinutes(1.8, 4.0);
      expect(etaLowSpeed, 6);

      // Clamped to at least 1 min for non-zero distances
      final etaShort = service.calculateEtaMinutes(0.1, 0.0);
      expect(etaShort, greaterThanOrEqualTo(1));
    });

    // 8. Dynamic ETA: Low speed (15 km/h)
    test('8. calculateEtaMinutes at 15 km/h calculates (dist / 15) * 60 correctly', () {
      // 1.8 km at 15 km/h: (1.8 / 15.0) * 60 = 7.2 -> ceil = 8 mins
      final eta = service.calculateEtaMinutes(1.8, 15.0);
      expect(eta, 8);

      // 5.0 km at 15 km/h: (5.0 / 15.0) * 60 = 20.0 -> ceil = 20 mins
      final eta5km = service.calculateEtaMinutes(5.0, 15.0);
      expect(eta5km, 20);
    });

    // 9. Dynamic ETA: Medium speed (30 km/h)
    test('9. calculateEtaMinutes at 30 km/h calculates (dist / 30) * 60 correctly', () {
      // 1.8 km at 30 km/h: (1.8 / 30.0) * 60 = 3.6 -> ceil = 4 mins
      final eta = service.calculateEtaMinutes(1.8, 30.0);
      expect(eta, 4);

      // 3.0 km at 30 km/h: (3.0 / 30.0) * 60 = 6 mins
      final eta3km = service.calculateEtaMinutes(3.0, 30.0);
      expect(eta3km, 6);
    });

    // 10. Dynamic ETA: High speed (60 km/h)
    test('10. calculateEtaMinutes at 60 km/h calculates (dist / 60) * 60 correctly', () {
      // 1.8 km at 60 km/h: (1.8 / 60.0) * 60 = 1.8 -> ceil = 2 mins
      final eta = service.calculateEtaMinutes(1.8, 60.0);
      expect(eta, 2);

      // 10.0 km at 60 km/h: (10.0 / 60.0) * 60 = 10 mins
      final eta10km = service.calculateEtaMinutes(10.0, 60.0);
      expect(eta10km, 10);
    });

    // 11. Dynamic ETA: Arrived condition (roadDistanceKm <= 0.05) returns 0 min
    test('11. calculateEtaMinutes returns 0 min when artisan arrives at doorstep', () {
      expect(service.calculateEtaMinutes(0.0, 25.0), 0);
      expect(service.calculateEtaMinutes(0.02, 20.0), 0);
      expect(service.calculateEtaMinutes(0.05, 0.0), 0);
    });

    // 12. Geofence 200m Boundary Conditions
    test('12. checkGeofenceTrigger strictly evaluates 200m doorstep boundary conditions', () {
      // 250m -> outside (false)
      expect(service.checkGeofenceTrigger(250.0), isFalse);
      expect(service.checkGeofenceTrigger(200.1), isFalse);

      // 200.0m -> boundary threshold (true)
      expect(service.checkGeofenceTrigger(200.0), isTrue);

      // 150m -> inside (true)
      expect(service.checkGeofenceTrigger(150.0), isTrue);

      // 50m -> inside (true)
      expect(service.checkGeofenceTrigger(50.0), isTrue);

      // 0m -> exact match (true)
      expect(service.checkGeofenceTrigger(0.0), isTrue);

      // Custom threshold
      expect(service.checkGeofenceTrigger(250.0, thresholdMeters: 300.0), isTrue);
      expect(service.checkGeofenceTrigger(150.0, thresholdMeters: 100.0), isFalse);
    });

    // 13. WebSocket/MQTT Mock Pub/Sub Multi-Subscriber Routing
    test('13. WebSocket/MQTT mock pub/sub broker broadcasts pings to multiple subscribers and isolates bookingIds', () async {
      const bookingA = 'BK_NANDED_001';
      const bookingB = 'BK_NANDED_002';

      final subscriber1Events = <LiveTrackingFeed>[];
      final subscriber2Events = <LiveTrackingFeed>[];
      final subscriberBEvents = <LiveTrackingFeed>[];

      // Two subscribers for booking A, one for booking B
      final sub1 = service.subscribeToLiveTracking(bookingA).listen(subscriber1Events.add);
      final sub2 = service.subscribeToLiveTracking(bookingA).listen(subscriber2Events.add);
      final subB = service.subscribeToLiveTracking(bookingB).listen(subscriberBEvents.add);

      // Allow initial stream yield
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Publish ping for booking A
      service.publishLocationPing(ArtisanLocationPing(
        bookingId: bookingA,
        artisanId: 'art_7721',
        coordinates: const TelemetryCoordinates(latitude: 19.1650, longitude: 77.3100),
        headingDegrees: 45.0,
        speedKmph: 26.0,
        batteryLevelPercent: 88,
        isForeground: true,
        timestamp: DateTime.now(),
      ));

      // Publish ping for booking B
      service.publishLocationPing(ArtisanLocationPing(
        bookingId: bookingB,
        artisanId: 'art_8842',
        coordinates: const TelemetryCoordinates(latitude: 19.1550, longitude: 77.3180),
        headingDegrees: 90.0,
        speedKmph: 32.0,
        batteryLevelPercent: 79,
        isForeground: false,
        timestamp: DateTime.now(),
      ));

      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Both subscribers for booking A must have received the ping
      // (1 initial yield + 1 published ping = 2 events)
      expect(subscriber1Events.length, greaterThanOrEqualTo(2));
      expect(subscriber2Events.length, greaterThanOrEqualTo(2));
      expect(subscriber1Events.last.bookingId, bookingA);
      expect(subscriber2Events.last.bookingId, bookingA);

      // Subscriber B must only have received booking B events
      expect(subscriberBEvents.last.bookingId, bookingB);

      // Verify that subscriber A never received booking B events
      expect(subscriber1Events.every((e) => e.bookingId == bookingA), isTrue);
      expect(subscriberBEvents.every((e) => e.bookingId == bookingB), isTrue);

      await sub1.cancel();
      await sub2.cancel();
      await subB.cancel();
    });

    // 14. Sequential Route Simulation
    test('14. simulateRoute executes sequential waypoint trajectory and emits feeds along the path', () async {
      const bookingId = 'BK_SIMULATION_8801';
      final customerDestination = const GeoPointModel(latitude: 19.1685, longitude: 77.3090);
      service.setCustomerDestination(bookingId, customerDestination);

      final waypoints = [
        const GeoPointModel(latitude: 19.1530, longitude: 77.3195), // Vazirabad (~2040m away)
        const GeoPointModel(latitude: 19.1600, longitude: 77.3140), // Midpoint (~1080m away)
        const GeoPointModel(latitude: 19.1675, longitude: 77.3095), // Near doorstep (~120m away - inside 200m)
      ];

      final feeds = await service.simulateRoute(
        bookingId,
        waypoints: waypoints,
        stepInterval: const Duration(milliseconds: 10),
        speedKmph: 28.0,
        batteryLevelPercent: 84,
      );

      expect(feeds, hasLength(3));

      // First waypoint (Vazirabad): outside geofence
      expect(feeds[0].isGeofenceTriggered, isFalse);
      expect(feeds[0].milestone, 'ON_THE_WAY');
      expect(feeds[0].etaMinutes, greaterThan(1));
      expect(feeds[0].geofenceDistanceMeters, greaterThan(1500.0));

      // Second waypoint: closer
      expect(feeds[1].geofenceDistanceMeters, lessThan(feeds[0].geofenceDistanceMeters));

      // Third waypoint (near doorstep): inside 200m geofence
      expect(feeds[2].geofenceDistanceMeters, lessThan(200.0));
      expect(feeds[2].isGeofenceTriggered, isTrue);
      expect(feeds[2].milestone, 'ARRIVED');
      expect(feeds[2].milestoneStepIndex, 3);
      expect(feeds[2].etaMinutes, 0);
      expect(feeds[2].remainingDistanceKm, 0.0);
    });

    // 15. Foreground vs. Background Telemetry Status
    test('15. ArtisanTelemetryStatus tracks foreground high-frequency and background power-saver modes', () {
      const defaultStatus = ArtisanTelemetryStatus();
      expect(defaultStatus.isStreaming, isTrue);
      expect(defaultStatus.isForeground, isTrue);
      expect(defaultStatus.pingIntervalSeconds, 3);
      expect(defaultStatus.currentSpeedKmph, 28.0);
      expect(defaultStatus.batteryPercent, 85);

      // Switch to background mode
      final bgStatus = defaultStatus.copyWith(
        isForeground: false,
        pingIntervalSeconds: 15,
        batteryPercent: 82,
      );
      expect(bgStatus.isForeground, isFalse);
      expect(bgStatus.pingIntervalSeconds, 15);
      expect(bgStatus.batteryPercent, 82);

      // Trigger geofence proximity
      final arrivedStatus = bgStatus.copyWith(
        isGeofenceTriggered: true,
        remainingDistanceKm: 0.0,
        currentSpeedKmph: 0.0,
      );
      expect(arrivedStatus.isGeofenceTriggered, isTrue);
      expect(arrivedStatus.remainingDistanceKm, 0.0);
      expect(arrivedStatus.currentSpeedKmph, 0.0);
    });
  });
}
