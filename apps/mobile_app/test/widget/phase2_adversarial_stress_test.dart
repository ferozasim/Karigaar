import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:karigaar_app/core/models/user_role.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/auth/artisan_registration_screen.dart';
import 'package:karigaar_app/features/customer/bookings/customer_bookings_screen.dart';
import 'package:karigaar_app/features/customer/home/customer_home_screen.dart';
import 'package:karigaar_app/features/customer/messages/customer_messages_screen.dart';
import 'package:karigaar_app/features/customer/profile/customer_profile_screen.dart';
import 'package:karigaar_app/features/artisan/radar/artisan_job_radar_screen.dart';
import 'package:karigaar_app/features/artisan/active_job/artisan_active_job_screen.dart';

void main() {
  Widget wrapWithTheme(
    Widget screen, {
    double textScale = 1.0,
    ProviderContainer? container,
  }) {
    final app = MaterialApp(
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(textScale),
            ),
            child: screen,
          );
        },
      ),
    );

    if (container != null) {
      return UncontrolledProviderScope(
        container: container,
        child: app,
      );
    }
    return ProviderScope(child: app);
  }

  Future<void> setViewport(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('Adversarial Viewport Stress Tests (320x568, 360x800, 390x844)', () {
    const viewports = [
      Size(320, 568), // Ultra-compact mobile (iPhone SE 1st gen / small Android)
      Size(360, 800), // Standard budget Android
      Size(390, 844), // Modern iPhone (iPhone 12/13/14)
    ];

    for (final size in viewports) {
      final desc = '${size.width.toInt()}x${size.height.toInt()}';

      testWidgets('CustomerHomeScreen renders cleanly at $desc without RenderFlex overflow', (tester) async {
        await setViewport(tester, size);
        await tester.pumpWidget(wrapWithTheme(const CustomerHomeScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Scroll down through all sections
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('CustomerBookingsScreen renders cleanly at $desc across tabs', (tester) async {
        await setViewport(tester, size);
        await tester.pumpWidget(wrapWithTheme(const CustomerBookingsScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Switch to Completed tab via ChoiceChip
        final completedChip = find.widgetWithText(ChoiceChip, 'Completed');
        await tester.ensureVisible(completedChip);
        await tester.pumpAndSettle();
        await tester.tap(completedChip);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Switch to Upcoming tab via ChoiceChip
        final upcomingChip = find.widgetWithText(ChoiceChip, 'Upcoming');
        await tester.ensureVisible(upcomingChip);
        await tester.pumpAndSettle();
        await tester.tap(upcomingChip);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('CustomerMessagesScreen renders and composes at $desc', (tester) async {
        await setViewport(tester, size);
        await tester.pumpWidget(wrapWithTheme(const CustomerMessagesScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.enterText(find.byType(TextField), 'Test message at $desc');
        await tester.tap(find.text('Send'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('CustomerProfileScreen renders cleanly at $desc', (tester) async {
        await setViewport(tester, size);
        await tester.pumpWidget(wrapWithTheme(const CustomerProfileScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('ArtisanRegistrationScreen renders all 4 steps at $desc without RenderFlex overflow', (tester) async {
        await setViewport(tester, size);
        await tester.pumpWidget(wrapWithTheme(const ArtisanRegistrationScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Step 1 -> Step 2
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Select Primary Trade'), findsOneWidget);

        // Step 2 -> Step 3
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Step 3 of 4: KYC & Tools Audit'), findsOneWidget);

        // Step 3 -> Step 4
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Verify via WhatsApp OTP'), findsOneWidget);
      });

      testWidgets('ArtisanJobRadarScreen & ArtisanActiveJobScreen render cleanly at $desc', (tester) async {
        await setViewport(tester, size);
        await tester.pumpWidget(wrapWithTheme(const ArtisanJobRadarScreen()));
        await tester.pump(const Duration(milliseconds: 200));
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(wrapWithTheme(const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Adversarial Font Scaling (1.5x & 2.0x TextScaler) Stress Tests', () {
    const scales = [1.5, 2.0];

    for (final scale in scales) {
      testWidgets('ArtisanRegistrationScreen Step 1 & Action Dock survive ${scale}x font scaling', (tester) async {
        await setViewport(tester, const Size(360, 800));
        await tester.pumpWidget(wrapWithTheme(const ArtisanRegistrationScreen(), textScale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        expect(find.text('Next Step'), findsOneWidget);
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('CustomerHomeScreen and Discovery cards survive ${scale}x font scaling', (tester) async {
        await setViewport(tester, const Size(360, 800));
        await tester.pumpWidget(wrapWithTheme(const CustomerHomeScreen(), textScale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('CustomerBookingsScreen chips and action buttons survive ${scale}x font scaling', (tester) async {
        await setViewport(tester, const Size(360, 800));
        await tester.pumpWidget(wrapWithTheme(const CustomerBookingsScreen(), textScale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('CustomerMessagesScreen message bubbles and composer survive ${scale}x font scaling', (tester) async {
        await setViewport(tester, const Size(360, 800));
        await tester.pumpWidget(wrapWithTheme(const CustomerMessagesScreen(), textScale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Artisan Registration Wizard Extreme Form Inputs & Validation Stress Tests', () {
    testWidgets('Empty and short input validation guards prevent Step 1 advance', (tester) async {
      await setViewport(tester, const Size(360, 800));
      await tester.pumpWidget(wrapWithTheme(const ArtisanRegistrationScreen()));
      await tester.pumpAndSettle();

      // Clear the name field (first TextField)
      final nameField = find.byType(TextField).at(0);
      await tester.enterText(nameField, '');
      await tester.pumpAndSettle();

      // Tap Next Step -> Should be blocked and show SnackBar
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full Aadhaar name and 10-digit mobile number.'), findsOneWidget);
      expect(find.text('Step 1 of 4: Personal Details'), findsOneWidget);
      expect(find.text('Select Primary Trade'), findsNothing);

      // Enter valid name, but malformed phone number (only 5 digits)
      await tester.enterText(nameField, 'Ramesh Sharma');
      final phoneField = find.byType(TextField).at(1);
      await tester.enterText(phoneField, '98220');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full Aadhaar name and 10-digit mobile number.'), findsOneWidget);
      expect(find.text('Select Primary Trade'), findsNothing);
    });

    testWidgets('Adversarial inputs (150+ chars, emojis, script characters, symbols) do not crash Step 1', (tester) async {
      await setViewport(tester, const Size(360, 800));
      await tester.pumpWidget(wrapWithTheme(const ArtisanRegistrationScreen()));
      await tester.pumpAndSettle();

      const adversarialName = 'डॉ. रमेशचंद्र शंकाराचार्य-शर्मा ⚡🔧 𝕶𝖆𝖗𝖎𝖌𝖆𝖆𝖗 🌟 LongLongLongLongLongLongLongLongNameThatExceedsNormalScreenMarginsAndMightCauseWrapIssue99999';
      final nameField = find.byType(TextField).at(0);
      await tester.enterText(nameField, adversarialName);

      const adversarialEmergency = 'सुरेश (भाऊ) 🔥 9999999999 #!@%^&*()';
      final emergencyField = find.byType(TextField).at(2);
      await tester.enterText(emergencyField, adversarialEmergency);

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Successfully advance to Step 2
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Select Primary Trade'), findsOneWidget);
    });

    testWidgets('Rapid trade switching across all 10 launch trades in Step 2', (tester) async {
      await setViewport(tester, const Size(360, 800));
      await tester.pumpWidget(wrapWithTheme(const ArtisanRegistrationScreen(initialStep: 2)));
      await tester.pumpAndSettle();

      expect(find.text('Select Primary Trade'), findsOneWidget);

      final tradesToTap = [
        'Plumbing',
        'Carpenter',
        'Mason / Gawandi',
        'Painter',
        'AC & Refrigeration',
        'Appliance Repair',
        'Welder',
        'Pest Control',
        'Deep Cleaning',
        'Electrician',
      ];

      for (final tradeName in tradesToTap) {
        final tradeWidget = find.text(tradeName);
        await tester.ensureVisible(tradeWidget);
        await tester.pumpAndSettle();
        await tester.tap(tradeWidget, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Verify sub-trade chips render for Electrician
      expect(find.text('Certified Skills for Electrician'), findsOneWidget);
      expect(find.text('3-Phase Commercial'), findsOneWidget);
    });

    testWidgets('Step 3 Aadhaar validation guards and tools checklist toggle', (tester) async {
      await setViewport(tester, const Size(360, 800));
      await tester.pumpWidget(wrapWithTheme(const ArtisanRegistrationScreen(initialStep: 3)));
      await tester.pumpAndSettle();

      expect(find.text('Step 3 of 4: KYC & Tools Audit'), findsOneWidget);

      // Test short Aadhaar rejection (<12 digits)
      final aadhaarField = find.byType(TextField).at(0);
      await tester.enterText(aadhaarField, '1234');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid 12-digit Aadhaar number.'), findsOneWidget);
      expect(find.text('Verify via WhatsApp OTP'), findsNothing);

      // Fix Aadhaar to 12 digits and dismiss SnackBar so it does not intercept taps
      await tester.enterText(aadhaarField, '5482 9104 2291');
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).hideCurrentSnackBar();
      await tester.pumpAndSettle();

      // Toggle photo upload card
      await tester.tap(find.text('Aadhaar Front Scan Captured'));
      await tester.pumpAndSettle();
      expect(find.text('Capture Front of Aadhaar Card'), findsOneWidget);

      await tester.tap(find.text('Capture Front of Aadhaar Card'));
      await tester.pumpAndSettle();
      expect(find.text('Aadhaar Front Scan Captured'), findsOneWidget);

      // Tap DigiLocker gateway button
      await tester.tap(find.text('DigiLocker'));
      await tester.pumpAndSettle();
      expect(find.text('DigiLocker KYC Gateway synced successfully!'), findsOneWidget);

      // Advance to Step 4
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();
      expect(find.text('Step 4 of 4: Payout & Protection'), findsOneWidget);
    });

    testWidgets('Step 4 UPI VPA dynamic verification and final registration dispatch', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/register',
        routes: [
          GoRoute(
            path: '/register',
            builder: (context, state) => const ArtisanRegistrationScreen(initialStep: 4),
          ),
          GoRoute(
            path: '/otp-verify',
            builder: (context, state) => const Scaffold(body: Text('Mock OTP Screen')),
          ),
        ],
      );

      await setViewport(tester, const Size(360, 800));
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.lightTheme,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Step 4 of 4: Payout & Protection'), findsOneWidget);
      expect(find.text('Penny-Drop Verified'), findsOneWidget);

      // Find UPI field (4th TextField in Step 4: accountNo, reAccountNo, ifsc, upi)
      final upiField = find.byType(TextField).at(3);
      await tester.enterText(upiField, 'invalidupinodat');
      await tester.pumpAndSettle();
      expect(find.text('Pending'), findsOneWidget);

      // Enter UPI with '@' -> Penny-Drop Verified
      await tester.enterText(upiField, 'artisan.guild@upi');
      await tester.pumpAndSettle();
      expect(find.text('Penny-Drop Verified'), findsOneWidget);

      // Tap "Verify via WhatsApp OTP"
      final submitBtn = find.text('Verify via WhatsApp OTP');
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Verify userRoleProvider changed to UserRole.artisan and routed to /otp-verify
      expect(container.read(userRoleProvider), UserRole.artisan);
      expect(find.text('Mock OTP Screen'), findsOneWidget);
    });

    testWidgets('Rapid forward and backward step cycling (20x) does not corrupt state or cause crash', (tester) async {
      await setViewport(tester, const Size(360, 800));
      await tester.pumpWidget(wrapWithTheme(const ArtisanRegistrationScreen()));
      await tester.pumpAndSettle();

      // Cycle Step 1 -> Step 2 -> Back -> Step 2 -> Back repeatedly
      for (var i = 0; i < 10; i++) {
        await tester.tap(find.text('Next Step'));
        await tester.pump(const Duration(milliseconds: 30));
        expect(find.text('Select Primary Trade'), findsOneWidget);

        await tester.tap(find.text('Back'));
        await tester.pump(const Duration(milliseconds: 30));
        expect(find.text('Step 1 of 4: Personal Details'), findsOneWidget);
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
