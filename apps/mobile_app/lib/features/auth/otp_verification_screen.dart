import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../core/models/user_role.dart';
import '../../../core/models/artisan_onboarding.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/localized_strings.dart';
import '../shared/widgets/karigaar_button.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerificationScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 42;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 42;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) return;
    final role = ref.read(userRoleProvider);
    final identity = await ref
        .read(phoneIdentityServiceProvider)
        .verifyCode(widget.phone, _otpController.text);
    if (!mounted) return;
    if (identity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid development code. Use 123456.')),
      );
      return;
    }
    if (role == UserRole.artisan) {
      ref.read(authenticatedRoleProvider.notifier).state = UserRole.artisan;
      ref.read(verifiedPhoneIdentityProvider.notifier).state = identity;
      final draft =
          await ref.read(artisanOnboardingStoreProvider).read(identity.userId);
      if (!mounted) return;
      if (draft?.status == ArtisanReviewStatus.approved &&
          identity.isArtisanApproved) {
        context.go('/artisan/radar');
      } else if (draft != null && draft.status != ArtisanReviewStatus.draft) {
        context.go('/artisan/application-status');
      } else {
        context.go('/artisan/register', extra: {'resume': true});
      }
    } else {
      ref.read(authenticatedRoleProvider.notifier).state = UserRole.customer;
      ref.read(verifiedPhoneIdentityProvider.notifier).state = identity;
      context.go('/customer/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 54,
      textStyle: AppTypography.headlineLg.copyWith(fontSize: 22),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );
    final strings = localizedStrings(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: Text(strings.authOtpVerification),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      (constraints.maxHeight - 32).clamp(0.0, double.infinity),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.mark_chat_read_rounded,
                          color: Color(0xFF16A34A),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        strings.authVerifyWhatsAppCode,
                        style: AppTypography.headlineLg,
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          style: AppTypography.bodyMd
                              .copyWith(color: AppColors.textMuted),
                          children: [
                            TextSpan(text: strings.authCodeSent),
                            TextSpan(
                              text: '+91 ${widget.phone}',
                              style: AppTypography.labelLg
                                  .copyWith(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ref.watch(phoneIdentityServiceProvider).modeLabel,
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 32),

                      // Pinput 6-digit OTP
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Pinput(
                          length: 6,
                          controller: _otpController,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          onCompleted: (pin) {
                            _otpController.text = pin;
                            _verifyOtp();
                          },
                        ),
                      ),

                      const SizedBox(height: 24),
                      // 42-Second Resend Countdown
                      if (!_canResend)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer_outlined,
                                size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '${strings.authResendCode} • ${_secondsRemaining}s',
                                style: AppTypography.labelMd
                                    .copyWith(color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        )
                      else
                        TextButton.icon(
                          onPressed: _startCountdown,
                          icon: const Icon(Icons.refresh_rounded,
                              size: 16, color: AppColors.secondary),
                          label: Text(
                            strings.authResendCode,
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),
                      // SMS Fallback
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.authFallbackSms)),
                          );
                        },
                        child: Text(
                          strings.authSmsFallback,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.textMuted,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(height: 16),
                      // Verify Button
                      KarigaarButton(
                        label: strings.authVerifyContinue,
                        onPressed: () => _verifyOtp(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
