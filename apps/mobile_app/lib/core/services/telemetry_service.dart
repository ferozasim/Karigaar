import 'dart:async';
import 'dart:math';
import '../models/city_model.dart';
import '../models/telemetry_model.dart';

/// Telemetry & Geospatial Service for Karigaar.
/// Conforms to PROJECT.md Contract 3.
/// Features an in-memory WebSocket/MQTT mock pub/sub broker,
/// Haversine geospatial calculations, 1.3x road network tortuosity,
/// dynamic ETA calculation, and 200m geofence proximity triggers.
class KarigaarTelemetryService {
  /// Earth's mean radius in meters for Haversine calculations.
  static const double earthRadiusMeters = 6371000.0;

  /// Urban road network tortuosity multiplier (Indian municipal corridors).
  static const double roadTortuosityMultiplier = 1.3;

  /// Default doorstep proximity geofence radius in meters.
  static const double defaultGeofenceThresholdMeters = 200.0;

  /// In-memory broadcast stream controller for live tracking feeds (WebSocket/MQTT mock broker).
  final StreamController<LiveTrackingFeed> _feedStreamController =
      StreamController<LiveTrackingFeed>.broadcast();

  /// In-memory broadcast stream controller for geofence proximity alerts.
  final StreamController<GeofenceEvent> _geofenceStreamController =
      StreamController<GeofenceEvent>.broadcast();

  /// Cache of latest pings keyed by bookingId.
  final Map<String, ArtisanLocationPing> _latestPings = {};

  /// Cache of latest feeds keyed by bookingId.
  final Map<String, LiveTrackingFeed> _latestFeeds = {};

  /// Registered customer destination coordinates keyed by bookingId.
  final Map<String, GeoPointModel> _customerDestinations = {};

  /// Stream of all live tracking feed events.
  Stream<LiveTrackingFeed> get feedStream => _feedStreamController.stream;

  /// Stream of all geofence proximity events.
  Stream<GeofenceEvent> get geofenceStream => _geofenceStreamController.stream;

  /// Set or override the customer destination coordinates for a booking.
  void setCustomerDestination(String bookingId, GeoPointModel destination) {
    _customerDestinations[bookingId] = destination;
  }

  /// Get the customer destination for a booking, defaulting to Anand Nagar, Nanded.
  GeoPointModel getCustomerDestination(String bookingId) {
    return _customerDestinations[bookingId] ??
        const GeoPointModel(latitude: 19.1685, longitude: 77.3090);
  }

  /// Calculates great-circle Haversine distance between two coordinates in meters.
  /// Uses Earth radius R = 6,371,000 meters.
  double calculateHaversineDistance(GeoPointModel p1, GeoPointModel p2) {
    if (p1.latitude == p2.latitude && p1.longitude == p2.longitude) {
      return 0.0;
    }

    final lat1Rad = p1.latitude * (pi / 180.0);
    final lon1Rad = p1.longitude * (pi / 180.0);
    final lat2Rad = p2.latitude * (pi / 180.0);
    final lon2Rad = p2.longitude * (pi / 180.0);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final sinDlat = sin(dLat / 2.0);
    final sinDlon = sin(dLon / 2.0);

    final a = (sinDlat * sinDlat) +
        (cos(lat1Rad) * cos(lat2Rad) * (sinDlon * sinDlon));
    final clampedA = a.clamp(0.0, 1.0);
    final c = 2.0 * atan2(sqrt(clampedA), sqrt(1.0 - clampedA));

    return earthRadiusMeters * c;
  }

  /// Calculates urban road network distance in kilometers.
  /// Applies a 1.3x tortuosity multiplier over straight-line Haversine distance.
  double calculateRoadDistanceKm(double haversineMeters) {
    if (haversineMeters <= 0.0) return 0.0;
    final straightLineKm = haversineMeters / 1000.0;
    return straightLineKm * roadTortuosityMultiplier;
  }

  /// Calculates dynamic ETA in minutes.
  /// - When road distance <= 0.05 km (arrived): returns 0 min.
  /// - When speed >= 5 km/h: (roadDistanceKm / speed) * 60, clamped to >= 1 min.
  /// - When stationary (< 5 km/h): (roadDistanceKm / 22.0) * 60 + 1, clamped to >= 1 min.
  int calculateEtaMinutes(double roadDistanceKm, double speedKmph) {
    if (roadDistanceKm <= 0.05) {
      return 0;
    }

    if (speedKmph >= 5.0) {
      final rawMinutes = (roadDistanceKm / speedKmph) * 60.0;
      return rawMinutes.ceil().clamp(1, 999);
    } else {
      // Standard urban two-wheeler speed: 22 km/h + 1 minute buffer
      final rawMinutes = (roadDistanceKm / 22.0) * 60.0 + 1.0;
      return rawMinutes.ceil().clamp(1, 999);
    }
  }

  /// Evaluates whether current distance is within the geofence perimeter.
  /// Default threshold is 200.0 meters.
  bool checkGeofenceTrigger(double distanceMeters,
      {double thresholdMeters = defaultGeofenceThresholdMeters}) {
    return distanceMeters <= thresholdMeters;
  }

  /// Ingests an artisan location update ping, recalculates geospatial metrics,
  /// updates state, checks the 200m geofence trigger, and broadcasts a LiveTrackingFeed.
  LiveTrackingFeed publishLocationPing(ArtisanLocationPing ping) {
    _latestPings[ping.bookingId] = ping;

    final customerCoord = getCustomerDestination(ping.bookingId);
    final haversineDistanceMeters = calculateHaversineDistance(
      ping.coordinates.toGeoPoint(),
      customerCoord,
    );

    final roadDistanceKm = calculateRoadDistanceKm(haversineDistanceMeters);
    final isGeofenceTriggered = checkGeofenceTrigger(haversineDistanceMeters);
    final etaMinutes = isGeofenceTriggered
        ? 0
        : calculateEtaMinutes(roadDistanceKm, ping.speedKmph);

    final String milestone = isGeofenceTriggered ? 'ARRIVED' : 'ON_THE_WAY';
    final int stepIndex = isGeofenceTriggered ? 3 : 2;
    final String locationLabel = isGeofenceTriggered
        ? 'At Customer Doorstep'
        : (roadDistanceKm < 0.5
            ? 'Approaching Street'
            : 'En route (${ping.speedKmph.toStringAsFixed(0)} km/h)');

    final feed = LiveTrackingFeed(
      bookingId: ping.bookingId,
      milestone: milestone,
      milestoneStepIndex: stepIndex,
      etaMinutes: etaMinutes,
      remainingDistanceKm: isGeofenceTriggered
          ? 0.0
          : double.parse(roadDistanceKm.toStringAsFixed(2)),
      currentLocationLabel: locationLabel,
      securityStartCode: '4921',
      cannedQuickChips: const [
        'Gate code is 8842',
        'Visitor parking spot #4',
        'Ring the doorbell twice',
      ],
      artisanLocation: ping.coordinates,
      isGeofenceTriggered: isGeofenceTriggered,
      geofenceDistanceMeters: haversineDistanceMeters,
      timestamp: ping.timestamp,
    );

    _latestFeeds[ping.bookingId] = feed;
    _feedStreamController.add(feed);

    if (isGeofenceTriggered) {
      final geofenceEvent = GeofenceEvent(
        bookingId: ping.bookingId,
        artisanId: ping.artisanId,
        distanceMeters: haversineDistanceMeters,
        triggeredAt: ping.timestamp,
        isInside200m: true,
      );
      _geofenceStreamController.add(geofenceEvent);
    }

    return feed;
  }

  /// Returns the latest feed for a booking, or a realistic default if no ping has arrived yet.
  LiveTrackingFeed getLatestFeed(String bookingId) {
    return _latestFeeds[bookingId] ??
        LiveTrackingFeed(
          bookingId: bookingId,
          milestone: 'ON_THE_WAY',
          milestoneStepIndex: 2,
          etaMinutes: 6,
          remainingDistanceKm: 1.8,
          currentLocationLabel: 'En Route to Doorstep (~6 mins)',
          securityStartCode: '4921',
          cannedQuickChips: const [
            'Gate code is 8842',
            'Visitor parking spot #4',
            'Ring the doorbell twice',
          ],
          artisanLocation: const TelemetryCoordinates(
            latitude: 19.1620,
            longitude: 77.3150,
          ),
          isGeofenceTriggered: false,
          geofenceDistanceMeters: 1380.0,
          timestamp: DateTime.now(),
        );
  }

  /// Subscribes to live tracking updates for a specific booking ID.
  /// Yields the latest/default feed immediately, followed by all broadcast pings.
  Stream<LiveTrackingFeed> subscribeToLiveTracking(String bookingId) async* {
    yield getLatestFeed(bookingId);
    yield* _feedStreamController.stream
        .where((feed) => feed.bookingId == bookingId);
  }

  /// Simulates a sequential route traversal along waypoints.
  Future<List<LiveTrackingFeed>> simulateRoute(
    String bookingId, {
    required List<GeoPointModel> waypoints,
    Duration stepInterval = const Duration(milliseconds: 50),
    String artisanId = 'art_7721',
    double speedKmph = 28.0,
    int batteryLevelPercent = 85,
    bool isForeground = true,
  }) async {
    final emittedFeeds = <LiveTrackingFeed>[];

    for (int i = 0; i < waypoints.length; i++) {
      final wp = waypoints[i];
      final ping = ArtisanLocationPing(
        bookingId: bookingId,
        artisanId: artisanId,
        coordinates: TelemetryCoordinates.fromGeoPoint(wp),
        headingDegrees: 45.0,
        speedKmph: speedKmph,
        batteryLevelPercent: batteryLevelPercent,
        isForeground: isForeground,
        timestamp: DateTime.now(),
      );

      final feed = publishLocationPing(ping);
      emittedFeeds.add(feed);

      if (stepInterval > Duration.zero && i < waypoints.length - 1) {
        await Future<void>.delayed(stepInterval);
      }
    }

    return emittedFeeds;
  }

  /// Closes active broadcast controllers.
  void dispose() {
    _feedStreamController.close();
    _geofenceStreamController.close();
  }
}
