import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/shared/widgets/locality_selector_sheet.dart';

void main() {
  Widget buildTestApp({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: LocalitySelectorSheet(),
        ),
      ),
    );
  }

  group('LocalitySelectorSheet Adversarial Stress Tests', () {
    testWidgets('empty search query displays all 10 pilot city localities', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Select Locality'), findsOneWidget);
      expect(find.text('10 Hubs Active'), findsOneWidget);

      // Verify several known localities are present in the list
      expect(find.text('Anand Nagar'), findsWidgets);
      expect(find.text('Vazirabad & Sarafa'), findsWidgets);
      expect(find.text('CIDCO New Nanded'), findsWidgets);
      expect(find.text('Taroda Naka & Taroda BK'), findsWidgets);
      expect(find.text('Shivaji Nagar'), findsWidgets);
    });

    testWidgets('whitespace-only query trims cleanly and displays all localities', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, '     \t  ');
      await tester.pumpAndSettle();

      // All localities should remain visible because trim() produces empty string
      expect(find.text('Anand Nagar'), findsWidgets);
      expect(find.text('CIDCO New Nanded'), findsWidgets);
      expect(find.text('No locality found in Nanded'), findsNothing);
    });

    testWidgets('non-existent search query displays empty state and location_off icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'ZzzNonExistentLocality999');
      await tester.pumpAndSettle();

      expect(find.text('No locality found in Nanded'), findsOneWidget);
      expect(find.byIcon(Icons.location_off_rounded), findsOneWidget);
      expect(find.text('Anand Nagar'), findsNothing);
    });

    testWidgets('case-insensitive search matching (uppercase, mixed case, lowercase)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);

      // UPPERCASE
      await tester.enterText(searchField, 'CIDCO');
      await tester.pumpAndSettle();
      expect(find.text('CIDCO New Nanded'), findsOneWidget);
      expect(find.text('Anand Nagar'), findsNothing);

      // Mixed case
      await tester.enterText(searchField, 'VaZiRaBaD');
      await tester.pumpAndSettle();
      expect(find.text('Vazirabad & Sarafa'), findsOneWidget);
      expect(find.text('CIDCO New Nanded'), findsNothing);

      // Partial lowercase
      await tester.enterText(searchField, 'taroda');
      await tester.pumpAndSettle();
      expect(find.text('Taroda Naka & Taroda BK'), findsOneWidget);
    });

    testWidgets('Marathi Devanagari script search filtering', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);

      // Search 'आनंद'
      await tester.enterText(searchField, 'आनंद');
      await tester.pumpAndSettle();
      expect(find.text('Anand Nagar'), findsWidgets);
      expect(find.text('CIDCO New Nanded'), findsNothing);

      // Search 'सिडको'
      await tester.enterText(searchField, 'सिडको');
      await tester.pumpAndSettle();
      expect(find.text('CIDCO New Nanded'), findsOneWidget);
      expect(find.text('Anand Nagar'), findsNothing);

      // Search 'सराफा'
      await tester.enterText(searchField, 'सराफा');
      await tester.pumpAndSettle();
      expect(find.text('Vazirabad & Sarafa'), findsOneWidget);
    });

    testWidgets('pincode search matching', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);

      // Pincode 431602 (Anand Nagar)
      await tester.enterText(searchField, '431602');
      await tester.pumpAndSettle();
      expect(find.text('Anand Nagar'), findsWidgets);

      // Pincode 431603 (CIDCO)
      await tester.enterText(searchField, '431603');
      await tester.pumpAndSettle();
      expect(find.text('CIDCO New Nanded'), findsOneWidget);
    });

    testWidgets('adversarial inputs (Regex metacharacters, SQL injection, XSS) do not crash UI', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);

      const adversarialQueries = [
        '.*',
        '[a-z]+',
        '(',
        '\\',
        r'^$',
        '?+*',
        "' OR '1'='1",
        '<script>alert("xss")</script>',
        r'${1+1}',
        'NULL',
        '\\u0000',
      ];

      for (final query in adversarialQueries) {
        await tester.enterText(searchField, query);
        await tester.pumpAndSettle();

        // Must not crash; should show "No locality found in Nanded"
        expect(find.text('No locality found in Nanded'), findsOneWidget,
            reason: 'Adversarial query failed safely: $query');
      }
    });

    testWidgets('clear button appears when query is entered and resets search on tap', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Initially no clear button
      expect(find.byIcon(Icons.clear_rounded), findsNothing);

      // Enter query
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'vazirabad');
      await tester.pumpAndSettle();

      expect(find.text('Vazirabad & Sarafa'), findsOneWidget);
      expect(find.text('Anand Nagar'), findsNothing);

      // Clear button should now be visible
      final clearButton = find.byIcon(Icons.clear_rounded);
      expect(clearButton, findsOneWidget);

      // Tap clear button
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Clear icon disappears and all localities reappear
      expect(find.byIcon(Icons.clear_rounded), findsNothing);
      expect(find.text('Anand Nagar'), findsWidgets);
      expect(find.text('CIDCO New Nanded'), findsWidgets);
    });

    testWidgets('tapping filtered locality selects it and updates selectedLocalityProvider', (tester) async {
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

      // Initially loc_anand_nagar
      expect(container.read(selectedLocalityProvider).localityId, equals('loc_anand_nagar'));

      // Search for degloor
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'degloor');
      await tester.pumpAndSettle();

      final degloorItem = find.text('Railway Station & Degloor Naka');
      expect(degloorItem, findsOneWidget);

      await tester.tap(degloorItem);
      await tester.pumpAndSettle();

      // Updated to Railway Station & Degloor Naka
      expect(container.read(selectedLocalityProvider).localityId, equals('loc_station_degloor'));
    });

    testWidgets('renders fallback list when pilotCityProvider throws error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          overrides: [
            pilotCityProvider.overrideWith((ref) => Future.error(Exception('Network timeout'))),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Fallback list includes Anand Nagar, Vazirabad, and CIDCO
      expect(find.text('Anand Nagar'), findsWidgets);
      expect(find.text('Vazirabad & Sarafa'), findsWidgets);
      expect(find.text('CIDCO New Nanded'), findsWidgets);
    });
  });
}
