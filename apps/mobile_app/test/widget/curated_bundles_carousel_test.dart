import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/preventive_bundle_model.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/customer/home/widgets/curated_bundles_carousel.dart';
import 'package:karigaar_app/features/customer/home/customer_home_screen.dart';
import 'package:karigaar_app/features/customer/scoping/service_scoping_screen.dart';

void main() {
  Widget buildTestableWidget(
    Widget child, {
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      ),
    );
  }

  group('CuratedBundlesCarousel Widget Tests (F-08)', () {
    testWidgets('1. CuratedBundlesCarousel renders section header and bundle cards', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const CuratedBundlesCarousel()));
      await tester.pumpAndSettle();

      expect(find.text('Preventive Care Bundles'), findsOneWidget);
      expect(find.text('Save up to 30%'), findsOneWidget);
      expect(find.text('Monsoon Electrical Shield'), findsOneWidget);
      expect(find.text('Full Home Plumbing Health Check'), findsOneWidget);
      expect(find.text('₹499'), findsOneWidget);
      expect(find.text('₹699'), findsOneWidget);
      expect(find.byKey(const Key('add_bundle_bundle_monsoon_elec')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2. Tapping "Add +" invokes onSelectBundle callback with tapped bundle', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      PreventiveBundleModel? selectedBundle;

      await tester.pumpWidget(
        buildTestableWidget(
          CuratedBundlesCarousel(
            onSelectBundle: (bundle) {
              selectedBundle = bundle;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final addBtn = find.byKey(const Key('add_bundle_bundle_monsoon_elec'));
      expect(addBtn, findsOneWidget);
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      expect(selectedBundle, isNotNull);
      expect(selectedBundle!.bundleId, 'bundle_monsoon_elec');
      expect(selectedBundle!.tradeId, 'trade_electrician');
      expect(selectedBundle!.discountedPrice, 499);
      expect(tester.takeException(), isNull);
    });

    testWidgets('3. Carousel scrolls horizontally and displays subsequent bundles', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const CuratedBundlesCarousel()));
      await tester.pumpAndSettle();

      // Drag carousel to reveal 3rd and 4th cards
      await tester.drag(find.byType(ListView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(find.text('Pre-Summer AC Super Cool'), findsOneWidget);
      expect(find.text('₹649'), findsWidgets);
      expect(find.byKey(const Key('add_bundle_bundle_ac_summer')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('4. CustomerHomeScreen renders CuratedBundlesCarousel within sliver tree', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const CustomerHomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('curated_bundles_carousel')), findsOneWidget);
      expect(find.text('Preventive Care Bundles'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('5. Layout verification on ultra-narrow 320x568 mobile viewport', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const CuratedBundlesCarousel()));
      await tester.pumpAndSettle();

      expect(find.byType(CuratedBundlesCarousel), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('6. ServiceScopingScreen renders Curated Bundle Applied banner when passed bundle', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const sampleBundle = PreventiveBundleModel(
        bundleId: 'bundle_monsoon_elec',
        title: 'Monsoon Electrical Shield',
        marathiTitle: 'पावसाळी विद्युत सुरक्षा',
        subtitle: 'Prevent short circuits & water-contact shocks',
        tradeId: 'trade_electrician',
        originalPrice: 699,
        discountedPrice: 499,
        discountTag: 'SAVE 28%',
        includedPackageIds: ['pkg_elec_mcb', 'pkg_elec_switchboard'],
        includedTasks: ['MCB test', 'Earthing check'],
        estimatedMinutes: 60,
        badgeText: 'Monsoon Ready',
        iconName: 'bolt',
        accentColorHex: '#D97706',
        surfaceTintHex: '#FEF3C7',
        guaranteeDays: 30,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const ServiceScopingScreen(
            tradeId: 'trade_electrician',
            initialPackageIds: ['pkg_elec_mcb', 'pkg_elec_switchboard'],
            bundleId: 'bundle_monsoon_elec',
            bundle: sampleBundle,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('curated_bundle_applied_banner')), findsOneWidget);
      expect(find.text('Curated Bundle Applied'), findsOneWidget);
      expect(find.textContaining('Monsoon Electrical Shield'), findsWidgets);
      expect(find.textContaining('Save ₹200'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
