/// Balance amounts are stored in paise to avoid floating-point payment errors.
class WalletModel {
  final String artisanId;
  final int availableBalancePaise;
  final int reserveBalancePaise;
  final DateTime updatedAt;

  const WalletModel({
    required this.artisanId,
    required this.availableBalancePaise,
    required this.reserveBalancePaise,
    required this.updatedAt,
  });

  int get withdrawablePaise => availableBalancePaise > reserveBalancePaise
      ? availableBalancePaise - reserveBalancePaise
      : 0;

  WalletModel copyWith({
    int? availableBalancePaise,
    int? reserveBalancePaise,
    DateTime? updatedAt,
  }) =>
      WalletModel(
        artisanId: artisanId,
        availableBalancePaise:
            availableBalancePaise ?? this.availableBalancePaise,
        reserveBalancePaise: reserveBalancePaise ?? this.reserveBalancePaise,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'artisanId': artisanId,
        'availableBalancePaise': availableBalancePaise,
        'reserveBalancePaise': reserveBalancePaise,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        artisanId: json['artisanId'] as String,
        availableBalancePaise: (json['availableBalancePaise'] as num).toInt(),
        reserveBalancePaise: (json['reserveBalancePaise'] as num).toInt(),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
