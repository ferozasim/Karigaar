import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class TrustShieldBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color tintColor;
  final Color textColor;

  const TrustShieldBadge({
    super.key,
    required this.label,
    this.icon = Icons.verified_user_rounded,
    this.tintColor = AppColors.tertiarySurfaceTint,
    this.textColor = AppColors.tertiary,
  });

  const TrustShieldBadge.policeVerified({super.key})
      : label = 'Police Verified',
        icon = Icons.verified_user_rounded,
        tintColor = AppColors.tertiarySurfaceTint,
        textColor = AppColors.tertiary;

  const TrustShieldBadge.warranty30Days({super.key})
      : label = '30-Day Guarantee',
        icon = Icons.shield_rounded,
        tintColor = AppColors.secondarySurfaceTint,
        textColor = AppColors.secondary;

  const TrustShieldBadge.toolAuditPassed({super.key})
      : label = 'Laser Tool Calibrated',
        icon = Icons.build_circle_rounded,
        tintColor = const Color(0xFFEFF6FF),
        textColor = const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tintColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
