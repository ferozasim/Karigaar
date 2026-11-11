import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/trade_model.dart';
import '../../../core/models/artisan_profile_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/emergency_assist_banner.dart';
import '../../shared/widgets/karigaar_brand_logo.dart';
import '../../shared/widgets/karigaar_radar_sync_skeleton.dart';
import '../../shared/widgets/trust_shield_badge.dart';
import '../../shared/widgets/mode_switcher_pill.dart';
import '../../shared/widgets/locality_selector_sheet.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradesAsync = ref.watch(launchTradesProvider);
    final artisans = ref.watch(topArtisansProvider);
    final selectedLocality = ref.watch(selectedLocalityProvider);
    final selectedDistrict = ref.watch(selectedDistrictProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Row(
                  children: [
                    // Official Squircle Brand Logo (F-34)
                    const KarigaarBrandLogo(size: 36),
                    const SizedBox(width: 8),
                    // Locality Selector (Pilot City: Nanded)
                    Expanded(
                      child: InkWell(
                        onTap: () => LocalitySelectorSheet.show(context),
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${selectedLocality.name}, ${selectedDistrict.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.headlineSm.copyWith(fontSize: 15),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                              ],
                            ),
                            Text(
                              '${selectedLocality.marathiName} • ${selectedLocality.pincode}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Mode Switcher (Homeowner <-> Karigaar)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 136),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ModeSwitcherPill(compact: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showQuickTradeSearchSheet(context, tradesAsync.valueOrNull ?? []),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Search electricians, carpenters, plumbers...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMd.copyWith(color: AppColors.textSubtle),
                          ),
                        ),
                        const Icon(Icons.mic_rounded, color: AppColors.secondary, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Emergency Quick-Assist Banner (25 mins dispatch)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: EmergencyAssistBanner(
                  onBookUrgent: () {
                    // Navigate to emergency booking with first available electrician
                    context.push('/customer/service/trade_electrician');
                  },
                ),
              ),
            ),

            // 10 Launch Trades Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '10 Launch Trades',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedDistrict.name} Guild',
                      style: AppTypography.labelSm.copyWith(color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ),

            // 10 Launch Trades Grid (5 columns x 2 rows with fixed mainAxisExtent for all screen widths)
            tradesAsync.when(
              data: (trades) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 88,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final trade = trades[index];
                      return _buildTradeGridItem(context, trade);
                    },
                    childCount: trades.length,
                  ),
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: KarigaarRadarSyncSkeleton(),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Text('Error: $err'),
              ),
            ),

            // The Karigaar Shield Commitment Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
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
                      Row(
                        children: [
                          const Icon(Icons.security_rounded, color: AppColors.tertiary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('The Karigaar Shield Commitment', style: AppTypography.labelLg),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Expanded(child: TrustShieldBadge.policeVerified()),
                          SizedBox(width: 8),
                          Expanded(child: TrustShieldBadge.warranty30Days()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Top Rated Karigaars Nearby
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Top Rated Karigaars in ${selectedDistrict.name}', style: AppTypography.headlineSm),
                    ),
                  ],
                ),
              ),
            ),

            // Artisans List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final artisan = artisans[index];
                    return _buildArtisanCard(context, artisan);
                  },
                  childCount: artisans.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTradeGridItem(BuildContext context, TradeModel trade) {
    return GestureDetector(
      onTap: () => context.push('/customer/service/${trade.tradeId}'),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: trade.surfaceTint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: trade.accentColor.withValues(alpha: 0.3)),
              ),
              child: Icon(
                _getIconData(trade.iconName),
                color: trade.accentColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              trade.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              trade.marathiName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(
                fontSize: 9,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanCard(BuildContext context, ArtisanProfileModel artisan) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/customer/artisan/${artisan.artisanId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.tertiary, width: 2),
                  ),
                  child: const Icon(Icons.person_rounded, color: AppColors.textMuted, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              artisan.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.headlineSm.copyWith(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded, color: AppColors.tertiary, size: 16),
                        ],
                      ),
                      Text(
                        '${artisan.tradeTitle} • ${artisan.yearsExperience} yrs exp',
                        style: AppTypography.bodySm,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${artisan.rating} (${artisan.reviewCount} reviews) • ${artisan.distanceKm} km away',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSm.copyWith(color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              artisan.bio,
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnostic Inspection',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSm,
                    ),
                    Text('₹${artisan.inspectionFee}', style: AppTypography.numericPrice.copyWith(fontSize: 18)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => context.push('/customer/service/${artisan.primaryTradeId}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Book Artisan', style: AppTypography.labelMd.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
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
          _buildNavItem(icon: Icons.explore_rounded, label: 'Explore', isActive: true),
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
            isActive: false,
            onTap: () => context.go('/customer/profile'),
          ),
        ],
      ),
    );
  }

  void _showQuickTradeSearchSheet(BuildContext context, List<TradeModel> trades) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Trade Search', style: AppTypography.headlineSm),
            const SizedBox(height: 6),
            Text('Select a Nanded Guild trade to scope your issue:', style: AppTypography.bodySm),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trades.length,
                itemBuilder: (_, idx) {
                  final t = trades[idx];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: t.surfaceTint,
                      child: Icon(_getIconData(t.iconName), color: t.accentColor, size: 20),
                    ),
                    title: Text('${t.name} (${t.marathiName})', style: AppTypography.labelLg),
                    subtitle: Text('Inspection ₹${t.baseInspectionFee} • ${t.guaranteeDays}d Warranty', style: AppTypography.bodySm),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/customer/service/${t.tradeId}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

  IconData _getIconData(String name) {
    switch (name) {
      case 'bolt':
        return Icons.bolt_rounded;
      case 'plumbing':
        return Icons.plumbing_rounded;
      case 'carpenter':
        return Icons.handyman_rounded;
      case 'foundation':
        return Icons.foundation_rounded;
      case 'format_paint':
        return Icons.format_paint_rounded;
      case 'mode_fan':
        return Icons.ac_unit_rounded;
      case 'home_repair_service':
        return Icons.home_repair_service_rounded;
      case 'construction':
        return Icons.construction_rounded;
      case 'pest_control':
        return Icons.pest_control_rounded;
      case 'cleaning_services':
        return Icons.cleaning_services_rounded;
      default:
        return Icons.build_rounded;
    }
  }
}
