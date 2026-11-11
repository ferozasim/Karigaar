import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/artisan_profile_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/contact_intent_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ArtisanProfileScreen extends ConsumerStatefulWidget {
  final String artisanId;

  const ArtisanProfileScreen({super.key, required this.artisanId});

  @override
  ConsumerState<ArtisanProfileScreen> createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends ConsumerState<ArtisanProfileScreen> {
  bool _isFavorited = false;
  bool _isSecuringSlot = false;

  @override
  Widget build(BuildContext context) {
    final artisan = ref.watch(artisanByIdProvider(widget.artisanId));

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBase.withValues(alpha: 0.95),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/customer/home');
            }
          },
        ),
        title: Text(
          'Craftsman Profile',
          style: AppTypography.headlineSm.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorited ? AppColors.error : AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _isFavorited = !_isFavorited;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorited
                        ? 'Saved ${artisan.name} to favorites!'
                        : 'Removed from favorites.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing ${artisan.name}\'s profile link...'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Hero Card
                _buildHeroCard(artisan),

                const SizedBox(height: 16),

                // Path A Direct Contact Actions (Call & WhatsApp)
                _buildPathADirectContactButtons(artisan),

                const SizedBox(height: 20),

                // Trust & Verification Shield (4 Pillars)
                _buildVerificationShieldSection(),

                const SizedBox(height: 24),

                // Specializations & Certified Skills (6 Chips)
                _buildSpecializationsSection(artisan),

                const SizedBox(height: 24),

                // Craftsmanship Showcase (Portfolio Carousel)
                _buildCraftsmanshipShowcase(),

                const SizedBox(height: 24),

                // Performance Scorecard
                _buildPerformanceScorecard(),

                const SizedBox(height: 24),

                // Verified Client Reviews List
                _buildClientReviewsList(artisan),
              ],
            ),
          ),

          // Path B Sticky Bottom Concierge Action Dock
          _buildPathBStickyDock(artisan),
        ],
      ),
    );
  }

  Widget _buildHeroCard(ArtisanProfileModel artisan) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Squircle Avatar with Amber Gradient Frame & PRO Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.secondaryLight],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: AppColors.primaryContainer,
                    child: Center(
                      child: Text(
                        artisan.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                        style: AppTypography.displayLg.copyWith(
                          fontSize: 32,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -6,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, color: Colors.white, size: 13),
                      const SizedBox(width: 3),
                      Text(
                        'PRO',
                        style: AppTypography.labelSm.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Name & Title
          Text(
            artisan.name,
            style: AppTypography.headlineLg.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.handyman_rounded, color: AppColors.secondary, size: 16),
              const SizedBox(width: 6),
              Text(
                artisan.tradeTitle,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Locality & Live Availability Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.secondary, size: 15),
                  const SizedBox(width: 4),
                  Text(
                    'Anand Nagar • Within ${artisan.distanceKm} km',
                    style: AppTypography.labelMd.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Available Today',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Metric Trio
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.star_rounded,
                  iconColor: AppColors.secondary,
                  title: '${artisan.rating}★',
                  subtitle: '${artisan.reviewCount} Reviews',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  title: '${artisan.yearsExperience}+ Yrs',
                  subtitle: 'Experience',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  title: '${artisan.totalJobsCompleted}+',
                  subtitle: 'Completed Jobs',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    IconData? icon,
    Color? iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 3),
              ],
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPathADirectContactButtons(ArtisanProfileModel artisan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Path A: Call Artisan (tel:)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ContactIntentService.makePhoneCall(
                  context,
                  phoneNumber: artisan.phone,
                  contactName: artisan.name,
                );
              },
              icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
              label: const Text('Call Artisan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Path A: WhatsApp Artisan (wa.me:)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ContactIntentService.openWhatsAppChat(
                  context,
                  phoneNumber: artisan.phone,
                  prefilledMessage:
                      'Namaste ${artisan.name} Ji, I found your profile on Karigaar for ${artisan.tradeTitle}. Are you available for a visit in Nanded?',
                  contactName: artisan.name,
                );
              },
              icon: const Icon(Icons.chat_bubble_rounded, size: 18, color: Colors.white),
              label: const Text('WhatsApp Artisan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationShieldSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.tertiary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Karigaar Verified Guildsman', style: AppTypography.headlineSm.copyWith(fontSize: 16)),
                    Text(
                      'Triple-screened for home safety & master craftsmanship',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 4-Pillar Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: const [
              _VerificationPod(
                icon: Icons.badge_rounded,
                title: 'Govt. ID & Police',
                subtitle: 'Background Cleared',
              ),
              _VerificationPod(
                icon: Icons.workspace_premium_rounded,
                title: 'NSDC Certified',
                subtitle: 'Skill-Tested Grade A',
              ),
              _VerificationPod(
                icon: Icons.shield_rounded,
                title: '₹25k Master Cover',
                subtitle: 'Damage Protection',
              ),
              _VerificationPod(
                icon: Icons.build_circle_rounded,
                title: 'Calibrated Tools',
                subtitle: 'Tool Audit Passed',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationsSection(ArtisanProfileModel artisan) {
    final List<String> skills = [
      '3-Phase Wiring',
      'Inverter Setup',
      'MCB Spark Diagnosis',
      'Modular Switchboards',
      'Earthing Verification',
      'Appliance Load Audit',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Specializations & Skills',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(fontSize: 17),
                ),
              ),
              const SizedBox(width: 8),
              Text('6 Certified', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  skill,
                  style: AppTypography.labelMd.copyWith(color: AppColors.primary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCraftsmanshipShowcase() {
    final showcaseItems = [
      {
        'title': 'Custom 32A MCB Panel Wiring',
        'location': 'Anand Nagar, Nanded',
        'badge': 'Commercial Grade',
        'duration': 'Completed in 3 hrs',
        'icon': Icons.electrical_services_rounded,
      },
      {
        'title': 'Inverter & Battery Backup Hub',
        'location': 'Vazirabad, Nanded',
        'badge': 'Pure Sine Wave',
        'duration': 'Zero Downtime',
        'icon': Icons.battery_charging_full_rounded,
      },
      {
        'title': 'Concealed Copper Conduit Setup',
        'location': 'CIDCO New Nanded',
        'badge': 'Laser Aligned',
        'duration': 'Completed in 1 Day',
        'icon': Icons.home_repair_service_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Craftsmanship Showcase', style: AppTypography.headlineSm.copyWith(fontSize: 17)),
                    Text(
                      'Verified work photos from local homes',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('View All (38)', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: showcaseItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = showcaseItems[index];
              return Container(
                width: 250,
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              item['icon'] as IconData,
                              color: AppColors.secondary,
                              size: 40,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['badge'] as String,
                                style: AppTypography.labelSm.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['duration'] as String,
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
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: AppTypography.headlineSm.copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['location'] as String,
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceScorecard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Artisan Scorecard', style: AppTypography.headlineSm.copyWith(fontSize: 17)),
          const SizedBox(height: 14),
          _buildScoreBar('Punctuality & Timing', 5.0, 1.0),
          const SizedBox(height: 12),
          _buildScoreBar('Master Craftsmanship', 4.9, 0.98),
          const SizedBox(height: 12),
          _buildScoreBar('Sawdust & Cleanliness', 5.0, 1.0),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, double score, double factor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMd,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${score.toStringAsFixed(1)} / 5.0',
              style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: LinearProgressIndicator(
            value: factor,
            minHeight: 8,
            backgroundColor: AppColors.surfaceSubtle,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),
        ),
      ],
    );
  }

  Widget _buildClientReviewsList(ArtisanProfileModel artisan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Recent Client Feedback',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(fontSize: 17),
                ),
              ),
              const SizedBox(width: 8),
              Text('Verified Bookings', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            initials: 'P',
            name: 'Pooja M.',
            localityAndDate: 'Anand Nagar • 2 days ago',
            stars: 5,
            comment:
                '${artisan.name} arrived in 18 minutes with full laser & testing toolkit. Repaired our heavy main distribution board that was sparking constantly. Super polite, zero dust left behind!',
            verifiedBadgeText: 'Verified MCB Spark Repair Job',
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            initials: 'A',
            name: 'Amit V.',
            localityAndDate: 'Vazirabad • 1 week ago',
            stars: 5,
            comment:
                'Exceptional precision on our 3-phase inverter changeover switch. Transparent billing and genuine master artisan attitude. Highly recommended in Nanded!',
            verifiedBadgeText: 'Verified Inverter Setup Job',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String initials,
    required String name,
    required String localityAndDate,
    required int stars,
    required String comment,
    required String verifiedBadgeText,
  }) {
    return Container(
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.surfaceSubtle,
                      child: Text(
                        initials,
                        style: AppTypography.headlineSm.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w700)),
                          Text(
                            localityAndDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  stars,
                  (_) => const Icon(Icons.star_rounded, color: AppColors.secondary, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.tertiarySurfaceTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.tertiary, size: 14),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    verifiedBadgeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.tertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathBStickyDock(ArtisanProfileModel artisan) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
            // Left inspection price & warranty badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${artisan.inspectionFee}',
                          style: AppTypography.numericPrice.copyWith(fontSize: 22),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/ visit',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSm.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: AppColors.tertiary, size: 13),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          'Includes ₹25k Guild Warranty',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.tertiary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Path B: Book Artisan Now Button
            ElevatedButton(
              onPressed: _isSecuringSlot
                  ? null
                  : () {
                      setState(() {
                        _isSecuringSlot = true;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) {
                          setState(() {
                            _isSecuringSlot = false;
                          });
                          context.push('/customer/service/${artisan.primaryTradeId}');
                        }
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
              ),
              child: _isSecuringSlot
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Book ${artisan.name.split(' ').first} Now',
                          style: AppTypography.labelLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationPod extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _VerificationPod({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.tertiary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMd.copyWith(fontSize: 11, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 9,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
