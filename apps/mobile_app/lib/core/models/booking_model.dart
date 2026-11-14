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
  final BookingStatus status;
  final String startOtp; // Default '4921'
  final String completionOtp;
  final int baseInspectionFee;
  final int laborFee;
  final int safetyShieldFee;
  final List<BillPartItem> parts;
  final String? audioMemoUrl;
  final List<String> defectPhotoUrls;
  final DateTime createdAt;
  final DateTime? arrivalTime;
  final DateTime? completionTime;

  // Ticket T-05 Fields: Upfront Mandate, Financial Breakdown, and Dwell Tracking
  final UpiMandateStatus mandateStatus;
  final String? mandateId;
  final String? upiVpa;
  final int partsGatewaySurcharge;
  final int gstAmount;
  final int grandTotal;
  final int dwellMinutesAtDestination;

  const BookingModel({
    required this.bookingId,
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
    required this.status,
    this.startOtp = '4921',
    this.completionOtp = '7294',
    this.baseInspectionFee = 199,
    this.laborFee = 249,
    this.safetyShieldFee = 29,
    this.parts = const [],
    this.audioMemoUrl,
    this.defectPhotoUrls = const [],
    required this.createdAt,
    this.arrivalTime,
    this.completionTime,
    this.mandateStatus = UpiMandateStatus.authorized,
    this.mandateId = 'man_preauth_9981',
    this.upiVpa = 'customer@okaxis',
    this.partsGatewaySurcharge = 8,
    this.gstAmount = 115,
    this.grandTotal = 752,
    this.dwellMinutesAtDestination = 16,
  });

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

  bool verifyStartOtp(String code) => code.trim() == startOtp;
  bool verifyCompletionOtp(String code) => code.trim() == completionOtp;

  BookingModel copyWith({
    BookingStatus? status,
    String? assignedArtisanId,
    String? assignedArtisanName,
    String? assignedArtisanPhone,
    List<BillPartItem>? parts,
    DateTime? arrivalTime,
    DateTime? completionTime,
    UpiMandateStatus? mandateStatus,
    String? mandateId,
    String? upiVpa,
    int? partsGatewaySurcharge,
    int? gstAmount,
    int? grandTotal,
    int? dwellMinutesAtDestination,
  }) {
    return BookingModel(
      bookingId: bookingId,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      assignedArtisanId: assignedArtisanId ?? this.assignedArtisanId,
      assignedArtisanName: assignedArtisanName ?? this.assignedArtisanName,
      assignedArtisanPhone: assignedArtisanPhone ?? this.assignedArtisanPhone,
      tradeId: tradeId,
      tradeName: tradeName,
      localityId: localityId,
      localityName: localityName,
      address: address,
      status: status ?? this.status,
      startOtp: startOtp,
      completionOtp: completionOtp,
      baseInspectionFee: baseInspectionFee,
      laborFee: laborFee,
      safetyShieldFee: safetyShieldFee,
      parts: parts ?? this.parts,
      audioMemoUrl: audioMemoUrl,
      defectPhotoUrls: defectPhotoUrls,
      createdAt: createdAt,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      completionTime: completionTime ?? this.completionTime,
      mandateStatus: mandateStatus ?? this.mandateStatus,
      mandateId: mandateId ?? this.mandateId,
      upiVpa: upiVpa ?? this.upiVpa,
      partsGatewaySurcharge: partsGatewaySurcharge ?? this.partsGatewaySurcharge,
      gstAmount: gstAmount ?? this.gstAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      dwellMinutesAtDestination: dwellMinutesAtDestination ?? this.dwellMinutesAtDestination,
    );
  }
}
