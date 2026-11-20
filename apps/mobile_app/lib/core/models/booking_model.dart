import 'booking_lifecycle.dart';

enum BookingStatus {
  draft,
  broadcasting,
  claimed,
  assigned,
  artisanEnRoute,
  artisanArrived,
  workInProgress,
  partsPendingApproval,
  completionPendingOtp,
  completed,
  cancelledByCustomer,
  cancelledByArtisan,
  disputed,
  dispatchFailed,
  settled;

  String get label {
    switch (this) {
      case BookingStatus.draft:
        return 'Drafting';
      case BookingStatus.broadcasting:
        return 'Radar Broadcasting (45s)';
      case BookingStatus.claimed:
        return 'Job Claimed';
      case BookingStatus.assigned:
        return 'Artisan Assigned';
      case BookingStatus.artisanEnRoute:
        return 'Artisan En Route';
      case BookingStatus.artisanArrived:
        return 'Arrived at Doorstep';
      case BookingStatus.workInProgress:
        return 'Work In Progress';
      case BookingStatus.partsPendingApproval:
        return 'Parts Review Pending';
      case BookingStatus.completionPendingOtp:
        return 'Awaiting Completion PIN';
      case BookingStatus.completed:
        return 'Service Completed';
      case BookingStatus.cancelledByCustomer:
        return 'Cancelled by Customer';
      case BookingStatus.cancelledByArtisan:
        return 'Cancelled by Artisan';
      case BookingStatus.disputed:
        return 'Dispute In Review';
      case BookingStatus.dispatchFailed:
        return 'Dispatch needs a retry';
      case BookingStatus.settled:
        return 'Settled & Paid Out';
    }
  }

  bool get isActive =>
      this != BookingStatus.draft &&
      this != BookingStatus.completed &&
      this != BookingStatus.cancelledByCustomer &&
      this != BookingStatus.cancelledByArtisan &&
      this != BookingStatus.settled;
}

/// Upfront UPI Pre-Authorization Mandate Lifecycle Status (Razorpay / Cashfree compliant)
enum UpiMandateStatus {
  created,
  authorized,
  captured,
  released,
  revoked;

  bool get isSecured => this == UpiMandateStatus.authorized;
  bool get isCaptured => this == UpiMandateStatus.captured;
  bool get isReleased => this == UpiMandateStatus.released;
  bool get isRevoked => this == UpiMandateStatus.revoked;
}

class BillPartItem {
  final String id;
  final String name;
  final int unitPrice;
  final int quantity;
  final String? receiptPhotoUrl;
  final String? hardwareStoreName;
  final bool isApproved;
  final bool is2FaApproved;

  const BillPartItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    this.quantity = 1,
    this.receiptPhotoUrl,
    this.hardwareStoreName,
    this.isApproved = true,
    this.is2FaApproved = true,
  });

  int get total => unitPrice * quantity;

  factory BillPartItem.fromJson(Map<String, dynamic> json) {
    return BillPartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      unitPrice: json['unitPrice'] as int,
      quantity: json['quantity'] as int? ?? 1,
      receiptPhotoUrl: json['receiptPhotoUrl'] as String?,
      hardwareStoreName: json['hardwareStoreName'] as String?,
      isApproved: json['isApproved'] as bool? ?? true,
      is2FaApproved: json['is2FaApproved'] as bool? ?? (json['isApproved'] as bool? ?? true),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'receiptPhotoUrl': receiptPhotoUrl,
        'hardwareStoreName': hardwareStoreName,
        'isApproved': isApproved,
        'is2FaApproved': is2FaApproved,
      };
}

class BookingModel {
  final String bookingId;
  final String idempotencyKey;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String? assignedArtisanId;
  final String? assignedArtisanName;
  final String? assignedArtisanPhone;
  final String tradeId;
  final String tradeName;
  final String localityId;
  final String localityName;
  final String address;
  final String problemDescription;
  final bool issuePhotoAttached;
  final BookingStatus status;
  final String startOtp; // Default '4921'
  final String completionOtp;
  final int baseInspectionFee;
  final int laborFee;
  final int safetyShieldFee;
  final List<BillPartItem> parts;
  final String? audioMemoUrl;
  final int? audioMemoDurationSeconds;
  final List<double>? audioMemoWaveform;
  final String? audioMemoTranscript;
  final List<String> defectPhotoUrls;
  final DateTime createdAt;
  final DateTime? arrivalTime;
  final DateTime? completionTime;
  final List<BookingStatusEvent> statusEvents;

  // Scheduled Arrival Slot Fields (Ticket T-08 F-11)
  final DateTime? scheduledDate;
  final String? scheduledSlot;
  final String? scheduledSlotId;
  final bool isEmergencyDispatch;

  // Ticket T-05 Fields: Upfront Mandate, Financial Breakdown, and Dwell Tracking
  final UpiMandateStatus mandateStatus;
  final String? mandateId;
  final String? upiVpa;
  final int partsGatewaySurcharge;
  final int gstAmount;
  final int grandTotal;
  final int dwellMinutesAtDestination;

  // Ticket T-09 Fields: Two-Tier Guild Damage Shield & Retroactive On-Site Lock
  final int damageCoverAmount;
  final int customerDeductible;
  final bool isRetroactiveOnSiteLock;

  const BookingModel({
    required this.bookingId,
    String? idempotencyKey,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    this.assignedArtisanId,
    this.assignedArtisanName,
    this.assignedArtisanPhone,
    required this.tradeId,
    required this.tradeName,
    required this.localityId,
    required this.localityName,
    required this.address,
    this.problemDescription = '',
    this.issuePhotoAttached = false,
    required this.status,
    this.startOtp = '4921',
    this.completionOtp = '7294',
    this.baseInspectionFee = 199,
    this.laborFee = 249,
    this.safetyShieldFee = 29,
    this.parts = const [],
    this.audioMemoUrl,
    this.audioMemoDurationSeconds,
    this.audioMemoWaveform,
    this.audioMemoTranscript,
    this.defectPhotoUrls = const [],
    required this.createdAt,
    this.arrivalTime,
    this.completionTime,
    this.statusEvents = const [],
    this.scheduledDate,
    this.scheduledSlot,
    this.scheduledSlotId,
    this.isEmergencyDispatch = false,
    this.mandateStatus = UpiMandateStatus.authorized,
    this.mandateId = 'man_preauth_9981',
    this.upiVpa = 'customer@okaxis',
    this.partsGatewaySurcharge = 8,
    this.gstAmount = 115,
    this.grandTotal = 752,
    this.dwellMinutesAtDestination = 16,
    this.damageCoverAmount = 25000,
    this.customerDeductible = 250,
    this.isRetroactiveOnSiteLock = false,
  }) : idempotencyKey = idempotencyKey ?? bookingId;

  int get partsTotal => parts.fold(0, (sum, part) => sum + part.total);
  int get calculatedPartsSurcharge => (partsTotal * 0.02).round();
  int get calculatedSubtotal => laborFee + partsTotal + calculatedPartsSurcharge;
  int get calculatedGstAmount => (calculatedSubtotal * 0.18).round();
  int get calculatedGrandTotal => calculatedSubtotal + calculatedGstAmount;

  int get totalAmount => laborFee + safetyShieldFee + partsTotal;
  int get totalFinalAmount => grandTotal > 0 ? grandTotal : calculatedGrandTotal;
  String get issueTitle => '$tradeName Service & Diagnostic';
  String get artisanId => assignedArtisanId ?? 'art_nanded_01';
  String get artisanName => assignedArtisanName ?? 'Ganesh Kadam';
  String get customerAddress => address;

  String get damageCoverLabel =>
      '₹${(damageCoverAmount / 1000).round()}k ${damageCoverAmount >= 25000 ? "Master" : "Base"} Cover (₹$customerDeductible Deductible)';

  bool verifyStartOtp(String code) => code.trim() == startOtp;
  bool verifyCompletionOtp(String code) => code.trim() == completionOtp;

  BookingModel copyWith({
    BookingStatus? status,
    String? idempotencyKey,
    List<BookingStatusEvent>? statusEvents,
    String? assignedArtisanId,
    String? assignedArtisanName,
    String? assignedArtisanPhone,
    bool clearAssignedArtisan = false,
    String? problemDescription,
    bool? issuePhotoAttached,
    List<BillPartItem>? parts,
    String? audioMemoUrl,
    int? audioMemoDurationSeconds,
    List<double>? audioMemoWaveform,
    String? audioMemoTranscript,
    List<String>? defectPhotoUrls,
    DateTime? arrivalTime,
    DateTime? completionTime,
    DateTime? scheduledDate,
    String? scheduledSlot,
    String? scheduledSlotId,
    bool? isEmergencyDispatch,
    UpiMandateStatus? mandateStatus,
    String? mandateId,
    String? upiVpa,
    int? partsGatewaySurcharge,
    int? gstAmount,
    int? grandTotal,
    int? dwellMinutesAtDestination,
    int? damageCoverAmount,
    int? customerDeductible,
    bool? isRetroactiveOnSiteLock,
  }) {
    return BookingModel(
      bookingId: bookingId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      assignedArtisanId: clearAssignedArtisan
          ? null
          : assignedArtisanId ?? this.assignedArtisanId,
      assignedArtisanName: clearAssignedArtisan
          ? null
          : assignedArtisanName ?? this.assignedArtisanName,
      assignedArtisanPhone: clearAssignedArtisan
          ? null
          : assignedArtisanPhone ?? this.assignedArtisanPhone,
      tradeId: tradeId,
      tradeName: tradeName,
      localityId: localityId,
      localityName: localityName,
      address: address,
      problemDescription: problemDescription ?? this.problemDescription,
      issuePhotoAttached: issuePhotoAttached ?? this.issuePhotoAttached,
      status: status ?? this.status,
      statusEvents: statusEvents ?? this.statusEvents,
      startOtp: startOtp,
      completionOtp: completionOtp,
      baseInspectionFee: baseInspectionFee,
      laborFee: laborFee,
      safetyShieldFee: safetyShieldFee,
      parts: parts ?? this.parts,
      audioMemoUrl: audioMemoUrl ?? this.audioMemoUrl,
      audioMemoDurationSeconds: audioMemoDurationSeconds ?? this.audioMemoDurationSeconds,
      audioMemoWaveform: audioMemoWaveform ?? this.audioMemoWaveform,
      audioMemoTranscript: audioMemoTranscript ?? this.audioMemoTranscript,
      defectPhotoUrls: defectPhotoUrls ?? this.defectPhotoUrls,
      createdAt: createdAt,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      completionTime: completionTime ?? this.completionTime,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledSlot: scheduledSlot ?? this.scheduledSlot,
      scheduledSlotId: scheduledSlotId ?? this.scheduledSlotId,
      isEmergencyDispatch: isEmergencyDispatch ?? this.isEmergencyDispatch,
      mandateStatus: mandateStatus ?? this.mandateStatus,
      mandateId: mandateId ?? this.mandateId,
      upiVpa: upiVpa ?? this.upiVpa,
      partsGatewaySurcharge: partsGatewaySurcharge ?? this.partsGatewaySurcharge,
      gstAmount: gstAmount ?? this.gstAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      dwellMinutesAtDestination: dwellMinutesAtDestination ?? this.dwellMinutesAtDestination,
      damageCoverAmount: damageCoverAmount ?? this.damageCoverAmount,
      customerDeductible: customerDeductible ?? this.customerDeductible,
      isRetroactiveOnSiteLock: isRetroactiveOnSiteLock ?? this.isRetroactiveOnSiteLock,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'] as String,
      idempotencyKey: json['idempotencyKey'] as String?,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      assignedArtisanId: json['assignedArtisanId'] as String?,
      assignedArtisanName: json['assignedArtisanName'] as String?,
      assignedArtisanPhone: json['assignedArtisanPhone'] as String?,
      tradeId: json['tradeId'] as String,
      tradeName: json['tradeName'] as String,
      localityId: json['localityId'] as String,
      localityName: json['localityName'] as String,
      address: json['address'] as String,
      problemDescription: json['problemDescription'] as String? ?? '',
      issuePhotoAttached: json['issuePhotoAttached'] as bool? ?? false,
      status: BookingStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => BookingStatus.draft,
      ),
      statusEvents: (json['statusEvents'] as List<dynamic>?)
              ?.map((event) => BookingStatusEvent.fromJson(
                  event as Map<String, dynamic>))
              .toList(growable: false) ??
          const [],
      startOtp: json['startOtp'] as String? ?? '4921',
      completionOtp: json['completionOtp'] as String? ?? '7294',
      baseInspectionFee: (json['baseInspectionFee'] as num?)?.toInt() ?? 199,
      laborFee: (json['laborFee'] as num?)?.toInt() ?? 249,
      safetyShieldFee: (json['safetyShieldFee'] as num?)?.toInt() ?? 29,
      parts: (json['parts'] as List<dynamic>?)
              ?.map((p) => BillPartItem.fromJson(p as Map<String, dynamic>))
              .toList() ??
          const [],
      audioMemoUrl: json['audioMemoUrl'] as String?,
      audioMemoDurationSeconds: (json['audioMemoDurationSeconds'] as num?)?.toInt(),
      audioMemoWaveform: (json['audioMemoWaveform'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      audioMemoTranscript: json['audioMemoTranscript'] as String?,
      defectPhotoUrls: (json['defectPhotoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'] as String)
          : null,
      completionTime: json['completionTime'] != null
          ? DateTime.parse(json['completionTime'] as String)
          : null,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
      scheduledSlot: json['scheduledSlot'] as String?,
      scheduledSlotId: json['scheduledSlotId'] as String?,
      isEmergencyDispatch: json['isEmergencyDispatch'] as bool? ?? false,
      mandateStatus: UpiMandateStatus.values.firstWhere(
        (m) => m.name == json['mandateStatus'],
        orElse: () => UpiMandateStatus.authorized,
      ),
      mandateId: json['mandateId'] as String? ?? 'man_preauth_9981',
      upiVpa: json['upiVpa'] as String? ?? 'customer@okaxis',
      partsGatewaySurcharge: (json['partsGatewaySurcharge'] as num?)?.toInt() ?? 8,
      gstAmount: (json['gstAmount'] as num?)?.toInt() ?? 115,
      grandTotal: (json['grandTotal'] as num?)?.toInt() ?? 752,
      dwellMinutesAtDestination: (json['dwellMinutesAtDestination'] as num?)?.toInt() ?? 16,
    );
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'idempotencyKey': idempotencyKey,
        'customerId': customerId,
        'customerName': customerName,
        'customerPhone': customerPhone,
        if (assignedArtisanId != null) 'assignedArtisanId': assignedArtisanId,
        if (assignedArtisanName != null) 'assignedArtisanName': assignedArtisanName,
        if (assignedArtisanPhone != null) 'assignedArtisanPhone': assignedArtisanPhone,
        'tradeId': tradeId,
        'tradeName': tradeName,
        'localityId': localityId,
        'localityName': localityName,
        'address': address,
        'problemDescription': problemDescription,
        'issuePhotoAttached': issuePhotoAttached,
        'status': status.name,
        'statusEvents': statusEvents.map((event) => event.toJson()).toList(),
        'startOtp': startOtp,
        'completionOtp': completionOtp,
        'baseInspectionFee': baseInspectionFee,
        'laborFee': laborFee,
        'safetyShieldFee': safetyShieldFee,
        'parts': parts.map((p) => p.toJson()).toList(),
        if (audioMemoUrl != null) 'audioMemoUrl': audioMemoUrl,
        if (audioMemoDurationSeconds != null)
          'audioMemoDurationSeconds': audioMemoDurationSeconds,
        if (audioMemoWaveform != null) 'audioMemoWaveform': audioMemoWaveform,
        if (audioMemoTranscript != null)
          'audioMemoTranscript': audioMemoTranscript,
        'defectPhotoUrls': defectPhotoUrls,
        'createdAt': createdAt.toIso8601String(),
        if (arrivalTime != null) 'arrivalTime': arrivalTime!.toIso8601String(),
        if (completionTime != null)
          'completionTime': completionTime!.toIso8601String(),
        if (scheduledDate != null)
          'scheduledDate': scheduledDate!.toIso8601String(),
        if (scheduledSlot != null) 'scheduledSlot': scheduledSlot,
        if (scheduledSlotId != null) 'scheduledSlotId': scheduledSlotId,
        'isEmergencyDispatch': isEmergencyDispatch,
        'mandateStatus': mandateStatus.name,
        if (mandateId != null) 'mandateId': mandateId,
        if (upiVpa != null) 'upiVpa': upiVpa,
        'partsGatewaySurcharge': partsGatewaySurcharge,
        'gstAmount': gstAmount,
        'grandTotal': grandTotal,
        'dwellMinutesAtDestination': dwellMinutesAtDestination,
      };
}
