import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:karigaar_app/core/models/radar_broadcast_model.dart';
import 'package:karigaar_app/core/services/contact_intent_service.dart';
import 'package:karigaar_app/core/services/radar_broadcast_service.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/artisan/radar/artisan_job_radar_screen.dart';

void main() {
  late KarigaarRadarBroadcastService service;

  setUp(() {
    ContactIntentService.forceSimulationForTesting = true;
    service = KarigaarRadarBroadcastService.instance;
    service.reset();
  });

  tearDown(() {
    ContactIntentService.forceSimulationForTesting = false;
    service.cancelTimer();
    service.reset();
  });

  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/radar',
      routes: [
        GoRoute(
          path: '/radar',
          builder: (context, state) => const ArtisanJobRadarScreen(),
        ),
        GoRoute(
          path: '/artisan/active-job/:bookingId',
          builder: (context, state) => const Scaffold(
            body: Text('Active Job Screen Destination'),
          ),
        ),
      ],
    );
  }

  Widget buildTestScreen({GoRouter? router}) {
    return ProviderScope(
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router ?? createTestRouter(),
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

  group('Ticket T-07: Artisan Job Radar Broadcast Widget Tests', () {
    testWidgets('1. Dynamic broadcast card renders with emergency badge, distance, and earnings',
        (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      // Broadcast card is rendered
      expect(find.byKey(const Key('radar_broadcast_card')), findsOneWidget);
      expect(find.text('EMERGENCY BREAKDOWN'), findsOneWidget);
      expect(find.text('Emergency Short Circuit & MCB Trip'), findsOneWidget);
      expect(find.text('1.2 km away • Anand Nagar, Nanded'), findsOneWidget);
      expect(find.textContaining('₹480'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2. Countdown circular progress indicator updates with remaining seconds',
        (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      // Countdown badge displays initial 45s
      expect(find.text('45s'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Simulate tick to 30s
      service.simulateCountdownTick(30);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('30s'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('3. Radius tier badge switches dynamically between 2 km and 6 km on escalation',
        (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      // Initial Tier 1 (2 km)
      expect(find.text('Primary Corridor • 2 km'), findsOneWidget);

      // Trigger Tier 1 expiry -> auto-escalates to Tier 2 (6 km)
      service.simulateExpiry();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Expanded Radar • 6 km'), findsOneWidget);
      expect(find.byKey(const Key('radar_radius_tier_chip')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('4. Renders photo and audio attachments badges when present', (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('1 Photo'), findsOneWidget);
      expect(find.text('14s Audio'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      expect(find.byIcon(Icons.mic_outlined), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('5. Tapping "Ask Customer" button triggers masked WhatsApp chat intent',
        (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      final askBtn = find.byKey(const Key('radar_ask_customer_btn'));
      expect(askBtn, findsOneWidget);

      await tester.tap(askBtn);
      await tester.pump(const Duration(milliseconds: 200));

      // Check WhatsApp intent simulation modal
      expect(find.text('Meta WhatsApp Cloud Relay Active'), findsOneWidget);
      expect(find.text('Chatting with Customer (Asim Ji)'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Dismiss Intent Simulation'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
    });

    testWidgets('6. Tapping "CLAIM JOB NOW" invokes acceptBroadcastJob and sets state claimed',
        (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      final claimBtn = find.byKey(const Key('radar_claim_job_btn'));
      expect(claimBtn, findsOneWidget);

      await tester.tap(claimBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(service.activeBroadcast?.state, RadarDispatchState.claimed);
      expect(find.text('Active Job Screen Destination'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('7. Toggling duty switch to offline hides broadcast card and shows standby',
        (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byKey(const Key('radar_broadcast_card')), findsOneWidget);

      // Toggle duty switch off
      final dutySwitch = find.byType(Switch);
      expect(dutySwitch, findsOneWidget);
      await tester.tap(dutySwitch);
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('DUTY PAUSED'), findsOneWidget);
      expect(find.byKey(const Key('radar_broadcast_card')), findsNothing);
      expect(find.textContaining('Duty paused'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('8. Unfulfilled state renders fallback card and "Refresh Radar" CTA button',
        (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));

      // Trigger Tier 1 expiry (to Tier 2)
      service.simulateExpiry();
      await tester.pump(const Duration(milliseconds: 200));

      // Trigger Tier 2 expiry (to unfulfilled)
      service.simulateExpiry();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byKey(const Key('radar_unfulfilled_state_card')), findsOneWidget);
      expect(find.text('No active broadcasts in your 6 km corridor'), findsOneWidget);
      expect(find.byKey(const Key('radar_refresh_btn')), findsOneWidget);

      // Tap Refresh Radar to restart broadcast
      await tester.tap(find.byKey(const Key('radar_refresh_btn')));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byKey(const Key('radar_broadcast_card')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('9. Screen mounts cleanly on narrow 360x800 and 320x568 mobile viewports without overflow',
        (tester) async {
      // Test on standard Android 360x800
      await setMobileViewport(tester, size: const Size(360, 800));
      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);

      // Test on ultra-compact 320x568 (iPhone SE 1st gen)
      await setMobileViewport(tester, size: const Size(320, 568));
      await tester.pumpWidget(buildTestScreen());
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
    });
  });
}
