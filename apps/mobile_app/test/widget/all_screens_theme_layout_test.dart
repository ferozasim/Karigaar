import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/main.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/auth/artisan_registration_screen.dart';
import 'package:karigaar_app/features/auth/login_screen.dart';
import 'package:karigaar_app/features/auth/otp_verification_screen.dart';
import 'package:karigaar_app/features/customer/bookings/customer_bookings_screen.dart';
import 'package:karigaar_app/features/customer/home/customer_home_screen.dart';
import 'package:karigaar_app/features/customer/messages/customer_messages_screen.dart';
import 'package:karigaar_app/features/customer/scoping/service_scoping_screen.dart';
import 'package:karigaar_app/features/customer/profile/artisan_profile_screen.dart';
import 'package:karigaar_app/features/customer/profile/customer_profile_screen.dart';
import 'package:karigaar_app/features/customer/tracking/live_tracking_screen.dart';
import 'package:karigaar_app/features/artisan/radar/artisan_job_radar_screen.dart';
import 'package:karigaar_app/features/artisan/active_job/artisan_active_job_screen.dart';

void main() {
  Widget wrapWithAppTheme(Widget screen) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: screen,
      ),
    );
  }

  Future<void> setMobileViewport(WidgetTester tester, {Size size = const Size(360, 800)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('All Screens Layout & AppTheme Constraint Regression Tests', () {
    testWidgets('LoginScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Continue with WhatsApp'), findsOneWidget);
    });

    testWidgets('OtpVerificationScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const OtpVerificationScreen(phone: '9822199882')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
      expect(find.text('Verify & Continue'), findsOneWidget);
    });

    testWidgets('CustomerHomeScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const CustomerHomeScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Book Fast'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Book Artisan'), findsWidgets);
    });

    testWidgets('ServiceScopingScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const ServiceScopingScreen(tradeId: 'trade_electrician')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Request Artisan'), findsOneWidget);
    });

    testWidgets('ArtisanProfileScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanProfileScreen(artisanId: 'art_nanded_01')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Book Ganesh Now'), findsOneWidget);
    });

    testWidgets('LiveTrackingScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const LiveTrackingScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Live Dispatch Radar'), findsOneWidget);
    });

    testWidgets('ArtisanJobRadarScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanJobRadarScreen()));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
      expect(find.text('Ask Customer'), findsOneWidget);
      expect(find.textContaining('CLAIM JOB NOW'), findsOneWidget);
    });

    testWidgets('ArtisanActiveJobScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('ON-SITE REPAIR STOPWATCH'), findsOneWidget);
    });

    testWidgets('ArtisanRegistrationScreen renders with AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanRegistrationScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Join the Karigaar Guild'), findsWidgets);
      expect(find.text('Next Step'), findsOneWidget);

      // Advance through all 4 wizard steps
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();
      expect(find.text('Select Primary Trade'), findsOneWidget);

      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();
      expect(find.text('Step 3 of 4: KYC & Tools Audit'), findsOneWidget);

      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();
      expect(find.text('Verify via WhatsApp OTP'), findsOneWidget);
    });

    testWidgets('CustomerBookingsScreen renders and filters tabs under AppTheme.lightTheme', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const CustomerBookingsScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('My Service Bookings'), findsOneWidget);
      expect(find.text('Track Live'), findsOneWidget);

      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Book Again'), findsWidgets);
    });

    testWidgets('CustomerMessagesScreen renders and sends messages under AppTheme.lightTheme', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const CustomerMessagesScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Guild Masked Chat & WhatsApp'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Gate pass approved at society gate.');
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Gate pass approved at society gate.', skipOffstage: false), findsOneWidget);
    });

    testWidgets('CustomerProfileScreen renders under AppTheme.lightTheme without layout errors', (tester) async {
      await tester.pumpWidget(wrapWithAppTheme(const CustomerProfileScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Homeowner Profile & Settings'), findsOneWidget);
      expect(find.text('Asim Farooqui'), findsOneWidget);
    });
  });

  group('Mobile Portrait Viewport (360x800) & Soft Keyboard Stress Tests', () {
    testWidgets('All 8 screens render cleanly on a 360x800 narrow mobile screen without overflow', (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      // 1. LoginScreen
      await tester.pumpWidget(wrapWithAppTheme(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 2. OtpVerificationScreen (including compact height simulating open soft keyboard: 360x420)
      await setMobileViewport(tester, size: const Size(360, 420));
      await tester.pumpWidget(wrapWithAppTheme(const OtpVerificationScreen(phone: '9822199882')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);

      // Restore 360x800
      await setMobileViewport(tester, size: const Size(360, 800));

      // 3. CustomerHomeScreen
      await tester.pumpWidget(wrapWithAppTheme(const CustomerHomeScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 4. ServiceScopingScreen
      await tester.pumpWidget(wrapWithAppTheme(const ServiceScopingScreen(tradeId: 'trade_plumber')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 5. ArtisanProfileScreen
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanProfileScreen(artisanId: 'art_nanded_01')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 6. LiveTrackingScreen
      await tester.pumpWidget(wrapWithAppTheme(const LiveTrackingScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 7. ArtisanJobRadarScreen
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanJobRadarScreen()));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);

      // 8. ArtisanActiveJobScreen
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 9. ArtisanRegistrationScreen
      await tester.pumpWidget(wrapWithAppTheme(const ArtisanRegistrationScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 10. CustomerBookingsScreen
      await tester.pumpWidget(wrapWithAppTheme(const CustomerBookingsScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 11. CustomerMessagesScreen
      await tester.pumpWidget(wrapWithAppTheme(const CustomerMessagesScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 12. CustomerProfileScreen
      await tester.pumpWidget(wrapWithAppTheme(const CustomerProfileScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Full KarigaarApp GoRouter end-to-end Customer & Artisan flows work on 360x800 mobile screen', (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(const ProviderScope(child: KarigaarApp()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Starts at /login
      expect(find.text('Continue with WhatsApp'), findsOneWidget);
      await tester.tap(find.text('Continue with WhatsApp'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Now on /otp-verify
      expect(find.text('Verify & Continue'), findsOneWidget);
      await tester.tap(find.text('Verify & Continue'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Now on /customer/home
      expect(find.text('10 Launch Trades'), findsOneWidget);
      await tester.tap(find.text('Book Fast'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Now on /customer/service/trade_electrician
      expect(find.text('Request Artisan'), findsOneWidget);
      await tester.tap(find.text('Request Artisan'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final authBtn = find.text('Authorize ₹99 Mandate & Request Artisan');
      if (authBtn.evaluate().isNotEmpty) {
        await tester.tap(authBtn);
        await tester.pumpAndSettle();
      }

      // Now on /customer/active-tracking/BK_NANDED_8821
      expect(find.text('Live Dispatch Radar'), findsOneWidget);
      expect(find.text('4921'), findsOneWidget);

      // Navigate back to /customer/home and switch to Karigaar (Artisan) mode
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Karigaar'), findsOneWidget);

      await tester.tap(find.text('Karigaar'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Now on /artisan/radar
      expect(find.text('Nanded Trade Guild'), findsOneWidget);
      expect(find.textContaining('CLAIM JOB NOW'), findsOneWidget);

      // Tap CLAIM JOB NOW -> /artisan/active-job/BK_NANDED_8821
      await tester.ensureVisible(find.textContaining('CLAIM JOB NOW'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.textContaining('CLAIM JOB NOW'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('ON-SITE REPAIR STOPWATCH'), findsOneWidget);
    });
  });
}
