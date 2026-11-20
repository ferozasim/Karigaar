import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/artisan_onboarding.dart';
import '../../../core/models/user_role.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';

class ArtisanApplicationStatusScreen extends ConsumerWidget {
  const ArtisanApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(verifiedPhoneIdentityProvider);
    if (identity == null ||
        ref.watch(authenticatedRoleProvider) != UserRole.artisan) {
      return _signInPrompt(context, ref);
    }
    final draft = ref.watch(artisanOnboardingDraftProvider(identity.userId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karigaar application'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(verifiedPhoneIdentityProvider.notifier).state = null;
              ref.read(authenticatedRoleProvider.notifier).state = null;
              context.go('/login');
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: draft.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(
          child: Text('Could not load your application. Please try again.'),
        ),
        data: (value) {
          final status = value?.status ?? ArtisanReviewStatus.draft;
          final (icon, title, message) = switch (status) {
            ArtisanReviewStatus.draft => (
                Icons.edit_note_rounded,
                'Continue your application',
                'Your saved details are ready to continue.'
              ),
            ArtisanReviewStatus.submitted => (
                Icons.hourglass_top_rounded,
                'Application under review',
                'We have received your application. You can return here to check its status.'
              ),
            ArtisanReviewStatus.needsAction => (
                Icons.assignment_late_outlined,
                'Action needed',
                'Please contact Karigaar support to learn what needs updating.'
              ),
            ArtisanReviewStatus.approved => (
                Icons.verified_rounded,
                'You are approved',
                'Your artisan account can accept eligible jobs.'
              ),
            ArtisanReviewStatus.rejected => (
                Icons.info_outline_rounded,
                'Application not approved',
                'Please contact Karigaar support for next steps.'
              ),
          };
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 64, color: AppColors.secondary),
                    const SizedBox(height: 16),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    const Text(
                      'Development account: review decisions are not made in this app. Sign-in is a local development stub.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    if (status == ArtisanReviewStatus.draft) ...[
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => context.go('/artisan/register'),
                        child: const Text('Resume application'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _signInPrompt(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Karigaar application')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Sign in with your verified phone to view your application.'),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    ref.read(userRoleProvider.notifier).state =
                        UserRole.artisan;
                    context.go('/login');
                  },
                  child: const Text('Go to sign in'),
                ),
              ],
            ),
          ),
        ),
      );
}

/// Keeps every protected artisan destination behind verified identity and
/// server-owned approval state. Local drafts never grant job access.
class ArtisanAccessGate extends ConsumerWidget {
  const ArtisanAccessGate({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(verifiedPhoneIdentityProvider);
    if (identity == null ||
        ref.watch(authenticatedRoleProvider) != UserRole.artisan) {
      return const ArtisanApplicationStatusScreen();
    }
    final draft = ref.watch(artisanOnboardingDraftProvider(identity.userId));
    return draft.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => const Scaffold(
          body: Center(child: Text('Could not verify artisan access.'))),
      data: (value) => identity.isArtisanApproved &&
              value?.status == ArtisanReviewStatus.approved
          ? child
          : const ArtisanApplicationStatusScreen(),
    );
  }
}

class CustomerAccessGate extends ConsumerWidget {
  const CustomerAccessGate({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authenticatedRoleProvider);
    final identity = ref.watch(verifiedPhoneIdentityProvider);
    if (role == UserRole.customer && identity != null) return child;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Sign in as a homeowner to open this page.'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  ref.read(userRoleProvider.notifier).state = UserRole.customer;
                  context.go('/login');
                },
                child: const Text('Go to homeowner sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
