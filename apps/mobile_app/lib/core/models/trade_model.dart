import 'package:flutter/material.dart';

class ServicePackageModel {
  final String packageId;
  final String name;
  final int estimatedPrice;
  final int estimatedMinutes;
  final String description;

  const ServicePackageModel({
    required this.packageId,
    required this.name,
    required this.estimatedPrice,
    required this.estimatedMinutes,
    required this.description,
  });

  factory ServicePackageModel.fromJson(Map<String, dynamic> json) {
    return ServicePackageModel(
      packageId: json['packageId'] as String,
      name: json['name'] as String,
      estimatedPrice: json['estimatedPrice'] as int,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 45,
      description: json['description'] as String,
    );
  }
}

class TradeModel {
  final String tradeId;
  final String slug;
  final String name;
  final String marathiName;
  final String tagline;
  final String accentColorHex;
  final String surfaceTintHex;
  final String iconName;
  final int baseInspectionFee;
  final int safetyShieldFee;
  final int guaranteeDays;
  final bool emergencyEligible;
  final List<ServicePackageModel> popularPackages;

  const TradeModel({
    required this.tradeId,
    required this.slug,
    required this.name,
    required this.marathiName,
    required this.tagline,
    required this.accentColorHex,
    required this.surfaceTintHex,
    required this.iconName,
    required this.baseInspectionFee,
    required this.safetyShieldFee,
    required this.guaranteeDays,
    required this.emergencyEligible,
    required this.popularPackages,
  });

  Color get accentColor {
    final hex = accentColorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  Color get surfaceTint {
    final hex = surfaceTintHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      tradeId: json['tradeId'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      marathiName: json['marathiName'] as String,
      tagline: json['tagline'] as String,
      accentColorHex: json['accentColor'] as String,
      surfaceTintHex: json['surfaceTint'] as String,
      iconName: json['iconName'] as String,
      baseInspectionFee: json['baseInspectionFee'] as int,
      safetyShieldFee: json['safetyShieldFee'] as int? ?? 29,
      guaranteeDays: json['guaranteeDays'] as int? ?? 30,
      emergencyEligible: json['emergencyEligible'] as bool? ?? false,
      popularPackages: (json['popularPackages'] as List<dynamic>)
          .map((e) => ServicePackageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
