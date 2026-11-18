/// Typed model for Completed Job Settlement Ledger & IMPS Payout entries
/// in the Karigaar Partner Guild Wallet (`/artisan/wallet`).
class WalletSettlementEntry {
  final String id;
  final String bookingId;
  final String jobTitle;
  final String customerLocality;
  final String completedAtLabel;
  final double laborAmount;
  final double partsPassThrough;
  final double commissionRate;
  final double commissionAmount;
  final double netPayout;
  final bool isCredit;
  final bool isImpsWithdrawal;
  final String statusLabel;
  final String? bankReference;
  final bool isToday;
  final bool isThisWeek;

  const WalletSettlementEntry({
    required this.id,
    required this.bookingId,
    required this.jobTitle,
    required this.customerLocality,
    required this.completedAtLabel,
    required this.laborAmount,
    required this.partsPassThrough,
    required this.commissionRate,
    required this.commissionAmount,
    required this.netPayout,
    required this.isCredit,
    required this.isImpsWithdrawal,
    required this.statusLabel,
    this.bankReference,
    this.isToday = false,
    this.isThisWeek = true,
  });

  /// Commission percentage as integer (e.g. 5 or 12)
  int get commissionPercent => (commissionRate * 100).round();

  WalletSettlementEntry copyWith({
    String? id,
    String? bookingId,
    String? jobTitle,
    String? customerLocality,
    String? completedAtLabel,
    double? laborAmount,
    double? partsPassThrough,
    double? commissionRate,
    double? commissionAmount,
    double? netPayout,
    bool? isCredit,
    bool? isImpsWithdrawal,
    String? statusLabel,
    String? bankReference,
    bool? isToday,
    bool? isThisWeek,
  }) {
    return WalletSettlementEntry(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      jobTitle: jobTitle ?? this.jobTitle,
      customerLocality: customerLocality ?? this.customerLocality,
      completedAtLabel: completedAtLabel ?? this.completedAtLabel,
      laborAmount: laborAmount ?? this.laborAmount,
      partsPassThrough: partsPassThrough ?? this.partsPassThrough,
      commissionRate: commissionRate ?? this.commissionRate,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      netPayout: netPayout ?? this.netPayout,
      isCredit: isCredit ?? this.isCredit,
      isImpsWithdrawal: isImpsWithdrawal ?? this.isImpsWithdrawal,
      statusLabel: statusLabel ?? this.statusLabel,
      bankReference: bankReference ?? this.bankReference,
      isToday: isToday ?? this.isToday,
      isThisWeek: isThisWeek ?? this.isThisWeek,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingId': bookingId,
        'jobTitle': jobTitle,
        'customerLocality': customerLocality,
        'completedAtLabel': completedAtLabel,
        'laborAmount': laborAmount,
        'partsPassThrough': partsPassThrough,
        'commissionRate': commissionRate,
        'commissionAmount': commissionAmount,
        'netPayout': netPayout,
        'isCredit': isCredit,
        'isImpsWithdrawal': isImpsWithdrawal,
        'statusLabel': statusLabel,
        if (bankReference != null) 'bankReference': bankReference,
        'isToday': isToday,
        'isThisWeek': isThisWeek,
      };

  factory WalletSettlementEntry.fromJson(Map<String, dynamic> json) {
    return WalletSettlementEntry(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      jobTitle: json['jobTitle'] as String,
      customerLocality: json['customerLocality'] as String,
      completedAtLabel: json['completedAtLabel'] as String,
      laborAmount: (json['laborAmount'] as num).toDouble(),
      partsPassThrough: (json['partsPassThrough'] as num).toDouble(),
      commissionRate: (json['commissionRate'] as num).toDouble(),
      commissionAmount: (json['commissionAmount'] as num).toDouble(),
      netPayout: (json['netPayout'] as num).toDouble(),
      isCredit: json['isCredit'] as bool,
      isImpsWithdrawal: json['isImpsWithdrawal'] as bool,
      statusLabel: json['statusLabel'] as String,
      bankReference: json['bankReference'] as String?,
      isToday: json['isToday'] as bool? ?? false,
      isThisWeek: json['isThisWeek'] as bool? ?? true,
    );
  }
}
