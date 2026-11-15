import 'package:flutter/material.dart';

/// Curated seasonal and multi-task preventive maintenance bundle model (F-08).
///
/// Bundles group common diagnostic, cleaning, and tuning tasks for a trade
/// at discounted package rates with one-tap scoping checkout.
class PreventiveBundleModel {
  final String bundleId;
  final String title;
  final String marathiTitle;
  final String subtitle;
  final String tradeId;
  final int originalPrice;
  final int discountedPrice;
  final String discountTag;
  final List<String> includedPackageIds;
  final List<String> includedTasks;
  final int estimatedMinutes;
  final String badgeText;
  final String iconName;
  final String accentColorHex;
  final String surfaceTintHex;
  final int guaranteeDays;

  const PreventiveBundleModel({
    required this.bundleId,
    required this.title,
    required this.marathiTitle,
    required this.subtitle,
    required this.tradeId,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountTag,
    required this.includedPackageIds,
    required this.includedTasks,
    required this.estimatedMinutes,
    required this.badgeText,
    required this.iconName,
    required this.accentColorHex,
    required this.surfaceTintHex,
    this.guaranteeDays = 30,
  });

  /// Rupee savings compared to individual unbundled bookings.
  int get savingsAmount => originalPrice - discountedPrice;

  /// Effective discount percentage rounded to the nearest integer.
  int get computedDiscountPercent => originalPrice > 0
      ? (((originalPrice - discountedPrice) / originalPrice) * 100).round()
      : 0;

  /// Parsed accent color for themed badge chips and border accents.
  Color get accentColor {
    final hex = accentColorHex.replaceFirst('#', '');
    if (hex.length == 6) {
      return Color(int.parse('0xFF$hex'));
    } else if (hex.length == 8) {
      return Color(int.parse('0x$hex'));
    }
    return const Color(0xFF1E3A8A);
  }

  /// Parsed surface tint color for subtle card backgrounds.
  Color get surfaceTint {
    final hex = surfaceTintHex.replaceFirst('#', '');
    if (hex.length == 6) {
      return Color(int.parse('0xFF$hex'));
    } else if (hex.length == 8) {
      return Color(int.parse('0x$hex'));
    }
    return const Color(0xFFF1F5F9);
  }

  factory PreventiveBundleModel.fromJson(Map<String, dynamic> json) {
    return PreventiveBundleModel(
      bundleId: json['bundleId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      marathiTitle: json['marathiTitle'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      tradeId: json['tradeId'] as String? ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toInt() ?? 0,
      discountedPrice: (json['discountedPrice'] as num?)?.toInt() ?? 0,
      discountTag: json['discountTag'] as String? ?? '',
      includedPackageIds: (json['includedPackageIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      includedTasks: (json['includedTasks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 45,
      badgeText: json['badgeText'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'verified',
      accentColorHex: json['accentColorHex'] as String? ?? '#1E3A8A',
      surfaceTintHex: json['surfaceTintHex'] as String? ?? '#EFF6FF',
      guaranteeDays: (json['guaranteeDays'] as num?)?.toInt() ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bundleId': bundleId,
      'title': title,
      'marathiTitle': marathiTitle,
      'subtitle': subtitle,
      'tradeId': tradeId,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'discountTag': discountTag,
      'includedPackageIds': includedPackageIds,
      'includedTasks': includedTasks,
      'estimatedMinutes': estimatedMinutes,
      'badgeText': badgeText,
      'iconName': iconName,
      'accentColorHex': accentColorHex,
      'surfaceTintHex': surfaceTintHex,
      'guaranteeDays': guaranteeDays,
      'savingsAmount': savingsAmount,
      'computedDiscountPercent': computedDiscountPercent,
    };
  }
}
