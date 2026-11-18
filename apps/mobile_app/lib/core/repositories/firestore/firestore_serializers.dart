import '../../models/artisan_profile_model.dart';

class FirestoreSerializers {
  const FirestoreSerializers._();

  static Map<String, dynamic> artisanToJson(ArtisanProfileModel artisan) => {
        'artisanId': artisan.artisanId,
        'name': artisan.name,
        'phone': artisan.phone,
        'primaryTradeId': artisan.primaryTradeId,
        'tradeTitle': artisan.tradeTitle,
        'yearsExperience': artisan.yearsExperience,
        'rating': artisan.rating,
        'reviewCount': artisan.reviewCount,
        'distanceKm': artisan.distanceKm,
        'policeVerified': artisan.policeVerified,
        'toolAuditPassed': artisan.toolAuditPassed,
        'tier': artisan.tier.name,
        'bio': artisan.bio,
        'inspectionFee': artisan.inspectionFee,
        'cityId': artisan.cityId,
        'localityId': artisan.localityId,
        'isOnline': artisan.isOnline,
        'totalJobsCompleted': artisan.totalJobsCompleted,
        'roleType': artisan.roleType.name,
        'isGuildElite': artisan.isGuildElite,
        'guildId': artisan.guildId,
        'kycBadgeLabel': artisan.kycBadgeLabel,
        'aadhaarVerified': artisan.aadhaarVerified,
        'experienceTierLabel': artisan.experienceTierLabel,
        'dailyDihadiRate': artisan.dailyDihadiRate,
        'workMode': artisan.workMode,
        'serviceLocalityIds': artisan.serviceLocalityIds,
        'specialties': artisan.specialties,
        'verifiedTools': artisan.verifiedTools,
        'portfolioItems': artisan.portfolioItems
            .map((item) => {
                  'id': item.id,
                  'title': item.title,
                  'location': item.location,
                  'badge': item.badge,
                  'duration': item.duration,
                  if (item.imagePathOrUrl != null)
                    'imagePathOrUrl': item.imagePathOrUrl,
                })
            .toList(),
        'cleanlinessScore': artisan.cleanlinessScore,
        'onTimeArrivalPercent': artisan.onTimeArrivalPercent,
        'bankName': artisan.bankName,
        'maskedAccountNumber': artisan.maskedAccountNumber,
        'ifscCode': artisan.ifscCode,
        'upiId': artisan.upiId,
        'securityReserveAmount': artisan.securityReserveAmount,
      };

  static ArtisanProfileModel artisanFromJson(Map<String, dynamic> json) {
    final portfolioItems =
        (json['portfolioItems'] as List<dynamic>? ?? const []).map((raw) {
      final item = Map<String, dynamic>.from(raw as Map);
      return PortfolioWorkItem(
        id: item['id'] as String,
        title: item['title'] as String,
        location: item['location'] as String,
        badge: item['badge'] as String,
        duration: item['duration'] as String,
        imagePathOrUrl: item['imagePathOrUrl'] as String?,
      );
    }).toList(growable: false);

    return ArtisanProfileModel(
      artisanId: json['artisanId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      primaryTradeId: json['primaryTradeId'] as String,
      tradeTitle: json['tradeTitle'] as String,
      yearsExperience: (json['yearsExperience'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      policeVerified: json['policeVerified'] as bool? ?? false,
      toolAuditPassed: json['toolAuditPassed'] as bool? ?? false,
      tier: GuildTier.values.firstWhere(
        (tier) => tier.name == json['tier'],
        orElse: () => GuildTier.registered,
      ),
      bio: json['bio'] as String? ?? '',
      inspectionFee: (json['inspectionFee'] as num?)?.toInt() ?? 0,
      cityId: json['cityId'] as String,
      localityId: json['localityId'] as String,
      isOnline: json['isOnline'] as bool? ?? false,
      totalJobsCompleted: (json['totalJobsCompleted'] as num?)?.toInt() ?? 0,
      roleType: KarigaarRoleType.values.firstWhere(
        (role) => role.name == json['roleType'],
        orElse: () => KarigaarRoleType.skilledKarigaar,
      ),
      isGuildElite: json['isGuildElite'] as bool? ?? false,
      guildId: json['guildId'] as String? ?? '',
      kycBadgeLabel: json['kycBadgeLabel'] as String? ?? 'KYC Pending',
      aadhaarVerified: json['aadhaarVerified'] as bool? ?? false,
      experienceTierLabel: json['experienceTierLabel'] as String? ?? '',
      dailyDihadiRate: (json['dailyDihadiRate'] as num?)?.toInt() ?? 0,
      workMode: json['workMode'] as String? ?? '',
      serviceLocalityIds:
          (json['serviceLocalityIds'] as List<dynamic>? ?? const [])
              .map((value) => value.toString())
              .toList(growable: false),
      specialties: (json['specialties'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(growable: false),
      verifiedTools: (json['verifiedTools'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(growable: false),
      portfolioItems: portfolioItems,
      cleanlinessScore: (json['cleanlinessScore'] as num?)?.toDouble() ?? 0,
      onTimeArrivalPercent:
          (json['onTimeArrivalPercent'] as num?)?.toInt() ?? 0,
      bankName: json['bankName'] as String? ?? '',
      maskedAccountNumber: json['maskedAccountNumber'] as String? ?? '',
      ifscCode: json['ifscCode'] as String? ?? '',
      upiId: json['upiId'] as String? ?? '',
      securityReserveAmount:
          (json['securityReserveAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}
