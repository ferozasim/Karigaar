import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

class EmergencyAssistBanner extends StatelessWidget {
  final VoidCallback onBookUrgent;

  const EmergencyAssistBanner({super.key, required this.onBookUrgent});

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final isLargeText = textScaler.scale(1.0) >= 1.4;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981), // Pulsing beacon
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'URGENT BREAKDOWN? (25 MINS)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSm.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Immediate Doorstep Dispatch',
          style: AppTypography.headlineSm.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Electricians & Plumbers on stand-by across Nanded',
          style: AppTypography.bodySm.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );

    final actionButton = ElevatedButton(
      onPressed: onBookUrgent,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF92400E),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFD97706)),
          const SizedBox(width: 4),
          Text(
            'Book Fast',
            style: AppTypography.labelMd.copyWith(
              color: const Color(0xFF92400E),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB45309), // Amber-700
            Color(0xFFD97706), // Secondary Amber
            Color(0xFFF59E0B), // Amber-500
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD97706).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isLargeText
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: 12),
                actionButton,
              ],
            )
          : Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 12),
                actionButton,
              ],
            ),
    );
  }
}
