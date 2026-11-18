import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_data_service.dart';
import '../../../core/config/partner_copy.dart';
import '../../../core/models/artisan_profile_model.dart';
import '../../../core/models/city_model.dart';
import '../../../core/models/user_role.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../widgets/artisan_bottom_nav.dart';

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
    final copy = PartnerCopy.of(lang);

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
      bottomNavigationBar:
          const ArtisanBottomNav(currentTab: ArtisanNavTab.profile),
    );
  }

  Widget _buildGuildIdentityHeader(
    BuildContext context,
    WidgetRef ref, {
    required ArtisanProfileModel profile,
    required String lang,
    required bool isOnline,
    required bool isEliteActive,
    required PartnerCopy copy,
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
              // Top bar: Portal Title + Language Toggle (Wrap prevents 2.0x overflow)
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                        Flexible(
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
                    _buildLanguagePill(ref, lang),
                  ],
                ),
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
                              label:
                                  '${copy.guildIdPrefix}: ${profile.guildId}',
                              bg: AppColors.primaryLight,
                              fg: AppColors.secondaryLight,
                              borderColor:
                                  AppColors.secondary.withValues(alpha: 0.5),
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
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Text(
                            isEliteActive
                                ? copy.elitePassActive
                                : copy.elitePassEligible,
                            style: AppTypography.bodySm.copyWith(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
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
                                isEliteActive
                                    ? copy.floorActiveChip
                                    : copy.activatePassChip,
                                style: AppTypography.labelSm.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
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
    required PartnerCopy copy,
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
                    copy,
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
                    color:
                        AppColors.secondarySurfaceTint.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        copy.visitFeeHeader,
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
                        copy.dailyDihadiHeader,
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
            context,
            Icons.handyman_rounded,
            copy.primaryTradeLabel,
            '${profile.tradeTitle} • ${profile.localizedRoleTitle}',
          ),
          const SizedBox(height: 8),
          _infoRow(
            context,
            Icons.timeline_rounded,
            copy.experienceTierLabel,
            '${profile.experienceTierLabel} (${profile.roleType.standardLabel})',
          ),
          const SizedBox(height: 8),
          _infoRow(
            context,
            Icons.work_outline_rounded,
            copy.workModeLabel,
            profile.workMode,
          ),
          const SizedBox(height: 8),
          _infoRow(
            context,
            Icons.location_on_rounded,
            copy.activeDistrictLabel,
            activeDistrict.name,
          ),
          const SizedBox(height: 10),

          Text(copy.serviceLocalitiesLabel, style: AppTypography.labelMd),
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

          Text(copy.workBioLabel, style: AppTypography.labelMd),
          const SizedBox(height: 4),
          Text(
            profile.bio,
            style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
          ),
          if (profile.specialties.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(copy.certifiedSpecialtiesLabel, style: AppTypography.labelMd),
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

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            textScaler: MediaQuery.textScalerOf(context),
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

  Widget _buildScorecardSection(ArtisanProfileModel profile, PartnerCopy copy) {
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
                  label: copy.overallRatingLabel,
                  value: '${profile.rating.toStringAsFixed(1)} ★',
                  accent: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _scoreTile(
                  label: copy.cleanlinessLabel,
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
                  label: copy.onTimeArrivalLabel,
                  value: '${profile.onTimeArrivalPercent}%',
                  accent: AppColors.info,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _scoreTile(
                  label: copy.completedJobsLabel,
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
    PartnerCopy copy,
  ) {
    final double textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 2.5);
    final double portfolioHeight = 164 + (textScale - 1.0) * 64;

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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  copy.auditedBadge,
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
                      _showAddWorkPhotoDialog(context, ref, profile, copy),
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
          if (profile.portfolioItems.isEmpty)
            Container(
              key: const Key('empty_portfolio_prompt'),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      copy.emptyPortfolioText,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: portfolioHeight,
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
    PartnerCopy copy,
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
            context,
            Icons.account_balance_rounded,
            copy.linkedBankLabel,
            '${profile.bankName} ${profile.maskedAccountNumber} (IFSC: ${profile.ifscCode})',
          ),
          const SizedBox(height: 8),
          _infoRow(
            context,
            Icons.qr_code_rounded,
            copy.upiIdLabel,
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
    PartnerCopy copy,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return _EditRateCardSheet(
          profile: profile,
          initialDistrict: initialDistrict,
          copy: copy,
          tradeCatalog: _tradeCatalog,
          experienceTiers: _experienceTiers,
          onSaved: ({
            required String primaryTradeId,
            required String tradeTitle,
            required KarigaarRoleType roleType,
            required String experienceTierLabel,
            required int yearsExperience,
            required int inspectionFee,
            required int dailyDihadiRate,
            required CityConfigModel districtObj,
            required List<String> serviceLocalityIds,
            required String bio,
          }) {
            ref
                .read(currentArtisanProfileProvider.notifier)
                .updateProfileAndRateCard(
                  primaryTradeId: primaryTradeId,
                  tradeTitle: tradeTitle,
                  roleType: roleType,
                  experienceTierLabel: experienceTierLabel,
                  yearsExperience: yearsExperience,
                  inspectionFee: inspectionFee,
                  dailyDihadiRate: dailyDihadiRate,
                  cityId: districtObj.cityId,
                  localityId: serviceLocalityIds.isNotEmpty
                      ? serviceLocalityIds.first
                      : districtObj.localities.first.localityId,
                  serviceLocalityIds: serviceLocalityIds,
                  bio: bio,
                );

            if (districtObj.cityId !=
                ref.read(selectedDistrictProvider).cityId) {
              ref.read(selectedDistrictProvider.notifier).state = districtObj;
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Profile & rate card updated and synced to district directory!',
                    ),
                    backgroundColor: AppColors.tertiary,
                  ),
                );
            }
          },
        );
      },
    );
  }

  void _showAddWorkPhotoDialog(
    BuildContext context,
    WidgetRef ref,
    ArtisanProfileModel profile,
    PartnerCopy copy,
  ) {
    final activeDistrict = AppDataService.getDistrictById(profile.cityId);
    final locMatch = activeDistrict.localities
        .where((l) => l.localityId == profile.localityId);
    final defaultLocation = locMatch.isNotEmpty
        ? '${locMatch.first.name}, ${activeDistrict.name}'
        : 'Anand Nagar, Nanded';

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => _AddWorkPhotoDialog(
        defaultLocation: defaultLocation,
        copy: copy,
        onAddPhoto: (item) {
          ref
              .read(currentArtisanProfileProvider.notifier)
              .addPortfolioPhoto(item);
          if (context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content:
                      Text('Added "${item.title}" to portfolio & synced live!'),
                  backgroundColor: AppColors.tertiary,
                ),
              );
          }
        },
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

class _EditRateCardSheet extends StatefulWidget {
  final ArtisanProfileModel profile;
  final CityConfigModel initialDistrict;
  final PartnerCopy copy;
  final List<Map<String, String>> tradeCatalog;
  final List<String> experienceTiers;
  final void Function({
    required String primaryTradeId,
    required String tradeTitle,
    required KarigaarRoleType roleType,
    required String experienceTierLabel,
    required int yearsExperience,
    required int inspectionFee,
    required int dailyDihadiRate,
    required CityConfigModel districtObj,
    required List<String> serviceLocalityIds,
    required String bio,
  }) onSaved;

  const _EditRateCardSheet({
    required this.profile,
    required this.initialDistrict,
    required this.copy,
    required this.tradeCatalog,
    required this.experienceTiers,
    required this.onSaved,
  });

  @override
  State<_EditRateCardSheet> createState() => _EditRateCardSheetState();
}

class _EditRateCardSheetState extends State<_EditRateCardSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _feeCtrl;
  late final TextEditingController _dihadiCtrl;
  late final TextEditingController _bioCtrl;

  late String _selectedTradeId;
  late String _selectedTradeTitle;
  late KarigaarRoleType _selectedRole;
  late String _selectedExp;
  late String _selectedCityId;
  late final Set<String> _selectedLocalities;
  late final List<CityConfigModel> _allDistricts;

  @override
  void initState() {
    super.initState();
    _feeCtrl =
        TextEditingController(text: widget.profile.inspectionFee.toString());
    _dihadiCtrl =
        TextEditingController(text: widget.profile.dailyDihadiRate.toString());
    _bioCtrl = TextEditingController(text: widget.profile.bio);
    _selectedTradeId = widget.profile.primaryTradeId;
    _selectedTradeTitle = widget.profile.tradeTitle;
    _selectedRole = widget.profile.roleType;
    _selectedExp = widget.profile.experienceTierLabel;
    _selectedCityId = widget.initialDistrict.cityId;
    _selectedLocalities = Set<String>.from(widget.profile.serviceLocalityIds);
    _allDistricts = AppDataService.getAllRegionalDistricts();
  }

  @override
  void dispose() {
    _feeCtrl.dispose();
    _dihadiCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copy = widget.copy;
    final districtObj = _allDistricts.firstWhere(
      (d) => d.cityId == _selectedCityId,
      orElse: () => widget.initialDistrict,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        copy.editRateCard,
                        style: AppTypography.headlineSm,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(copy.primaryTradeLabel, style: AppTypography.labelMd),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.tradeCatalog.map((t) {
                    final isSelected = _selectedTradeId == t['id'];
                    return ChoiceChip(
                      label: Text(t['title']!),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedTradeId = t['id']!;
                          _selectedTradeTitle = t['title']!;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(copy.guildRoleTypeLabel, style: AppTypography.labelMd),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: KarigaarRoleType.values.map((role) {
                    return ChoiceChip(
                      label: Text(role.shortLabel),
                      selected: _selectedRole == role,
                      onSelected: (_) {
                        setState(() => _selectedRole = role);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(copy.experienceTierLabel, style: AppTypography.labelMd),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.experienceTiers.map((exp) {
                    return ChoiceChip(
                      label: Text(exp),
                      selected: _selectedExp == exp,
                      onSelected: (_) {
                        setState(() => _selectedExp = exp);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text('${copy.visitFeeFieldLabel} (₹)',
                    style: AppTypography.labelMd),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [150, 200, 249, 300, 399].map((fee) {
                    return ActionChip(
                      label: Text('₹$fee'),
                      onPressed: () {
                        setState(() => _feeCtrl.text = '$fee');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('edit_visit_fee_field'),
                  controller: _feeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    labelText: copy.visitFeeFieldLabel,
                  ),
                  validator: (value) {
                    final parsed = int.tryParse((value ?? '').trim());
                    if (parsed == null || parsed < 50) {
                      return copy.visitFeeError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text('${copy.dihadiFieldLabel} (₹/day)',
                    style: AppTypography.labelMd),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [500, 700, 900, 1200].map((rate) {
                    return ActionChip(
                      label: Text('₹$rate'),
                      onPressed: () {
                        setState(() => _dihadiCtrl.text = '$rate');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('edit_dihadi_rate_field'),
                  controller: _dihadiCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    labelText: copy.dihadiFieldLabel,
                  ),
                  validator: (value) {
                    final parsed = int.tryParse((value ?? '').trim());
                    if (parsed == null || parsed < 100) {
                      return copy.dihadiRateError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text(copy.activeDistrictLocalitiesLabel,
                    style: AppTypography.labelMd),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _allDistricts.map((d) {
                    return ChoiceChip(
                      label: Text(d.name),
                      selected: _selectedCityId == d.cityId,
                      onSelected: (_) {
                        setState(() {
                          _selectedCityId = d.cityId;
                          _selectedLocalities
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
                        _selectedLocalities.contains(loc.localityId);
                    return FilterChip(
                      label: Text(loc.name),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedLocalities.add(loc.localityId);
                          } else if (_selectedLocalities.length > 1) {
                            _selectedLocalities.remove(loc.localityId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('edit_bio_field'),
                  controller: _bioCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: copy.workBioLabel,
                    hintText: 'Describe your craft expertise & safety gear...',
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return copy.bioError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: const Key('save_profile_rate_card_btn'),
                    onPressed: () {
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      final parsedFee = int.parse(_feeCtrl.text.trim());
                      final parsedDihadi = int.parse(_dihadiCtrl.text.trim());
                      final trimmedBio = _bioCtrl.text.trim();
                      final years = switch (_selectedExp) {
                        '1 - 3 Years' => 2,
                        '3 - 5 Years' => 4,
                        '5 - 10 Years' => 8,
                        '10+ Master' => 12,
                        _ => widget.profile.yearsExperience,
                      };

                      Navigator.pop(context);
                      widget.onSaved(
                        primaryTradeId: _selectedTradeId,
                        tradeTitle: _selectedTradeTitle,
                        roleType: _selectedRole,
                        experienceTierLabel: _selectedExp,
                        yearsExperience: years,
                        inspectionFee: parsedFee,
                        dailyDihadiRate: parsedDihadi,
                        districtObj: districtObj,
                        serviceLocalityIds: _selectedLocalities.toList(),
                        bio: trimmedBio,
                      );
                    },
                    icon: const Icon(Icons.sync_rounded, size: 18),
                    label: Text(
                      copy.saveSyncBtn,
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
      ),
    );
  }
}

class _AddWorkPhotoDialog extends StatefulWidget {
  final String defaultLocation;
  final PartnerCopy copy;
  final void Function(PortfolioWorkItem item) onAddPhoto;

  const _AddWorkPhotoDialog({
    required this.defaultLocation,
    required this.copy,
    required this.onAddPhoto,
  });

  @override
  State<_AddWorkPhotoDialog> createState() => _AddWorkPhotoDialogState();
}

class _AddWorkPhotoDialogState extends State<_AddWorkPhotoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _badgeCtrl;
  late final TextEditingController _durationCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _locationCtrl = TextEditingController(text: widget.defaultLocation);
    _badgeCtrl = TextEditingController(text: 'Verified Work');
    _durationCtrl = TextEditingController(text: 'Completed in 2 hrs');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _badgeCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copy = widget.copy;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      title: Text(copy.addWorkPhoto),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('portfolio_title_field'),
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: copy.workTitleLabel,
                  hintText: 'e.g. 6-Way Distribution Box Setup',
                ),
                validator: (val) {
                  if ((val ?? '').trim().isEmpty) {
                    return copy.workTitleError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: const Key('portfolio_location_field'),
                controller: _locationCtrl,
                decoration: InputDecoration(labelText: copy.localityLabel),
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: const Key('portfolio_badge_field'),
                controller: _badgeCtrl,
                decoration: InputDecoration(labelText: copy.qualityBadgeLabel),
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: const Key('portfolio_duration_field'),
                controller: _durationCtrl,
                decoration: InputDecoration(labelText: copy.durationLabel),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(copy.cancelBtn),
        ),
        ElevatedButton(
          key: const Key('confirm_add_work_photo_btn'),
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) {
              return;
            }
            final title = _titleCtrl.text.trim();
            final item = PortfolioWorkItem(
              id: 'pf_${DateTime.now().millisecondsSinceEpoch}',
              title: title,
              location: _locationCtrl.text.trim().isNotEmpty
                  ? _locationCtrl.text.trim()
                  : widget.defaultLocation,
              badge: _badgeCtrl.text.trim().isNotEmpty
                  ? _badgeCtrl.text.trim()
                  : 'Verified Work',
              duration: _durationCtrl.text.trim().isNotEmpty
                  ? _durationCtrl.text.trim()
                  : 'Same Day',
            );
            Navigator.pop(context);
            widget.onAddPhoto(item);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(copy.addPhotoBtn),
        ),
      ],
    );
  }
}
