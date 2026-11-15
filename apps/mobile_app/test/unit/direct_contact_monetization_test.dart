import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/services/api_service.dart';
import 'package:karigaar_app/core/services/whatsapp_telephony_service.dart';

void main() {
  group('Feature F-35: Direct Contact Monetization Unit Tests', () {
    late KarigaarApiService apiService;

    setUp(() {
      apiService = const KarigaarApiService();
    });

    test('unlockDirectContact succeeds for Pay-Per-Lead (₹49) with masked proxy', () async {
      final res = await apiService.unlockDirectContact(
        customerId: 'cust_01',
        artisanId: 'art_nanded_01',
        option: 'PAY_PER_LEAD_49',
      );

      expect(res['status'], equals('SUCCESS'));
      final data = res['data'] as Map<String, dynamic>;
      expect(data['amountPaid'], equals(49));
      expect(data['virtualProxyNumber'],
          equals(KarigaarWhatsAppTelephonyService.defaultVirtualProxyDid));
      expect(data['zeroRawMsisdnLeakageGuaranteed'], isTrue);
      expect(data['unlockId'], startsWith('unl_'));
    });

    test('unlockDirectContact succeeds for Unlimited Directory Pass (₹499) with masked proxy', () async {
      final res = await apiService.unlockDirectContact(
        customerId: 'cust_01',
        artisanId: 'art_nanded_02',
        option: 'UNLIMITED_DIRECTORY_PASS_499',
      );

      expect(res['status'], equals('SUCCESS'));
      final data = res['data'] as Map<String, dynamic>;
      expect(data['amountPaid'], equals(499));
      expect(data['virtualProxyNumber'],
          equals(KarigaarWhatsAppTelephonyService.defaultVirtualProxyDid));
      expect(data['zeroRawMsisdnLeakageGuaranteed'], isTrue);
      expect(data['message'], contains('Unlimited Directory Pass activated'));
    });

    test('unlockDirectContact throws ApiException on missing parameters', () async {
      expect(
        () => apiService.unlockDirectContact(
          customerId: '',
          artisanId: 'art_nanded_01',
          option: 'PAY_PER_LEAD_49',
        ),
        throwsA(isA<ApiException>()),
      );

      expect(
        () => apiService.unlockDirectContact(
          customerId: 'cust_01',
          artisanId: '',
          option: 'PAY_PER_LEAD_49',
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('ContactUnlockNotifier transitions state accurately', () {
      final notifier = ContactUnlockNotifier();

      // Initially locked
      expect(notifier.state.hasDirectoryPass, isFalse);
      expect(notifier.state.isUnlocked('art_nanded_01'), isFalse);
      expect(notifier.state.isUnlocked('art_nanded_02'), isFalse);

      // Unlock artisan 1 via Pay-Per-Lead
      notifier.unlockPayPerLead('art_nanded_01');
      expect(notifier.state.isUnlocked('art_nanded_01'), isTrue);
      expect(notifier.state.isUnlocked('art_nanded_02'), isFalse);

      // Activate Directory Pass unlocks all
      notifier.activateDirectoryPass();
      expect(notifier.state.hasDirectoryPass, isTrue);
      expect(notifier.state.isUnlocked('art_nanded_01'), isTrue);
      expect(notifier.state.isUnlocked('art_nanded_02'), isTrue);
      expect(notifier.state.isUnlocked('any_artisan_id'), isTrue);

      // Reset restores locked state
      notifier.reset();
      expect(notifier.state.hasDirectoryPass, isFalse);
      expect(notifier.state.isUnlocked('art_nanded_01'), isFalse);
    });
  });
}
