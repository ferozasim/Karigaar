import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/customer/scoping/service_scoping_screen.dart';
import 'package:karigaar_app/features/artisan/active_job/artisan_active_job_screen.dart';
import 'package:karigaar_app/features/customer/tracking/live_tracking_screen.dart';

void main() {
  Widget buildApp(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );
  }

  group('Ticket T-05: Payment Gateway & Escrow Widget Integration Tests', () {
    testWidgets('1. ServiceScopingScreen: Tapping Request Artisan presents ₹99 UPI Mandate Sheet with app chips', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildApp(const ServiceScopingScreen(tradeId: 'trade_electrician')));
      await tester.pumpAndSettle();

      final requestBtn = find.text('Request Artisan');
      expect(requestBtn, findsOneWidget);
      await tester.tap(requestBtn);
      await tester.pumpAndSettle();

      expect(find.text('Upfront ₹99 Standby Mandate'), findsOneWidget);
      expect(find.text('Razorpay / Cashfree UPI Autopay Protected'), findsOneWidget);
      expect(find.textContaining('Secures ₹99 standby transit fee hold'), findsOneWidget);

      expect(find.text('GPay'), findsOneWidget);
      expect(find.text('PhonePe'), findsOneWidget);
      expect(find.text('Paytm'), findsOneWidget);

      // Tap PhonePe chip
      await tester.tap(find.text('PhonePe'));
      await tester.pumpAndSettle();
      expect(find.text('customer@ybl'), findsOneWidget);

      // Tap CTA to authorize mandate
      final authBtn = find.text('Authorize ₹99 Mandate & Request Artisan');
      expect(authBtn, findsOneWidget);
      await tester.tap(authBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('2. ArtisanActiveJobScreen: Doorstep Access Denial respects 15m dwell invariant', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildApp(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();

      final denialBtn = find.text('Doorstep Access Denied (Claim ₹80 Transit)');
      expect(denialBtn, findsOneWidget);

      // Initially dwell is 16m. Decrement twice to 14m (< 15m)
      final decBtn = find.byKey(const Key('dwell_decrement_btn'));
      await tester.tap(decBtn);
      await tester.pumpAndSettle();
      await tester.tap(decBtn);
      await tester.pumpAndSettle();

      expect(find.text('Doorstep Dwell: 14m (Min 15m for denial)'), findsOneWidget);

      // Tapping denial button at 14m should show rejection snackbar
      await tester.tap(denialBtn);
      await tester.pumpAndSettle();
      expect(find.textContaining('at least 15 minutes dwell time'), findsOneWidget);

      // Increment dwell back to 16m
      final incBtn = find.byKey(const Key('dwell_increment_btn'));
      await tester.tap(incBtn);
      await tester.pumpAndSettle();
      await tester.tap(incBtn);
      await tester.pumpAndSettle();

      expect(find.text('Doorstep Dwell: 16m (Min 15m for denial)'), findsOneWidget);

      // Now tap denial button at 16m -> should open confirmation dialog
      await tester.tap(denialBtn);
      await tester.pumpAndSettle();

      expect(find.text('Doorstep Access Denied'), findsOneWidget);
      expect(find.textContaining('₹80.00 transit fee has been credited'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close Job'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('3. ArtisanActiveJobScreen: Dynamic Bill Builder recalculates 2% surcharge and 18% GST', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildApp(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();

      expect(find.text('Dynamic Bill Builder'), findsOneWidget);
      expect(find.text('Labor & Inspection Base'), findsOneWidget);
      expect(find.text('2% Parts Gateway Surcharge'), findsOneWidget);
      expect(find.text('18% GST (Labor & Surcharge)'), findsOneWidget);

      // Base part is Havells 32A MCB (₹380) + labor (₹249)
      // partsTotal = 380, surcharge = round(380 * 0.02) = 8
      // subtotal = 249 + 380 + 8 = 637
      // gst18 = round(637 * 0.18) = 115
      // totalBill = 637 + 115 = 752
      expect(find.text('+₹8'), findsOneWidget);
      expect(find.text('+₹115'), findsOneWidget);
      expect(find.text('₹752'), findsOneWidget);

      // Tap Add Part (adds Finolex Wire ₹220)
      final addPartBtn = find.text('Add Part');
      await tester.ensureVisible(addPartBtn);
      await tester.pumpAndSettle();
      await tester.tap(addPartBtn);
      await tester.pumpAndSettle();

      // partsTotal = 380 + 220 = 600
      // surcharge = round(600 * 0.02) = 12
      // subtotal = 249 + 600 + 12 = 861
      // gst18 = round(861 * 0.18) = 155
      // totalBill = 861 + 155 = 1016
      expect(find.text('+₹12'), findsOneWidget);
      expect(find.text('+₹155'), findsOneWidget);
      expect(find.text('₹1016'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('4. ArtisanActiveJobScreen: Decoupled Invoice Submission invokes submitDecoupledInvoice', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildApp(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();

      final submitInvoiceBtn = find.text('Submit Itemized Invoice (Decoupled)');
      expect(submitInvoiceBtn, findsOneWidget);
      await tester.ensureVisible(submitInvoiceBtn);
      await tester.pumpAndSettle();

      await tester.tap(submitInvoiceBtn);
      await tester.pumpAndSettle();

      expect(find.text('Itemized Invoice Submitted • Waiting Customer PIN'), findsOneWidget);
      expect(find.textContaining('Itemized Invoice Submitted!'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('5. ArtisanActiveJobScreen: Guild Wallet displays locked ₹2,000 reserve and enforces withdrawal limit', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildApp(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();

      final walletHeader = find.text('Guild Wallet');
      await tester.ensureVisible(walletHeader);
      await tester.pumpAndSettle();

      expect(find.text('LOCKED RESERVE'), findsOneWidget);
      expect(find.text('₹2,000.00'), findsOneWidget);
      expect(find.text('AVAILABLE PAYOUT'), findsOneWidget);
      expect(find.text('₹2620.00'), findsOneWidget);

      // Open withdrawal dialog
      final withdrawBtn = find.text('Withdraw to Bank via UPI / IMPS (₹0 Fee)');
      await tester.ensureVisible(withdrawBtn);
      await tester.pumpAndSettle();
      await tester.tap(withdrawBtn);
      await tester.pumpAndSettle();

      expect(find.text('Instant IMPS Payout'), findsOneWidget);
      expect(find.textContaining('Mandatory ₹2,000 rolling security reserve locked'), findsOneWidget);
      expect(find.textContaining('₹2620.00 directly to verified HDFC vault'), findsOneWidget);

      // Confirm IMPS Payout
      await tester.tap(find.text('Confirm IMPS Payout'));
      await tester.pumpAndSettle();

      // Cleared balance hero card must show exactly remaining ₹2000.00 (not drained to 0)
      expect(find.text('₹2000.00'), findsOneWidget);
      expect(find.text('₹2,000.00'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('6. LiveTrackingScreen: Displays Doorstep Dwell Warning and Customer Invoice Review Sheet', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Override active booking with arrived state and dwell minutes
      final arrivedBooking = BookingModel(
        bookingId: 'BK_NANDED_8821',
        customerId: 'cust_01',
        customerName: 'Asim Farooqui',
        customerPhone: '+919822199882',
        tradeId: 'trade_electrician',
        tradeName: 'Electrician',
        localityId: 'loc_anand_nagar',
        localityName: 'Anand Nagar, Nanded',
        address: 'Plot 14, Anand Nagar',
        status: BookingStatus.artisanArrived,
        dwellMinutesAtDestination: 16,
        parts: const [
          BillPartItem(
            id: 'p1',
            name: 'Havells 32A Double Pole MCB',
            unitPrice: 380,
            quantity: 1,
            receiptPhotoUrl: 'receipt.jpg',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      );

      await tester.pumpWidget(
        buildApp(
          const LiveTrackingScreen(bookingId: 'BK_NANDED_8821'),
          overrides: [
            activeBookingProvider.overrideWith((ref) => arrivedBooking),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Verify Doorstep Dwell Warning Card
      expect(find.byKey(const Key('doorstep_dwell_warning_card')), findsOneWidget);
      expect(find.textContaining('Doorstep Arrival Dwell Warning (16m)'), findsOneWidget);
      expect(find.textContaining('Standby ₹99 transit fee applies'), findsOneWidget);

      // Verify Customer Invoice Review Card
      expect(find.byKey(const Key('customer_invoice_review_card')), findsOneWidget);
      expect(find.text('Customer Invoice Review'), findsOneWidget);
      expect(find.text('YOUR 4-DIGIT COMPLETION OTP'), findsOneWidget);
      expect(find.text('7294'), findsOneWidget);

      // Tap Review Detailed Invoice button
      final reviewBtn = find.text('Review Detailed Invoice & Release OTP');
      await tester.ensureVisible(reviewBtn);
      await tester.pumpAndSettle();
      await tester.tap(reviewBtn);
      await tester.pumpAndSettle();

      expect(find.text('Itemized Service Invoice'), findsOneWidget);
      expect(find.textContaining('Havells 32A Double Pole MCB'), findsAtLeastNWidgets(1));
      expect(find.text('2% Parts Payment Gateway Surcharge'), findsOneWidget);

      // Tap Verify & Release Completion OTP
      final releaseBtn = find.text('Verify & Release Completion OTP (7294)');
      await tester.tap(releaseBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('Completion Verified! Standby ₹99 mandate released'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('7. Layout compliance: Clean rendering across mobile viewports 360x800 and 320x568', (tester) async {
      for (final size in [const Size(360, 800), const Size(320, 568)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(buildApp(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Must not throw layout overflow on size $size');
      }
      tester.view.resetPhysicalSize();
    });
  });
}
