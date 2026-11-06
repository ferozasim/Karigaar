import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/features/shared/widgets/locality_selector_sheet.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
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
          child: const MaterialApp(
            home: Scaffold(
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
  });
}
