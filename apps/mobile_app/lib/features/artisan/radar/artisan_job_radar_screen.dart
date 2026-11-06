import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/mode_switcher_pill.dart';

class ArtisanJobRadarScreen extends ConsumerStatefulWidget {
  const ArtisanJobRadarScreen({super.key});

  @override
  ConsumerState<ArtisanJobRadarScreen> createState() => _ArtisanJobRadarScreenState();
}

class _ArtisanJobRadarScreenState extends ConsumerState<ArtisanJobRadarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(radarCountdownProvider.notifier).startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(artisanDutyOnlineProvider);
    final countdown = ref.watch(radarCountdownProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Duty Status & Mode Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: isOnline ? AppColors.tertiary : AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isOnline ? 'RADAR ACTIVE' : 'DUTY PAUSED',
                            style: AppTypography.labelSm.copyWith(
                              color: isOnline ? AppColors.tertiary : AppColors.error,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Text('Nanded Trade Guild', style: AppTypography.headlineSm),
                    ],
                  ),
                  const ModeSwitcherPill(compact: true),
                ],
              ),

              const SizedBox(height: 16),

              // Duty Toggle Switch Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Icon(
                      isOnline ? Icons.radar_rounded : Icons.pause_circle_outline_rounded,
                      color: isOnline ? AppColors.secondary : AppColors.textMuted,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOnline ? 'Accepting Nearby Jobs' : 'Go Online to Receive Jobs',
                            style: AppTypography.labelLg,
                          ),
                          Text(
                            'Dispatch Radius: 4.5 km • Anand Nagar Hub',
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isOnline,
                      activeThumbColor: AppColors.secondary,
                      onChanged: (val) {
                        ref.read(artisanDutyOnlineProvider.notifier).state = val;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bento Earnings & Stats Grid
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Today\'s Payout', style: AppTypography.labelSm),
                          const SizedBox(height: 4),
                          Text('₹1,850', style: AppTypography.numericPrice.copyWith(fontSize: 24, color: AppColors.tertiary)),
                          const SizedBox(height: 4),
                          Text('Instant IMPS Ready', style: AppTypography.bodySm.copyWith(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Master Guild Tier', style: AppTypography.labelSm),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('0%', style: AppTypography.numericPrice.copyWith(fontSize: 24, color: AppColors.primary)),
                              const SizedBox(width: 4),
                              Text('Fee', style: AppTypography.labelSm),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('4.9★ (340 jobs)', style: AppTypography.bodySm.copyWith(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Incoming 45-Second Dispatch Radar Card
              if (isOnline && countdown > 0) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.secondary, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // 45s Circular Countdown Badge
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: CircularProgressIndicator(
                                  value: countdown / 45.0,
                                  strokeWidth: 4,
                                  backgroundColor: AppColors.secondarySurfaceTint,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                                ),
                              ),
                              Text(
                                '${countdown}s',
                                style: AppTypography.labelMd.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('EMERGENCY BREAKDOWN', style: AppTypography.labelSm.copyWith(color: AppColors.error)),
                                ),
                                const SizedBox(height: 4),
                                Text('Short Circuit & MCB Trip', style: AppTypography.headlineSm.copyWith(fontSize: 17)),
                                Text('1.2 km away • Anand Nagar, Nanded', style: AppTypography.bodySm),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estimated Earnings', style: AppTypography.labelSm),
                              Text('₹399 - ₹650', style: AppTypography.numericPrice.copyWith(fontSize: 20)),
                            ],
                          ),
                          // WhatsApp Pre-Accept inquiry
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: Color(0xFF25D366)),
                            label: const Text('Ask Customer'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF25D366)),
                              foregroundColor: const Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Claim Job CTA
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/artisan/active-job/BK_NANDED_8821');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'CLAIM JOB NOW (${countdown}s)',
                            style: AppTypography.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.radar_rounded, size: 48, color: AppColors.textSubtle),
                        const SizedBox(height: 12),
                        Text('Scanning Nanded for incoming requests...', style: AppTypography.labelLg),
                        const SizedBox(height: 4),
                        Text('Keep app active to receive 45s priority broadcasts', style: AppTypography.bodySm),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
