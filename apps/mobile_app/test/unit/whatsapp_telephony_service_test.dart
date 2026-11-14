import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/whatsapp_template_model.dart';
import 'package:karigaar_app/core/services/whatsapp_telephony_service.dart';
import 'package:karigaar_app/core/services/api_service.dart';

void main() {
  late KarigaarWhatsAppTelephonyService service;
  late KarigaarApiService api;

  setUp(() {
    service = KarigaarWhatsAppTelephonyService.instance;
    service.resetForTesting();
    api = const KarigaarApiService();
  });

  group('Ticket T-06: Meta WhatsApp Business Cloud API & Templates Engine', () {
    test('1. dispatch_alert template serializes to Meta Cloud API v21.0 schema', () async {
      final res = await service.dispatchWhatsAppTemplate(
        recipientPhone: '+919822012345',
        templateName: 'dispatch_alert',
        languageCode: 'hi_IN',
        components: [
          const WhatsAppTemplateComponent(
            type: 'header',
            parameters: [WhatsAppTemplateParameter(type: 'text', text: 'Nanded Emergency MCB Trip')],
          ),
          const WhatsAppTemplateComponent(
            type: 'body',
            parameters: [
              WhatsAppTemplateParameter(type: 'text', text: 'Anand Nagar Gate 2'),
              WhatsAppTemplateParameter(type: 'currency', currencyAmount: 450),
            ],
          ),
          const WhatsAppTemplateComponent(
            type: 'button',
            subType: 'quick_reply',
            index: 0,
            parameters: [WhatsAppTemplateParameter(type: 'payload', payload: 'ACCEPT_JOB_ALERT')],
          ),
        ],
      );

      expect(res['messaging_product'], 'whatsapp');
      expect((res['messages'] as List)[0]['message_status'], 'accepted');
      expect((res['messages'] as List)[0]['id'], startsWith('wamid.'));

      final meta = res['_metaPayload'] as Map<String, dynamic>;
      expect(meta['recipient_type'], 'individual');
      expect(meta['to'], '+919822012345');
      final template = meta['template'] as Map<String, dynamic>;
      expect(template['name'], 'dispatch_alert');
      expect(template['language']['code'], 'hi_IN');
      expect((template['components'] as List).length, 3);
    });

    test('2. auth_otp template serializes with copy_code button', () async {
      final res = await service.dispatchWhatsAppTemplate(
        recipientPhone: '9822012345',
        templateName: 'auth_otp',
        languageCode: 'en_US',
        components: [
          const WhatsAppTemplateComponent(
            type: 'body',
            parameters: [WhatsAppTemplateParameter(type: 'text', text: '492108')],
          ),
          const WhatsAppTemplateComponent(
            type: 'button',
            subType: 'url',
            index: 0,
            parameters: [WhatsAppTemplateParameter(type: 'text', text: '492108')],
          ),
        ],
      );

      final meta = res['_metaPayload'] as Map<String, dynamic>;
      expect(meta['to'], '+919822012345');
      expect(meta['template']['name'], 'auth_otp');
    });

    test('3. milestone_update template serializes Start Code 4921 & status', () async {
      final res = await service.dispatchWhatsAppTemplate(
        recipientPhone: '+919822012345',
        templateName: 'milestone_update',
        components: [
          const WhatsAppTemplateComponent(
            type: 'body',
            parameters: [
              WhatsAppTemplateParameter(type: 'text', text: 'ARTISAN_ARRIVED'),
              WhatsAppTemplateParameter(type: 'text', text: '4921'),
            ],
          ),
        ],
      );

      final receipt = service.getReceipt((res['messages'] as List)[0]['id'] as String);
      expect(receipt, isNotNull);
      expect(receipt!.status, WhatsAppDeliveryStatus.sent);
      expect(receipt.templateName, 'milestone_update');
    });

    test('4. voice_memo_relay template includes audio attachment parameter', () async {
      final res = await service.dispatchWhatsAppTemplate(
        recipientPhone: '+919822012345',
        templateName: 'voice_memo_relay',
        components: [
          const WhatsAppTemplateComponent(
            type: 'header',
            parameters: [
              WhatsAppTemplateParameter(
                type: 'audio',
                audioUrl: 'https://cdn.karigaar.in/voice/memo_8821.m4a',
              ),
            ],
          ),
        ],
      );

      final meta = res['_metaPayload'] as Map<String, dynamic>;
      final comps = meta['template']['components'] as List;
      final header = comps[0] as Map<String, dynamic>;
      expect(header['parameters'][0]['audio']['link'], 'https://cdn.karigaar.in/voice/memo_8821.m4a');
    });

    test('5. daily_settlement_slip template includes currency and reserve breakdown', () async {
      final res = await service.dispatchWhatsAppTemplate(
        recipientPhone: '+919822012345',
        templateName: 'daily_settlement_slip',
        languageCode: 'mr_IN',
        components: [
          const WhatsAppTemplateComponent(
            type: 'body',
            parameters: [
              WhatsAppTemplateParameter(type: 'currency', currencyAmount: 2450),
              WhatsAppTemplateParameter(type: 'currency', currencyAmount: 2000), // rolling reserve
            ],
          ),
        ],
      );

      final meta = res['_metaPayload'] as Map<String, dynamic>;
      expect(meta['template']['language']['code'], 'mr_IN');
      final params = (meta['template']['components'] as List)[0]['parameters'] as List;
      expect(params[0]['currency']['amount_1000'], 2450000);
      expect(params[1]['currency']['fallback_value'], '₹2000');
    });

    test('6. Rejects invalid mobile numbers (< 10 digits or invalid prefix)', () {
      expect(
        () => service.cleanAndValidatePhone('12345'),
        throwsArgumentError,
      );
      expect(
        () => service.cleanAndValidatePhone('5551234567'), // Starts with 5 (invalid Indian mobile)
        throwsArgumentError,
      );
    });

    test('7. Rejects unsupported WhatsApp template name', () {
      expect(
        () => service.dispatchWhatsAppTemplate(
          recipientPhone: '+919822012345',
          templateName: 'random_promo_spam',
        ),
        throwsArgumentError,
      );
    });

    test('8. Rejects unsupported language code', () {
      expect(
        () => service.dispatchWhatsAppTemplate(
          recipientPhone: '+919822012345',
          templateName: 'auth_otp',
          languageCode: 'fr_FR',
        ),
        throwsArgumentError,
      );
    });

    test('9. Webhook delivery status simulator transitions from SENT to DELIVERED to READ', () async {
      final res = await service.dispatchWhatsAppTemplate(
        recipientPhone: '+919822012345',
        templateName: 'auth_otp',
      );
      final messageId = (res['messages'] as List)[0]['id'] as String;

      final statuses = <WhatsAppDeliveryStatus>[];
      final subscription = service.outboundReceiptStream.listen((receipt) {
        if (receipt.messageId == messageId) {
          statuses.add(receipt.status);
        }
      });

      service.simulateDeliveryWebhook(messageId: messageId, status: WhatsAppDeliveryStatus.delivered);
      service.simulateDeliveryWebhook(messageId: messageId, status: WhatsAppDeliveryStatus.read);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(statuses, containsAll([WhatsAppDeliveryStatus.delivered, WhatsAppDeliveryStatus.read]));

      final current = service.getReceipt(messageId);
      expect(current!.status, WhatsAppDeliveryStatus.read);

      await subscription.cancel();
    });
  });

  group('Ticket T-06: Dual-Sync Dispatch Payload Engine', () {
    test('10. syncDualDispatchPayload emits both In-App Radar and WhatsApp template with audio memo', () async {
      final result = await service.syncDualDispatchPayload(
        bookingId: 'BK_NANDED_8821',
        artisanPhone: '+919822012345',
        customerAddress: 'Flat 402, Anand Heights, Anand Nagar',
        landmarkOrSocietyCode: 'Gate 2, Visitor Pass #14',
        latitude: 19.1685,
        longitude: 77.3090,
        audioMemoUrl: 'https://cdn.karigaar.in/audio/memo_8821.aac',
        guaranteedBasePayout: 450,
      );

      expect(result.bookingId, 'BK_NANDED_8821');
      expect(result.inAppBroadcastDispatched, isTrue);
      expect(result.whatsAppTemplateDispatched, isTrue);
      expect(result.audioMemoRelayed, isTrue);
      expect(result.societyCodeIncluded, isTrue);
      expect(result.mapsLinkIncluded, isTrue);
      expect(result.maskedCallBridgeReady, isTrue);
      expect(result.virtualProxyNumber, '+91-11-4084-2190');
    });

    test('11. syncDualDispatchPayload without audio uses dispatch_alert template', () async {
      final result = await service.syncDualDispatchPayload(
        bookingId: 'BK_NANDED_9941',
        artisanPhone: '9822012345',
        customerAddress: 'Shop 4, Vazirabad Market',
        landmarkOrSocietyCode: 'Near Clock Tower',
        latitude: 19.1500,
        longitude: 77.3100,
        guaranteedBasePayout: 350,
      );

      expect(result.audioMemoRelayed, isFalse);
      expect(result.whatsAppTemplateDispatched, isTrue);
      final receipt = service.getReceipt(result.whatsAppMessageId);
      expect(receipt!.templateName, 'dispatch_alert');
    });
  });

  group('Ticket T-06: Virtual Masked Telephony Bridge & Zero MSISDN Leakage', () {
    test('12. bridgeTelephonyCall establishes active proxy DID with zero raw MSISDN exposure', () async {
      final session = await service.bridgeTelephonyCall(
        callerNumber: '+919822012345',
        calleeId: 'art_nanded_01',
        role: 'CUSTOMER',
        bookingId: 'BK_NANDED_8821',
      );

      expect(session.virtualProxyNumber, '+91-11-4084-2190');
      expect(session.sessionStatus, 'BRIDGED');
      expect(session.zeroRawMsisdnLeakageGuaranteed, isTrue);
      expect(session.expiresInSeconds, 600);
      expect(session.isExpired, isFalse);
      expect(session.remainingSeconds, inInclusiveRange(590, 600));

      final json = session.toJson();
      expect(json.containsKey('callerNumber'), isFalse);
      expect(json.containsKey('calleeNumber'), isFalse);
      expect(json['virtualProxyNumber'], '+91-11-4084-2190');
    });

    test('13. getTelephonyBridgeSession retrieves active session', () async {
      final session = await service.bridgeTelephonyCall(
        callerNumber: '+919822012345',
        calleeId: 'art_nanded_02',
        role: 'ARTISAN',
      );

      final retrieved = service.getTelephonyBridgeSession(session.sessionId);
      expect(retrieved, isNotNull);
      expect(retrieved!.sessionId, session.sessionId);
      expect(retrieved.sessionStatus, 'BRIDGED');
    });

    test('14. terminateTelephonyBridgeSession cleanly terminates proxy bridge', () async {
      final session = await service.bridgeTelephonyCall(
        callerNumber: '+919822012345',
        calleeId: 'art_nanded_03',
        role: 'CUSTOMER',
      );

      final terminated = service.terminateTelephonyBridgeSession(session.sessionId);
      expect(terminated.sessionStatus, 'TERMINATED');

      final queried = service.getTelephonyBridgeSession(session.sessionId);
      expect(queried!.sessionStatus, 'TERMINATED');
    });
  });

  group('Ticket T-06: ApiService Microservice Interface Contract Verification', () {
    test('15. api.dispatchWhatsAppTemplate forwards to service with standard envelope', () async {
      final res = await api.dispatchWhatsAppTemplate(
        recipientPhone: '+919822012345',
        templateName: 'auth_otp',
      );
      expect(res['messaging_product'], 'whatsapp');
      expect(res['messages'], isNotEmpty);
    });

    test('16. api.syncDualDispatchPayload returns standard JSON response', () async {
      final res = await api.syncDualDispatchPayload(
        bookingId: 'BK_NANDED_8821',
        artisanPhone: '+919822012345',
        customerAddress: 'Anand Nagar',
        landmarkOrSocietyCode: 'Gate 2',
        latitude: 19.1685,
        longitude: 77.3090,
        guaranteedBasePayout: 500,
      );

      expect(res['status'], 'SUCCESS');
      final data = res['data'] as Map<String, dynamic>;
      expect(data['inAppBroadcastDispatched'], isTrue);
      expect(data['whatsAppTemplateDispatched'], isTrue);
      expect(data['virtualProxyNumber'], '+91-11-4084-2190');
    });

    test('17. api.getTelephonyBridgeSession & terminateTelephonyBridgeSession contract', () async {
      final bridgeRes = await api.bridgeTelephonyCall(
        callerNumber: '+919822012345',
        calleeId: 'art_7721',
        role: 'CUSTOMER',
      );
      final sessionId = (bridgeRes['data'] as Map<String, dynamic>)['bridgeSessionId'] as String;

      final sessionRes = await api.getTelephonyBridgeSession(sessionId: sessionId);
      expect(sessionRes['status'], 'SUCCESS');
      expect((sessionRes['data'] as Map<String, dynamic>)['sessionStatus'], 'BRIDGED');

      final termRes = await api.terminateTelephonyBridgeSession(sessionId: sessionId);
      expect(termRes['status'], 'SUCCESS');
      expect((termRes['data'] as Map<String, dynamic>)['sessionStatus'], 'TERMINATED');
    });
  });
}
