import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/trust_shield_badge.dart';

class ServiceScopingScreen extends ConsumerStatefulWidget {
  final String tradeId;

  const ServiceScopingScreen({super.key, required this.tradeId});

  @override
  ConsumerState<ServiceScopingScreen> createState() => _ServiceScopingScreenState();
}

class _ServiceScopingScreenState extends ConsumerState<ServiceScopingScreen> {
  final Set<String> _selectedPackageIds = {'pkg_elec_mcb'};
  bool _isRecordingAudio = false;
  int _audioSeconds = 0;
  String _selectedSlot = 'Morning (9:00 AM - 12:00 PM)';

  final List<String> _availableSlots = [
    'Emergency (Within 25 Mins)',
    'Morning (9:00 AM - 12:00 PM)',
    'Afternoon (1:00 PM - 4:00 PM)',
    'Evening (5:00 PM - 8:00 PM)',
  ];

  @override
  Widget build(BuildContext context) {
    final tradesAsync = ref.watch(launchTradesProvider);

    return tradesAsync.when(
      data: (trades) {
        final trade = trades.firstWhere(
          (t) => t.tradeId == widget.tradeId,
          orElse: () => trades.first,
        );

        // Calculate dynamic total
        int laborTotal = 0;
        for (final pkg in trade.popularPackages) {
          if (_selectedPackageIds.contains(pkg.packageId)) {
            laborTotal += pkg.estimatedPrice;
          }
        }
        if (laborTotal == 0) laborTotal = trade.baseInspectionFee;
        final safetyShieldFee = trade.safetyShieldFee;
        final grandTotal = laborTotal + safetyShieldFee;

        return Scaffold(
          backgroundColor: AppColors.surfaceBase,
          appBar: AppBar(
            title: Text(trade.name),
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
                    // Hero & Trust Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              TrustShieldBadge(
                                label: 'Verified Master Guild',
                                icon: Icons.workspace_premium_rounded,
                              ),
                              Spacer(),
                              Icon(Icons.star_rounded, color: AppColors.secondary, size: 18),
                              SizedBox(width: 4),
                              Text(
                                '4.9 (1.4k jobs in Nanded)',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            trade.name,
                            style: AppTypography.headlineLg.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trade.tagline,
                            style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimaryContainer),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_rounded, color: AppColors.tertiaryLight, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Includes 45-min diagnostic inspection & 30-day rework warranty',
                                    style: AppTypography.bodySm.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text('Select Issues to Resolve', style: AppTypography.headlineSm),
                    const SizedBox(height: 6),
                    Text('Choose all relevant problems for accurate tooling', style: AppTypography.bodySm),
                    const SizedBox(height: 16),

                    // Issues Checklist
                    ...trade.popularPackages.map((pkg) {
                      final isSelected = _selectedPackageIds.contains(pkg.packageId);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedPackageIds.remove(pkg.packageId);
                            } else {
                              _selectedPackageIds.add(pkg.packageId);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceRaised,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isSelected,
                                activeColor: AppColors.primary,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedPackageIds.add(pkg.packageId);
                                    } else {
                                      _selectedPackageIds.remove(pkg.packageId);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pkg.name, style: AppTypography.labelLg),
                                    const SizedBox(height: 4),
                                    Text(
                                      pkg.description,
                                      style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text('₹${pkg.estimatedPrice} Est.', style: AppTypography.numericPrice.copyWith(fontSize: 16)),
                                        const SizedBox(width: 8),
                                        Text('• ~${pkg.estimatedMinutes} mins', style: AppTypography.bodySm),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                    // Media & Voice Scoping (15s Audio Memo)
                    Text('Photo & 15-Second Voice Note', style: AppTypography.headlineSm),
                    const SizedBox(height: 6),
                    Text('Help your craftsman bring the exact spares from the hardware store', style: AppTypography.bodySm),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Photo upload button
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceRaised,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Text('Add Photo', style: AppTypography.labelMd),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 15s voice note record button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRecordingAudio = !_isRecordingAudio;
                                if (_isRecordingAudio) _audioSeconds = 15;
                              });
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: _isRecordingAudio ? const Color(0xFFFEE2E2) : AppColors.surfaceRaised,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _isRecordingAudio ? AppColors.error : AppColors.borderSubtle,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isRecordingAudio ? Icons.stop_rounded : Icons.mic_rounded,
                                    color: _isRecordingAudio ? AppColors.error : AppColors.secondary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isRecordingAudio ? 'Stop (${_audioSeconds}s)' : '15s Audio Memo',
                                    style: AppTypography.labelMd.copyWith(
                                      color: _isRecordingAudio ? AppColors.error : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Arrival Slot
                    Text('Select Arrival Slot', style: AppTypography.headlineSm),
                    const SizedBox(height: 12),
                    ..._availableSlots.map((slot) {
                      final isSelected = _selectedSlot == slot;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSlot = slot),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.surfaceSubtle : AppColors.surfaceRaised,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                color: isSelected ? AppColors.primary : AppColors.textSubtle,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(slot, style: AppTypography.labelMd),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Sticky Bottom Dock
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text('₹$grandTotal', style: AppTypography.numericPrice),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.tertiarySurfaceTint,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('+₹29 Shield Fee', style: AppTypography.labelSm.copyWith(color: AppColors.tertiary)),
                              ),
                            ],
                          ),
                          Text('Adjustable on-site bill', style: AppTypography.bodySm),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to live tracking for demo
                          context.push('/customer/active-tracking/BK_NANDED_8821');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Request Artisan',
                          style: AppTypography.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
