import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/partner_copy.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

enum ArtisanNavTab { radar, wallet, profile }

/// Shared 3-tab Industrial Partner Bottom Navigation Bar
/// Wired across `/artisan/radar`, `/artisan/wallet`, and `/artisan/profile`.
class ArtisanBottomNav extends StatelessWidget {
  final ArtisanNavTab currentTab;

  const ArtisanBottomNav({
    super.key,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    final hasScope =
        context.findAncestorWidgetOfExactType<UncontrolledProviderScope>() !=
            null;
    if (!hasScope) {
      return _buildNav(context, PartnerCopy.of('en'));
    }
    return Consumer(
      builder: (context, ref, _) {
        final lang = ref.watch(partnerLanguageProvider);
        return _buildNav(context, PartnerCopy.of(lang));
      },
    );
  }

  Widget _buildNav(BuildContext context, PartnerCopy copy) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(top: BorderSide(color: AppColors.primaryLight)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: _ArtisanNavItem(
                  key: const Key('artisan_nav_radar'),
                  icon: Icons.radar_rounded,
                  label: copy.navRadar,
                  isActive: currentTab == ArtisanNavTab.radar,
                  onTap: () => _navigateTo(
                    context,
                    ArtisanNavTab.radar,
                    '/artisan/radar',
                  ),
                ),
              ),
              Expanded(
                child: _ArtisanNavItem(
                  key: const Key('artisan_nav_wallet'),
                  icon: Icons.account_balance_wallet_rounded,
                  label: copy.navWallet,
                  isActive: currentTab == ArtisanNavTab.wallet,
                  onTap: () => _navigateTo(
                    context,
                    ArtisanNavTab.wallet,
                    '/artisan/wallet',
                  ),
                ),
              ),
              Expanded(
                child: _ArtisanNavItem(
                  key: const Key('artisan_nav_profile'),
                  icon: Icons.person_rounded,
                  label: copy.navProfile,
                  isActive: currentTab == ArtisanNavTab.profile,
                  onTap: () => _navigateTo(
                    context,
                    ArtisanNavTab.profile,
                    '/artisan/profile',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, ArtisanNavTab tab, String route) {
    if (tab == currentTab) return;
    GoRouter.maybeOf(context)?.go(route);
  }
}

class _ArtisanNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ArtisanNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.secondaryLight : Colors.white70;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: isActive ? 24 : 0,
            height: 3,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondary : Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          Icon(
            icon,
            size: 22,
            color: color,
          ),
          const SizedBox(height: 3),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTypography.labelSm.copyWith(
                    color: color,
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
