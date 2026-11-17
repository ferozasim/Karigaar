import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/trade_model.dart';
import '../../../core/models/karigaar_role_type.dart';
import '../../../core/models/preventive_bundle_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/trust_shield_badge.dart';
import 'widgets/audio_memo_recorder_widget.dart';
import 'widgets/arrival_slot_picker_widget.dart';

class ServiceScopingScreen extends ConsumerStatefulWidget {
  final String tradeId;
  final List<String>? initialPackageIds;
  final String? bundleId;
  final PreventiveBundleModel? bundle;

  const ServiceScopingScreen({
    super.key,
    required this.tradeId,
    this.initialPackageIds,
    this.bundleId,
    this.bundle,
  });

  @override
  ConsumerState<ServiceScopingScreen> createState() => _ServiceScopingScreenState();
}

class _ServiceScopingScreenState extends ConsumerState<ServiceScopingScreen> {
  final Set<String> _selectedPackageIds = {'pkg_elec_mcb'};
  KarigaarRoleType _selectedRoleTier = KarigaarRoleType.skilledKarigaar;
  bool _hasInitializedTradeSelection = false;
  bool _hasAttachedPhoto = false;

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
          if (widget.initialPackageIds != null && widget.initialPackageIds!.isNotEmpty) {
            _selectedPackageIds
              ..clear()
              ..addAll(widget.initialPackageIds!);
          } else {
            final hasMatch = trade.popularPackages.any((p) => _selectedPackageIds.contains(p.packageId));
            if (!hasMatch) {
              _selectedPackageIds
                ..clear()
                ..add(trade.popularPackages.first.packageId);
            }
          }
        }

        // Calculate dynamic total
        int baseLaborTotal = 0;
        final hasBundleApplied = widget.bundle != null &&
            widget.bundle!.includedPackageIds.every((id) => _selectedPackageIds.contains(id));

        if (hasBundleApplied) {
          baseLaborTotal = widget.bundle!.discountedPrice;
          for (final pkg in trade.popularPackages) {
            if (_selectedPackageIds.contains(pkg.packageId) &&
                !widget.bundle!.includedPackageIds.contains(pkg.packageId)) {
              baseLaborTotal += pkg.estimatedPrice;
            }
          }
        } else {
          for (final pkg in trade.popularPackages) {
            if (_selectedPackageIds.contains(pkg.packageId)) {
              baseLaborTotal += pkg.estimatedPrice;
            }
          }
          if (baseLaborTotal == 0) baseLaborTotal = trade.baseInspectionFee;
        }

        final laborTotal = (baseLaborTotal * _selectedRoleTier.rateMultiplier).round();
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

                    if (widget.bundle != null) ...[
                      Container(
                        key: const Key('curated_bundle_applied_banner'),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: widget.bundle!.surfaceTint,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: widget.bundle!.accentColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.bundle!.accentColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Curated Bundle Applied',
                                          style: AppTypography.labelSm.copyWith(
                                            color: widget.bundle!.accentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: widget.bundle!.accentColor,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              widget.bundle!.discountTag,
                                              style: AppTypography.labelSm.copyWith(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${widget.bundle!.title} (Save ₹${widget.bundle!.savingsAmount})',
                                    style: AppTypography.headlineSm.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

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
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '₹${pkg.estimatedPrice} Est.',
                                            style: AppTypography.numericPrice.copyWith(fontSize: 16),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '• ~${pkg.estimatedMinutes} mins',
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
                    // Craftsperson Skill Tier Selection (KarigaarRoleType)
                    _buildRoleRateTierSelector(trade),

                    const SizedBox(height: 20),
                    // Media & Voice Scoping (15s Audio Memo)
                    Text('Photo & 15-Second Voice Note', style: AppTypography.headlineSm),
                    const SizedBox(height: 6),
                    Text('Help your craftsman bring the exact spares from the hardware store', style: AppTypography.bodySm),
                    const SizedBox(height: 12),
                    // Photo upload button
                    GestureDetector(
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
                        height: 52,
                        width: double.infinity,
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
                                _hasAttachedPhoto ? 'Defect Photo Attached' : 'Add Issue Photo (Optional)',
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

                    const SizedBox(height: 14),

                    // Interactive 15s Audio Memo Recorder
                    const AudioMemoRecorderWidget(
                      key: Key('audio_memo_recorder_widget'),
                    ),

                    const SizedBox(height: 24),

                    // Scheduled Arrival Slot Picker (7-day carousel + time windows)
                    const ArrivalSlotPickerWidget(
                      key: Key('arrival_slot_picker_widget'),
                    ),
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
                        fit: FlexFit.loose,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              _showUpiPreAuthMandateSheet(context, grandTotal);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Request Artisan',
                              maxLines: 1,
                              style: AppTypography.labelLg.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget _buildRoleRateTierSelector(TradeModel trade) {
    final activeTitle = _selectedRoleTier.getLocalizedTitle(trade.tradeId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Craftsperson Skill Tier',
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _selectedRoleTier.badgeText,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Active: $activeTitle',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          ...KarigaarRoleType.values.map((role) {
            final isSelected = _selectedRoleTier == role;
            final localizedTitle = role.getLocalizedTitle(trade.tradeId);
            final multText = switch (role) {
              KarigaarRoleType.headMistry => '1.25x (+25% Master Tier)',
              KarigaarRoleType.skilledKarigaar => '1.0x (Standard Rate)',
              KarigaarRoleType.helperAssistant => '0.65x (-35% Helper Tier)',
              KarigaarRoleType.thekedar => '1.35x (+35% Team Contractor)',
            };

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                key: Key('role_tier_${role.id}'),
                onTap: () => setState(() => _selectedRoleTier = role),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.borderSubtle,
                            width: isSelected ? 6 : 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizedTitle,
                              style: AppTypography.labelMd.copyWith(
                                fontWeight:
                                    isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              multText,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
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

                            final audioMemo = ref.read(recordedAudioMemoProvider);
                            final selectedSlot = ref.read(selectedArrivalSlotProvider);
                            final selectedDate = ref.read(selectedArrivalDateProvider);

                            String? audioUrl;
                            int? audioDuration;
                            List<double>? audioWf;
                            String? audioTranscript;

                            if (audioMemo != null) {
                              try {
                                final uploadRes = await api.uploadAudioMemo(
                                  bookingId: 'BK_NANDED_8821',
                                  tradeId: widget.tradeId,
                                  durationSeconds: audioMemo.durationSeconds,
                                  waveform: audioMemo.waveform,
                                );
                                final uploadData = uploadRes['data'] as Map<String, dynamic>?;
                                audioUrl = uploadData?['audioMemoUrl'] as String? ?? audioMemo.url;
                                audioDuration = (uploadData?['durationSeconds'] as num?)?.toInt() ?? audioMemo.durationSeconds;
                                audioWf = (uploadData?['waveform'] as List<dynamic>?)
                                    ?.map((e) => (e as num).toDouble())
                                    .toList() ?? audioMemo.waveform;
                                audioTranscript = uploadData?['transcript'] as String? ?? audioMemo.transcript;
                              } catch (_) {
                                audioUrl = audioMemo.url;
                                audioDuration = audioMemo.durationSeconds;
                                audioWf = audioMemo.waveform;
                                audioTranscript = audioMemo.transcript;
                              }
                            }

                            final slotLabel = selectedSlot != null
                                ? '${selectedSlot.category.label} (${selectedSlot.timeWindow})'
                                : null;
                            final slotId = selectedSlot?.slotId;
                            final isEmergency = selectedSlot?.isEmergency ?? false;

                            if (selectedSlot != null) {
                              try {
                                await api.reserveArrivalSlot(
                                  bookingId: 'BK_NANDED_8821',
                                  tradeId: widget.tradeId,
                                  date: selectedDate,
                                  slotId: selectedSlot.slotId,
                                );
                              } catch (_) {}
                            }

                            final currentBooking = ref.read(activeBookingProvider);
                            if (currentBooking != null) {
                              ref.read(activeBookingProvider.notifier).state = currentBooking.copyWith(
                                mandateStatus: UpiMandateStatus.authorized,
                                mandateId: mandateData?['mandateId'] as String?,
                                upiVpa: vpa,
                                audioMemoUrl: audioUrl,
                                audioMemoDurationSeconds: audioDuration,
                                audioMemoWaveform: audioWf,
                                audioMemoTranscript: audioTranscript,
                                scheduledDate: selectedDate,
                                scheduledSlot: slotLabel,
                                scheduledSlotId: slotId,
                                isEmergencyDispatch: isEmergency,
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
