import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/models/user_role.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/artisan/active_job/artisan_active_job_screen.dart';
import 'package:karigaar_app/features/auth/artisan_registration_screen.dart';
import 'package:karigaar_app/features/customer/profile/artisan_profile_screen.dart';
import 'package:karigaar_app/features/customer/tracking/live_tracking_screen.dart';
import 'package:karigaar_app/features/shared/widgets/karigaar_brand_logo.dart';
import 'package:karigaar_app/features/shared/widgets/karigaar_radar_sync_skeleton.dart';
import 'package:karigaar_app/features/shared/widgets/mode_switcher_pill.dart';

void main() {
  group('Phase 1 State Synchronization & Adversarial Stress Tests', () {
    testWidgets(
      'ArtisanActiveJobScreen synchronizes Start OTP, Bill Parts, Completion PIN, and Wallet Balance with providers',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initial booking state is artisanEnRoute and wallet balance is 4620.00
        expect(container.read(activeBookingProvider)?.status, BookingStatus.artisanEnRoute);
        expect(container.read(artisanWalletBalanceProvider), 4620.00);

        // 1. Verify Start OTP (4921) updates activeBookingProvider to workInProgress
        final startInput = find.widgetWithText(TextField, 'Enter 4-digit Start Code');
        await tester.enterText(startInput, '4921');
        await tester.tap(find.text('Verify Code & Begin Repair'));
        await tester.pumpAndSettle();

        expect(container.read(activeBookingProvider)?.status, BookingStatus.workInProgress);
        expect(container.read(activeBookingProvider)?.arrivalTime, isNotNull);

        // 2. Add Part updates activeBookingProvider parts list
        await tester.tap(find.text('Add Part'));
        await tester.pumpAndSettle();

        expect(container.read(activeBookingProvider)?.parts.length, 2);

        // Total bill with 2% parts surcharge and 18% GST = 1016
        expect(find.text('₹1016'), findsOneWidget);

        // 3. Enter Completion PIN (7294) transitions status to settled and credits wallet
        final completionInput = find.widgetWithText(TextField, 'Enter 4-digit Completion PIN');
        await tester.ensureVisible(completionInput);
        await tester.pumpAndSettle();
        await tester.enterText(completionInput, '7294');

        final finishBtn = find.textContaining('Finish Job & Claim ₹1016');
        await tester.ensureVisible(finishBtn);
        await tester.pumpAndSettle();
        await tester.tap(finishBtn);
        await tester.pumpAndSettle();

        expect(container.read(activeBookingProvider)?.status, BookingStatus.settled);
        expect(container.read(activeBookingProvider)?.completionTime, isNotNull);
        expect(container.read(artisanWalletBalanceProvider), 4620.00 + 1016.00);
        expect(find.text('IMPS Payout Settled!'), findsOneWidget);
      },
    );

    testWidgets(
      'Guild Wallet prevents duplicate/zero-balance IMPS withdrawal after balance is drained',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            artisanWalletBalanceProvider.overrideWith((ref) => 0.00),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const ArtisanActiveJobScreen(bookingId: 'BK_NANDED_8821'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final withdrawBtn = find.text('Withdraw to Bank via UPI / IMPS (₹0 Fee)');
        await tester.ensureVisible(withdrawBtn);
        await tester.pumpAndSettle();
        await tester.tap(withdrawBtn);
        await tester.pumpAndSettle();

        // Should show guard SnackBar instead of opening confirmation dialog
        expect(find.text('No cleared balance available for withdrawal.'), findsOneWidget);
        expect(find.text('Confirm IMPS Payout'), findsNothing);
      },
    );

    testWidgets(
      'LiveTrackingScreen milestones dynamically reflect BookingStatus changes',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const LiveTrackingScreen(bookingId: 'BK_NANDED_8821'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Default status is artisanEnRoute -> 'Live tracking active'
        expect(find.text('Live tracking active'), findsOneWidget);

        // Transition to workInProgress
        final current = container.read(activeBookingProvider)!;
        container.read(activeBookingProvider.notifier).state = current.copyWith(
          status: BookingStatus.workInProgress,
        );
        await tester.pumpAndSettle();

        expect(find.text('Handshake verified'), findsOneWidget);
        expect(find.text('Repair in progress'), findsOneWidget);

        // Transition to settled
        container.read(activeBookingProvider.notifier).state = current.copyWith(
          status: BookingStatus.settled,
        );
        await tester.pumpAndSettle();

        expect(find.text('IMPS payout settled'), findsOneWidget);
      },
    );

    testWidgets(
      'ArtisanProfileScreen gracefully falls back to default Nanded craftsman on unknown artisanId',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const ArtisanProfileScreen(artisanId: 'non_existent_id_999'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Ganesh Kadam'), findsOneWidget);
      },
    );

    testWidgets(
      'ModeSwitcherPill survives rapid 20x toggling without state corruption or layout exception',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const Scaffold(
                body: Center(child: ModeSwitcherPill(compact: true)),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        for (var i = 0; i < 10; i++) {
          await tester.tap(find.text('Karigaar'));
          await tester.pump(const Duration(milliseconds: 50));
          expect(container.read(userRoleProvider), UserRole.artisan);

          await tester.tap(find.text('Homeowner'));
          await tester.pump(const Duration(milliseconds: 50));
          expect(container.read(userRoleProvider), UserRole.customer);
        }

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'F-34 KarigaarBrandLogo and F-33 KarigaarRadarSyncSkeleton render cleanly under AppTheme.lightTheme',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    KarigaarBrandLogo(size: 64),
                    KarigaarBrandLogo(size: 40),
                    KarigaarRadarSyncSkeleton(),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(tester.takeException(), isNull);
        expect(find.byType(KarigaarBrandLogo), findsNWidgets(2));
        expect(find.byType(KarigaarRadarSyncSkeleton), findsOneWidget);
        expect(find.text('Connecting to Karigaar Guild...'), findsOneWidget);
      },
    );

    testWidgets(
      'F-37 ArtisanRegistrationScreen supports trade selection, language toggle, and referral accordion',
      (tester) async {
        tester.view.physicalSize = const Size(800, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const ArtisanRegistrationScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Step 1 of 4: Personal Details'), findsOneWidget);
        expect(find.text('Join the Karigaar Guild'), findsWidgets);

        // Toggle language pill
        final hindiPill = find.text('हिंदी');
        await tester.tap(hindiPill, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Open Referral Code Accordion
        final toggle = find.byKey(const ValueKey('referral_code_accordion_toggle'));
        await tester.ensureVisible(toggle);
        await tester.pumpAndSettle();
        await tester.tap(toggle, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.text('Apply', skipOffstage: false), findsOneWidget);

        // Advance to Step 2: Trade Selection
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();

        // Select Plumbing trade
        final plumberTile = find.text('Plumbing');
        await tester.ensureVisible(plumberTile);
        await tester.pumpAndSettle();
        await tester.tap(plumberTile, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
