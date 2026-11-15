import 'karigaar_role_type.dart';
export 'karigaar_role_type.dart';

enum GuildTier {
  registered,
  guildVerifiedPro,
  masterGuildsman,
  guildElite;

  String get label {
    switch (this) {
      case GuildTier.registered:
        return 'Registered Apprentice';
      case GuildTier.guildVerifiedPro:
        return 'Guild Verified Pro';
      case GuildTier.masterGuildsman:
        return 'Master Guildsman (8% Commission)';
      case GuildTier.guildElite:
        return 'Guild Elite (5% Commission Floor)';
    }
  }

  double get commissionRate {
    switch (this) {
      case GuildTier.registered:
        return 0.15; // 15%
      case GuildTier.guildVerifiedPro:
        return 0.12; // 12%
      case GuildTier.masterGuildsman:
        return 0.08; // 8% Master Tier
      case GuildTier.guildElite:
        return 0.05; // 5% Sustainable Commission Floor
    }
  }
}

class ArtisanProfileModel {
  final String artisanId;
  final String name;
  final String phone;
  final String primaryTradeId;
  final String tradeTitle;
  final int yearsExperience;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final bool policeVerified;
  final bool toolAuditPassed;
  final GuildTier tier;
  final String bio;
  final int inspectionFee;
  final String cityId;
  final String localityId;
  final bool isOnline;
  final int totalJobsCompleted;
  final KarigaarRoleType roleType;
  final bool isGuildElite;

  const ArtisanProfileModel({
    required this.artisanId,
    required this.name,
    required this.phone,
    required this.primaryTradeId,
    required this.tradeTitle,
    required this.yearsExperience,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    this.policeVerified = true,
    this.toolAuditPassed = true,
    this.tier = GuildTier.guildVerifiedPro,
    required this.bio,
    required this.inspectionFee,
    required this.cityId,
    required this.localityId,
    this.isOnline = true,
    this.totalJobsCompleted = 320,
    this.roleType = KarigaarRoleType.skilledKarigaar,
    this.isGuildElite = false,
  });

  /// Dynamically resolved localized trade title based on role type and trade ID
  String get localizedRoleTitle => roleType.getLocalizedTitle(primaryTradeId);

  /// Standard role badge text (e.g. 'Head Mistry / Ustad')
  String get roleBadgeLabel => roleType.standardLabel;

  /// Effective commission rate taking into account Guild Elite status or tier
  double get effectiveCommissionRate =>
      (isGuildElite || tier == GuildTier.guildElite) ? 0.05 : tier.commissionRate;

  /// Whether artisan is eligible for the 5% commission floor
  bool get isCommissionFloorEligible =>
      isGuildElite || (totalJobsCompleted >= 50 && rating >= 4.85);

  /// Backwards-compatible alias for existing test suites
  bool get isZeroCommissionEligible => isCommissionFloorEligible;
}
