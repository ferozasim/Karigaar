import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/radar_broadcast_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/contact_intent_service.dart';
import '../../../core/services/radar_broadcast_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/mode_switcher_pill.dart';

class ArtisanJobRadarScreen extends ConsumerStatefulWidget {
  const ArtisanJobRadarScreen({super.key});

  @override
  ConsumerState<ArtisanJobRadarScreen> createState() => _ArtisanJobRadarScreenState();
}

class _ArtisanJobRadarScreenState extends ConsumerState<ArtisanJobRadarScreen> {
  RadarCountdownNotifier? _radarNotifier;
  bool _isClaiming = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _radarNotifier = ref.read(radarCountdownProvider.notifier);
      final service = ref.read(radarBroadcastServiceProvider);
      if (service.activeBroadcast == null && ref.read(artisanDutyOnlineProvider)) {
        service.startBroadcast(KarigaarRadarBroadcastService.createSampleBroadcast());
      } else {
        _radarNotifier?.startTimer();
      }
    });
  }

  @override
  void dispose() {
    _radarNotifier?.cancelTimer();
    KarigaarRadarBroadcastService.instance.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(artisanDutyOnlineProvider);
    final countdown = ref.watch(radarCountdownProvider);
    final activeBroadcast = ref.watch(activeRadarBroadcastProvider);
    final radiusTier = ref.watch(radarRadiusTierProvider);

    final showCard = isOnline &&
        countdown > 0 &&
        activeBroadcast != null &&
        activeBroadcast.state != RadarDispatchState.claimed &&
        activeBroadcast.state != RadarDispatchState.unfulfilled;

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
                  Expanded(
                    child: Column(
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
                            Flexible(
                              child: Text(
                                isOnline ? 'RADAR ACTIVE' : 'DUTY PAUSED',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.labelSm.copyWith(
                                  color: isOnline ? AppColors.tertiary : AppColors.error,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Nanded Trade Guild',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Role Switcher (Homeowner <-> Karigaar)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 136),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ModeSwitcherPill(compact: true),
                    ),
                  ),
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
                            'Dispatch Radius: ${radiusTier == RadarRadiusTier.tier2Expanded ? '6.0' : '4.5'} km • Anand Nagar Hub',
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
                        ref.read(radarBroadcastServiceProvider).setArtisanDutyOnline(val);
                        if (val) {
                          ref.read(radarBroadcastServiceProvider).startBroadcast(
                                KarigaarRadarBroadcastService.createSampleBroadcast(),
                              );
                        }
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Today\'s Payout', style: AppTypography.labelSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text('₹1,850', style: AppTypography.numericPrice.copyWith(fontSize: 22, color: AppColors.tertiary)),
                          ),
                          const SizedBox(height: 4),
                          Text('Instant IMPS Ready', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySm.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Master Guild Tier', style: AppTypography.labelSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('0%', style: AppTypography.numericPrice.copyWith(fontSize: 22, color: AppColors.primary)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Fee',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelSm,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('4.9★ (340 jobs)', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySm.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Incoming 45-Second Dispatch Radar Card
              if (showCard) ...[
                Container(
                  key: const Key('radar_broadcast_card'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: radiusTier == RadarRadiusTier.tier2Expanded
                          ? const Color(0xFFF59E0B)
                          : AppColors.secondary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (radiusTier == RadarRadiusTier.tier2Expanded
                                ? const Color(0xFFF59E0B)
                                : AppColors.secondary)
                            .withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  value: (countdown / 45.0).clamp(0.0, 1.0),
                                  strokeWidth: 4,
                                  backgroundColor: AppColors.secondarySurfaceTint,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    radiusTier == RadarRadiusTier.tier2Expanded
                                        ? const Color(0xFFF59E0B)
                                        : AppColors.secondary,
                                  ),
                                ),
                              ),
                              Text(
                                '${countdown}s',
                                style: AppTypography.labelMd.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: radiusTier == RadarRadiusTier.tier2Expanded
                                      ? const Color(0xFFB45309)
                                      : AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    if (activeBroadcast.isEmergency)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEE2E2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'EMERGENCY BREAKDOWN',
                                          style: AppTypography.labelSm.copyWith(color: AppColors.error),
                                        ),
                                      ),
                                    Container(
                                      key: const Key('radar_radius_tier_chip'),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: radiusTier == RadarRadiusTier.tier2Expanded
                                            ? const Color(0xFFFEF3C7)
                                            : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: radiusTier == RadarRadiusTier.tier2Expanded
                                              ? const Color(0xFFF59E0B)
                                              : const Color(0xFFCBD5E1),
                                        ),
                                      ),
                                      child: Text(
                                        radiusTier.label,
                                        style: AppTypography.labelSm.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: radiusTier == RadarRadiusTier.tier2Expanded
                                              ? const Color(0xFFB45309)
                                              : AppColors.textMuted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activeBroadcast.title,
                                  style: AppTypography.headlineSm.copyWith(fontSize: 17),
                                ),
                                Text(
                                  '${activeBroadcast.customer.distanceKm.toStringAsFixed(1)} km away • ${activeBroadcast.customer.locality}',
                                  style: AppTypography.bodySm,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Attachments Row (Photo & Voice Note)
                      if (activeBroadcast.attachments.hasPhoto || activeBroadcast.attachments.hasVoiceMemo) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (activeBroadcast.attachments.hasPhoto)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceBase,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.borderSubtle),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.secondary),
                                    const SizedBox(width: 4),
                                    Text('1 Photo', style: AppTypography.labelSm.copyWith(fontSize: 11)),
                                  ],
                                ),
                              ),
                            if (activeBroadcast.attachments.hasVoiceMemo)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceBase,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.borderSubtle),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.mic_outlined, size: 14, color: AppColors.secondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${activeBroadcast.attachments.voiceMemoDurationSeconds ?? 14}s Audio',
                                      style: AppTypography.labelSm.copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Estimated Earnings', style: AppTypography.labelSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '₹${activeBroadcast.payout.guaranteedBase.toStringAsFixed(0)} - ₹${(activeBroadcast.payout.guaranteedBase * 1.5).toStringAsFixed(0)}',
                                    style: AppTypography.numericPrice.copyWith(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // WhatsApp Pre-Accept inquiry
                          OutlinedButton.icon(
                            key: const Key('radar_ask_customer_btn'),
                            onPressed: () {
                              ContactIntentService.initiateMaskedWhatsAppChat(
                                context,
                                calleeId: 'cust_asim_01',
                                bookingId: activeBroadcast.bookingId,
                                message:
                                    'Namaste ${activeBroadcast.customer.firstName}, I am Ganesh Kadam (Master Electrician) on Karigaar Radar. Can you share a photo of the MCB board?',
                                contactName: 'Customer (${activeBroadcast.customer.firstName})',
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: Color(0xFF25D366)),
                            label: const Text('Ask Customer', maxLines: 1, overflow: TextOverflow.ellipsis),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                          key: const Key('radar_claim_job_btn'),
                          onPressed: _isClaiming
                              ? null
                              : () async {
                                  setState(() => _isClaiming = true);
                                  try {
                                    final current = activeBroadcast;
                                    await ref.read(radarBroadcastServiceProvider).acceptBroadcastJob(
                                          broadcastId: current.broadcastId,
                                          artisanId: 'art_nanded_01',
                                        );

                                    final currentBooking = ref.read(activeBookingProvider);
                                    if (currentBooking != null) {
                                      ref.read(activeBookingProvider.notifier).state = currentBooking.copyWith(
                                            status: BookingStatus.artisanEnRoute,
                                            assignedArtisanId: 'art_nanded_01',
                                          );
                                    }

                                    if (!context.mounted) return;
                                    await context.push('/artisan/active-job/${current.bookingId}');
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isClaiming = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: radiusTier == RadarRadiusTier.tier2Expanded
                                ? const Color(0xFFD97706)
                                : AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _isClaiming ? 'CLAIMING JOB...' : 'CLAIM JOB NOW (${countdown}s)',
                            style: AppTypography.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (activeBroadcast?.state == RadarDispatchState.unfulfilled) ...[
                // Unfulfilled / Timeout State
                Container(
                  key: const Key('radar_unfulfilled_state_card'),
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
                        Text(
                          'No active broadcasts in your 6 km corridor',
                          style: AppTypography.labelLg,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Broadcast timed out without acceptance. Search expanded to regional guild.',
                          style: AppTypography.bodySm,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          key: const Key('radar_refresh_btn'),
                          onPressed: () {
                            ref.read(radarBroadcastServiceProvider).startBroadcast(
                                  KarigaarRadarBroadcastService.createSampleBroadcast(),
                                );
                          },
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Refresh Radar', maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Empty / Scanning Standby State
                Container(
                  key: const Key('radar_scanning_state_card'),
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
                        Text(
                          isOnline ? 'Scanning Nanded for incoming requests...' : 'Duty paused. Go online to receive jobs.',
                          style: AppTypography.labelLg,
                        ),
                        const SizedBox(height: 4),
                        Text('Keep app active to receive 45s priority broadcasts', style: AppTypography.bodySm),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          key: const Key('radar_simulate_broadcast_btn'),
                          onPressed: () {
                            ref.read(artisanDutyOnlineProvider.notifier).state = true;
                            ref.read(radarBroadcastServiceProvider).setArtisanDutyOnline(true);
                            ref.read(radarBroadcastServiceProvider).startBroadcast(
                                  KarigaarRadarBroadcastService.createSampleBroadcast(),
                                );
                          },
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Simulate Incoming Broadcast', maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.surfaceRaised,
          border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildArtisanNavItem(
                icon: Icons.radar_rounded,
                label: 'Job Radar',
                isActive: true,
                onTap: () {},
              ),
            ),
            Expanded(
              child: _buildArtisanNavItem(
                icon: Icons.build_circle_outlined,
                label: 'Active Job & Bill',
                isActive: false,
                onTap: () => context.push('/artisan/active-job/BK_NANDED_8821'),
              ),
            ),
            Expanded(
              child: _buildArtisanNavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Guild Wallet',
                isActive: false,
                onTap: () => context.push('/artisan/active-job/BK_NANDED_8821'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? AppColors.secondary : AppColors.textSubtle,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSm.copyWith(
              color: isActive ? AppColors.secondary : AppColors.textSubtle,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
