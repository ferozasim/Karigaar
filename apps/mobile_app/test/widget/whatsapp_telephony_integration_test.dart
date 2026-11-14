import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/core/services/contact_intent_service.dart';
import 'package:karigaar_app/core/services/whatsapp_telephony_service.dart';
import 'package:karigaar_app/features/customer/messages/customer_messages_screen.dart';
import 'package:karigaar_app/features/customer/tracking/live_tracking_screen.dart';
import 'package:karigaar_app/features/artisan/radar/artisan_job_radar_screen.dart';

void main() {
  setUp(() {
    ContactIntentService.forceSimulationForTesting = true;
    KarigaarWhatsAppTelephonyService.instance.resetForTesting();
  });

  tearDown(() {
    ContactIntentService.forceSimulationForTesting = false;
  });

  Widget buildTestScreen(Widget child, {Size size = const Size(390, 844)}) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: child,
        ),
      ),
    );
  }

  group('Ticket T-06: WhatsApp & Masked Telephony Integration Tests', () {
    testWidgets('1. CustomerMessagesScreen: Number Masking banner & masked call bridge action', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestScreen(const CustomerMessagesScreen()));
      await tester.pumpAndSettle();

      // Check Privacy & Masked Bridge Notice
      expect(find.byKey(const Key('masked_privacy_notice_banner')), findsOneWidget);
      expect(find.textContaining('Zero Raw MSISDN Leakage'), findsOneWidget);

      // Tap Masked Call Action Button in AppBar
      final callBtn = find.byKey(const Key('masked_call_action_btn'));
      expect(callBtn, findsOneWidget);
      await tester.tap(callBtn);
      await tester.pumpAndSettle();

      // Verify Virtual Telephony Bridge Active sheet opened
      expect(find.text('Virtual Telephony Bridge Active'), findsOneWidget);
      expect(find.textContaining('+91-11-4084-2190'), findsOneWidget);
      expect(find.textContaining('Zero MSISDN Leakage: GUARANTEED'), findsOneWidget);

      // Dismiss simulation modal
      await tester.tap(find.text('Dismiss Intent Simulation'));
      await tester.pumpAndSettle();

      // Tap WhatsApp Cloud Relay Quick Chip
      final relayChip = find.byKey(const Key('whatsapp_cloud_relay_chip'));
      expect(relayChip, findsOneWidget);
      await tester.ensureVisible(relayChip);
      await tester.pumpAndSettle();
      await tester.tap(relayChip);
      await tester.pumpAndSettle();

      expect(find.text('Meta WhatsApp Cloud Relay Active'), findsOneWidget);
      expect(find.textContaining('+91-11-4084-2190'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('2. LiveTrackingScreen: Masked Phone & WhatsApp buttons connect through virtual proxy', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestScreen(const LiveTrackingScreen(bookingId: 'BK_NANDED_8821')));
      await tester.pumpAndSettle();

      // Scroll down to Assigned Artisan Card
      final phoneBtn = find.byKey(const Key('tracking_phone_call_btn'));
      await tester.ensureVisible(phoneBtn);
      await tester.pumpAndSettle();

      // Tap Phone Call Button
      await tester.tap(phoneBtn);
      await tester.pumpAndSettle();

      // Verify Masked Telephony Sheet appears with proxy DID
      expect(find.text('Virtual Telephony Bridge Active'), findsOneWidget);
      expect(find.textContaining('+91-11-4084-2190'), findsOneWidget);

      // Dismiss sheet
      await tester.tap(find.text('Dismiss Intent Simulation'));
      await tester.pumpAndSettle();

      // Tap WhatsApp Chat Button
      final waBtn = find.byKey(const Key('tracking_whatsapp_chat_btn'));
      await tester.tap(waBtn);
      await tester.pumpAndSettle();

      expect(find.text('Meta WhatsApp Cloud Relay Active'), findsOneWidget);
      expect(find.textContaining('Zero MSISDN Exposure'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('3. ArtisanJobRadarScreen: Ask Customer CTA invokes Masked WhatsApp without raw MSISDN exposure', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestScreen(const ArtisanJobRadarScreen()));
      await tester.pumpAndSettle();

      final askBtn = find.byKey(const Key('radar_ask_customer_btn'));
      expect(askBtn, findsOneWidget);
      await tester.ensureVisible(askBtn);
      await tester.tap(askBtn);
      await tester.pumpAndSettle();

      expect(find.text('Meta WhatsApp Cloud Relay Active'), findsOneWidget);
      expect(find.textContaining('Zero MSISDN Exposure'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('4. Responsive Viewport Stress Test: 360x800 and 320x568 screens render cleanly', (tester) async {
      // 360x800 (Narrow Android)
      tester.view.physicalSize = const Size(360 * 2, 800 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestScreen(const CustomerMessagesScreen(), size: const Size(360, 800)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 320x568 (Smallest supported viewport)
      tester.view.physicalSize = const Size(320 * 2, 568 * 2);
      await tester.pumpWidget(buildTestScreen(const CustomerMessagesScreen(), size: const Size(320, 568)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
