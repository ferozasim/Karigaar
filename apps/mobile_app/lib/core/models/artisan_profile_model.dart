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

class PortfolioWorkItem {
  final String id;
  final String title;
  final String location;
  final String badge;
  final String duration;
  final String? imagePathOrUrl;

  const PortfolioWorkItem({
    required this.id,
    required this.title,
    required this.location,
    required this.badge,
    required this.duration,
    this.imagePathOrUrl,
  });

  PortfolioWorkItem copyWith({
    String? id,
    String? title,
    String? location,
    String? badge,
    String? duration,
    String? imagePathOrUrl,
  }) {
    return PortfolioWorkItem(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      badge: badge ?? this.badge,
      duration: duration ?? this.duration,
      imagePathOrUrl: imagePathOrUrl ?? this.imagePathOrUrl,
    );
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

  // Extended T-10 Partner Profile & Payout Fields (all defaulted for const compatibility)
  final String guildId;
  final String kycBadgeLabel;
  final bool aadhaarVerified;
  final String experienceTierLabel;
  final int dailyDihadiRate;
  final String workMode;
  final List<String> serviceLocalityIds;
  final List<String> specialties;
  final List<String> verifiedTools;
  final List<PortfolioWorkItem> portfolioItems;
  final double cleanlinessScore;
  final int onTimeArrivalPercent;
  final String bankName;
  final String maskedAccountNumber;
  final String ifscCode;
  final String upiId;
  final double securityReserveAmount;

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
    this.guildId = 'KG-ND-2026-089',
    this.kycBadgeLabel = 'Aadhaar & Police Verified',
    this.aadhaarVerified = true,
    this.experienceTierLabel = '5 - 10 Years',
    this.dailyDihadiRate = 900,
    this.workMode = 'Both Visit & Daily Dihadi',
    this.serviceLocalityIds = const [
      'loc_anand_nagar',
      'loc_vazirabad',
      'loc_cidco',
    ],
    this.specialties = const [],
    this.verifiedTools = const [
      'True-RMS Multimeter',
      '1000V Insulated Toolset',
      'Rotary Hammer Drill',
      'Canvas Drop-Cloth & Sawdust Vacuum',
    ],
    this.portfolioItems = const [],
    this.cleanlinessScore = 4.9,
    this.onTimeArrivalPercent = 98,
    this.bankName = 'HDFC Bank',
    this.maskedAccountNumber = '•••• 2104',
    this.ifscCode = 'HDFC0002104',
    this.upiId = 'ramesh.karigaar@okaxis',
    this.securityReserveAmount = 2000.0,
  });

  ArtisanProfileModel copyWith({
    String? artisanId,
    String? name,
    String? phone,
    String? primaryTradeId,
    String? tradeTitle,
    int? yearsExperience,
    double? rating,
    int? reviewCount,
    double? distanceKm,
    bool? policeVerified,
    bool? toolAuditPassed,
    GuildTier? tier,
    String? bio,
    int? inspectionFee,
    String? cityId,
    String? localityId,
    bool? isOnline,
    int? totalJobsCompleted,
    KarigaarRoleType? roleType,
    bool? isGuildElite,
    String? guildId,
    String? kycBadgeLabel,
    bool? aadhaarVerified,
    String? experienceTierLabel,
    int? dailyDihadiRate,
    String? workMode,
    List<String>? serviceLocalityIds,
    List<String>? specialties,
    List<String>? verifiedTools,
    List<PortfolioWorkItem>? portfolioItems,
    double? cleanlinessScore,
    int? onTimeArrivalPercent,
    String? bankName,
    String? maskedAccountNumber,
    String? ifscCode,
    String? upiId,
    double? securityReserveAmount,
  }) {
    return ArtisanProfileModel(
      artisanId: artisanId ?? this.artisanId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      primaryTradeId: primaryTradeId ?? this.primaryTradeId,
      tradeTitle: tradeTitle ?? this.tradeTitle,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distanceKm: distanceKm ?? this.distanceKm,
      policeVerified: policeVerified ?? this.policeVerified,
      toolAuditPassed: toolAuditPassed ?? this.toolAuditPassed,
      tier: tier ?? this.tier,
      bio: bio ?? this.bio,
      inspectionFee: inspectionFee ?? this.inspectionFee,
      cityId: cityId ?? this.cityId,
      localityId: localityId ?? this.localityId,
      isOnline: isOnline ?? this.isOnline,
      totalJobsCompleted: totalJobsCompleted ?? this.totalJobsCompleted,
      roleType: roleType ?? this.roleType,
      isGuildElite: isGuildElite ?? this.isGuildElite,
      guildId: guildId ?? this.guildId,
      kycBadgeLabel: kycBadgeLabel ?? this.kycBadgeLabel,
      aadhaarVerified: aadhaarVerified ?? this.aadhaarVerified,
      experienceTierLabel: experienceTierLabel ?? this.experienceTierLabel,
      dailyDihadiRate: dailyDihadiRate ?? this.dailyDihadiRate,
      workMode: workMode ?? this.workMode,
      serviceLocalityIds: serviceLocalityIds ?? this.serviceLocalityIds,
      specialties: specialties ?? this.specialties,
      verifiedTools: verifiedTools ?? this.verifiedTools,
      portfolioItems: portfolioItems ?? this.portfolioItems,
      cleanlinessScore: cleanlinessScore ?? this.cleanlinessScore,
      onTimeArrivalPercent: onTimeArrivalPercent ?? this.onTimeArrivalPercent,
      bankName: bankName ?? this.bankName,
      maskedAccountNumber: maskedAccountNumber ?? this.maskedAccountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      upiId: upiId ?? this.upiId,
      securityReserveAmount:
          securityReserveAmount ?? this.securityReserveAmount,
    );
  }

  /// Dynamically resolved localized trade title based on role type and trade ID
  String get localizedRoleTitle => roleType.getLocalizedTitle(primaryTradeId);

  /// Standard role badge text (e.g. 'Head Mistry / Ustad')
  String get roleBadgeLabel => roleType.standardLabel;

  /// Guild tier display label highlighting the sustainable 5% commission floor
  String get guildTierDisplayLabel {
    if (isGuildElite ||
        tier == GuildTier.guildElite ||
        tier == GuildTier.masterGuildsman) {
      return 'Tier 3: Master Guildsman • 5% Commission Floor';
    }
    return tier.label;
  }

  /// Effective commission rate taking into account Guild Elite status or tier
  double get effectiveCommissionRate =>
      (isGuildElite || tier == GuildTier.guildElite) ? 0.05 : tier.commissionRate;

  /// Whether artisan is eligible for the 5% commission floor
  bool get isCommissionFloorEligible =>
      isGuildElite || (totalJobsCompleted >= 50 && rating >= 4.85);

  /// Backwards-compatible alias for existing test suites
  bool get isZeroCommissionEligible => isCommissionFloorEligible;
}
