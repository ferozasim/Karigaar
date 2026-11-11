import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/shared/widgets/locality_selector_sheet.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: LocalitySelectorSheet(),
        ),
      ),
    );
  }

  group('LocalitySelectorSheet Tests', () {
    testWidgets('renders title, pilot city badge, and locality items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Select Locality'), findsOneWidget);
      expect(find.text('Pilot City: Nanded-Waghala (Maharashtra)'), findsOneWidget);
      expect(find.text('10 Hubs Active'), findsOneWidget);

      expect(find.text('Anand Nagar'), findsWidgets);
      expect(find.text('Vazirabad & Sarafa'), findsWidgets);
      expect(find.text('CIDCO New Nanded'), findsWidgets);
    });

    testWidgets('filters locality list by search query', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'cidco');
      await tester.pumpAndSettle();

      expect(find.text('CIDCO New Nanded'), findsOneWidget);
      expect(find.text('Anand Nagar'), findsNothing);
    });

    testWidgets('selecting a locality updates selectedLocalityProvider', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: LocalitySelectorSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially Anand Nagar
      expect(container.read(selectedLocalityProvider).localityId, equals('loc_anand_nagar'));

      // Tap Vazirabad
      final vazirabadItem = find.text('Vazirabad & Sarafa');
      await tester.tap(vazirabadItem.first);
      await tester.pumpAndSettle();

      // Now Vazirabad
      expect(container.read(selectedLocalityProvider).localityId, equals('loc_vazirabad'));
    });

    testWidgets('T-01: renders 7-district regional corridor selector and switches district', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: LocalitySelectorSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify district options are rendered
      expect(find.text('Nanded'), findsWidgets);
      expect(find.text('Parbhani'), findsWidgets);
      expect(find.text('Latur'), findsWidgets);
      expect(find.text('Hingoli'), findsWidgets);
      expect(find.text('Chhatrapati Sambhajinagar'), findsWidgets);
      expect(find.text('Nagpur'), findsWidgets);
      expect(find.text('Nizamabad'), findsWidgets);

      // Tap on Parbhani district
      await tester.tap(find.text('Parbhani').first);
      await tester.pumpAndSettle();

      // Verify district switched
      expect(container.read(selectedDistrictProvider).name, equals('Parbhani'));
    });

    testWidgets('T-01: switching district updates topArtisansProvider to localized verified roster', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: LocalitySelectorSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially Nanded artisans
      final nandedArtisans = container.read(topArtisansProvider);
      expect(nandedArtisans.every((a) => a.cityId == 'city_nanded_01'), isTrue);
      expect(nandedArtisans.first.name, equals('Ganesh Kadam'));

      // Switch to Nagpur
      final nagpurChip = find.text('Nagpur').first;
      await tester.ensureVisible(nagpurChip);
      await tester.pumpAndSettle();
      await tester.tap(nagpurChip);
      await tester.pumpAndSettle();

      // Verify Nagpur roster
      final nagpurArtisans = container.read(topArtisansProvider);
      expect(nagpurArtisans.every((a) => a.cityId == 'dist_nagpur'), isTrue);
      expect(nagpurArtisans.first.name, equals('Chetan Meshram'));

      // Switch to Nizamabad
      final nizamabadChip = find.text('Nizamabad').first;
      await tester.ensureVisible(nizamabadChip);
      await tester.pumpAndSettle();
      await tester.tap(nizamabadChip);
      await tester.pumpAndSettle();

      // Verify Nizamabad roster
      final nizamabadArtisans = container.read(topArtisansProvider);
      expect(nizamabadArtisans.every((a) => a.cityId == 'dist_nizamabad'), isTrue);
      expect(nizamabadArtisans.first.name, equals('K. Srinivas Rao'));
    });
  });
}
