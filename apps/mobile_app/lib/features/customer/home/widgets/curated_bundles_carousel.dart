import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/preventive_bundle_model.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Curated Preventive Maintenance Bundles Horizontal Carousel (F-08).
///
/// Showcases seasonal and multi-task maintenance packages with discounted
/// pricing and one-tap "Add +" navigation directly to scoping checkout.
class CuratedBundlesCarousel extends ConsumerWidget {
  final void Function(PreventiveBundleModel bundle)? onSelectBundle;

  const CuratedBundlesCarousel({
    super.key,
    this.onSelectBundle,
  });

  IconData _resolveTradeIcon(String iconName) {
    switch (iconName) {
      case 'bolt':
        return Icons.bolt_rounded;
      case 'plumbing':
        return Icons.plumbing_rounded;
      case 'mode_fan':
        return Icons.mode_fan_off_rounded;
      case 'carpenter':
        return Icons.carpenter_rounded;
      case 'format_paint':
        return Icons.format_paint_rounded;
      default:
        return Icons.verified_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bundles = ref.watch(curatedBundlesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    'Preventive Care Bundles',
                    style: AppTypography.headlineSm.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Text(
                      'Save up to 30%',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Multi-task diagnostic & protection packages',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal Bundles Carousel
        SizedBox(
          height: 244,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: bundles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final bundle = bundles[index];
              return _buildBundleCard(context, bundle);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBundleCard(BuildContext context, PreventiveBundleModel bundle) {
    final iconData = _resolveTradeIcon(bundle.iconName);

    return Container(
      width: 280,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: discount badge + trade icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: bundle.surfaceTint,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: bundle.accentColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      size: 11,
                      color: bundle.accentColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      bundle.discountTag,
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: bundle.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bundle.surfaceTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 16,
                  color: bundle.accentColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Title & Subtitle
          Text(
            bundle.title,
            style: AppTypography.headlineSm.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            bundle.subtitle,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // Included tasks preview (up to 2 items)
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: bundle.includedTasks.take(2).map((task) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 13,
                            color: AppColors.tertiary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              task,
                              style: AppTypography.bodySm.copyWith(
                                fontSize: 11,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Price row and Add CTA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹${bundle.discountedPrice}',
                            style: AppTypography.numericPrice.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '₹${bundle.originalPrice}',
                            style: AppTypography.labelSm.copyWith(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Save ₹${bundle.savingsAmount}',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Add + CTA Button (strictly finite minimumSize per flutter_layout_rules)
              ElevatedButton(
                key: Key('add_bundle_${bundle.bundleId}'),
                onPressed: () {
                  if (onSelectBundle != null) {
                    onSelectBundle!(bundle);
                  } else {
                    context.push(
                      '/customer/service/${bundle.tradeId}',
                      extra: {
                        'bundle': bundle,
                        'packageIds': bundle.includedPackageIds,
                        'bundleId': bundle.bundleId,
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(64, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Add +',
                  style: AppTypography.labelSm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
