enum GuildTier {
  registered,
  guildVerifiedPro,
  masterGuildsman;

  String get label {
    switch (this) {
      case GuildTier.registered:
        return 'Registered Apprentice';
      case GuildTier.guildVerifiedPro:
        return 'Guild Verified Pro';
      case GuildTier.masterGuildsman:
        return 'Master Guildsman (0% Commission)';
    }
  }

  double get commissionRate {
    switch (this) {
      case GuildTier.registered:
        return 0.15; // 15%
      case GuildTier.guildVerifiedPro:
        return 0.12; // 12%
      case GuildTier.masterGuildsman:
        return 0.00; // 0% Master Tier
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
  });

  bool get isZeroCommissionEligible =>
      totalJobsCompleted >= 50 && rating >= 4.85;
}
