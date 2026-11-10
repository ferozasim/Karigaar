import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/artisan/active_job/artisan_active_job_screen.dart';

void main() {
  Widget createWidgetUnderTest({String bookingId = 'BK_NANDED_8821'}) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: ArtisanActiveJobScreen(bookingId: bookingId),
      ),
    );
  }

  group('Screen 7: Partner Active Job & Guild Wallet Tests', () {
    testWidgets('renders active job repair stopwatch and Start Code input field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('ON-SITE REPAIR STOPWATCH'), findsOneWidget);
      expect(find.text('28m 14s Elapsed'), findsOneWidget);
      expect(find.text('Step 1: Enter Customer Start Code'), findsOneWidget);
      expect(find.text('Enter 4-digit Start Code'), findsOneWidget);
    });

    testWidgets('verifying start code 4921 unlocks repair completion state', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final input = find.widgetWithText(TextField, 'Enter 4-digit Start Code');
      await tester.enterText(input, '4921');
      await tester.tap(find.text('Verify Code & Begin Repair'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Start Code 4921 Verified'), findsOneWidget);
    });

    testWidgets('dynamic bill builder adds part and updates total', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Dynamic Bill Builder'), findsOneWidget);
      expect(find.text('Havells 32A Double Pole MCB'), findsOneWidget);

      await tester.tap(find.text('Add Part'));
      await tester.pumpAndSettle();

      expect(find.text('Finolex 2.5 sq mm Copper Wire (5m)'), findsOneWidget);
    });

    testWidgets('renders Gold Guildsman tier progress gauge and 42/50 milestone', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final tierWidget = find.text('Gold Guildsman');
      await tester.ensureVisible(tierWidget);
      await tester.pumpAndSettle();

      expect(find.text('Gold Guildsman'), findsOneWidget);
      expect(find.text('Tier Level 4 Craftsman'), findsOneWidget);
      expect(find.text('Top 5% Partner'), findsOneWidget);
      expect(find.text('42 / 50 Jobs'), findsOneWidget);
      expect(
        find.text('Only 8 jobs remaining to unlock 0% commission master tier!'),
        findsOneWidget,
      );
    });

    testWidgets('renders Guild Wallet hero card with available balance and bank vault info', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final walletHeader = find.text('Guild Wallet');
      await tester.ensureVisible(walletHeader);
      await tester.pumpAndSettle();

      expect(find.text('Guild Wallet'), findsOneWidget);
      expect(find.text('Instant IMPS Live'), findsOneWidget);
      expect(find.text('CLEARED AVAILABLE PAYOUT'), findsOneWidget);
      expect(find.text('₹4620.00'), findsOneWidget);
      expect(find.text('HDFC Bank •••• 2104'), findsOneWidget);
      expect(find.text('Verified Guild Vault'), findsOneWidget);
    });

    testWidgets('triggers Instant IMPS Withdrawal Dialog and confirms transfer', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final withdrawBtn = find.text('Withdraw to Bank via UPI / IMPS (₹0 Fee)');
      await tester.ensureVisible(withdrawBtn);
      await tester.pumpAndSettle();

      await tester.tap(withdrawBtn);
      await tester.pumpAndSettle();

      expect(find.text('Instant IMPS Payout'), findsOneWidget);
      expect(find.textContaining('HDFC Bank Limited (Nanded Main Branch)'), findsOneWidget);
      expect(find.text('Payout Fee: ₹0.00 (Guild Covered)'), findsOneWidget);

      await tester.tap(find.text('Confirm IMPS Payout'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('transferred via IMPS!'), findsOneWidget);
      expect(find.text('₹0.00'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('renders recent transaction ledger and guild guarantee note', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final recentActivity = find.text('Recent Activity');
      await tester.ensureVisible(recentActivity);
      await tester.pumpAndSettle();

      expect(find.text('Recent Activity'), findsOneWidget);
      expect(find.text('MCB & Wiring Repair'), findsOneWidget);
      expect(find.text('+₹480.00'), findsOneWidget);
      expect(find.text('Daily Payout to HDFC'), findsOneWidget);
      expect(find.text('-₹2,100.00'), findsOneWidget);
      expect(find.textContaining('Guild guarantee: Guaranteed immediate IMPS payout'), findsOneWidget);
    });
  });
}
