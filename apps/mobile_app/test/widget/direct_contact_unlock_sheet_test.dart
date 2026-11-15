import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/artisan_profile_model.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/customer/profile/widgets/direct_contact_unlock_sheet.dart';

void main() {
  const sampleArtisan = ArtisanProfileModel(
    artisanId: 'art_nanded_01',
    name: 'Ganesh Kadam',
    phone: '+919822012345',
    primaryTradeId: 'trade_electrician',
    tradeTitle: 'Master Electrician',
    yearsExperience: 9,
    rating: 4.9,
    reviewCount: 340,
    distanceKm: 1.2,
    bio: 'Specialist in commercial wiring',
    inspectionFee: 199,
    cityId: 'city_nanded_01',
    localityId: 'loc_anand_nagar',
    tier: GuildTier.guildVerifiedPro,
    roleType: KarigaarRoleType.headMistry,
  );

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (ctx) => Center(
              child: ElevatedButton(
                key: const Key('open_sheet_btn'),
                onPressed: () => DirectContactUnlockSheet.show(ctx, sampleArtisan),
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('Feature F-35: DirectContactUnlockSheet Widget Tests', () {
    testWidgets('renders modal sheet with options, privacy guarantee, and CTA without layout exceptions', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('open_sheet_btn')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Unlock Direct Contact'), findsOneWidget);
      expect(find.textContaining('Ganesh Kadam'), findsWidgets);

      // Privacy Guarantee notice
      expect(find.text('100% Privacy Protected • Zero Raw Phone Leakage'), findsOneWidget);
      expect(find.textContaining('+91-11-4084-2190'), findsOneWidget);

      // Two options
      expect(find.byKey(const Key('unlock_option_pay_per_lead')), findsOneWidget);
      expect(find.byKey(const Key('unlock_option_directory_pass')), findsOneWidget);
      expect(find.text('Pay-Per-Lead'), findsOneWidget);
      expect(find.text('Unlimited Directory Pass'), findsOneWidget);
      expect(find.text('Unlock for ₹49'), findsOneWidget);

      // Switch to directory pass
      await tester.tap(find.byKey(const Key('unlock_option_directory_pass')));
      await tester.pumpAndSettle();

      expect(find.text('Activate Directory Pass (₹499/mo)'), findsOneWidget);

      // Confirm unlock
      await tester.ensureVisible(find.byKey(const Key('confirm_unlock_direct_contact_btn')));
      await tester.tap(find.byKey(const Key('confirm_unlock_direct_contact_btn')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Unlock Direct Contact'), findsNothing);
    });

    testWidgets('renders cleanly on narrow viewport 320x568 without overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('open_sheet_btn')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Unlock Direct Contact'), findsOneWidget);
      expect(find.byKey(const Key('confirm_unlock_direct_contact_btn')), findsOneWidget);
    });
  });
}
