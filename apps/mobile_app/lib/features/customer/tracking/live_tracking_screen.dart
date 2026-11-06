import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/trust_shield_badge.dart';

class LiveTrackingScreen extends ConsumerWidget {
  final String bookingId;

  const LiveTrackingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(activeBookingProvider);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Tracking')),
        body: const Center(child: Text('No active booking found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: const Text('Live Dispatch Radar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simulated Vector Map Card with Route Polyline
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Stack(
                    children: [
                      // Grid background pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: MapGridPainter(),
                        ),
                      ),
                      // Destination Point (Customer)
                      Positioned(
                        right: 40,
                        top: 50,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('Your Home', style: AppTypography.labelSm),
                            ),
                          ],
                        ),
                      ),
                      // Artisan Motorcycle Marker (Moving)
                      Positioned(
                        left: 60,
                        bottom: 60,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondary,
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 22),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('Ganesh • 6 mins away', style: AppTypography.labelSm.copyWith(color: AppColors.secondary)),
                            ),
                          ],
                        ),
                      ),
                      // ETA Badge Top-Left
                      Positioned(
                        left: 16,
                        top: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Arriving in ~6 mins', style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Security Start Code Display (4921)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurfaceTint,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondaryContainer),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_rounded, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'DOORSTEP SECURITY START CODE',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.secondary,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.startOtp,
                        style: AppTypography.displayLg.copyWith(
                          fontSize: 36,
                          letterSpacing: 8,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Share this 4-digit code verbally ONLY when your artisan arrives at your doorstep.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Assigned Artisan Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.tertiary, width: 2),
                        ),
                        child: const Icon(Icons.person_rounded, size: 30, color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.assignedArtisanName ?? 'Ganesh Kadam', style: AppTypography.labelLg),
                            Text('${booking.tradeName} • Master Tier', style: AppTypography.bodySm),
                            const SizedBox(height: 4),
                            const TrustShieldBadge.policeVerified(),
                          ],
                        ),
                      ),
                      // WhatsApp Chat & Call Buttons
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366)),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // 5-Stage Milestone Progress
                Text('Booking Milestones', style: AppTypography.headlineSm),
                const SizedBox(height: 14),
                _buildMilestoneStep(
                  title: 'Booking Confirmed & Escrow Held',
                  time: '12 mins ago',
                  isCompleted: true,
                  isCurrent: false,
                ),
                _buildMilestoneStep(
                  title: 'Artisan Dispatched from Anand Nagar',
                  time: '8 mins ago',
                  isCompleted: true,
                  isCurrent: false,
                ),
                _buildMilestoneStep(
                  title: 'En Route to Doorstep (~6 mins)',
                  time: 'Live tracking active',
                  isCompleted: false,
                  isCurrent: true,
                ),
                _buildMilestoneStep(
                  title: 'Start Code 4921 Verified',
                  time: 'Pending arrival',
                  isCompleted: false,
                  isCurrent: false,
                ),
                _buildMilestoneStep(
                  title: 'Work Completed & Completion OTP',
                  time: 'Pending finish',
                  isCompleted: false,
                  isCurrent: false,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneStep({
    required String title,
    required String time,
    required bool isCompleted,
    required bool isCurrent,
    bool isLast = false,
  }) {
    Color iconColor;
    Color lineColor = AppColors.borderSubtle;

    if (isCompleted) {
      iconColor = AppColors.tertiary;
      lineColor = AppColors.tertiary;
    } else if (isCurrent) {
      iconColor = AppColors.secondary;
    } else {
      iconColor = AppColors.textSubtle;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.tertiary
                    : (isCurrent ? AppColors.secondarySurfaceTint : AppColors.surfaceSubtle),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.tertiary
                      : (isCurrent ? AppColors.secondary : AppColors.borderSubtle),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : (isCurrent
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: lineColor,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelMd.copyWith(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                  color: isCurrent ? AppColors.textPrimary : (isCompleted ? AppColors.textPrimary : AppColors.textMuted),
                ),
              ),
              Text(time, style: AppTypography.bodySm.copyWith(fontSize: 11)),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Polyline Route
    final routePaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(60, size.height - 60);
    path.lineTo(120, size.height - 90);
    path.lineTo(180, 100);
    path.lineTo(size.width - 40, 50);

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
