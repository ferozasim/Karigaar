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

class BillPartItem {
  final String id;
  final String name;
  final int unitPrice;
  final int quantity;
  final String? receiptPhotoUrl;
  final bool isApproved;

  const BillPartItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    this.quantity = 1,
    this.receiptPhotoUrl,
    this.isApproved = true,
  });

  int get total => unitPrice * quantity;

  factory BillPartItem.fromJson(Map<String, dynamic> json) {
    return BillPartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      unitPrice: json['unitPrice'] as int,
      quantity: json['quantity'] as int? ?? 1,
      receiptPhotoUrl: json['receiptPhotoUrl'] as String?,
      isApproved: json['isApproved'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'receiptPhotoUrl': receiptPhotoUrl,
        'isApproved': isApproved,
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
  });

  int get partsTotal => parts.fold(0, (sum, part) => sum + part.total);
  int get totalAmount => laborFee + safetyShieldFee + partsTotal;
  int get totalFinalAmount => totalAmount;
  String get issueTitle => '$tradeName Service & Diagnostic';
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
    );
  }
}
