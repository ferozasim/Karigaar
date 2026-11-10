import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/locality_selector_sheet.dart';
import '../../shared/widgets/trust_shield_badge.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  bool _whatsAppUpdates = true;
  bool _upiAutoMandate = true;
  final String _defaultPaymentMethod = 'UPI AutoPay (asim@okicici)';

  @override
  Widget build(BuildContext context) {
    final selectedLocality = ref.watch(selectedLocalityProvider);
    final localitiesAsync = ref.watch(nandedLocalitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: const Text('Homeowner Profile & Settings'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Homeowner Identity Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primaryContainer,
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.secondary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Asim Farooqui',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.headlineSm.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '+91 9822199882 • Verified Homeowner',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const TrustShieldBadge(
                    label: '₹25,000 Master Guild Damage Protection Active',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Saved Nanded Localities
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Saved Nanded Localities',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm,
                  ),
                ),
                TextButton(
                  onPressed: () => LocalitySelectorSheet.show(context),
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
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
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Primary: ${selectedLocality.name}, Nanded (${selectedLocality.pincode})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelLg,
                            ),
                            Text(
                              '${selectedLocality.marathiName} • Plot 14, Near Guru Gobind Singh Ji Marg',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  localitiesAsync.when(
                    data: (localities) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: localities.take(4).map((loc) {
                        final isCurrent =
                            loc.localityId == selectedLocality.localityId;
                        return ChoiceChip(
                          label: Text(loc.name),
                          selected: isCurrent,
                          selectedColor: AppColors.secondarySurfaceTint,
                          onSelected: (_) {
                            ref.read(selectedLocalityProvider.notifier).state =
                                loc;
                          },
                        );
                      }).toList(),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Payment & Escrow Preferences
            Text(
              'Escrow & Payment Preferences',
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: 8),
            Material(
              color: AppColors.surfaceRaised,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppColors.tertiary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _defaultPaymentMethod,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.labelLg,
                              ),
                              Text(
                                '₹99 Transit Fee Mandate & RBI 2FA Parts Approval',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'UPI Escrow Pre-Authorization',
                        style: AppTypography.labelMd,
                      ),
                      subtitle: Text(
                        'Release payout only after 4-digit Completion OTP',
                        style: AppTypography.bodySm,
                      ),
                      value: _upiAutoMandate,
                      activeThumbColor: AppColors.tertiary,
                      onChanged: (val) => setState(() => _upiAutoMandate = val),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'WhatsApp Dispatch & Gate Pass Alerts',
                        style: AppTypography.labelMd,
                      ),
                      subtitle: Text(
                        'Receive live artisan tracking & digital GST invoices',
                        style: AppTypography.bodySm,
                      ),
                      value: _whatsAppUpdates,
                      activeThumbColor: AppColors.tertiary,
                      onChanged: (val) =>
                          setState(() => _whatsAppUpdates = val),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Emergency Contact & Mode Switch
            Text('Guild Portal & Security', style: AppTypography.headlineSm),
            const SizedBox(height: 8),
            Material(
              color: AppColors.surfaceRaised,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.emergency_share_rounded,
                        color: AppColors.error,
                      ),
                      title: Text(
                        'Emergency SOS Contact',
                        style: AppTypography.labelLg,
                      ),
                      subtitle: Text(
                        '+91 9422100100 • Nanded Control Desk (24x7)',
                        style: AppTypography.bodySm,
                      ),
                    ),
                    const Divider(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.radar_rounded,
                        color: AppColors.secondary,
                      ),
                      title: Text(
                        'Switch to Artisan Guild Portal',
                        style: AppTypography.labelLg,
                      ),
                      subtitle: Text(
                        'Open 45s Job Radar & Instant IMPS Wallet',
                        style: AppTypography.bodySm,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.go('/artisan/radar'),
                    ),
                    const Divider(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.error,
                      ),
                      title: Text(
                        'Sign Out / Switch Number',
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      onTap: () => context.go('/login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.explore_rounded,
            label: 'Explore',
            isActive: false,
            onTap: () => context.go('/customer/home'),
          ),
          _buildNavItem(
            icon: Icons.assignment_rounded,
            label: 'Bookings',
            isActive: false,
            onTap: () => context.go('/customer/bookings'),
          ),
          _buildNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Messages',
            isActive: false,
            onTap: () => context.go('/customer/messages'),
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textSubtle,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTypography.labelSm.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textSubtle,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
