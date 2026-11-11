import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/shared/widgets/locality_selector_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestWidget(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: LocalitySelectorSheet(),
        ),
      ),
    );
  }

  group('LocalitySelectorSheet Step-by-Step District Test', () {
    testWidgets('Initial render of LocalitySelectorSheet does not overflow', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      final exc = tester.takeException();
      expect(exc, isNull, reason: 'Initial render threw: $exc');
    });

    for (final distName in [
      'Nanded',
      'Parbhani',
      'Latur',
      'Hingoli',
      'Chhatrapati Sambhajinagar',
      'Nagpur',
      'Nizamabad',
    ]) {
      testWidgets('Tapping district chip $distName', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(buildTestWidget(container));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        final chipFinder = find.text(distName).first;
        final hScrollFinder = find.byType(SingleChildScrollView).first;
        if (hScrollFinder.evaluate().isNotEmpty) {
          await tester.scrollUntilVisible(
            chipFinder,
            50.0,
            scrollable: find.descendant(of: hScrollFinder, matching: find.byType(Scrollable)).first,
          ).catchError((_) {});
        }
        await tester.pumpAndSettle();
        await tester.tap(chipFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        final exc = tester.takeException();
        expect(exc, isNull, reason: 'Tapping $distName caused layout overflow or exception: $exc');
      });
    }
  });
}
