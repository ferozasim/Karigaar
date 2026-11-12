import 'city_model.dart';

/// Geographical coordinates model for telemetry streaming.
class TelemetryCoordinates {
  final double latitude;
  final double longitude;

  const TelemetryCoordinates({
    required this.latitude,
    required this.longitude,
  });

  GeoPointModel toGeoPoint() => GeoPointModel(latitude: latitude, longitude: longitude);

  factory TelemetryCoordinates.fromGeoPoint(GeoPointModel geoPoint) {
    return TelemetryCoordinates(
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
    );
  }

  factory TelemetryCoordinates.fromJson(Map<String, dynamic> json) {
    return TelemetryCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TelemetryCoordinates &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'TelemetryCoordinates(lat: $latitude, lon: $longitude)';
}

/// Upstream Artisan Location Ping conforming to PROJECT.md Contract 3.
/// Emitted by artisan mobile device via WebSocket/MQTT mock transport.
class ArtisanLocationPing {
  final String bookingId;
  final String artisanId;
  final TelemetryCoordinates coordinates;
  final double headingDegrees;
  final double speedKmph;
  final int batteryLevelPercent;
  final bool isForeground;
  final DateTime timestamp;

  const ArtisanLocationPing({
    required this.bookingId,
    required this.artisanId,
    required this.coordinates,
    required this.headingDegrees,
    required this.speedKmph,
    required this.batteryLevelPercent,
    this.isForeground = true,
    required this.timestamp,
  });

  factory ArtisanLocationPing.fromJson(Map<String, dynamic> json) {
    // Support direct JSON and Contract 3 envelope:
    // { "event": "ARTISAN_LOCATION_UPDATE", "timestamp": "...", "data": { ... } }
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final ts = json.containsKey('timestamp') && json['timestamp'] is String
        ? DateTime.parse(json['timestamp'] as String)
        : (data.containsKey('timestamp') && data['timestamp'] is String
            ? DateTime.parse(data['timestamp'] as String)
            : DateTime.now());

    return ArtisanLocationPing(
      bookingId: data['bookingId'] as String,
      artisanId: data['artisanId'] as String,
      coordinates: TelemetryCoordinates.fromJson(data['coordinates'] as Map<String, dynamic>),
      headingDegrees: (data['headingDegrees'] as num).toDouble(),
      speedKmph: (data['speedKmph'] as num).toDouble(),
      batteryLevelPercent: (data['batteryLevelPercent'] as num).toInt(),
      isForeground: data['isForeground'] as bool? ?? true,
      timestamp: ts,
    );
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'artisanId': artisanId,
        'coordinates': coordinates.toJson(),
        'headingDegrees': headingDegrees,
        'speedKmph': speedKmph,
        'batteryLevelPercent': batteryLevelPercent,
        'isForeground': isForeground,
        'timestamp': timestamp.toIso8601String(),
      };

  Map<String, dynamic> toEnvelopeJson() => {
        'event': 'ARTISAN_LOCATION_UPDATE',
        'timestamp': timestamp.toIso8601String(),
        'data': toJson(),
      };
}

/// Downstream Customer Live Tracking Feed broadcast conforming to PROJECT.md Contract 3.
/// Delivered to customer mobile clients in real-time.
class LiveTrackingFeed {
  final String bookingId;
  final String milestone;
  final int milestoneStepIndex;
  final int etaMinutes;
  final double remainingDistanceKm;
  final String currentLocationLabel;
  final String securityStartCode;
  final List<String> cannedQuickChips;
  final TelemetryCoordinates? artisanLocation;
  final bool isGeofenceTriggered;
  final double geofenceDistanceMeters;
  final DateTime timestamp;

  const LiveTrackingFeed({
    required this.bookingId,
    required this.milestone,
    required this.milestoneStepIndex,
    required this.etaMinutes,
    required this.remainingDistanceKm,
    required this.currentLocationLabel,
    required this.securityStartCode,
    required this.cannedQuickChips,
    this.artisanLocation,
    required this.isGeofenceTriggered,
    required this.geofenceDistanceMeters,
    required this.timestamp,
  });

  factory LiveTrackingFeed.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final ts = json.containsKey('timestamp') && json['timestamp'] is String
        ? DateTime.parse(json['timestamp'] as String)
        : (data.containsKey('timestamp') && data['timestamp'] is String
            ? DateTime.parse(data['timestamp'] as String)
            : DateTime.now());

    final coordsMap = data['artisanLocation'] != null
        ? data['artisanLocation'] as Map<String, dynamic>
        : (data['coordinates'] != null ? data['coordinates'] as Map<String, dynamic> : null);

    return LiveTrackingFeed(
      bookingId: data['bookingId'] as String,
      milestone: data['milestone'] as String? ?? 'ON_THE_WAY',
      milestoneStepIndex: (data['milestoneStepIndex'] as num?)?.toInt() ?? 2,
      etaMinutes: (data['etaMinutes'] as num).toInt(),
      remainingDistanceKm: (data['remainingDistanceKm'] as num).toDouble(),
      currentLocationLabel: data['currentLocationLabel'] as String? ?? 'In Transit',
      securityStartCode: data['securityStartCode'] as String? ?? '4921',
      cannedQuickChips: data['cannedQuickChips'] != null
          ? List<String>.from(data['cannedQuickChips'] as List)
          : const [
              'Gate code is 8842',
              'Visitor parking spot #4',
              'Ring the doorbell twice',
            ],
      artisanLocation: coordsMap != null ? TelemetryCoordinates.fromJson(coordsMap) : null,
      isGeofenceTriggered: data['isGeofenceTriggered'] as bool? ?? false,
      geofenceDistanceMeters: (data['geofenceDistanceMeters'] as num?)?.toDouble() ?? 0.0,
      timestamp: ts,
    );
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'milestone': milestone,
        'milestoneStepIndex': milestoneStepIndex,
        'etaMinutes': etaMinutes,
        'remainingDistanceKm': remainingDistanceKm,
        'currentLocationLabel': currentLocationLabel,
        'securityStartCode': securityStartCode,
        'cannedQuickChips': cannedQuickChips,
        if (artisanLocation != null) 'artisanLocation': artisanLocation!.toJson(),
        'isGeofenceTriggered': isGeofenceTriggered,
        'geofenceDistanceMeters': geofenceDistanceMeters,
        'timestamp': timestamp.toIso8601String(),
      };

  Map<String, dynamic> toEnvelopeJson() => {
        'event': 'LIVE_TRACKING_FEED',
        'timestamp': timestamp.toIso8601String(),
        'data': toJson(),
      };
}

/// Geofence breach event model for doorstep proximity detection (< 200m).
class GeofenceEvent {
  final String bookingId;
  final String artisanId;
  final double distanceMeters;
  final DateTime triggeredAt;
  final bool isInside200m;

  const GeofenceEvent({
    required this.bookingId,
    required this.artisanId,
    required this.distanceMeters,
    required this.triggeredAt,
    required this.isInside200m,
  });

  factory GeofenceEvent.fromJson(Map<String, dynamic> json) {
    return GeofenceEvent(
      bookingId: json['bookingId'] as String,
      artisanId: json['artisanId'] as String,
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      triggeredAt: DateTime.parse(json['triggeredAt'] as String),
      isInside200m: json['isInside200m'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'artisanId': artisanId,
        'distanceMeters': distanceMeters,
        'triggeredAt': triggeredAt.toIso8601String(),
        'isInside200m': isInside200m,
      };
}

/// Artisan en-route telemetry HUD status model for foreground/background streaming.
class ArtisanTelemetryStatus {
  final bool isStreaming;
  final bool isForeground;
  final double currentSpeedKmph;
  final double headingDegrees;
  final int batteryPercent;
  final int pingIntervalSeconds;
  final double remainingDistanceKm;
  final bool isGeofenceTriggered;

  const ArtisanTelemetryStatus({
    this.isStreaming = true,
    this.isForeground = true,
    this.currentSpeedKmph = 28.0,
    this.headingDegrees = 45.0,
    this.batteryPercent = 85,
    this.pingIntervalSeconds = 3,
    this.remainingDistanceKm = 1.8,
    this.isGeofenceTriggered = false,
  });

  ArtisanTelemetryStatus copyWith({
    bool? isStreaming,
    bool? isForeground,
    double? currentSpeedKmph,
    double? headingDegrees,
    int? batteryPercent,
    int? pingIntervalSeconds,
    double? remainingDistanceKm,
    bool? isGeofenceTriggered,
  }) {
    return ArtisanTelemetryStatus(
      isStreaming: isStreaming ?? this.isStreaming,
      isForeground: isForeground ?? this.isForeground,
      currentSpeedKmph: currentSpeedKmph ?? this.currentSpeedKmph,
      headingDegrees: headingDegrees ?? this.headingDegrees,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      pingIntervalSeconds: pingIntervalSeconds ?? this.pingIntervalSeconds,
      remainingDistanceKm: remainingDistanceKm ?? this.remainingDistanceKm,
      isGeofenceTriggered: isGeofenceTriggered ?? this.isGeofenceTriggered,
    );
  }
}
