import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/features/customer/profile/artisan_profile_screen.dart';

void main() {
  Widget createWidgetUnderTest({String artisanId = 'art_nanded_01'}) {
    return ProviderScope(
      child: MaterialApp(
        home: ArtisanProfileScreen(artisanId: artisanId),
      ),
    );
  }

  group('Screen 4: Artisan Profile & Reviews Tests', () {
    testWidgets('renders craftsman profile hero, credentials, and PRO badge', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Top app bar
      expect(find.text('Craftsman Profile'), findsOneWidget);

      // Hero Card details
      expect(find.text('Ganesh Kadam'), findsOneWidget);
      expect(find.text('Master Electrician'), findsOneWidget);
      expect(find.text('PRO'), findsOneWidget);
      expect(find.textContaining('Anand Nagar'), findsWidgets);
      expect(find.text('Available Today'), findsOneWidget);

      // Metric trio
      expect(find.text('4.9★'), findsOneWidget);
      expect(find.text('340 Reviews'), findsOneWidget);
      expect(find.text('9+ Yrs'), findsOneWidget);
      expect(find.text('512+'), findsOneWidget);
    });

    testWidgets('renders 4-pillar trust verification pods and 6 skill chips', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // 4 Pillars
      expect(find.text('Karigaar Verified Guildsman'), findsOneWidget);
      expect(find.text('Govt. ID & Police'), findsOneWidget);
      expect(find.text('NSDC Certified'), findsOneWidget);
      expect(find.text('₹25k Master Cover'), findsOneWidget);
      expect(find.text('Calibrated Tools'), findsOneWidget);

      // Specialization skill chips
      expect(find.text('Specializations & Skills'), findsOneWidget);
      expect(find.text('6 Certified'), findsOneWidget);
      expect(find.text('3-Phase Wiring'), findsOneWidget);
      expect(find.text('Inverter Setup'), findsOneWidget);
      expect(find.text('MCB Spark Diagnosis'), findsOneWidget);
      expect(find.text('Modular Switchboards'), findsOneWidget);
    });

    testWidgets('renders craftsmanship showcase carousel, scorecard, and reviews', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Showcase carousel
      expect(find.text('Craftsmanship Showcase'), findsOneWidget);
      expect(find.text('Custom 32A MCB Panel Wiring'), findsOneWidget);

      // Scorecard
      expect(find.text('Artisan Scorecard'), findsOneWidget);
      expect(find.text('Punctuality & Timing'), findsOneWidget);
      expect(find.text('5.0 / 5.0'), findsWidgets);
      expect(find.text('Master Craftsmanship'), findsOneWidget);
      expect(find.text('4.9 / 5.0'), findsOneWidget);
      expect(find.text('Sawdust & Cleanliness'), findsOneWidget);

      // Client Reviews
      expect(find.text('Recent Client Feedback'), findsOneWidget);
      expect(find.text('Pooja M.'), findsOneWidget);
      expect(find.text('Amit V.'), findsOneWidget);
    });

    testWidgets('renders Path A direct contact actions and Path B sticky dock', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Path A Call & WhatsApp buttons
      expect(find.text('Call Artisan'), findsOneWidget);
      expect(find.text('WhatsApp Artisan'), findsOneWidget);

      // Path B sticky dock
      expect(find.text('₹199'), findsOneWidget);
      expect(find.text('/ visit'), findsOneWidget);
      expect(find.text('Includes ₹25k Guild Warranty'), findsOneWidget);
      expect(find.text('Book Ganesh Now'), findsOneWidget);
    });

    testWidgets('toggles favorite icon state on tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final favoriteBtn = find.byIcon(Icons.favorite_border_rounded);
      expect(favoriteBtn, findsOneWidget);

      await tester.tap(favoriteBtn);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.text('Saved Ganesh Kadam to favorites!'), findsOneWidget);
    });

    testWidgets('tapping Path A Call Artisan opens simulated intent modal on test harness', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final callBtn = find.text('Call Artisan');
      await tester.ensureVisible(callBtn);
      await tester.tap(callBtn);
      await tester.pumpAndSettle();

      expect(find.text('Direct Telephony Call Dispatched'), findsOneWidget);
      final dismissBtn = find.text('Dismiss Intent Simulation');
      expect(dismissBtn, findsOneWidget);

      await tester.ensureVisible(dismissBtn);
      await tester.tap(dismissBtn);
      await tester.pumpAndSettle();
      expect(find.text('Direct Telephony Call Dispatched'), findsNothing);
    });

    testWidgets('tapping Path A WhatsApp Artisan opens simulated intent modal on test harness', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final waBtn = find.text('WhatsApp Artisan');
      await tester.ensureVisible(waBtn);
      await tester.tap(waBtn);
      await tester.pumpAndSettle();

      expect(find.text('WhatsApp Conversation Dispatched'), findsOneWidget);
      final dismissBtn = find.text('Dismiss Intent Simulation');
      expect(dismissBtn, findsOneWidget);

      await tester.ensureVisible(dismissBtn);
      await tester.tap(dismissBtn);
      await tester.pumpAndSettle();
      expect(find.text('WhatsApp Conversation Dispatched'), findsNothing);
    });
  });
}
