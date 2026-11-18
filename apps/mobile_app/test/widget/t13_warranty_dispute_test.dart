import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/customer/bookings/customer_bookings_screen.dart';

void main() {
  Future<void> openCompletedBookings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const CustomerBookingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Completed'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
  }

  testWidgets('completed booking exposes CSAT and warranty claim actions',
      (tester) async {
    await openCompletedBookings(tester);

    expect(find.byKey(const Key('csat_BK_NANDED_8412')), findsOneWidget);
    expect(
        find.byKey(const Key('warranty_claim_BK_NANDED_8412')), findsOneWidget);
    await tester.tap(find.byKey(const Key('warranty_claim_BK_NANDED_8412')));
    await tester.pumpAndSettle();
    expect(find.text('30-day warranty claim'), findsOneWidget);
    expect(find.textContaining('₹250 deductible'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('customer can submit post-job satisfaction ratings',
      (tester) async {
    await openCompletedBookings(tester);
    await tester.tap(find.byKey(const Key('csat_BK_NANDED_8412')));
    await tester.pumpAndSettle();

    expect(find.text('How was the service?'), findsOneWidget);
    await tester.tap(find.text('Submit rating'));
    await tester.pumpAndSettle();
    expect(find.text('How was the service?'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
