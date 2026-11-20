import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/trade_model.dart';
import '../../../core/models/artisan_profile_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/service_discovery_catalog.dart';
import '../../../l10n/localized_strings.dart';
import '../../shared/widgets/emergency_assist_banner.dart';
import '../../shared/widgets/karigaar_brand_logo.dart';
import '../../shared/widgets/karigaar_radar_sync_skeleton.dart';
import '../../shared/widgets/trust_shield_badge.dart';
import '../../shared/widgets/mode_switcher_pill.dart';
import '../../shared/widgets/locality_selector_sheet.dart';
import 'widgets/curated_bundles_carousel.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradesAsync = ref.watch(launchTradesProvider);
    final artisans = ref.watch(topArtisansProvider);
    final selectedLocality = ref.watch(selectedLocalityProvider);
    final selectedDistrict = ref.watch(selectedDistrictProvider);
    final unfulfilledEvent = ref.watch(radarUnfulfilledEventProvider);

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
                                    style: AppTypography.headlineSm
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded,
                                    size: 20),
                              ],
                            ),
                            Text(
                              '${selectedLocality.marathiName} • ${selectedLocality.pincode}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm
                                  .copyWith(color: AppColors.textMuted),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showQuickTradeSearchSheet(
                      context, tradesAsync.valueOrNull ?? []),
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
                        const Icon(Icons.search_rounded,
                            color: AppColors.textMuted, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            localizedStrings(context).searchServices,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMd
                                .copyWith(color: AppColors.textSubtle),
                          ),
                        ),
                        const Icon(Icons.mic_rounded,
                            color: AppColors.secondary, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (unfulfilledEvent != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.radar_rounded,
                            size: 20, color: Color(0xFFB45309)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            unfulfilledEvent.customerNotification,
                            style: AppTypography.bodySm.copyWith(
                              color: const Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        localizedStrings(context).launchTrades,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localizedStrings(context)
                          .districtGuild(selectedDistrict.name),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.secondary),
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
                      return _buildTradeGridItem(
                        context,
                        trade,
                        ref.watch(appLocaleProvider).languageCode,
                      );
                    },
                    childCount: trades.length,
                  ),
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: KarigaarRadarSyncSkeleton(),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Text(localizedStrings(context).servicesLoadError),
              ),
            ),

            // Curated Preventive Maintenance Bundles Carousel (F-08)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24, bottom: 4),
                child: CuratedBundlesCarousel(
                  key: Key('curated_bundles_carousel'),
                ),
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
                          const Icon(Icons.security_rounded,
                              color: AppColors.tertiary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                                localizedStrings(context).shieldCommitment,
                                style: AppTypography.labelLg),
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
                      child: Text(
                          localizedStrings(context)
                              .topRatedInDistrict(selectedDistrict.name),
                          style: AppTypography.headlineSm),
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

  Widget _buildTradeGridItem(
      BuildContext context, TradeModel trade, String languageCode) {
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
                border:
                    Border.all(color: trade.accentColor.withValues(alpha: 0.3)),
              ),
              child: Icon(
                _getIconData(trade.iconName),
                color: trade.accentColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ServiceDiscoveryCatalog.localizedTradeName(trade, languageCode),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanCard(BuildContext context, ArtisanProfileModel artisan) {
    final strings = localizedStrings(context);
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
                  child: const Icon(Icons.person_rounded,
                      color: AppColors.textMuted, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  artisan.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.headlineSm
                                      .copyWith(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified_rounded,
                                  color: AppColors.tertiary, size: 16),
                            ],
                          ),
                          _buildRoleBadge(artisan.roleType),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${artisan.localizedRoleTitle} • ${strings.yearsExperience(artisan.yearsExperience)}',
                        style: AppTypography.bodySm,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: AppColors.secondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${artisan.rating} (${strings.reviewsAndDistance(artisan.reviewCount, artisan.distanceKm)})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSm
                                  .copyWith(color: AppColors.textMuted),
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
                      strings.diagnosticInspection,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSm,
                    ),
                    Text('₹${artisan.inspectionFee}',
                        style:
                            AppTypography.numericPrice.copyWith(fontSize: 18)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => context
                      .push('/customer/service/${artisan.primaryTradeId}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(strings.bookArtisan,
                      style:
                          AppTypography.labelMd.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(KarigaarRoleType roleType) {
    Color bg;
    Color fg;
    switch (roleType) {
      case KarigaarRoleType.headMistry:
        bg = AppColors.secondary.withValues(alpha: 0.15);
        fg = AppColors.secondary;
        break;
      case KarigaarRoleType.skilledKarigaar:
        bg = AppColors.primary.withValues(alpha: 0.12);
        fg = AppColors.primary;
        break;
      case KarigaarRoleType.helperAssistant:
        bg = AppColors.textMuted.withValues(alpha: 0.15);
        fg = AppColors.textMuted;
        break;
      case KarigaarRoleType.thekedar:
        bg = AppColors.tertiary.withValues(alpha: 0.15);
        fg = AppColors.tertiary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        roleType.badgeText,
        style: AppTypography.labelSm.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 10,
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
          _buildNavItem(
              icon: Icons.explore_rounded,
              label: localizedStrings(context).explore,
              isActive: true),
          _buildNavItem(
            icon: Icons.assignment_rounded,
            label: localizedStrings(context).bookings,
            isActive: false,
            onTap: () => context.go('/customer/bookings'),
          ),
          _buildNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: localizedStrings(context).messages,
            isActive: false,
            onTap: () => context.go('/customer/messages'),
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            label: localizedStrings(context).profile,
            isActive: false,
            onTap: () => context.go('/customer/profile'),
          ),
        ],
      ),
    );
  }

  void _showQuickTradeSearchSheet(
      BuildContext context, List<TradeModel> trades) {
    var query = '';
    final strings = localizedStrings(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final results = ServiceDiscoveryCatalog.search(trades, query);
          return Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 20 + MediaQuery.viewInsetsOf(ctx).bottom),
            child: SizedBox(
              height: MediaQuery.sizeOf(ctx).height * 0.72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.quickServiceSearch,
                      style: AppTypography.headlineSm),
                  const SizedBox(height: 6),
                  Text(strings.selectServicePrompt,
                      style: AppTypography.bodySm),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    onChanged: (value) => setModalState(() => query = value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      hintText: strings.searchServices,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: results.isEmpty
                        ? Center(child: Text(strings.noServicesFound))
                        : ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (_, idx) {
                              final trade = results[idx];
                              final languageCode =
                                  Localizations.localeOf(ctx).languageCode;
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: trade.surfaceTint,
                                  child: Icon(_getIconData(trade.iconName),
                                      color: trade.accentColor, size: 20),
                                ),
                                title: Text(
                                    ServiceDiscoveryCatalog.serviceLabel(
                                        trade, query, languageCode),
                                    style: AppTypography.labelLg),
                                subtitle: Text(
                                  '${ServiceDiscoveryCatalog.localizedTradeName(trade, languageCode)} • ${strings.inspectionWarranty(trade.baseInspectionFee, trade.guaranteeDays)}',
                                  style: AppTypography.bodySm,
                                ),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  context.push(
                                      '/customer/service/${trade.tradeId}');
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
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
