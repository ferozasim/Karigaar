import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/user_role.dart';
import '../../../core/models/artisan_onboarding.dart';
import '../../../core/services/identity_service.dart';
import '../../../core/models/karigaar_role_type.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/catalog_localizations.dart';
import '../../../l10n/localized_strings.dart';
import '../shared/widgets/karigaar_button.dart';
import '../shared/widgets/locality_selector_sheet.dart';

/// 4-Step Artisan Registration & Guild Onboarding Wizard
/// Matches Stitch UI design `create_account_artisan_registration/code.html`
/// - Step 1: Personal Details (Aadhaar legal name, 10-digit WhatsApp phone, emergency contact, experience tier, locality)
/// - Step 2: Trade Selection from all 10 launch trades with subtitles and checkmark badges
/// - Step 3: Simulated Aadhaar KYC upload (12 digits, dropzone with 72% auto-verified badge, encrypted tag) & tools audit
/// - Step 4: Bank/UPI Payout Verification (Account number, IFSC, UPI VPA, simulated instant ₹1 penny drop IMPS verification, ₹25k guild protection)
class ArtisanRegistrationScreen extends ConsumerStatefulWidget {
  final int initialStep;

  const ArtisanRegistrationScreen({
    super.key,
    this.initialStep = 1,
  });

  @override
  ConsumerState<ArtisanRegistrationScreen> createState() =>
      _ArtisanRegistrationScreenState();
}

class _ArtisanRegistrationScreenState
    extends ConsumerState<ArtisanRegistrationScreen> {
  late int _currentStep;
  String _selectedTradeId = 'trade_electrician';
  KarigaarRoleType _selectedRoleType = KarigaarRoleType.skilledKarigaar;
  String _selectedExperience = '3 - 5 Years';
  String _selectedLanguage = 'en'; // 'en', 'hi', 'mr'
  bool _aadhaarUploaded = true;
  bool _upiPayoutVerified = true;
  bool _whatsAppOptIn = true;
  bool _showReferralInput = false;
  late AppLocalizations _strings;

  // Tool audit item states
  bool _toolMultimeter = true;
  bool _toolInsulatedSet = true;
  bool _toolDrillGoggles = true;
  bool _toolDropCloth = true;
  Timer? _draftSaveTimer;

  // Form controllers
  final TextEditingController _nameController =
      TextEditingController(text: 'Ramesh Chandra Sharma');
  final TextEditingController _phoneController =
      TextEditingController(text: '9822012345');
  final TextEditingController _emergencyNameController =
      TextEditingController(text: 'Suresh Sharma (Brother)');
  final TextEditingController _emergencyPhoneController =
      TextEditingController(text: '9822054321');
  final TextEditingController _aadhaarController =
      TextEditingController(text: '5482 9104 2291');
  final TextEditingController _accountNoController =
      TextEditingController(text: '50100429188210');
  final TextEditingController _reAccountNoController =
      TextEditingController(text: '50100429188210');
  final TextEditingController _ifscController =
      TextEditingController(text: 'HDFC0002104');
  final TextEditingController _upiController =
      TextEditingController(text: 'ramesh.karigaar@okaxis');
  final TextEditingController _referralController = TextEditingController();

  static const List<Map<String, dynamic>> _all10LaunchTrades = [
    {
      'id': 'trade_electrician',
      'name': 'Electrician',
      'subtitle': 'Wiring & Inverters',
      'icon': Icons.bolt_rounded,
      'specialties': [
        '3-Phase Commercial',
        'Inverter DB Wiring',
        'MCB Tripping',
        'Concealed Piping'
      ],
    },
    {
      'id': 'trade_plumber',
      'name': 'Plumbing',
      'subtitle': 'Fittings & Pressure',
      'icon': Icons.plumbing_rounded,
      'specialties': [
        'CPVC Pipelines',
        'Diverter Cartridge',
        'Pressure Pump',
        'Drainage Unclog'
      ],
    },
    {
      'id': 'trade_carpenter',
      'name': 'Carpenter',
      'subtitle': 'Modular & Woodwork',
      'icon': Icons.handyman_rounded,
      'specialties': [
        'Modular Kitchen',
        'Hydraulic Hinges',
        'Door Lock Fitting',
        'Laminate Pasting'
      ],
    },
    {
      'id': 'trade_mason',
      'name': 'Mason / Gawandi',
      'subtitle': 'Tiles, Granite & Civil',
      'icon': Icons.foundation_rounded,
      'specialties': [
        'Vitrified Tiles',
        'Granite Platform',
        'Plastering & Brick',
        'Waterproofing'
      ],
    },
    {
      'id': 'trade_painter',
      'name': 'Painter',
      'subtitle': 'Textures & Polish',
      'icon': Icons.format_paint_rounded,
      'specialties': [
        'Royal Texture',
        'Waterproof Primer',
        'Wood PU Polish',
        'Wall Putty Level'
      ],
    },
    {
      'id': 'trade_ac_refrig',
      'name': 'AC & Refrigeration',
      'subtitle': 'HVAC & Whitegoods',
      'icon': Icons.ac_unit_rounded,
      'specialties': [
        'Inverter Split AC',
        'Jet Pump Wash',
        'R32 Gas Charging',
        'Deep Freezer'
      ],
    },
    {
      'id': 'trade_appliance',
      'name': 'Appliance Repair',
      'subtitle': 'RO, Geyser & Washer',
      'icon': Icons.home_repair_service_rounded,
      'specialties': [
        'RO Membrane & Pump',
        'Instant Geyser Coil',
        'Front Load Washer',
        'Microwave PCB'
      ],
    },
    {
      'id': 'trade_welder',
      'name': 'Welder',
      'subtitle': 'Grills & Fabrication',
      'icon': Icons.construction_rounded,
      'specialties': [
        'Arc Welding',
        'Safety Gate Grill',
        'Shed Fabrication',
        'Stainless Steel Railing'
      ],
    },
    {
      'id': 'trade_pest_control',
      'name': 'Pest Control',
      'subtitle': 'Termite & Herbal',
      'icon': Icons.pest_control_rounded,
      'specialties': [
        'Termite Drill Injection',
        'Herbal Cockroach Gel',
        'Bedbug Heat Treat',
        'Rodent Proofing'
      ],
    },
    {
      'id': 'trade_deep_cleaning',
      'name': 'Deep Cleaning',
      'subtitle': 'Tank & Home Sanitize',
      'icon': Icons.cleaning_services_rounded,
      'specialties': [
        'Overhead Water Tank',
        'Kitchen Degreasing',
        'Sofa Steam Vacuum',
        'Bathroom Descaling'
      ],
    },
  ];

  static const List<String> _experienceOptions = [
    '1 - 3 Years',
    '3 - 5 Years',
    '5 - 10 Years',
    '10+ Master',
  ];

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep.clamp(1, 4);
    _nameController.addListener(_scheduleDraftSave);
    _phoneController.addListener(_scheduleDraftSave);
    _restoreDraft();
  }

  void _scheduleDraftSave() {
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(const Duration(milliseconds: 350), () {
      unawaited(_saveDraft());
    });
  }

  Future<void> _restoreDraft() async {
    final identity = ref.read(verifiedPhoneIdentityProvider);
    final userId = identity?.userId ??
        DevelopmentPhoneIdentityService.localUserIdForPhone(
            _phoneController.text);
    final draft = await ref.read(artisanOnboardingStoreProvider).read(userId);
    if (!mounted ||
        draft == null ||
        draft.status != ArtisanReviewStatus.draft) {
      return;
    }
    setState(() {
      if (draft.name.isNotEmpty) _nameController.text = draft.name;
      _phoneController.text = draft.phone.replaceFirst('+91', '');
      _selectedTradeId = draft.tradeId;
      _currentStep = draft.step;
    });
  }

  Future<void> _saveDraft({ArtisanReviewStatus? status}) async {
    final identity = ref.read(verifiedPhoneIdentityProvider);
    final phone = _phoneController.text.trim();
    final userId = identity?.userId ??
        DevelopmentPhoneIdentityService.localUserIdForPhone(phone);
    await ref.read(artisanOnboardingStoreProvider).save(
          ArtisanOnboardingDraft(
            userId: userId,
            phone:
                identity?.phone ?? '+91${phone.replaceAll(RegExp(r'\D'), '')}',
            name: _nameController.text.trim(),
            tradeId: _selectedTradeId,
            cityId: ref.read(selectedDistrictProvider).cityId,
            localityId: ref.read(selectedLocalityProvider).localityId,
            step: _currentStep,
            status: status ?? ArtisanReviewStatus.draft,
            updatedAt: DateTime.now(),
          ),
        );
  }

  @override
  void dispose() {
    _draftSaveTimer?.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _aadhaarController.dispose();
    _accountNoController.dispose();
    _reAccountNoController.dispose();
    _ifscController.dispose();
    _upiController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 1:
        return _strings.authStepPersonal;
      case 2:
        return _strings.authStepTrade;
      case 3:
        return _strings.authStepAudit;
      case 4:
      default:
        return _strings.authStepPayout;
    }
  }

  double get _progressValue => _currentStep * 0.25;

  Future<void> _nextStep() async {
    if (_currentStep == 1) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      if (name.isEmpty || phone.length < 10) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_strings.authLegalNameError),
          ),
        );
        return;
      }
    } else if (_currentStep == 2) {
      if (_selectedTradeId.isEmpty) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_strings.authTradeError),
          ),
        );
        return;
      }
    } else if (_currentStep == 3) {
      final aadhaar = _aadhaarController.text.replaceAll(' ', '').trim();
      if (aadhaar.length < 12) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_strings.authAadhaarError),
          ),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_currentStep < 4) {
      if (mounted) setState(() => _currentStep++);
      await _saveDraft();
    } else {
      await _submitRegistration();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
      unawaited(_saveDraft());
    } else {
      try {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/login');
        }
      } catch (_) {
        Navigator.of(context).maybePop();
      }
    }
  }

  Future<void> _submitRegistration() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(_strings.authLegalNameError),
          ),
        );
      return;
    }

    await _saveDraft(status: ArtisanReviewStatus.submitted);
    if (!mounted) return;

    ref.read(userRoleProvider.notifier).state = UserRole.artisan;
    try {
      await context.push('/otp-verify', extra: phone);
    } catch (_) {
      // Handle test harnesses without GoRouter
    }
  }

  @override
  Widget build(BuildContext context) {
    _strings = localizedStrings(context);
    _selectedLanguage = ref.watch(partnerLanguageProvider);
    final selectedLocality = ref.watch(selectedLocalityProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: Text(_strings.authJoinGuild),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _prevStep,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header + Language Selector
            _buildProgressHeader(),
            const SizedBox(height: 10),
            // Animated Progress Track
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: LinearProgressIndicator(
                value: _progressValue,
                minHeight: 6,
                backgroundColor: AppColors.surfaceSubtle,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ),

            const SizedBox(height: 16),

            // Step Indicator Pills
            _buildStepSelectorStrip(),

            const SizedBox(height: 16),

            if (_currentStep == 1) ...[
              // Guild Welcome Header Card (Ambient Glow)
              _buildGuildWelcomeCard(),

              const SizedBox(height: 16),

              // Visual Artisan Trust Highlight Banner
              _buildTrustEarningsBanner(),

              const SizedBox(height: 16),
            ],

            // Progressive Step Body Content
            if (_currentStep == 1)
              _buildStep1PersonalDetails(selectedLocality)
            else if (_currentStep == 2)
              _buildStep2TradeSelection()
            else if (_currentStep == 3)
              _buildStep3AadhaarAndTools()
            else
              _buildStep4PayoutAndGuildProtection(),

            const SizedBox(height: 16),

            Center(
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  _strings.authAlreadyRegistered,
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceBase,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: _buildActionDock(),
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_currentStep',
                  style: AppTypography.labelSm.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _stepTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Language Toggle Pill
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLangBtn('en', 'English'),
                  _buildLangBtn('hi', 'हिंदी'),
                  _buildLangBtn('mr', 'मराठी'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLangBtn(String code, String label) {
    final isSelected = _selectedLanguage == code;
    return GestureDetector(
      key: ValueKey('lang_btn_$code'),
      onTap: () => ref.read(partnerLanguageProvider.notifier).state = code,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          label,
          style: AppTypography.labelSm.copyWith(
            fontSize: 11,
            color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildGuildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded,
                        size: 14, color: AppColors.tertiary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _strings.authAccreditation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.tertiary),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  _strings.authCommissionGuarantee,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _strings.authJoinGuild,
            style: AppTypography.headlineLg.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            _strings.authJoinDescription,
            style: AppTypography.bodySm.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustEarningsBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.secondarySurfaceTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.military_tech_rounded,
              color: AppColors.secondary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _strings.authAverageEarnings,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelMd
                            .copyWith(color: AppColors.secondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _strings.authGuildProfessionals,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepSelectorStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [1, 2, 3, 4].map((step) {
        final isActive = step == _currentStep;
        final isCompleted = step < _currentStep;
        final labels = ['Details', 'Trade', 'KYC', 'Payout'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _currentStep = step),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : isCompleted
                        ? AppColors.tertiarySurfaceTint
                        : AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : isCompleted
                          ? AppColors.tertiary.withValues(alpha: 0.3)
                          : AppColors.borderSubtle,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '$step',
                    style: AppTypography.labelSm.copyWith(
                      color: isActive
                          ? Colors.white
                          : isCompleted
                              ? AppColors.tertiary
                              : AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    labels[step - 1],
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 10,
                      color: isActive
                          ? Colors.white70
                          : isCompleted
                              ? AppColors.tertiary
                              : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // STEP 1: Personal Details
  Widget _buildStep1PersonalDetails(dynamic selectedLocality) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_strings.authPersonalHeading, style: AppTypography.headlineSm),
        const SizedBox(height: 4),
        Text(
          _strings.authPersonalDescription,
          style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),

        // Full Legal Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child:
                    Text(_strings.authFullName, style: AppTypography.labelMd)),
            Flexible(
              child: Text(
                _strings.authMatchesAadhaar,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    AppTypography.bodySm.copyWith(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          onChanged: (_) => _scheduleDraftSave(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.badge_outlined, size: 20),
            hintText: _strings.authNameHint,
          ),
        ),

        const SizedBox(height: 14),

        // WhatsApp Mobile Number
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(_strings.authWhatsAppNumber,
                    style: AppTypography.labelMd)),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _strings.authInstantOtp,
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.tertiary),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          onChanged: (_) => _scheduleDraftSave(),
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
            hintText: _strings.authWhatsAppHint,
            counterText: '',
          ),
        ),

        const SizedBox(height: 14),

        // Emergency Contact
        Text(_strings.authEmergencyContact, style: AppTypography.labelMd),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _emergencyNameController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.person_outline_rounded, size: 20),
                  hintText: _strings.authContactName,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  hintText: _strings.authPhoneHint,
                  counterText: '',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Primary Working Locality
        Text(_strings.authWorkingLocality, style: AppTypography.labelMd),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => LocalitySelectorSheet.show(context),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    color: AppColors.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${selectedLocality.name}, Nanded (${selectedLocality.pincode})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMd,
                  ),
                ),
                const Icon(Icons.expand_more_rounded,
                    color: AppColors.textMuted),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Trade Experience Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(_strings.authExperience,
                    style: AppTypography.labelMd)),
            Flexible(
              child: Text(
                _strings.authPriorityLeads,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    AppTypography.labelSm.copyWith(color: AppColors.secondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _experienceOptions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 42,
          ),
          itemBuilder: (context, index) {
            final exp = _experienceOptions[index];
            final isSelected = _selectedExperience == exp;
            return GestureDetector(
              onTap: () => setState(() => _selectedExperience = exp),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primary : AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.borderSubtle,
                  ),
                ),
                child: Text(
                  exp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 14),

        // WhatsApp Alerts & Daily Slips Opt-In
        GestureDetector(
          onTap: () => setState(() => _whatsAppOptIn = !_whatsAppOptIn),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _whatsAppOptIn,
                  activeColor: AppColors.tertiary,
                  onChanged: (val) =>
                      setState(() => _whatsAppOptIn = val ?? true),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.chat_rounded,
                              size: 16, color: AppColors.tertiary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _strings.authDispatchAlerts,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelMd
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _strings.authDispatchDescription,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Referral Code Accordion
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            children: [
              GestureDetector(
                key: const ValueKey('referral_code_accordion_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    setState(() => _showReferralInput = !_showReferralInput),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.redeem_rounded,
                              color: AppColors.secondary, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _strings.authReferralQuestion,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelMd,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _showReferralInput
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              if (_showReferralInput) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _referralController,
                        decoration: InputDecoration(
                          hintText: _strings.authReferralHint,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(_strings.authReferralApplied),
                            ),
                          );
                      },
                      child: Text(_strings.authApply),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: Trade Selection from All 10 Launch Trades
  Widget _buildStep2TradeSelection() {
    final selectedTradeData = _all10LaunchTrades.firstWhere(
      (t) => t['id'] == _selectedTradeId,
      orElse: () => _all10LaunchTrades.first,
    );
    final specialties = selectedTradeData['specialties'] as List<String>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_strings.authPrimaryTrade,
                      style: AppTypography.headlineSm),
                  Text(
                    _strings.authPrimaryTradeDescription,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondarySurfaceTint,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                _strings.authOneRequired,
                style:
                    AppTypography.labelSm.copyWith(color: AppColors.secondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 10-Trade Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _all10LaunchTrades.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 84,
          ),
          itemBuilder: (context, index) {
            final trade = _all10LaunchTrades[index];
            final isSelected = _selectedTradeId == trade['id'];
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() => _selectedTradeId = trade['id'] as String);
                _scheduleDraftSave();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surfaceRaised
                      : AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.borderSubtle,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondarySurfaceTint
                            : AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        trade['icon'] as IconData,
                        color: isSelected
                            ? AppColors.secondary
                            : AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Localizations.localeOf(context).languageCode == 'en'
                                ? trade['name'] as String
                                : localizedTradeNameById(
                                    context,
                                    trade['id'] as String,
                                    trade['name'] as String,
                                  ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                          Text(
                            Localizations.localeOf(context).languageCode == 'en'
                                ? trade['subtitle'] as String
                                : localizedTradeTaglineById(
                                    context,
                                    trade['id'] as String,
                                    trade['subtitle'] as String,
                                  ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            size: 12, color: Colors.white),
                      ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 18),

        // Sub-Trade Skill Specialization Chips
        Text(
          'Certified Skills for ${Localizations.localeOf(context).languageCode == 'en' ? selectedTradeData['name'] : localizedTradeNameById(context, _selectedTradeId, selectedTradeData['name'] as String)}',
          style: AppTypography.labelMd,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: specialties.map((spec) {
            return Chip(
              label: Text(spec, style: AppTypography.labelSm),
              backgroundColor: AppColors.surfaceRaised,
              avatar: const Icon(Icons.check_circle_rounded,
                  size: 16, color: AppColors.tertiary),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        Text(
          _strings.authRoleType,
          style: AppTypography.labelMd,
        ),
        const SizedBox(height: 8),
        ...KarigaarRoleType.values.map((role) {
          final isSelected = _selectedRoleType == role;
          final localizedTitle = role.getLocalizedTitle(_selectedTradeId);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.surfaceRaised
                  : AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected ? AppColors.secondary : AppColors.borderSubtle,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _selectedRoleType = role),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        switch (role) {
                          KarigaarRoleType.headMistry => '👑',
                          KarigaarRoleType.skilledKarigaar => '🔧',
                          KarigaarRoleType.helperAssistant => '🤝',
                          KarigaarRoleType.thekedar => '👷',
                        },
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizedTitle,
                              style: AppTypography.labelMd.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.secondary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${role.standardLabel} • ${(role.rateMultiplier * 100).round()}% standard labor rate',
                              style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: isSelected
                            ? AppColors.secondary
                            : AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // STEP 3: Simulated Aadhaar KYC & Tools Audit
  Widget _buildStep3AadhaarAndTools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_strings.authKycHeading, style: AppTypography.headlineSm),
        const SizedBox(height: 4),
        Text(
          _strings.authKycDescription,
          style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),

        // 12-Digit Aadhaar Input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(_strings.authAadhaarNumber,
                    style: AppTypography.labelMd)),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _strings.authEncrypted,
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.tertiary),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _aadhaarController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.fingerprint_rounded, size: 20),
            hintText: 'XXXX XXXX XXXX',
          ),
        ),

        const SizedBox(height: 16),

        // Aadhaar Dropzone Photo Upload Card
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: AppColors.secondarySurfaceTint,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_strings.authTradeCard,
                                  style: AppTypography.labelLg,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(_strings.authFrontSync,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodySm
                                      .copyWith(color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                              content: Text(_strings.authDigilockerSuccess)),
                        );
                    },
                    icon: const Icon(Icons.cloud_sync_rounded, size: 16),
                    label: const Text('DigiLocker'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () =>
                    setState(() => _aadhaarUploaded = !_aadhaarUploaded),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _aadhaarUploaded
                            ? Icons.check_circle_rounded
                            : Icons.add_a_photo_rounded,
                        color: _aadhaarUploaded
                            ? AppColors.tertiary
                            : AppColors.secondary,
                        size: 32,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _aadhaarUploaded
                            ? _strings.authFrontCaptured
                            : _strings.authCaptureAadhaar,
                        style: AppTypography.labelMd,
                      ),
                      Text(
                        _strings.authPhotoLimit,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: _aadhaarUploaded ? 0.72 : 0.0,
                          minHeight: 8,
                          backgroundColor: Colors.white,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.tertiary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'aadhaar_front_scan.jpg',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSm
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _aadhaarUploaded
                                  ? _strings.authAutoVerified
                                  : _strings.authUpload,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSm.copyWith(
                                color: _aadhaarUploaded
                                    ? AppColors.tertiary
                                    : AppColors.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Trade Tools Audit Checklist
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _strings.authToolsAudit,
                      style: AppTypography.labelLg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.tertiarySurfaceTint,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _strings.authSafetyStandard,
                          style: AppTypography.labelSm
                              .copyWith(color: AppColors.tertiary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildToolCheckItem(
                _strings.authMultimeter,
                _toolMultimeter,
                (val) => setState(() => _toolMultimeter = val ?? true),
              ),
              _buildToolCheckItem(
                _strings.authInsulatedTools,
                _toolInsulatedSet,
                (val) => setState(() => _toolInsulatedSet = val ?? true),
              ),
              _buildToolCheckItem(
                _strings.authDrillTools,
                _toolDrillGoggles,
                (val) => setState(() => _toolDrillGoggles = val ?? true),
              ),
              _buildToolCheckItem(
                _strings.authCleanupTools,
                _toolDropCloth,
                (val) => setState(() => _toolDropCloth = val ?? true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToolCheckItem(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: value,
            activeColor: AppColors.tertiary,
            onChanged: onChanged,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySm,
            ),
          ),
        ],
      ),
    );
  }

  // STEP 4: Bank / UPI Instant IMPS Payout Verification
  Widget _buildStep4PayoutAndGuildProtection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_strings.authPayoutHeading, style: AppTypography.headlineSm),
        const SizedBox(height: 4),
        Text(
          _strings.authPayoutDescription,
          style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),

        // Bank Account Details Card
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
              Text(_strings.authDirectPayout, style: AppTypography.labelLg),
              const SizedBox(height: 12),
              TextField(
                controller: _accountNoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _strings.authBankAccount,
                  prefixIcon: const Icon(Icons.account_balance_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reAccountNoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _strings.authReenterBank,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ifscController,
                decoration: InputDecoration(
                  labelText: _strings.authIfsc,
                  prefixIcon: const Icon(Icons.domain_rounded),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        size: 16, color: AppColors.tertiary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _strings.authBranchResolved,
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // UPI Instant Settlement Card
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(_strings.authUpiPayout,
                        style: AppTypography.labelLg),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.tertiarySurfaceTint,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      _upiPayoutVerified ? _strings.authPennyDrop : 'Pending',
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.tertiary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _upiController,
                decoration: InputDecoration(
                  labelText: _strings.authVerifiedUpi,
                  prefixIcon: const Icon(Icons.qr_code_rounded),
                ),
                onChanged: (val) =>
                    setState(() => _upiPayoutVerified = val.contains('@')),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded,
                        size: 18, color: AppColors.tertiary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _strings.authPennyDropSimulation,
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.tertiary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ₹25k Guild Damage Shield & 0% Commission Guarantee
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.security_rounded,
                      color: AppColors.secondary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _strings.authProtectionActive,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _strings.authProtectionDescription,
                style: AppTypography.bodySm.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Bottom action buttons: Back & Next / Submit
  Widget _buildActionDock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_currentStep < 4) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(_strings.authBack),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: KarigaarButton(
                  label: _strings.authNextStep,
                  variant: KarigaarButtonVariant.primary,
                  icon: const Icon(Icons.arrow_forward_rounded,
                      size: 18, color: Colors.white),
                  onPressed: _nextStep,
                ),
              ),
            ],
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(_strings.authBack),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: KarigaarButton(
                  label: _strings.authVerifyWhatsApp,
                  variant: KarigaarButtonVariant.urgent,
                  icon: const Icon(Icons.lock_rounded,
                      size: 18, color: Colors.white),
                  onPressed: _submitRegistration,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
