import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/services/contact_intent_service.dart';

void main() {
  group('ContactIntentService Tests', () {
    testWidgets('makePhoneCall renders simulated intent sheet on test harness', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ContactIntentService.makePhoneCall(
                    context,
                    phoneNumber: '+919822012345',
                    contactName: 'Ganesh Kadam',
                  );
                },
                child: const Text('Call'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Call'));
      await tester.pumpAndSettle();

      expect(find.text('Direct Telephony Call Dispatched'), findsOneWidget);
      expect(find.text('Calling Ganesh Kadam'), findsOneWidget);
      expect(find.textContaining('tel:+919822012345'), findsOneWidget);
      final dismissBtn = find.text('Dismiss Intent Simulation');
      expect(dismissBtn, findsOneWidget);

      await tester.ensureVisible(dismissBtn);
      await tester.tap(dismissBtn);
      await tester.pumpAndSettle();
      expect(find.text('Direct Telephony Call Dispatched'), findsNothing);
    });

    testWidgets('openWhatsAppChat renders simulated intent sheet on test harness', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ContactIntentService.openWhatsAppChat(
                    context,
                    phoneNumber: '9822012345',
                    prefilledMessage: 'Namaste Ganesh Ji',
                    contactName: 'Ganesh Kadam',
                  );
                },
                child: const Text('Chat'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      expect(find.text('WhatsApp Conversation Dispatched'), findsOneWidget);
      expect(find.text('Chatting with Ganesh Kadam'), findsOneWidget);
      expect(find.textContaining('Namaste Ganesh Ji'), findsOneWidget);
      final dismissBtn2 = find.text('Dismiss Intent Simulation');
      expect(dismissBtn2, findsOneWidget);

      await tester.ensureVisible(dismissBtn2);
      await tester.tap(dismissBtn2);
      await tester.pumpAndSettle();
      expect(find.text('WhatsApp Conversation Dispatched'), findsNothing);
    });
  });
}
