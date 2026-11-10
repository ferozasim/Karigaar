import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/user_role.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/shared/widgets/mode_switcher_pill.dart';

void main() {
  group('ModeSwitcherPill Widget Tests', () {
    testWidgets('renders Homeowner and Artisan mode buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ModeSwitcherPill(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Homeowner Mode'), findsOneWidget);
      expect(find.text('Artisan Mode'), findsOneWidget);
    });

    testWidgets('renders compact labels when compact is true', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ModeSwitcherPill(compact: true),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Homeowner'), findsOneWidget);
      expect(find.text('Karigaar'), findsOneWidget);
    });

    testWidgets('toggles userRoleProvider state on tap', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ModeSwitcherPill(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial role is customer
      expect(container.read(userRoleProvider), equals(UserRole.customer));

      // Tap Artisan Mode
      await tester.tap(find.text('Artisan Mode'));
      await tester.pumpAndSettle();

      expect(container.read(userRoleProvider), equals(UserRole.artisan));

      // Tap Homeowner Mode
      await tester.tap(find.text('Homeowner Mode'));
      await tester.pumpAndSettle();

      expect(container.read(userRoleProvider), equals(UserRole.customer));
    });
  });
}
