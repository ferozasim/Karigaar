import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_data_service.dart';
import '../../../core/models/artisan_profile_model.dart';
import '../../../core/models/city_model.dart';
import '../../../core/models/user_role.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../widgets/artisan_bottom_nav.dart';

class _PartnerCopy {
  final String portalTitle;
  final String professionalRateCard;
  final String editRateCard;
  final String scorecardTitle;
  final String toolkitTitle;
  final String portfolioTitle;
  final String addWorkPhoto;
  final String payoutSecurityTitle;
  final String openWalletBtn;
  final String signOutBtn;

  const _PartnerCopy({
    required this.portalTitle,
    required this.professionalRateCard,
    required this.editRateCard,
    required this.scorecardTitle,
    required this.toolkitTitle,
    required this.portfolioTitle,
    required this.addWorkPhoto,
    required this.payoutSecurityTitle,
    required this.openWalletBtn,
    required this.signOutBtn,
  });

  factory _PartnerCopy.of(String lang) {
    switch (lang) {
      case 'hi':
        return const _PartnerCopy(
          portalTitle: 'कारीगर गिल्ड पोर्टल',
          professionalRateCard: 'पेशेवर प्रोफ़ाइल और रेट कार्ड',
          editRateCard: 'प्रोफ़ाइल और रेट कार्ड बदलें',
          scorecardTitle: 'कारीगरी और स्वच्छता स्कोरकार्ड',
          toolkitTitle: 'सत्यापित टूल किट',
          portfolioTitle: 'काम का पोर्टफोलियो गैलरी',
          addWorkPhoto: 'नया काम फोटो जोड़ें',
          payoutSecurityTitle: 'बैंक भुगतान और सुरक्षा रिजर्व',
          openWalletBtn: 'वॉलेट और कमाई देखें',
          signOutBtn: 'गिल्ड पोर्टल से साइन आउट करें',
        );
      case 'mr':
        return const _PartnerCopy(
          portalTitle: 'कारागीर गिल्ड पोर्टल',
          professionalRateCard: 'व्यावसायिक प्रोफाइल आणि दरपत्रक',
          editRateCard: 'प्रोफाइल आणि दर बदला',
          scorecardTitle: 'कौशल्य आणि स्वच्छता स्कोअरकार्ड',
          toolkitTitle: 'पडताळलेले टूल्स किट',
          portfolioTitle: 'कामाचा पोर्टफोलिओ गॅलरी',
          addWorkPhoto: 'नवीन कामाचा फोटो जोडा',
          payoutSecurityTitle: 'बँक पेआउट आणि सुरक्षा राखीव',
          openWalletBtn: 'वॉलेट आणि कमाई पहा',
          signOutBtn: 'गिल्ड पोर्टलमधून साइन आउट करा',
        );
      case 'en':
      default:
        return const _PartnerCopy(
          portalTitle: 'Karigaar Guild Portal',
          professionalRateCard: 'Professional & Rate Card',
          editRateCard: 'Edit Profile & Rate Card',
          scorecardTitle: 'Craftsmanship & Cleanliness Scorecard',
          toolkitTitle: 'Verified Tool Kit',
          portfolioTitle: 'Work Portfolio Gallery',
          addWorkPhoto: 'Add New Work Photo',
          payoutSecurityTitle: 'Payout Bank & Security Reserve',
          openWalletBtn: 'Open Guild Wallet & Ledger',
          signOutBtn: 'Sign Out of Guild Portal',
        );
    }
  }
}

class ArtisanPartnerProfileScreen extends ConsumerWidget {
  const ArtisanPartnerProfileScreen({super.key});

  static const List<Map<String, String>> _tradeCatalog = [
    {'id': 'trade_electrician', 'title': 'Master Electrician'},
    {'id': 'trade_plumber', 'title': 'Certified Plumber'},
    {'id': 'trade_carpenter', 'title': 'Guild Carpenter'},
    {'id': 'trade_mason', 'title': 'Mason / Gawandi'},
    {'id': 'trade_painter', 'title': 'Painter & Polish'},
    {'id': 'trade_ac_refrig', 'title': 'AC & Refrigeration'},
    {'id': 'trade_appliance', 'title': 'Appliance Technician'},
    {'id': 'trade_welder', 'title': 'Welder & Fabricator'},
    {'id': 'trade_pest_control', 'title': 'Pest Control Tech'},
    {'id': 'trade_deep_cleaning', 'title': 'Deep Cleaning Pro'},
  ];

  static const List<String> _experienceTiers = [
    '1 - 3 Years',
    '3 - 5 Years',
    '5 - 10 Years',
    '10+ Master',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentArtisanProfileProvider);
    final lang = ref.watch(partnerLanguageProvider);
    final selectedDistrict = ref.watch(selectedDistrictProvider);
    final isOnline = ref.watch(artisanDutyOnlineProvider);
    final isEliteActive =
        profile.isGuildElite || ref.watch(guildEliteSubscriptionProvider);
    final copy = _PartnerCopy.of(lang);

    final activeDistrict = AppDataService.getDistrictById(profile.cityId);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuildIdentityHeader(
              context,
              ref,
              profile: profile,
              lang: lang,
              isOnline: isOnline,
              isEliteActive: isEliteActive,
              copy: copy,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRateCardSection(
                    context,
                    ref,
                    profile: profile,
                    activeDistrict: activeDistrict.cityId == profile.cityId
                        ? activeDistrict
                        : selectedDistrict,
                    copy: copy,
                  ),
                  const SizedBox(height: 16),
                  _buildScorecardSection(profile, copy),
                  const SizedBox(height: 16),
                  _buildToolKitAndPortfolioSection(context, ref, profile, copy),
                  const SizedBox(height: 16),
                  _buildPayoutAndSignOutCard(context, ref, profile, copy),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ArtisanBottomNav(currentTab: ArtisanNavTab.profile),
    );
  }

  Widget _buildGuildIdentityHeader(
    BuildContext context,
    WidgetRef ref, {
    required ArtisanProfileModel profile,
    required String lang,
    required bool isOnline,
    required bool isEliteActive,
    required _PartnerCopy copy,
  }) {
    final initials = _getInitials(profile.name);
    final tierProgress =
        (profile.totalJobsCompleted / 150).clamp(0.15, 1.0).toDouble();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: Portal Title + Language Toggle
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: isOnline
                                ? AppColors.tertiaryLight
                                : AppColors.secondaryLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            copy.portalTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelLg.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildLanguagePill(ref, lang),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar + Legal Name + Guild ID + KYC & Role Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.secondary, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          initials,
                          style: AppTypography.headlineMd.copyWith(
                            color: AppColors.secondaryLight,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineMd.copyWith(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _headerBadge(
                              label: 'ID: ${profile.guildId}',
                              bg: AppColors.primaryLight,
                              fg: AppColors.secondaryLight,
                              borderColor: AppColors.secondary.withValues(alpha: 0.5),
                            ),
                            _headerBadge(
                              label: profile.kycBadgeLabel,
                              bg: AppColors.tertiary.withValues(alpha: 0.2),
                              fg: AppColors.tertiaryLight,
                              icon: Icons.verified_user_rounded,
                            ),
                            _headerBadge(
                              label: profile.roleType.badgeText,
                              bg: AppColors.secondary.withValues(alpha: 0.22),
                              fg: AppColors.secondaryLight,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Guild Tier Gauge Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.45),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: AppColors.secondaryLight,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            profile.guildTierDisplayLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelMd.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: LinearProgressIndicator(
                        value: tierProgress,
                        minHeight: 7,
                        backgroundColor: AppColors.primaryLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.secondaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEliteActive
                                ? '₹999/mo Guild Elite Pass • Active'
                                : '₹999/mo Guild Elite Pass • Eligible',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          key: const Key('toggle_guild_elite_pass_chip'),
                          borderRadius: BorderRadius.circular(9999),
                          onTap: () {
                            ref
                                .read(currentArtisanProfileProvider.notifier)
                                .toggleGuildElite(!isEliteActive);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isEliteActive
                                  ? AppColors.secondary
                                  : AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(color: AppColors.secondary),
                            ),
                            child: Text(
                              isEliteActive ? '5% Floor Active' : 'Activate Pass',
                              style: AppTypography.labelSm.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildLanguagePill(WidgetRef ref, String currentLang) {
    Widget chip(String code, String label) {
      final selected = currentLang == code;
      return GestureDetector(
        key: Key('partner_lang_$code'),
        onTap: () => ref.read(partnerLanguageProvider.notifier).state = code,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: selected ? Colors.white : Colors.white70,
              fontSize: 11,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          chip('en', 'EN'),
          chip('hi', 'हिं'),
          chip('mr', 'मरा'),
        ],
      ),
    );
  }

  Widget _headerBadge({
    required String label,
    required Color bg,
    required Color fg,
    Color? borderColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSm.copyWith(
                color: fg,
                fontSize: 10.5,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCardSection(
    BuildContext context,
    WidgetRef ref, {
    required ArtisanProfileModel profile,
    required CityConfigModel activeDistrict,
    required _PartnerCopy copy,
  }) {
    final localityNames = profile.serviceLocalityIds.map((id) {
      final match = activeDistrict.localities.where((l) => l.localityId == id);
      if (match.isNotEmpty) return match.first.name;
      return id.replaceAll('loc_', '').replaceAll('_', ' ');
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  copy.professionalRateCard,
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
                OutlinedButton.icon(
                  key: const Key('edit_profile_rate_card_btn'),
                  onPressed: () => _showEditRateCardSheet(
                    context,
                    ref,
                    profile,
                    activeDistrict,
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: Text(
                    copy.editRateCard,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    minimumSize: const Size(64, 38),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Visit Fee & Daily Dihadi Price Bento
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurfaceTint.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VISIT / INSPECTION FEE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onSecondaryContainer,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '₹${profile.inspectionFee}',
                          style: AppTypography.numericPrice.copyWith(
                            color: AppColors.primary,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAILY DIHADI RATE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm.copyWith(fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '₹${profile.dailyDihadiRate}/day',
                          style: AppTypography.numericPrice.copyWith(
                            color: AppColors.primary,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _infoRow(
            Icons.handyman_rounded,
            'Primary Trade',
            '${profile.tradeTitle} • ${profile.localizedRoleTitle}',
          ),
          const SizedBox(height: 8),
          _infoRow(
            Icons.timeline_rounded,
            'Experience Tier',
            '${profile.experienceTierLabel} (${profile.roleType.standardLabel})',
          ),
          const SizedBox(height: 8),
          _infoRow(
            Icons.work_outline_rounded,
            'Work Mode',
            profile.workMode,
          ),
          const SizedBox(height: 8),
          _infoRow(
            Icons.location_on_rounded,
            'Active District',
            activeDistrict.name,
          ),
          const SizedBox(height: 10),

          Text('Service Localities', style: AppTypography.labelMd),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: localityNames
                .map(
                  (loc) => Chip(
                    label: Text(
                      loc,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    backgroundColor: AppColors.surfaceSubtle,
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: AppColors.borderSubtle),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),

          Text('Work Bio', style: AppTypography.labelMd),
          const SizedBox(height: 4),
          Text(
            profile.bio,
            style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
          ),
          if (profile.specialties.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Certified Specialties', style: AppTypography.labelMd),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.specialties
                  .map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tertiarySurfaceTint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        s,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.tertiary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12.5,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScorecardSection(ArtisanProfileModel profile, _PartnerCopy copy) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            copy.scorecardTitle,
            style: AppTypography.headlineSm.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _scoreTile(
                  label: 'Overall Rating',
                  value: '${profile.rating.toStringAsFixed(1)} ★',
                  accent: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _scoreTile(
                  label: 'Cleanliness & Sawdust',
                  value: '${profile.cleanlinessScore.toStringAsFixed(1)} / 5.0',
                  accent: AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _scoreTile(
                  label: 'On-Time Arrival',
                  value: '${profile.onTimeArrivalPercent}%',
                  accent: AppColors.info,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _scoreTile(
                  label: 'Completed Jobs',
                  value: '${profile.totalJobsCompleted}',
                  accent: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreTile({
    required String label,
    required String value,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.numericPrice.copyWith(
                fontSize: 19,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolKitAndPortfolioSection(
    BuildContext context,
    WidgetRef ref,
    ArtisanProfileModel profile,
    _PartnerCopy copy,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build_circle_rounded,
                  color: AppColors.tertiary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  copy.toolkitTitle,
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'Audited',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.tertiary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.verifiedTools
                .map(
                  (tool) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppColors.tertiary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            tool,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.textPrimary,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  copy.portfolioTitle,
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
                OutlinedButton.icon(
                  key: const Key('add_work_photo_btn'),
                  onPressed: () =>
                      _showAddWorkPhotoDialog(context, ref, profile),
                  icon: const Icon(Icons.add_a_photo_rounded, size: 15),
                  label: Text(
                    copy.addWorkPhoto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: const Size(64, 36),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 164,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profile.portfolioItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = profile.portfolioItems[index];
                return Container(
                  width: 226,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBase,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 86,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(13)),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.photo_library_rounded,
                                color: AppColors.secondaryLight,
                                size: 32,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.badge,
                                  style: AppTypography.labelSm.copyWith(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.duration,
                                  style: AppTypography.labelSm.copyWith(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelMd.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm.copyWith(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutAndSignOutCard(
    BuildContext context,
    WidgetRef ref,
    ArtisanProfileModel profile,
    _PartnerCopy copy,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            copy.payoutSecurityTitle,
            style: AppTypography.headlineSm.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          _infoRow(
            Icons.account_balance_rounded,
            'Linked Bank',
            '${profile.bankName} ${profile.maskedAccountNumber} (IFSC: ${profile.ifscCode})',
          ),
          const SizedBox(height: 8),
          _infoRow(
            Icons.qr_code_rounded,
            'UPI ID',
            profile.upiId,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondarySurfaceTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_rounded,
                  size: 18,
                  color: AppColors.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '₹${profile.securityReserveAmount.toStringAsFixed(0)} Rolling Security Reserve Active (IMPS Protected)',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSecondaryContainer,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('open_standalone_wallet_btn'),
              onPressed: () {
                GoRouter.maybeOf(context)?.go('/artisan/wallet');
              },
              icon: const Icon(Icons.account_balance_wallet_rounded, size: 18),
              label: Text(
                copy.openWalletBtn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const Key('sign_out_guild_portal_btn'),
              onPressed: () {
                ref.read(userRoleProvider.notifier).state = UserRole.customer;
                GoRouter.maybeOf(context)?.go('/login');
              },
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(
                copy.signOutBtn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditRateCardSheet(
    BuildContext context,
    WidgetRef ref,
    ArtisanProfileModel profile,
    CityConfigModel initialDistrict,
  ) {
    final feeCtrl = TextEditingController(text: profile.inspectionFee.toString());
    final dihadiCtrl =
        TextEditingController(text: profile.dailyDihadiRate.toString());
    final bioCtrl = TextEditingController(text: profile.bio);

    String selectedTradeId = profile.primaryTradeId;
    String selectedTradeTitle = profile.tradeTitle;
    KarigaarRoleType selectedRole = profile.roleType;
    String selectedExp = profile.experienceTierLabel;
    String selectedCityId = initialDistrict.cityId;
    final selectedLocalities = Set<String>.from(profile.serviceLocalityIds);

    final allDistricts = AppDataService.getAllRegionalDistricts();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final districtObj = allDistricts.firstWhere(
              (d) => d.cityId == selectedCityId,
              orElse: () => initialDistrict,
            );

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Edit Profile & Rate Card',
                              style: AppTypography.headlineSm,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Text('Primary Trade', style: AppTypography.labelMd),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _tradeCatalog.map((t) {
                          final isSelected = selectedTradeId == t['id'];
                          return ChoiceChip(
                            label: Text(t['title']!),
                            selected: isSelected,
                            onSelected: (_) {
                              setModalState(() {
                                selectedTradeId = t['id']!;
                                selectedTradeTitle = t['title']!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      Text('Guild Role Type', style: AppTypography.labelMd),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: KarigaarRoleType.values.map((role) {
                          return ChoiceChip(
                            label: Text(role.shortLabel),
                            selected: selectedRole == role,
                            onSelected: (_) {
                              setModalState(() => selectedRole = role);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      Text('Experience Tier', style: AppTypography.labelMd),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _experienceTiers.map((exp) {
                          return ChoiceChip(
                            label: Text(exp),
                            selected: selectedExp == exp,
                            onSelected: (_) {
                              setModalState(() => selectedExp = exp);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      Text('Visit Fee (₹)', style: AppTypography.labelMd),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: [150, 200, 249, 300, 399].map((fee) {
                          return ActionChip(
                            label: Text('₹$fee'),
                            onPressed: () {
                              setModalState(() => feeCtrl.text = '$fee');
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        key: const Key('edit_visit_fee_field'),
                        controller: feeCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '₹ ',
                          labelText: 'Visit Inspection Fee',
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text('Daily Dihadi Rate (₹/day)',
                          style: AppTypography.labelMd),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: [500, 700, 900, 1200].map((rate) {
                          return ActionChip(
                            label: Text('₹$rate'),
                            onPressed: () {
                              setModalState(() => dihadiCtrl.text = '$rate');
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        key: const Key('edit_dihadi_rate_field'),
                        controller: dihadiCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '₹ ',
                          labelText: 'Daily Dihadi Rate',
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text('Active District & Service Localities',
                          style: AppTypography.labelMd),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: allDistricts.map((d) {
                          return ChoiceChip(
                            label: Text(d.name),
                            selected: selectedCityId == d.cityId,
                            onSelected: (_) {
                              setModalState(() {
                                selectedCityId = d.cityId;
                                selectedLocalities
                                  ..clear()
                                  ..add(d.localities.first.localityId);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: districtObj.localities.map((loc) {
                          final isSelected =
                              selectedLocalities.contains(loc.localityId);
                          return FilterChip(
                            label: Text(loc.name),
                            selected: isSelected,
                            onSelected: (val) {
                              setModalState(() {
                                if (val) {
                                  selectedLocalities.add(loc.localityId);
                                } else if (selectedLocalities.length > 1) {
                                  selectedLocalities.remove(loc.localityId);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        key: const Key('edit_bio_field'),
                        controller: bioCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Work Bio',
                          hintText:
                              'Describe your craft expertise & safety gear...',
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          key: const Key('save_profile_rate_card_btn'),
                          onPressed: () {
                            final parsedFee =
                                int.tryParse(feeCtrl.text.trim()) ??
                                    profile.inspectionFee;
                            final parsedDihadi =
                                int.tryParse(dihadiCtrl.text.trim()) ??
                                    profile.dailyDihadiRate;
                            final years = switch (selectedExp) {
                              '1 - 3 Years' => 2,
                              '3 - 5 Years' => 4,
                              '5 - 10 Years' => 8,
                              '10+ Master' => 12,
                              _ => profile.yearsExperience,
                            };

                            ref
                                .read(currentArtisanProfileProvider.notifier)
                                .updateProfileAndRateCard(
                                  primaryTradeId: selectedTradeId,
                                  tradeTitle: selectedTradeTitle,
                                  roleType: selectedRole,
                                  experienceTierLabel: selectedExp,
                                  yearsExperience: years,
                                  inspectionFee: parsedFee,
                                  dailyDihadiRate: parsedDihadi,
                                  cityId: selectedCityId,
                                  localityId: selectedLocalities.isNotEmpty
                                      ? selectedLocalities.first
                                      : districtObj.localities.first.localityId,
                                  serviceLocalityIds:
                                      selectedLocalities.toList(),
                                  bio: bioCtrl.text.trim().isNotEmpty
                                      ? bioCtrl.text.trim()
                                      : profile.bio,
                                );

                            if (selectedCityId !=
                                ref.read(selectedDistrictProvider).cityId) {
                              ref.read(selectedDistrictProvider.notifier).state =
                                  districtObj;
                            }

                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Profile & rate card updated and synced to district directory!',
                                ),
                                backgroundColor: AppColors.tertiary,
                              ),
                            );
                          },
                          icon: const Icon(Icons.sync_rounded, size: 18),
                          label: const Text(
                            'Save & Sync to Directory',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddWorkPhotoDialog(
    BuildContext context,
    WidgetRef ref,
    ArtisanProfileModel profile,
  ) {
    final titleCtrl = TextEditingController();
    final locationCtrl = TextEditingController(text: 'Anand Nagar, Nanded');
    final badgeCtrl = TextEditingController(text: 'Verified Work');
    final durationCtrl = TextEditingController(text: 'Completed in 2 hrs');

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Add New Work Photo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('portfolio_title_field'),
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Work Title',
                  hintText: 'e.g. 6-Way Distribution Box Setup',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                key: const Key('portfolio_location_field'),
                controller: locationCtrl,
                decoration: const InputDecoration(labelText: 'Locality'),
              ),
              const SizedBox(height: 10),
              TextField(
                key: const Key('portfolio_badge_field'),
                controller: badgeCtrl,
                decoration: const InputDecoration(labelText: 'Quality Badge'),
              ),
              const SizedBox(height: 10),
              TextField(
                key: const Key('portfolio_duration_field'),
                controller: durationCtrl,
                decoration: const InputDecoration(labelText: 'Duration'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: const Key('confirm_add_work_photo_btn'),
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              ref.read(currentArtisanProfileProvider.notifier).addPortfolioPhoto(
                    PortfolioWorkItem(
                      id: 'pf_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      location: locationCtrl.text.trim().isNotEmpty
                          ? locationCtrl.text.trim()
                          : 'Nanded',
                      badge: badgeCtrl.text.trim().isNotEmpty
                          ? badgeCtrl.text.trim()
                          : 'Verified Work',
                      duration: durationCtrl.text.trim().isNotEmpty
                          ? durationCtrl.text.trim()
                          : 'Same Day',
                    ),
                  );
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added "$title" to portfolio & synced live!'),
                  backgroundColor: AppColors.tertiary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Photo'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final list = parts.toList();
    if (list.isEmpty) return 'KG';
    if (list.length == 1) return list.first[0].toUpperCase();
    return '${list.first[0]}${list.last[0]}'.toUpperCase();
  }
}
