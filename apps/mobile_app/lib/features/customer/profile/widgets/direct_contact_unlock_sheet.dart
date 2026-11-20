import '../../../../l10n/localized_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/models/artisan_profile_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/whatsapp_telephony_service.dart';
import '../../../../core/providers/app_providers.dart';

enum DirectContactUnlockOption {
  payPerLead,
  directoryPass,
}

class DirectContactUnlockSheet extends ConsumerStatefulWidget {
  final ArtisanProfileModel artisan;

  const DirectContactUnlockSheet({
    super.key,
    required this.artisan,
  });

  static Future<bool?> show(BuildContext context, ArtisanProfileModel artisan) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DirectContactUnlockSheet(artisan: artisan),
    );
  }

  @override
  ConsumerState<DirectContactUnlockSheet> createState() =>
      _DirectContactUnlockSheetState();
}

class _DirectContactUnlockSheetState
    extends ConsumerState<DirectContactUnlockSheet> {
  DirectContactUnlockOption _selectedOption =
      DirectContactUnlockOption.payPerLead;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final artisan = widget.artisan;
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
              // Top grab handle
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
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock_open_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizedStrings(context).accountUnlockTitle,
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          localizedStrings(context).accountConnectName(artisan.name, artisan.tradeTitle),
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

              // Zero MSISDN Leakage Guarantee Notice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.tertiary.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
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
                            localizedStrings(context).accountPrivacyProtected,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizedStrings(context).accountProxyDescription(KarigaarWhatsAppTelephonyService.defaultVirtualProxyDid),
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Option 1: Pay-Per-Lead (₹49)
              _buildOptionCard(
                key: const Key('unlock_option_pay_per_lead'),
                option: DirectContactUnlockOption.payPerLead,
                title: localizedStrings(context).accountPayPerLead,
                priceTag: '₹49',
                periodTag: localizedStrings(context).accountOneTime,
                subtitle:
                    localizedStrings(context).accountUnlockDays(artisan.name),
                badge: localizedStrings(context).accountSingleArtisan,
                badgeColor: AppColors.primary,
              ),
              const SizedBox(height: 10),

              // Option 2: Unlimited Directory Pass (₹499/mo)
              _buildOptionCard(
                key: const Key('unlock_option_directory_pass'),
                option: DirectContactUnlockOption.directoryPass,
                title: localizedStrings(context).accountDirectoryPass,
                priceTag: '₹499',
                periodTag: localizedStrings(context).accountPerMonth,
                subtitle:
                    localizedStrings(context).accountUnlimitedContact,
                badge: localizedStrings(context).accountRecommended,
                badgeColor: AppColors.tertiary,
              ),
              const SizedBox(height: 14),

              // Highlights List
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureRow(
                      Icons.shield_outlined,
                      localizedStrings(context).accountMaskedBenefit,
                    ),
                    const SizedBox(height: 6),
                    _buildFeatureRow(
                      Icons.chat_bubble_outline_rounded,
                      localizedStrings(context).accountMetaBenefit,
                    ),
                    const SizedBox(height: 6),
                    _buildFeatureRow(
                      Icons.handshake_outlined,
                      localizedStrings(context).accountRetroactiveBenefit,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('confirm_unlock_direct_contact_btn'),
                  onPressed: _isProcessing ? null : _handleConfirmUnlock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _selectedOption == DirectContactUnlockOption.payPerLead
                              ? localizedStrings(context).accountUnlock49
                              : localizedStrings(context).accountActivatePass,
                          style: AppTypography.labelLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildOptionCard({
    required Key key,
    required DirectContactUnlockOption option,
    required String title,
    required String priceTag,
    required String periodTag,
    required String subtitle,
    required String badge,
    required Color badgeColor,
  }) {
    final isSelected = _selectedOption == option;

    return InkWell(
      key: key,
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: AppTypography.labelSm.copyWith(
                            color: badgeColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        priceTag,
                        style: AppTypography.headlineSm.copyWith(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        periodTag,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.tertiary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleConfirmUnlock() async {
    setState(() => _isProcessing = true);
    try {
      final apiService = ref.read(apiServiceProvider);
      final optionStr = _selectedOption == DirectContactUnlockOption.payPerLead
          ? 'PAY_PER_LEAD_49'
          : 'UNLIMITED_DIRECTORY_PASS_499';

      await apiService.unlockDirectContact(
        customerId: 'cust_01',
        artisanId: widget.artisan.artisanId,
        option: optionStr,
      );

      if (_selectedOption == DirectContactUnlockOption.payPerLead) {
        ref
            .read(contactUnlockProvider.notifier)
            .unlockPayPerLead(widget.artisan.artisanId);
      } else {
        ref.read(contactUnlockProvider.notifier).activateDirectoryPass();
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedOption == DirectContactUnlockOption.payPerLead
                  ? localizedStrings(context).accountContactUnlocked(KarigaarWhatsAppTelephonyService.defaultVirtualProxyDid)
                  : localizedStrings(context).accountPassActivated,
            ),
            backgroundColor: AppColors.tertiary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizedStrings(context).accountUnlockFailed(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
