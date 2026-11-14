// Meta WhatsApp Business Cloud API & Telephony Cloud Proxy Models
// Conforming to Meta Graph API v21.0 & Contract 2 Virtual Telephony Bridge

enum WhatsAppDeliveryStatus {
  sent,
  delivered,
  read,
  failed,
}

enum WhatsAppTemplateType {
  dispatchAlert,
  authOtp,
  milestoneUpdate,
  voiceMemoRelay,
  dailySettlementSlip,
}

extension WhatsAppTemplateTypeExtension on WhatsAppTemplateType {
  String get templateName {
    switch (this) {
      case WhatsAppTemplateType.dispatchAlert:
        return 'dispatch_alert';
      case WhatsAppTemplateType.authOtp:
        return 'auth_otp';
      case WhatsAppTemplateType.milestoneUpdate:
        return 'milestone_update';
      case WhatsAppTemplateType.voiceMemoRelay:
        return 'voice_memo_relay';
      case WhatsAppTemplateType.dailySettlementSlip:
        return 'daily_settlement_slip';
    }
  }

  static WhatsAppTemplateType fromName(String name) {
    switch (name) {
      case 'dispatch_alert':
        return WhatsAppTemplateType.dispatchAlert;
      case 'auth_otp':
        return WhatsAppTemplateType.authOtp;
      case 'milestone_update':
        return WhatsAppTemplateType.milestoneUpdate;
      case 'voice_memo_relay':
        return WhatsAppTemplateType.voiceMemoRelay;
      case 'daily_settlement_slip':
        return WhatsAppTemplateType.dailySettlementSlip;
      default:
        throw ArgumentError('Unsupported WhatsApp template name: $name');
    }
  }
}

class WhatsAppTemplateParameter {
  final String type; // text, currency, date_time, audio, payload
  final String? text;
  final String? audioUrl;
  final int? currencyAmount;
  final String? payload;

  const WhatsAppTemplateParameter({
    required this.type,
    this.text,
    this.audioUrl,
    this.currencyAmount,
    this.payload,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'type': type};
    if (text != null) map['text'] = text;
    if (audioUrl != null) {
      map['audio'] = {'link': audioUrl};
    }
    if (currencyAmount != null) {
      map['currency'] = {
        'fallback_value': '₹$currencyAmount',
        'code': 'INR',
        'amount_1000': currencyAmount! * 1000,
      };
    }
    if (payload != null) map['payload'] = payload;
    return map;
  }

  factory WhatsAppTemplateParameter.fromJson(Map<String, dynamic> json) {
    return WhatsAppTemplateParameter(
      type: json['type'] as String? ?? 'text',
      text: json['text'] as String?,
      audioUrl: json['audio'] is Map ? (json['audio'] as Map)['link'] as String? : null,
      currencyAmount: json['currency'] is Map ? ((json['currency'] as Map)['amount_1000'] as int? ?? 0) ~/ 1000 : null,
      payload: json['payload'] as String?,
    );
  }
}

class WhatsAppTemplateComponent {
  final String type; // header, body, button
  final String? subType; // url, quick_reply
  final int? index;
  final List<WhatsAppTemplateParameter> parameters;

  const WhatsAppTemplateComponent({
    required this.type,
    this.subType,
    this.index,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'type': type,
      'parameters': parameters.map((p) => p.toJson()).toList(),
    };
    if (subType != null) map['sub_type'] = subType;
    if (index != null) map['index'] = index;
    return map;
  }

  factory WhatsAppTemplateComponent.fromJson(Map<String, dynamic> json) {
    return WhatsAppTemplateComponent(
      type: json['type'] as String? ?? 'body',
      subType: json['sub_type'] as String?,
      index: json['index'] as int?,
      parameters: (json['parameters'] as List<dynamic>? ?? [])
          .map((p) => WhatsAppTemplateParameter.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WhatsAppOutboundReceipt {
  final String messageId;
  final String recipientPhone;
  final String templateName;
  final String languageCode;
  final WhatsAppDeliveryStatus status;
  final DateTime timestamp;

  const WhatsAppOutboundReceipt({
    required this.messageId,
    required this.recipientPhone,
    required this.templateName,
    required this.languageCode,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'recipientPhone': recipientPhone,
        'templateName': templateName,
        'languageCode': languageCode,
        'status': status.name.toUpperCase(),
        'timestamp': timestamp.toIso8601String(),
      };

  factory WhatsAppOutboundReceipt.fromJson(Map<String, dynamic> json) {
    return WhatsAppOutboundReceipt(
      messageId: json['messageId'] as String? ?? '',
      recipientPhone: json['recipientPhone'] as String? ?? '',
      templateName: json['templateName'] as String? ?? '',
      languageCode: json['languageCode'] as String? ?? 'en_US',
      status: WhatsAppDeliveryStatus.values.firstWhere(
        (s) => s.name.toUpperCase() == (json['status'] as String? ?? 'SENT'),
        orElse: () => WhatsAppDeliveryStatus.sent,
      ),
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class TelephonyBridgeSession {
  final String sessionId;
  final String? bookingId;
  final String callerRole;
  final String virtualProxyNumber;
  final String sessionStatus; // BRIDGED, COMPLETED, EXPIRED, TERMINATED
  final bool zeroRawMsisdnLeakageGuaranteed;
  final int expiresInSeconds;
  final DateTime createdAt;

  const TelephonyBridgeSession({
    required this.sessionId,
    this.bookingId,
    required this.callerRole,
    this.virtualProxyNumber = '+91-11-4084-2190',
    this.sessionStatus = 'BRIDGED',
    this.zeroRawMsisdnLeakageGuaranteed = true,
    this.expiresInSeconds = 600,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().difference(createdAt).inSeconds >= expiresInSeconds;
  int get remainingSeconds => (expiresInSeconds - DateTime.now().difference(createdAt).inSeconds).clamp(0, expiresInSeconds);

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'bookingId': bookingId,
        'callerRole': callerRole,
        'virtualProxyNumber': virtualProxyNumber,
        'sessionStatus': isExpired ? 'EXPIRED' : sessionStatus,
        'zeroRawMsisdnLeakageGuaranteed': zeroRawMsisdnLeakageGuaranteed,
        'expiresInSeconds': expiresInSeconds,
        'remainingSeconds': remainingSeconds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TelephonyBridgeSession.fromJson(Map<String, dynamic> json) {
    return TelephonyBridgeSession(
      sessionId: json['sessionId'] as String? ?? '',
      bookingId: json['bookingId'] as String?,
      callerRole: json['callerRole'] as String? ?? 'CUSTOMER',
      virtualProxyNumber: json['virtualProxyNumber'] as String? ?? '+91-11-4084-2190',
      sessionStatus: json['sessionStatus'] as String? ?? 'BRIDGED',
      zeroRawMsisdnLeakageGuaranteed: json['zeroRawMsisdnLeakageGuaranteed'] as bool? ?? true,
      expiresInSeconds: json['expiresInSeconds'] as int? ?? 600,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class DualSyncDispatchResult {
  final String bookingId;
  final bool inAppBroadcastDispatched;
  final bool whatsAppTemplateDispatched;
  final String whatsAppMessageId;
  final bool audioMemoRelayed;
  final bool societyCodeIncluded;
  final bool mapsLinkIncluded;
  final bool maskedCallBridgeReady;
  final String virtualProxyNumber;

  const DualSyncDispatchResult({
    required this.bookingId,
    required this.inAppBroadcastDispatched,
    required this.whatsAppTemplateDispatched,
    required this.whatsAppMessageId,
    required this.audioMemoRelayed,
    required this.societyCodeIncluded,
    required this.mapsLinkIncluded,
    required this.maskedCallBridgeReady,
    this.virtualProxyNumber = '+91-11-4084-2190',
  });

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'inAppBroadcastDispatched': inAppBroadcastDispatched,
        'whatsAppTemplateDispatched': whatsAppTemplateDispatched,
        'whatsAppMessageId': whatsAppMessageId,
        'audioMemoRelayed': audioMemoRelayed,
        'societyCodeIncluded': societyCodeIncluded,
        'mapsLinkIncluded': mapsLinkIncluded,
        'maskedCallBridgeReady': maskedCallBridgeReady,
        'virtualProxyNumber': virtualProxyNumber,
      };

  factory DualSyncDispatchResult.fromJson(Map<String, dynamic> json) {
    return DualSyncDispatchResult(
      bookingId: json['bookingId'] as String? ?? '',
      inAppBroadcastDispatched: json['inAppBroadcastDispatched'] as bool? ?? false,
      whatsAppTemplateDispatched: json['whatsAppTemplateDispatched'] as bool? ?? false,
      whatsAppMessageId: json['whatsAppMessageId'] as String? ?? '',
      audioMemoRelayed: json['audioMemoRelayed'] as bool? ?? false,
      societyCodeIncluded: json['societyCodeIncluded'] as bool? ?? false,
      mapsLinkIncluded: json['mapsLinkIncluded'] as bool? ?? false,
      maskedCallBridgeReady: json['maskedCallBridgeReady'] as bool? ?? false,
      virtualProxyNumber: json['virtualProxyNumber'] as String? ?? '+91-11-4084-2190',
    );
  }
}
