import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Skeleton Loading & Telemetry Radar Sync Widget matching Stitch design `skeleton_loading_radar_sync/code.html`
/// Features:
/// - 1800ms Linear animated shimmer gradient sweep across placeholders (karigaarShimmer)
/// - 2200ms Animated concentric radar sweep pulse (radarSweep)
/// - Telemetry search pill & filter skeleton
/// - Emergency 25-min dispatch banner skeleton with animated radar beacon
/// - 10-trade category grid skeleton
/// - Nearby master artisan card skeletons
/// - Pinned low-connectivity telemetry sync pill with amber spinner and 99.8% indicator
class KarigaarRadarSyncSkeleton extends StatefulWidget {
  final String statusTitle;
  final String statusSubtitle;
  final String syncPercentage;
  final bool showHeaderSkeletons;

  const KarigaarRadarSyncSkeleton({
    super.key,
    this.statusTitle = 'Connecting to Karigaar Guild...',
    this.statusSubtitle = 'WhatsApp Gateway Synced',
    this.syncPercentage = '99.8%',
    this.showHeaderSkeletons = true,
  });

  @override
  State<KarigaarRadarSyncSkeleton> createState() =>
      _KarigaarRadarSyncSkeletonState();
}

class _KarigaarRadarSyncSkeletonState extends State<KarigaarRadarSyncSkeleton>
    with TickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    // 1800ms shimmer animation matching Stitch specification
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // 2200ms concentric radar sweep pulse
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  Widget _buildShimmerBlock({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final progress = _shimmerController.value;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + (progress * 3.0), -0.2),
              end: Alignment(-0.5 + (progress * 3.0), 0.2),
              colors: const [
                Color(0xFFE5EEFF),
                Color(0xFFFFFFFF),
                Color(0xFFE5EEFF),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadarPulseSensor() {
    return AnimatedBuilder(
      animation: _radarController,
      builder: (context, child) {
        final val = _radarController.value;
        final scale1 = 0.7 + (val * 1.7);
        final opacity1 = (1.0 - val).clamp(0.0, 0.9);

        final val2 = (val + 0.5) % 1.0;
        final scale2 = 0.7 + (val2 * 1.7);
        final opacity2 = (1.0 - val2).clamp(0.0, 0.9);

        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: scale1,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: opacity1 * 0.35),
                  ),
                ),
              ),
              Transform.scale(
                scale: scale2,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: opacity2 * 0.45),
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
                child: const Icon(
                  Icons.near_me_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHeaderSkeletons) ...[
          // Telemetry Search Pill & Quick Filter Skeleton
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                _buildShimmerBlock(width: 32, height: 32, borderRadius: 9999),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBlock(width: 140, height: 12),
                      const SizedBox(height: 4),
                      _buildShimmerBlock(width: 90, height: 9),
                    ],
                  ),
                ),
                _buildShimmerBlock(width: 48, height: 28, borderRadius: 9999),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Emergency 25-Min Dispatch Banner Skeleton with Radar Ping
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildShimmerBlock(width: 130, height: 14),
                      ],
                    ),
                    _buildShimmerBlock(width: 72, height: 20, borderRadius: 9999),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShimmerBlock(width: 180, height: 16),
                          const SizedBox(height: 8),
                          _buildShimmerBlock(width: 150, height: 12),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildShimmerBlock(width: 84, height: 24, borderRadius: 9999),
                              const SizedBox(width: 8),
                              _buildShimmerBlock(width: 60, height: 24, borderRadius: 9999),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildRadarPulseSensor(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 10-Trade Grid Category Skeleton (2 rows x 4 columns sample)
          Text(
            'CERTIFIED GUILD TRADES',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 72,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    _buildShimmerBlock(width: 38, height: 38, borderRadius: 10),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShimmerBlock(width: 80, height: 12),
                          const SizedBox(height: 6),
                          _buildShimmerBlock(width: 50, height: 9),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),
        ],

        // Sticky Telemetry Connection Status Pill
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Spinning amber circular progress indicator
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.statusTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelMd.copyWith(color: Colors.white),
                          ),
                          Text(
                            widget.statusSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onPrimaryContainer,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.tertiaryLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.syncPercentage,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.tertiaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
