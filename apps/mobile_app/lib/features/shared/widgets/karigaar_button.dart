import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

enum KarigaarButtonVariant {
  primary, // Deep Slate
  urgent,  // Artisan Amber
  outline,
  ghost,
}

class KarigaarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final KarigaarButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final double height;

  const KarigaarButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = KarigaarButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case KarigaarButtonVariant.primary:
        bgColor = AppColors.primary;
        fgColor = AppColors.onPrimary;
        break;
      case KarigaarButtonVariant.urgent:
        bgColor = AppColors.secondary;
        fgColor = AppColors.onSecondary;
        break;
      case KarigaarButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.borderSubtle, width: 1.5);
        break;
      case KarigaarButtonVariant.ghost:
        bgColor = AppColors.surfaceSubtle;
        fgColor = AppColors.textPrimary;
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelLg.copyWith(
                        color: fgColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
