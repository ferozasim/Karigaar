import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/models/artisan_profile_model.dart';
import '../../../../core/models/booking_model.dart';
import '../../../../core/providers/app_providers.dart';

class RetroactiveEscrowLockSheet extends ConsumerStatefulWidget {
  final ArtisanProfileModel artisan;

  const RetroactiveEscrowLockSheet({
    super.key,
    required this.artisan,
  });

  static Future<bool?> show(BuildContext context, ArtisanProfileModel artisan) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RetroactiveEscrowLockSheet(artisan: artisan),
    );
  }

  @override
  ConsumerState<RetroactiveEscrowLockSheet> createState() =>
      _RetroactiveEscrowLockSheetState();
}

class _RetroactiveEscrowLockSheetState
    extends ConsumerState<RetroactiveEscrowLockSheet> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final artisan = widget.artisan;
    final isMaster = artisan.tier == GuildTier.masterGuildsman ||
        artisan.tier == GuildTier.guildElite;
    final coverAmount = isMaster ? 25000 : 10000;
    final coverTitle = isMaster ? '₹25,000 Master Cover' : '₹10,000 Base Cover';
    final totalUpfront = artisan.inspectionFee + 29;
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.90;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      decoration: const BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Subtitle
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: AppColors.tertiary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upgrade to Protected Guild Booking',
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Lock on-site visit into formal escrow protection',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Start OTP Handshake Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.tertiarySurfaceTint,
                      AppColors.surfaceRaised,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.tertiary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.vpn_key_rounded,
                          color: AppColors.tertiary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Doorstep Handshake Code',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Start Handshake OTP: 4921',
                            style: AppTypography.headlineSm.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: AppColors.tertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Active',
                            style: AppTypography.labelSm.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share this 4-digit code with ${artisan.name} on-site to verify arrival and activate the stopwatch.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Two-Tier Guild Damage Shield Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.tertiary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '$coverTitle Active',
                            style: AppTypography.headlineSm.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Comprehensive property damage underwriting during job execution. ₹250 customer deductible applies to eliminate frivolous claims.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Itemized Breakdown
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upfront Escrow Breakdown',
                      style: AppTypography.labelSm.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPriceRow('Base Inspection & Travel', '₹${artisan.inspectionFee}'),
                    const SizedBox(height: 6),
                    _buildPriceRow('Platform Safety Shield & Warranty', '₹29'),
                    const Divider(height: 16),
                    _buildPriceRow(
                      'Total Standby Escrow Hold',
                      '₹$totalUpfront',
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Confirm CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const Key('confirm_lock_escrow_btn'),
                  onPressed: _isProcessing ? null : () => _handleLockEscrow(coverAmount),
                  icon: const Icon(Icons.lock_rounded, size: 18),
                  label: const Text(
                    'Confirm & Lock Escrow (₹29 Shield)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySm.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: isBold ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTypography.bodySm.copyWith(
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLockEscrow(int coverAmount) async {
    setState(() => _isProcessing = true);
    final artisan = widget.artisan;

    final newBooking = BookingModel(
      bookingId:
          'BK_NANDED_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerId: 'cust_01',
      customerName: 'Asim Farooqui',
      customerPhone: '+919822199882',
      assignedArtisanId: artisan.artisanId,
      assignedArtisanName: artisan.name,
      assignedArtisanPhone: artisan.phone,
      tradeId: artisan.primaryTradeId,
      tradeName: artisan.tradeTitle,
      localityId: artisan.localityId,
      localityName: 'Anand Nagar, Nanded',
      address: 'Plot 14, Near Water Tank, Anand Nagar',
      status: BookingStatus.artisanArrived,
      startOtp: '4921',
      completionOtp: '7294',
      baseInspectionFee: artisan.inspectionFee,
      laborFee: 249,
      safetyShieldFee: 29,
      damageCoverAmount: coverAmount,
      customerDeductible: 250,
      isRetroactiveOnSiteLock: true,
      createdAt: DateTime.now(),
      arrivalTime: DateTime.now(),
    );

    ref.read(activeBookingProvider.notifier).state = newBooking;

    if (mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'On-site booking locked! Share Start OTP 4921 with ${artisan.name}.',
          ),
          backgroundColor: AppColors.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
