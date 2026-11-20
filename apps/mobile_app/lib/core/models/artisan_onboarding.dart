import 'dart:convert';

enum ArtisanReviewStatus { draft, submitted, needsAction, approved, rejected }

/// Safe, resumable onboarding data. KYC and payout secrets are intentionally
/// excluded from this client-side draft.
class ArtisanOnboardingDraft {
  const ArtisanOnboardingDraft({
    required this.userId,
    required this.phone,
    this.name = '',
    this.tradeId = 'trade_electrician',
    this.cityId = 'city_nanded_01',
    this.localityId = 'loc_anand_nagar',
    this.step = 1,
    this.status = ArtisanReviewStatus.draft,
    this.updatedAt,
  });

  final String userId;

  /// Stable artisan-side record key linked to the verified identity.
  String get artisanId => 'artisan_$userId';
  final String phone;
  final String name;
  final String tradeId;
  final String cityId;
  final String localityId;
  final int step;
  final ArtisanReviewStatus status;
  final DateTime? updatedAt;

  ArtisanOnboardingDraft copyWith({
    String? name,
    String? tradeId,
    String? cityId,
    String? localityId,
    int? step,
    ArtisanReviewStatus? status,
    DateTime? updatedAt,
  }) =>
      ArtisanOnboardingDraft(
        userId: userId,
        phone: phone,
        name: name ?? this.name,
        tradeId: tradeId ?? this.tradeId,
        cityId: cityId ?? this.cityId,
        localityId: localityId ?? this.localityId,
        step: step ?? this.step,
        status: status ?? this.status,
        updatedAt: updatedAt ?? DateTime.now(),
      );

  Map<String, Object?> toJson() => {
        'userId': userId,
        'artisanId': artisanId,
        'phone': phone,
        'name': name,
        'tradeId': tradeId,
        'cityId': cityId,
        'localityId': localityId,
        'step': step,
        'status': status.name,
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory ArtisanOnboardingDraft.fromJson(Map<String, dynamic> json) =>
      ArtisanOnboardingDraft(
        userId: json['userId'] as String,
        phone: json['phone'] as String,
        name: json['name'] as String? ?? '',
        tradeId: json['tradeId'] as String? ?? 'trade_electrician',
        cityId: json['cityId'] as String? ?? 'city_nanded_01',
        localityId: json['localityId'] as String? ?? 'loc_anand_nagar',
        step: (json['step'] as num?)?.toInt().clamp(1, 4).toInt() ?? 1,
        status: ArtisanReviewStatus.values.firstWhere(
          (value) => value.name == json['status'],
          orElse: () => ArtisanReviewStatus.draft,
        ),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      );

  static String encode(ArtisanOnboardingDraft value) =>
      jsonEncode(value.toJson());
}
