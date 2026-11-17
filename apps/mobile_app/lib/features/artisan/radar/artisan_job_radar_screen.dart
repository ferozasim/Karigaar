import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/partner_copy.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/radar_broadcast_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/contact_intent_service.dart';
import '../../../core/services/radar_broadcast_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/mode_switcher_pill.dart';
import '../widgets/artisan_bottom_nav.dart';

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
    final copy = PartnerCopy.of(ref.watch(partnerLanguageProvider));

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
                                isOnline ? copy.radarActive : copy.dutyPaused,
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
                            isOnline ? copy.acceptingJobs : copy.goOnlinePrompt,
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
                          Text(copy.todaysPayout, style: AppTypography.labelSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text('₹1,850', style: AppTypography.numericPrice.copyWith(fontSize: 22, color: AppColors.tertiary)),
                          ),
                          const SizedBox(height: 4),
                          Text(copy.clearedImpsReady, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySm.copyWith(fontSize: 10)),
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
                          Text(copy.masterGuildTier, style: AppTypography.labelSm, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                                    Flexible(
                                      child: Text(
                                        '1 Photo',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.labelSm.copyWith(fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (activeBroadcast.attachments.hasVoiceMemo)
                              GestureDetector(
                                key: const Key('voice_memo_radar_badge'),
                                onTap: () => _showAudioPreviewModal(
                                  context,
                                  activeBroadcast.attachments.voiceMemoDurationSeconds ?? 14,
                                  activeBroadcast.attachments.voiceMemoUrl,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondarySurfaceTint,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.mic_outlined, size: 14, color: AppColors.secondary),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          '${activeBroadcast.attachments.voiceMemoDurationSeconds ?? 14}s Audio',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.labelSm.copyWith(
                                            fontSize: 11,
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Builder(
                        builder: (context) {
                          final earningsCol = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                copy.estimatedEarnings,
                                style: AppTypography.labelSm,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '₹${activeBroadcast.payout.guaranteedBase.toStringAsFixed(0)} - ₹${(activeBroadcast.payout.guaranteedBase * 1.5).toStringAsFixed(0)}',
                                  style: AppTypography.numericPrice.copyWith(fontSize: 20),
                                ),
                              ),
                            ],
                          );
                          final askBtn = OutlinedButton.icon(
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
                            label: Text(
                              copy.askCustomer,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              side: const BorderSide(color: Color(0xFF25D366)),
                              foregroundColor: const Color(0xFF16A34A),
                            ),
                          );
                          final useWrap =
                              MediaQuery.textScalerOf(context).scale(1.0) > 1.15;
                          if (useWrap) {
                            return SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 10,
                                children: [earningsCol, askBtn],
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: earningsCol),
                              const SizedBox(width: 8),
                              Flexible(fit: FlexFit.loose, child: askBtn),
                            ],
                          );
                        },
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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _isClaiming ? copy.claimingJob : '${copy.claimJobNow} (${countdown}s)',
                              style: AppTypography.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
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
                          copy.noActiveBroadcasts,
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
                          label: Text(copy.refreshRadar, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                          label: Text(copy.simulateBroadcast, maxLines: 1, overflow: TextOverflow.ellipsis),
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
      bottomNavigationBar: const ArtisanBottomNav(currentTab: ArtisanNavTab.radar),
    );
  }

  void _showAudioPreviewModal(BuildContext context, int durationSeconds, String? url) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        bool isPlaying = false;
        double progress = 0.0;
        Timer? playbackTimer;

        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            void togglePlay() {
              if (isPlaying) {
                playbackTimer?.cancel();
                setModalState(() {
                  isPlaying = false;
                });
              } else {
                setModalState(() {
                  isPlaying = true;
                });
                playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
                  if (progress >= 1.0) {
                    t.cancel();
                    setModalState(() {
                      isPlaying = false;
                      progress = 0.0;
                    });
                  } else {
                    setModalState(() {
                      progress = (progress + (1.0 / (durationSeconds * 10))).clamp(0.0, 1.0);
                    });
                  }
                });
              }
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.secondarySurfaceTint,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.mic_rounded, color: AppColors.secondary, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Customer Audio Scoping (${durationSeconds}s)',
                                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            playbackTimer?.cancel();
                            Navigator.pop(modalContext);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Waveform visual
                    Container(
                      height: 48,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(24, (index) {
                          final h = ((index % 5 + 2) * 6.0).clamp(6.0, 36.0);
                          final passed = (index / 24) <= progress;
                          return Container(
                            width: 4,
                            height: h,
                            decoration: BoxDecoration(
                              color: passed ? AppColors.secondary : AppColors.borderSubtle,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0:${(progress * durationSeconds).round().toString().padLeft(2, '0')}',
                          style: AppTypography.labelSm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '0:${durationSeconds.toString().padLeft(2, '0')}',
                          style: AppTypography.labelSm.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Transcript
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.subtitles_rounded, size: 16, color: AppColors.tertiary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Customer Voice Note: "MCB switch sparking when turning on AC. Need 32A replacement."',
                              style: AppTypography.bodySm.copyWith(color: AppColors.textPrimary, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        key: const Key('radar_modal_play_button'),
                        onPressed: togglePlay,
                        icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 20),
                        label: Text(
                          isPlaying ? 'Pause Preview' : 'Listen to Customer Audio Memo',
                          style: AppTypography.labelMd.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(120, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
