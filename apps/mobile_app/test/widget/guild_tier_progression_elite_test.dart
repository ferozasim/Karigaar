import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/artisan/active_job/artisan_active_job_screen.dart';
import 'package:karigaar_app/features/customer/scoping/service_scoping_screen.dart';

void main() {
  Widget createActiveJobWidget() {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821'),
      ),
    );
  }

  Widget createScopingWidget() {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ServiceScopingScreen(tradeId: 'trade_electrician'),
      ),
    );
  }

  group('Feature F-24: Guild Tier Progression & Guild Elite 5% Floor Tests', () {
    testWidgets('renders 4-node progression track and Guild Elite subscription card', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createActiveJobWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      final gaugeFinder = find.byKey(const Key('guild_elite_subscription_card'));
      await tester.ensureVisible(gaugeFinder);
      await tester.pumpAndSettle();

      // Verify 4 nodes
      expect(find.textContaining('Apprentice'), findsOneWidget);
      expect(find.textContaining('Pro'), findsOneWidget);
      expect(find.textContaining('Master'), findsWidgets);
      expect(find.textContaining('Elite'), findsWidgets);

      // Verify progress & milestone copy
      expect(find.text('42 / 50 Jobs'), findsOneWidget);
      expect(
        find.text(
          'Complete 8 more jobs for 8% Master tier, or subscribe to Guild Elite for the 5% commission floor!',
        ),
        findsOneWidget,
      );

      // Verify Subscription card
      expect(find.text('Karigaar Guild Elite Partner'), findsOneWidget);
      expect(find.text('5% Commission Floor (Keep 95%)'), findsOneWidget);
      expect(find.textContaining('₹999 / month'), findsOneWidget);
      expect(find.byKey(const Key('upgrade_to_guild_elite_btn')), findsOneWidget);
    });

    testWidgets('subscribing to Guild Elite deducts ₹999 from wallet and activates 5% floor badge', (tester) async {
      await tester.pumpWidget(createActiveJobWidget());
      await tester.pumpAndSettle();

      final upgradeBtn = find.byKey(const Key('upgrade_to_guild_elite_btn'));
      await tester.ensureVisible(upgradeBtn);
      await tester.tap(upgradeBtn);
      await tester.pumpAndSettle();

      expect(find.text('Subscribe to Guild Elite'), findsOneWidget);
      expect(find.text('₹999.00'), findsOneWidget);
      expect(find.text('₹4620.00'), findsWidgets);
      expect(find.text('₹3621.00'), findsOneWidget);

      await tester.tap(find.byKey(const Key('confirm_guild_elite_subscription_btn')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('guild_elite_active_badge')), findsOneWidget);
      expect(find.textContaining('5% Commission Floor Locked'), findsOneWidget);
      expect(find.textContaining('Guild Elite active! You keep 95%'), findsOneWidget);
    });

    testWidgets('ServiceScopingScreen renders KarigaarRoleType rate tiers and adjusts estimate dynamically', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createScopingWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      final tierSection = find.text('Craftsperson Skill Tier');
      await tester.ensureVisible(tierSection);
      await tester.pumpAndSettle();

      // Check all 3 rate tier cards exist
      expect(find.byKey(const Key('role_tier_head_mistry')), findsOneWidget);
      expect(find.byKey(const Key('role_tier_skilled_karigaar')), findsOneWidget);
      expect(find.byKey(const Key('role_tier_helper_assistant')), findsOneWidget);

      // Electrician localized titles
      expect(find.textContaining('Head Wireman Mistry'), findsWidgets);
      expect(find.textContaining('Line & Panel Karigaar'), findsWidgets);
      expect(find.textContaining('Electrical Helper'), findsOneWidget);

      // Select Head Mistry (1.25x)
      await tester.tap(find.byKey(const Key('role_tier_head_mistry')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Head Mistry'), findsWidgets);

      // Select Helper Assistant (0.65x)
      await tester.tap(find.byKey(const Key('role_tier_helper_assistant')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Helper'), findsWidgets);
    });

    testWidgets('survives narrow viewport 320x568 without layout exceptions', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createActiveJobWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
