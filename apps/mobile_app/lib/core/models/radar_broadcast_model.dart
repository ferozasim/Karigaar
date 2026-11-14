import 'city_model.dart';

/// Radius tier for automated 45s cascading dispatch.
enum RadarRadiusTier {
  /// Tier 1: Local corridor (2.0 km).
  tier1Local,

  /// Tier 2: Expanded regional corridor (6.0 km).
  tier2Expanded,
}

extension RadarRadiusTierExtension on RadarRadiusTier {
  double get radiusKm => this == RadarRadiusTier.tier1Local ? 2.0 : 6.0;
  String get label => this == RadarRadiusTier.tier1Local ? 'Primary Corridor • 2 km' : 'Expanded Radar • 6 km';
}

/// Dispatch state of a radar broadcast.
enum RadarDispatchState {
  pending,
  broadcastActive,
  claimed,
  unfulfilled,
}

/// Navigation destination coordinates returned on job claim.
class RadarCoordinates {
  final double latitude;
  final double longitude;
  final String? addressText;

  const RadarCoordinates({
    required this.latitude,
    required this.longitude,
    this.addressText,
  });

  GeoPointModel toGeoPoint() => GeoPointModel(latitude: latitude, longitude: longitude);

  factory RadarCoordinates.fromJson(Map<String, dynamic> json) {
    final lat = (json['latitude'] ?? json['destinationLatitude'] ?? 19.1383) as num;
    final lng = (json['longitude'] ?? json['destinationLongitude'] ?? 77.3210) as num;
    return RadarCoordinates(
      latitude: lat.toDouble(),
      longitude: lng.toDouble(),
      addressText: json['addressText'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        if (addressText != null) 'addressText': addressText,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadarCoordinates &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          addressText == other.addressText;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ addressText.hashCode;
}

/// Customer details in incoming radar broadcast.
class RadarCustomerInfo {
  final String firstName;
  final String locality;
  final double distanceKm;
  final int reachTimeMinutes;

  const RadarCustomerInfo({
    required this.firstName,
    required this.locality,
    required this.distanceKm,
    required this.reachTimeMinutes,
  });

  factory RadarCustomerInfo.fromJson(Map<String, dynamic> json) {
    return RadarCustomerInfo(
      firstName: json['firstName'] as String? ?? 'Valued Customer',
      locality: json['locality'] as String? ?? 'Nanded Corridor',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 1.5,
      reachTimeMinutes: (json['reachTimeMinutes'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'locality': locality,
        'distanceKm': distanceKm,
        'reachTimeMinutes': reachTimeMinutes,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadarCustomerInfo &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          locality == other.locality &&
          distanceKm == other.distanceKm &&
          reachTimeMinutes == other.reachTimeMinutes;

  @override
  int get hashCode =>
      firstName.hashCode ^ locality.hashCode ^ distanceKm.hashCode ^ reachTimeMinutes.hashCode;
}

/// Guaranteed payout details for artisan.
class RadarPayoutInfo {
  final String currency;
  final double guaranteedBase;
  final bool partsReimbursementAllowed;

  const RadarPayoutInfo({
    this.currency = 'INR',
    required this.guaranteedBase,
    this.partsReimbursementAllowed = true,
  });

  factory RadarPayoutInfo.fromJson(Map<String, dynamic> json) {
    return RadarPayoutInfo(
      currency: json['currency'] as String? ?? 'INR',
      guaranteedBase: (json['guaranteedBase'] as num?)?.toDouble() ?? 399.0,
      partsReimbursementAllowed: json['partsReimbursementAllowed'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'currency': currency,
        'guaranteedBase': guaranteedBase,
        'partsReimbursementAllowed': partsReimbursementAllowed,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadarPayoutInfo &&
          runtimeType == other.runtimeType &&
          currency == other.currency &&
          guaranteedBase == other.guaranteedBase &&
          partsReimbursementAllowed == other.partsReimbursementAllowed;

  @override
  int get hashCode =>
      currency.hashCode ^ guaranteedBase.hashCode ^ partsReimbursementAllowed.hashCode;
}

/// Attachments included in broadcast (photo, voice memo).
class RadarAttachments {
  final String? photoUrl;
  final String? voiceMemoUrl;
  final int? voiceMemoDurationSeconds;

  const RadarAttachments({
    this.photoUrl,
    this.voiceMemoUrl,
    this.voiceMemoDurationSeconds,
  });

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;
  bool get hasVoiceMemo => voiceMemoUrl != null && voiceMemoUrl!.isNotEmpty;

  factory RadarAttachments.fromJson(Map<String, dynamic> json) {
    return RadarAttachments(
      photoUrl: json['photoUrl'] as String?,
      voiceMemoUrl: json['voiceMemoUrl'] as String?,
      voiceMemoDurationSeconds: (json['voiceMemoDurationSeconds'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (voiceMemoUrl != null) 'voiceMemoUrl': voiceMemoUrl,
        if (voiceMemoDurationSeconds != null) 'voiceMemoDurationSeconds': voiceMemoDurationSeconds,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadarAttachments &&
          runtimeType == other.runtimeType &&
          photoUrl == other.photoUrl &&
          voiceMemoUrl == other.voiceMemoUrl &&
          voiceMemoDurationSeconds == other.voiceMemoDurationSeconds;

  @override
  int get hashCode =>
      photoUrl.hashCode ^ voiceMemoUrl.hashCode ^ voiceMemoDurationSeconds.hashCode;
}

/// Incoming Job Radar Broadcast Model strictly adhering to PROJECT.md Contract 2.
class JobRadarBroadcastModel {
  final String broadcastId;
  final String bookingId;
  final String category;
  final bool isEmergency;
  final String title;
  final RadarCustomerInfo customer;
  final RadarPayoutInfo payout;
  final RadarAttachments attachments;
  final String telephonyBridgeEndpoint;
  final String secureChatChannelId;
  final String maskedContactVirtualNumber;
  final int acceptanceCountdownSeconds;
  final DateTime expiresAt;
  final RadarRadiusTier radiusTier;
  final RadarDispatchState state;

  const JobRadarBroadcastModel({
    required this.broadcastId,
    required this.bookingId,
    required this.category,
    this.isEmergency = false,
    required this.title,
    required this.customer,
    required this.payout,
    this.attachments = const RadarAttachments(),
    this.telephonyBridgeEndpoint = '/api/v1/telephony/bridge-call',
    required this.secureChatChannelId,
    required this.maskedContactVirtualNumber,
    this.acceptanceCountdownSeconds = 45,
    required this.expiresAt,
    this.radiusTier = RadarRadiusTier.tier1Local,
    this.state = RadarDispatchState.broadcastActive,
  });

  /// Factory creating broadcast from raw map or Contract 2 envelope.
  factory JobRadarBroadcastModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final expiresRaw = data['expiresAt'];
    final DateTime expires = expiresRaw is String
        ? DateTime.parse(expiresRaw)
        : (expiresRaw is DateTime ? expiresRaw : DateTime.now().add(const Duration(seconds: 45)));

    final radiusTierStr = data['radiusTier'] as String?;
    final RadarRadiusTier tier = radiusTierStr == 'tier2Expanded' || radiusTierStr == '6.0' || radiusTierStr == '6'
        ? RadarRadiusTier.tier2Expanded
        : RadarRadiusTier.tier1Local;

    final stateStr = data['state'] as String?;
    final RadarDispatchState dispatchState;
    if (stateStr == 'ARTISAN_DISPATCHED' || stateStr == 'claimed') {
      dispatchState = RadarDispatchState.claimed;
    } else if (stateStr == 'DISPATCH_UNFULFILLED' || stateStr == 'unfulfilled') {
      dispatchState = RadarDispatchState.unfulfilled;
    } else {
      dispatchState = RadarDispatchState.broadcastActive;
    }

    return JobRadarBroadcastModel(
      broadcastId: data['broadcastId'] as String? ?? 'bc_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: data['bookingId'] as String? ?? 'BK_AUTO',
      category: data['category'] as String? ?? 'GENERAL',
      isEmergency: data['isEmergency'] as bool? ?? false,
      title: data['title'] as String? ?? 'New Service Request',
      customer: data['customer'] != null
          ? RadarCustomerInfo.fromJson(data['customer'] as Map<String, dynamic>)
          : const RadarCustomerInfo(
              firstName: 'Customer',
              locality: 'Nanded',
              distanceKm: 2.0,
              reachTimeMinutes: 10,
            ),
      payout: data['payout'] != null
          ? RadarPayoutInfo.fromJson(data['payout'] as Map<String, dynamic>)
          : const RadarPayoutInfo(guaranteedBase: 399.0),
      attachments: data['attachments'] != null
          ? RadarAttachments.fromJson(data['attachments'] as Map<String, dynamic>)
          : const RadarAttachments(),
      telephonyBridgeEndpoint: data['telephonyBridgeEndpoint'] as String? ?? '/api/v1/telephony/bridge-call',
      secureChatChannelId: data['secureChatChannelId'] as String? ?? 'ch_masked',
      maskedContactVirtualNumber: data['maskedContactVirtualNumber'] as String? ?? '+91-11-4084XXXX',
      acceptanceCountdownSeconds: (data['acceptanceCountdownSeconds'] as num?)?.toInt() ?? 45,
      expiresAt: expires,
      radiusTier: tier,
      state: dispatchState,
    );
  }

  Map<String, dynamic> toJson() => {
        'broadcastId': broadcastId,
        'bookingId': bookingId,
        'category': category,
        'isEmergency': isEmergency,
        'title': title,
        'customer': customer.toJson(),
        'payout': payout.toJson(),
        'attachments': attachments.toJson(),
        'telephonyBridgeEndpoint': telephonyBridgeEndpoint,
        'secureChatChannelId': secureChatChannelId,
        'maskedContactVirtualNumber': maskedContactVirtualNumber,
        'acceptanceCountdownSeconds': acceptanceCountdownSeconds,
        'expiresAt': expiresAt.toUtc().toIso8601String(),
        'radiusTier': radiusTier.name,
        'state': state.name,
      };

  JobRadarBroadcastModel copyWith({
    String? broadcastId,
    String? bookingId,
    String? category,
    bool? isEmergency,
    String? title,
    RadarCustomerInfo? customer,
    RadarPayoutInfo? payout,
    RadarAttachments? attachments,
    String? telephonyBridgeEndpoint,
    String? secureChatChannelId,
    String? maskedContactVirtualNumber,
    int? acceptanceCountdownSeconds,
    DateTime? expiresAt,
    RadarRadiusTier? radiusTier,
    RadarDispatchState? state,
  }) {
    return JobRadarBroadcastModel(
      broadcastId: broadcastId ?? this.broadcastId,
      bookingId: bookingId ?? this.bookingId,
      category: category ?? this.category,
      isEmergency: isEmergency ?? this.isEmergency,
      title: title ?? this.title,
      customer: customer ?? this.customer,
      payout: payout ?? this.payout,
      attachments: attachments ?? this.attachments,
      telephonyBridgeEndpoint: telephonyBridgeEndpoint ?? this.telephonyBridgeEndpoint,
      secureChatChannelId: secureChatChannelId ?? this.secureChatChannelId,
      maskedContactVirtualNumber: maskedContactVirtualNumber ?? this.maskedContactVirtualNumber,
      acceptanceCountdownSeconds: acceptanceCountdownSeconds ?? this.acceptanceCountdownSeconds,
      expiresAt: expiresAt ?? this.expiresAt,
      radiusTier: radiusTier ?? this.radiusTier,
      state: state ?? this.state,
    );
  }
}

/// Fallback / Expiry Event conforming to Contract 2 `job.radar.unfulfilled`.
class RadarUnfulfilledEvent {
  final String broadcastId;
  final String bookingId;
  final String state;
  final String reason;
  final String fallbackAction;
  final double expandedRadiusKm;
  final String customerNotification;
  final DateTime timestamp;

  const RadarUnfulfilledEvent({
    required this.broadcastId,
    required this.bookingId,
    this.state = 'DISPATCH_UNFULFILLED',
    this.reason = 'RADAR_45S_TIMER_EXPIRED_NO_ACCEPTANCE',
    this.fallbackAction = 'AUTO_RETRY_EXPANDED_RADIUS',
    this.expandedRadiusKm = 6.0,
    this.customerNotification = 'Searching expanded radius (6 km) for available Master Electricians.',
    required this.timestamp,
  });

  factory RadarUnfulfilledEvent.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final ts = json.containsKey('timestamp') && json['timestamp'] is String
        ? DateTime.parse(json['timestamp'] as String)
        : (data.containsKey('timestamp') && data['timestamp'] is String
            ? DateTime.parse(data['timestamp'] as String)
            : DateTime.now());

    return RadarUnfulfilledEvent(
      broadcastId: data['broadcastId'] as String? ?? '',
      bookingId: data['bookingId'] as String? ?? '',
      state: data['state'] as String? ?? 'DISPATCH_UNFULFILLED',
      reason: data['reason'] as String? ?? 'RADAR_45S_TIMER_EXPIRED_NO_ACCEPTANCE',
      fallbackAction: data['fallbackAction'] as String? ?? 'AUTO_RETRY_EXPANDED_RADIUS',
      expandedRadiusKm: (data['expandedRadiusKm'] as num?)?.toDouble() ?? 6.0,
      customerNotification: data['customerNotification'] as String? ??
          'Searching expanded radius (6 km) for available Master Electricians.',
      timestamp: ts,
    );
  }

  Map<String, dynamic> toJson() => {
        'broadcastId': broadcastId,
        'bookingId': bookingId,
        'state': state,
        'reason': reason,
        'fallbackAction': fallbackAction,
        'expandedRadiusKm': expandedRadiusKm,
        'customerNotification': customerNotification,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

/// Partner accept job response conforming to Contract 2.
class BroadcastAcceptResult {
  final String bookingId;
  final String state;
  final String assignedArtisanId;
  final RadarCoordinates navigationCoordinates;
  final bool startOtpVerificationRequired;
  final String? doorstepStartOtpExpected;

  const BroadcastAcceptResult({
    required this.bookingId,
    this.state = 'ARTISAN_DISPATCHED',
    required this.assignedArtisanId,
    required this.navigationCoordinates,
    this.startOtpVerificationRequired = true,
    this.doorstepStartOtpExpected = '4921',
  });

  factory BroadcastAcceptResult.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final navCoords = data['navigationCoordinates'] != null
        ? RadarCoordinates.fromJson(data['navigationCoordinates'] as Map<String, dynamic>)
        : const RadarCoordinates(
            latitude: 19.1383,
            longitude: 77.3210,
            addressText: 'Anand Nagar, Nanded',
          );

    return BroadcastAcceptResult(
      bookingId: data['bookingId'] as String? ?? '',
      state: data['state'] as String? ?? 'ARTISAN_DISPATCHED',
      assignedArtisanId: data['assignedArtisanId'] as String? ?? '',
      navigationCoordinates: navCoords,
      startOtpVerificationRequired: data['startOtpVerificationRequired'] as bool? ?? true,
      doorstepStartOtpExpected: data['doorstepStartOtpExpected'] as String? ?? '4921',
    );
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'state': state,
        'assignedArtisanId': assignedArtisanId,
        'navigationCoordinates': navigationCoordinates.toJson(),
        'startOtpVerificationRequired': startOtpVerificationRequired,
        if (doorstepStartOtpExpected != null) 'doorstepStartOtpExpected': doorstepStartOtpExpected,
      };
}
