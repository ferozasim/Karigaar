import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/user_role.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/router/app_router.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/artisan/profile/artisan_partner_profile_screen.dart';
import 'package:karigaar_app/features/artisan/wallet/artisan_wallet_history_screen.dart';
import 'package:karigaar_app/features/artisan/widgets/artisan_bottom_nav.dart';
import 'package:karigaar_app/features/customer/profile/artisan_profile_screen.dart';
import 'package:karigaar_app/main.dart';

void main() {
  Widget wrapScreen(
    Widget child, {
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );
  }

  group('Ticket T-10 Widget Tests: Partner Profile, Standalone Wallet & ArtisanBottomNav', () {
    testWidgets('ArtisanBottomNav renders 3 tabs cleanly across 360x800, 320x568, and 2.0x text scaling without GoRouter',
        (tester) async {
      for (final size in const [Size(360, 800), Size(320, 568)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const Scaffold(
                body: Center(child: Text('Body')),
                bottomNavigationBar: ArtisanBottomNav(currentTab: ArtisanNavTab.radar),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Job Radar'), findsOneWidget);
        expect(find.text('Wallet & Jobs'), findsOneWidget);
        expect(find.text('My Profile'), findsOneWidget);

        // Tapping without GoRouter must not throw
        await tester.tap(find.byKey(const Key('artisan_nav_wallet')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('ArtisanPartnerProfileScreen renders all required Guild sections and survives 360x800 & 320x568',
        (tester) async {
      for (final size in const [Size(360, 800), Size(320, 568)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(wrapScreen(const ArtisanPartnerProfileScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        expect(find.text('Ramesh Chandra Sharma'), findsOneWidget);
        expect(find.textContaining('KG-ND-2026-089'), findsOneWidget);
        expect(find.text('Aadhaar & Police Verified'), findsOneWidget);
        expect(find.text('👑 Head Mistry'), findsOneWidget);
        expect(find.text('Tier 3: Master Guildsman • 5% Commission Floor'), findsOneWidget);
        expect(find.text('₹249'), findsOneWidget);
        expect(find.text('₹900/day'), findsOneWidget);
      }
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('ArtisanPartnerProfileScreen language toggle switches EN / HI / MR labels',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrapScreen(const ArtisanPartnerProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Karigaar Guild Portal'), findsOneWidget);

      await tester.tap(find.byKey(const Key('partner_lang_hi')));
      await tester.pumpAndSettle();
      expect(find.text('कारीगर गिल्ड पोर्टल'), findsOneWidget);

      await tester.tap(find.byKey(const Key('partner_lang_mr')));
      await tester.pumpAndSettle();
      expect(find.text('कारागीर गिल्ड पोर्टल'), findsOneWidget);

      await tester.tap(find.byKey(const Key('partner_lang_en')));
      await tester.pumpAndSettle();
      expect(find.text('Karigaar Guild Portal'), findsOneWidget);
    });

    testWidgets('Edit Profile & Rate Card updates currentArtisanProfileProvider and syncs to district directory',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ArtisanPartnerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final editBtn = find.byKey(const Key('edit_profile_rate_card_btn'));
      await tester.ensureVisible(editBtn);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('edit_visit_fee_field')), '349');
      await tester.enterText(find.byKey(const Key('edit_dihadi_rate_field')), '1150');
      await tester.enterText(
        find.byKey(const Key('edit_bio_field')),
        'Master Electrician specializing in 3-phase panels.',
      );

      final saveBtn = find.byKey(const Key('save_profile_rate_card_btn'));
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('₹349'), findsOneWidget);
      expect(find.text('₹1150/day'), findsOneWidget);

      final syncedDirectory = container.read(topArtisansProvider);
      expect(
        syncedDirectory.any((a) => a.artisanId == 'art_partner_self' && a.inspectionFee == 349),
        isTrue,
      );
    });

    testWidgets('Add New Work Photo updates portfolio gallery live', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrapScreen(const ArtisanPartnerProfileScreen()));
      await tester.pumpAndSettle();

      final addPhotoBtn = find.byKey(const Key('add_work_photo_btn'));
      await tester.ensureVisible(addPhotoBtn);
      await tester.tap(addPhotoBtn);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('portfolio_title_field')),
        '6-Way Smart MCB Panel',
      );
      await tester.tap(find.byKey(const Key('confirm_add_work_photo_btn')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('6-Way Smart MCB Panel'), findsOneWidget);
    });

    testWidgets('ArtisanWalletHistoryScreen renders balance, reserve, earnings bento, and itemized settlement ledger on 360x800 & 320x568',
        (tester) async {
      for (final size in const [Size(360, 800), Size(320, 568)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(wrapScreen(const ArtisanWalletHistoryScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        expect(find.text('₹4620.00'), findsOneWidget);
        expect(find.text('₹2000.00'), findsOneWidget);
        expect(find.text('₹2620.00'), findsOneWidget);
        expect(find.text('₹1875'), findsOneWidget);
        expect(find.text('₹5345'), findsOneWidget);
        expect(find.text('3-Phase MCB Distribution Box Upgrade'), findsOneWidget);
        expect(find.textContaining('Parts Pass-Through'), findsWidgets);
        expect(find.textContaining('Guild Commission (5%)'), findsWidgets);
      }
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('ArtisanWalletHistoryScreen enforces ₹2,000 rolling reserve and processes valid IMPS withdrawal',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // 1. Reserve floor violation when balance == 2000
      await tester.pumpWidget(
        wrapScreen(
          const ArtisanWalletHistoryScreen(),
          overrides: [
            artisanWalletBalanceProvider.overrideWith((ref) => 2000.0),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('wallet_withdraw_imps_btn')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('mandatory ₹2000 security reserve'),
        findsOneWidget,
      );

      // 2. Valid IMPS withdrawal from 4620.00
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ArtisanWalletHistoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('wallet_withdraw_imps_btn')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('wallet_imps_amount_field')), '1500');
      await tester.tap(find.byKey(const Key('wallet_confirm_imps_btn')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(container.read(artisanWalletBalanceProvider), equals(3120.0));
      expect(find.text('₹3120.00'), findsOneWidget);
      expect(container.read(walletSettlementLedgerProvider).first.isImpsWithdrawal, isTrue);
    });

    testWidgets('GoRouter navigates across /artisan/radar <-> /artisan/wallet <-> /artisan/profile and Sign Out goes to /login',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(userRoleProvider.notifier).state = UserRole.artisan;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const KarigaarApp(),
        ),
      );
      await tester.pumpAndSettle();

      appRouter.go('/artisan/radar');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Nanded Trade Guild'), findsOneWidget);

      // Switch to Wallet tab
      await tester.tap(find.byKey(const Key('artisan_nav_wallet')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Guild Wallet & Earnings'), findsOneWidget);

      // Switch to Profile tab
      await tester.tap(find.byKey(const Key('artisan_nav_profile')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Ramesh Chandra Sharma'), findsOneWidget);

      // Tap Sign Out of Guild Portal
      final signOutBtn = find.byKey(const Key('sign_out_guild_portal_btn'));
      await tester.ensureVisible(signOutBtn);
      await tester.tap(signOutBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(container.read(userRoleProvider), equals(UserRole.customer));
      expect(find.text('Continue with WhatsApp'), findsOneWidget);

      // Verify /karigaar/* aliases resolve to the same screens
      appRouter.go('/karigaar/wallet');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Guild Wallet & Earnings'), findsOneWidget);

      appRouter.go('/karigaar/profile');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Ramesh Chandra Sharma'), findsOneWidget);
    });

    testWidgets('Wallet ledger filters and excessive IMPS withdrawal reserve check work properly',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ArtisanWalletHistoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Filter to IMPS Payouts only
      final payoutsChip = find.byKey(const Key('ledger_filter_payouts'));
      await tester.ensureVisible(payoutsChip);
      await tester.tap(payoutsChip);
      await tester.pumpAndSettle();
      expect(find.textContaining('Instant IMPS Transfer'), findsOneWidget);
      expect(find.text('3-Phase MCB Distribution Box Upgrade'), findsNothing);

      // Filter to Job Credits
      await tester.tap(find.byKey(const Key('ledger_filter_credits')));
      await tester.pumpAndSettle();
      expect(find.text('3-Phase MCB Distribution Box Upgrade'), findsOneWidget);
      expect(find.textContaining('Instant IMPS Transfer'), findsNothing);

      // Attempt withdrawal exceeding ₹2,000 reserve (e.g. ₹3,000 from ₹4,620)
      final withdrawBtn = find.byKey(const Key('wallet_withdraw_imps_btn'));
      await tester.ensureVisible(withdrawBtn);
      await tester.tap(withdrawBtn);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('wallet_imps_amount_field')), '3000');
      await tester.tap(find.byKey(const Key('wallet_confirm_imps_btn')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(container.read(artisanWalletBalanceProvider), equals(4620.0));
      expect(find.textContaining('mandatory ₹2,000 security reserve'), findsOneWidget);
    });

    testWidgets('Customer ArtisanProfileScreen reflects live-synced partner specialties and portfolio',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(currentArtisanProfileProvider.notifier).updateProfileAndRateCard(
            inspectionFee: 299,
            specialties: const ['Solar Hybrid Inverter', 'Earthing Pit Calibration'],
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ArtisanProfileScreen(artisanId: 'art_partner_self'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Ramesh Chandra Sharma'), findsOneWidget);
      expect(find.text('₹299'), findsOneWidget);
      expect(find.text('2 Certified'), findsOneWidget);
      expect(find.text('Solar Hybrid Inverter'), findsOneWidget);
      expect(find.text('32A 3-Phase Distribution Board'), findsOneWidget);
    });
  });
}
