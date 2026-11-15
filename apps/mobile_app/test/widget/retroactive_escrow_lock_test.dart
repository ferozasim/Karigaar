import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/artisan_profile_model.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/customer/bookings/customer_bookings_screen.dart';
import 'package:karigaar_app/features/customer/profile/artisan_profile_screen.dart';
import 'package:karigaar_app/features/customer/profile/widgets/retroactive_escrow_lock_sheet.dart';

void main() {
  const proArtisan = ArtisanProfileModel(
    artisanId: 'art_nanded_03',
    name: 'Prakash Sutar',
    phone: '+919822098765',
    primaryTradeId: 'trade_carpenter',
    tradeTitle: 'Senior Guild Carpenter',
    yearsExperience: 8,
    rating: 4.8,
    reviewCount: 215,
    distanceKm: 1.8,
    bio: 'Precision door lock fitting',
    inspectionFee: 249,
    cityId: 'city_nanded_01',
    localityId: 'loc_cidco',
    tier: GuildTier.guildVerifiedPro,
    roleType: KarigaarRoleType.headMistry,
  );

  Widget createProfileTestWidget(String artisanId) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: ArtisanProfileScreen(artisanId: artisanId),
      ),
    );
  }

  Widget createBookingsTestWidget() {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const CustomerBookingsScreen(),
      ),
    );
  }

  group('Feature F-25 & F-36: Retroactive Escrow Lock Tests', () {
    testWidgets('ArtisanProfileScreen renders upgrade banner and opens lock sheet with Master cover (₹25,000)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProfileTestWidget('art_nanded_01'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final upgradeBtn = find.byKey(const Key('upgrade_to_protected_guild_booking_btn'));
      await tester.ensureVisible(upgradeBtn);
      expect(upgradeBtn, findsOneWidget);

      await tester.tap(upgradeBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Start Handshake OTP: 4921'), findsWidgets);
      expect(find.text('₹25,000 Master Cover Active'), findsOneWidget);
      expect(find.textContaining('₹250 customer deductible'), findsOneWidget);
      expect(find.text('₹228'), findsOneWidget); // 199 + 29
      final confirmBtn = find.byKey(const Key('confirm_lock_escrow_btn'));
      expect(confirmBtn, findsOneWidget);
      await tester.ensureVisible(confirmBtn);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('On-site booking locked!'), findsOneWidget);
    });

    testWidgets('RetroactiveEscrowLockSheet resolves Base cover (₹10,000) for Guild Verified Pro', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Builder(
                builder: (ctx) => Center(
                  child: ElevatedButton(
                    onPressed: () => RetroactiveEscrowLockSheet.show(ctx, proArtisan),
                    child: const Text('Open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('₹10,000 Base Cover Active'), findsOneWidget);
      expect(find.text('Start Handshake OTP: 4921'), findsWidgets);
      expect(find.text('₹278'), findsOneWidget); // 249 + 29
    });

    testWidgets('CustomerBookingsScreen renders direct on-site lead and upgrades to locked booking', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createBookingsTestWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, -250));
      await tester.pumpAndSettle();

      final upgradeBtn = find.byKey(const Key('upgrade_booking_direct_lead_btn'));
      expect(upgradeBtn, findsOneWidget);

      await tester.tap(upgradeBtn);
      await tester.pumpAndSettle();

      expect(find.text('Start Handshake OTP: 4921'), findsWidgets);
      final confirmBtn = find.byKey(const Key('confirm_lock_escrow_btn'));
      await tester.ensureVisible(confirmBtn);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Active booking now shows locked status
      expect(find.text('ON-SITE ESCROW LOCKED'), findsOneWidget);
      expect(find.text('Start Handshake OTP: 4921'), findsWidgets);
    });

    testWidgets('renders cleanly on narrow viewport 320x568 without overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProfileTestWidget('art_nanded_01'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final upgradeBtn = find.byKey(const Key('upgrade_to_protected_guild_booking_btn'));
      await tester.ensureVisible(upgradeBtn);
      expect(upgradeBtn, findsOneWidget);
    });
  });
}
