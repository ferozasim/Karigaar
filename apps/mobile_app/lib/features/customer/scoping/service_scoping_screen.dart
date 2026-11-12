import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/api_service.dart';
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
  bool _hasInitializedTradeSelection = false;
  bool _hasAttachedPhoto = false;
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

        if (!_hasInitializedTradeSelection && trade.popularPackages.isNotEmpty) {
          _hasInitializedTradeSelection = true;
          final hasMatch = trade.popularPackages.any((p) => _selectedPackageIds.contains(p.packageId));
          if (!hasMatch) {
            _selectedPackageIds
              ..clear()
              ..add(trade.popularPackages.first.packageId);
          }
        }

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
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/customer/home');
                }
              },
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
                              Flexible(
                                child: TrustShieldBadge(
                                  label: 'Verified Master Guild',
                                  icon: Icons.workspace_premium_rounded,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.star_rounded, color: AppColors.secondary, size: 18),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '4.9 (1.4k jobs in Nanded)',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
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
                                        Flexible(
                                          child: Text(
                                            '• ~${pkg.estimatedMinutes} mins',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.bodySm,
                                          ),
                                        ),
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
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _hasAttachedPhoto = !_hasAttachedPhoto;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _hasAttachedPhoto
                                        ? 'Issue photo attached for ${trade.name} inspection.'
                                        : 'Removed attached photo.',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: _hasAttachedPhoto ? AppColors.tertiarySurfaceTint : AppColors.surfaceRaised,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _hasAttachedPhoto ? AppColors.tertiary : AppColors.borderSubtle,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _hasAttachedPhoto ? Icons.check_circle_rounded : Icons.add_a_photo_rounded,
                                    color: _hasAttachedPhoto ? AppColors.tertiary : AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      _hasAttachedPhoto ? 'Photo Added' : 'Add Photo',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.labelMd.copyWith(
                                        color: _hasAttachedPhoto ? AppColors.tertiary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                  Flexible(
                                    child: Text(
                                      _isRecordingAudio ? 'Stop (${_audioSeconds}s)' : '15s Audio Memo',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.labelMd.copyWith(
                                        color: _isRecordingAudio ? AppColors.error : AppColors.textPrimary,
                                      ),
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
                              Expanded(
                                child: Text(slot, style: AppTypography.labelMd),
                              ),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text('₹$grandTotal', style: AppTypography.numericPrice),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.tertiarySurfaceTint,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '+₹29 Shield Fee',
                                      style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Adjustable on-site bill',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 0,
                        child: ElevatedButton(
                          onPressed: () {
                            _showUpiPreAuthMandateSheet(context, grandTotal);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Request Artisan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
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

  void _showUpiPreAuthMandateSheet(BuildContext context, int grandTotal) {
    final vpaController = TextEditingController(text: 'customer@okaxis');
    String? errorMessage;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderSubtle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.security_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upfront ₹99 Standby Mandate',
                                style: AppTypography.headlineSm.copyWith(fontSize: 17),
                              ),
                              Text(
                                'Razorpay / Cashfree UPI Autopay Protected',
                                style: AppTypography.labelSm.copyWith(color: AppColors.tertiary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Why is a ₹99 pre-authorization required?', style: AppTypography.labelSm.copyWith(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Secures ₹99 standby transit fee hold to protect artisan fuel and travel. The hold is RELEASED upon job completion and debited ONLY if doorstep access is denied for >15 minutes.',
                            style: AppTypography.bodySm.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Quick Select UPI App', style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFF1A73E8)),
                          label: const Text('GPay'),
                          onPressed: () {
                            setSheetState(() {
                              vpaController.text = 'customer@okaxis';
                              errorMessage = null;
                            });
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFF5F259F)),
                          label: const Text('PhonePe'),
                          onPressed: () {
                            setSheetState(() {
                              vpaController.text = 'customer@ybl';
                              errorMessage = null;
                            });
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFF002970)),
                          label: const Text('Paytm'),
                          onPressed: () {
                            setSheetState(() {
                              vpaController.text = 'customer@paytm';
                              errorMessage = null;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text('Enter UPI ID / VPA', style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vpaController,
                      decoration: InputDecoration(
                        hintText: 'e.g. mobile@okaxis',
                        prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        errorText: errorMessage,
                      ),
                      onChanged: (_) {
                        if (errorMessage != null) {
                          setSheetState(() {
                            errorMessage = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final vpa = vpaController.text.trim();
                          final vpaRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
                          if (!vpaRegex.hasMatch(vpa)) {
                            setSheetState(() {
                              errorMessage = 'Please enter a valid UPI VPA (e.g. name@bank)';
                            });
                            return;
                          }

                          try {
                            final api = ref.read(apiServiceProvider);
                            final res = await api.createUpiPreAuthMandate(
                              bookingId: 'BK_NANDED_8821',
                              customerId: 'cust_01',
                              upiVpa: vpa,
                              amount: 99,
                            );
                            final mandateData = res['data'] as Map<String, dynamic>?;

                            final currentBooking = ref.read(activeBookingProvider);
                            if (currentBooking != null) {
                              ref.read(activeBookingProvider.notifier).state = currentBooking.copyWith(
                                mandateStatus: UpiMandateStatus.authorized,
                                mandateId: mandateData?['mandateId'] as String?,
                                upiVpa: vpa,
                              );
                            }

                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                            }
                            if (context.mounted) {
                              await context.push('/customer/active-tracking/BK_NANDED_8821');
                            }
                          } catch (e) {
                            setSheetState(() {
                              errorMessage = e.toString();
                            });
                          }
                        },
                        child: Text(
                          'Authorize ₹99 Mandate & Request Artisan',
                          style: AppTypography.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
