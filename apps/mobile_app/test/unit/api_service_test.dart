import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/services/api_service.dart';

void main() {
  group('KarigaarApiService Contract Tests', () {
    const api = KarigaarApiService();

    group('Contract 1: WhatsApp Authentication', () {
      test('requestWhatsAppOtp succeeds for valid 10-digit number', () async {
        final res = await api.requestWhatsAppOtp(
          phoneNumber: '+919810422910',
          role: 'HOMEOWNER',
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['phoneNumber'], '+919810422910');
        expect(data['channelDispatched'], 'WHATSAPP');
        expect(data['resendAvailableAfterSeconds'], 42);
        expect(data['smsFallbackAvailable'], isTrue);
      });

      test('requestWhatsAppOtp rejects short or empty phone numbers', () async {
        expect(
          () => api.requestWhatsAppOtp(phoneNumber: '123', role: 'HOMEOWNER'),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_PHONE')),
        );
      });

      test('verifyWhatsAppOtp accepts 4-digit and 6-digit codes', () async {
        final res4 = await api.verifyWhatsAppOtp(
          requestId: 'req_123',
          phoneNumber: '+919810422910',
          otpCode: '4921',
        );
        expect(res4['status'], 'SUCCESS');

        final res6 = await api.verifyWhatsAppOtp(
          requestId: 'req_123',
          phoneNumber: '+919810422910',
          otpCode: '583291',
        );
        expect(res6['status'], 'SUCCESS');
      });

      test('verifyWhatsAppOtp rejects non-4/6 digit codes', () async {
        expect(
          () => api.verifyWhatsAppOtp(requestId: 'req_123', phoneNumber: '+919810422910', otpCode: '12'),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_OTP_LENGTH')),
        );
      });
    });

    group('Contract 2: Masked Telephony & Job Acceptance', () {
      test('bridgeTelephonyCall produces proxy bridge without MSISDN leakage', () async {
        final res = await api.bridgeTelephonyCall(
          callerNumber: '+919810422910',
          calleeId: 'art_7721',
          role: 'CUSTOMER',
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['zeroRawMsisdnLeakageGuaranteed'], isTrue);
        expect(data['virtualProxyNumber'], contains('+91-11-4084'));
      });

      test('acceptJob dispatches job with doorstep Start Code requirement', () async {
        final res = await api.acceptJob(
          bookingId: 'KG-8842',
          broadcastId: 'bc_998124',
          artisanId: 'art_7721',
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['state'], 'ARTISAN_DISPATCHED');
        expect(data['startOtpVerificationRequired'], isTrue);
        expect(data['doorstepStartOtpExpected'], '4921');
      });
    });

    group('Contract 3: Start Code & Doorstep Denial', () {
      test('verifyStartSecurityCode accepts exact code 4921', () async {
        final res = await api.verifyStartSecurityCode(
          bookingId: 'KG-8842',
          securityStartCode: ' 4921 ',
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['state'], 'IN_PROGRESS');
        expect(data['stopwatchActive'], isTrue);
      });

      test('verifyStartSecurityCode rejects invalid code', () async {
        expect(
          () => api.verifyStartSecurityCode(bookingId: 'KG-8842', securityStartCode: '0000'),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_START_CODE')),
        );
      });

      test('triggerDoorstepAccessDenied captures ₹99 transit fee after 15m dwell time', () async {
        final res = await api.triggerDoorstepAccessDenied(
          bookingId: 'KG-8842',
          dwellMinutes: 16,
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['state'], 'DOORSTEP_ACCESS_DENIED');
        final transit = data['transitCompensation'] as Map<String, dynamic>;
        expect(transit['totalDebitedFromPreAuthMandate'], 99.0);
        expect(transit['creditedToArtisanGuildWallet'], 80.0);
        expect(transit['platformCancellationProcessingFee'], 19.0);
      });

      test('triggerDoorstepAccessDenied rejects dwell time < 15 minutes', () async {
        expect(
          () => api.triggerDoorstepAccessDenied(bookingId: 'KG-8842', dwellMinutes: 10),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'DWELL_TIME_INSUFFICIENT')),
        );
      });
    });

    group('Contract 4: Decoupled Invoicing, Completion & IMPS Reserve', () {
      test('submitDecoupledInvoice accurately computes 2% parts surcharge and 18% GST', () async {
        final parts = [
          const BillPartItem(id: 'p1', name: 'MCB Switch', unitPrice: 380, quantity: 1),
          const BillPartItem(id: 'p2', name: 'Copper Wire 1m', unitPrice: 120, quantity: 2),
        ];
        // partsTotal = 380 + 240 = 620
        // partsSurcharge = 620 * 0.02 = 12.4 -> 12
        // subtotal = labor 450 + 620 + 12 = 1082
        // gst18 = 1082 * 0.18 = 194.76 -> 195
        // grandTotal = 1082 + 195 = 1277

        final res = await api.submitDecoupledInvoice(
          bookingId: 'KG-8842',
          parts: parts,
          laborBase: 450,
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['partsTotal'], 620);
        expect(data['partsGatewaySurcharge2Percent'], 12);
        expect(data['gst18Percent'], 195);
        expect(data['grandTotal'], 1277);
        expect(data['state'], 'INVOICE_SUBMITTED');
        expect(data['completionOtpExpected'], '7294');
      });

      test('verifyCustomerCompletion accepts OTP 7294 and settles escrow', () async {
        final res = await api.verifyCustomerCompletion(
          bookingId: 'KG-8842',
          completionOtp: ' 7294 ',
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['state'], 'PAYMENT_RELEASED');
        expect(data['escrowSettled'], isTrue);
        expect(data['masterShieldCover'], 25000);
      });

      test('verifyCustomerCompletion rejects incorrect completion OTP', () async {
        expect(
          () => api.verifyCustomerCompletion(bookingId: 'KG-8842', completionOtp: '1111'),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_COMPLETION_OTP')),
        );
      });

      test('withdrawWalletImps enforces mandatory ₹2,000 security reserve invariant', () async {
        // Balance = 2500, Reserve = 2000, Available = 500
        // Attempting to withdraw 600 must fail
        expect(
          () => api.withdrawWalletImps(
            artisanId: 'art_7721',
            amount: 600,
            currentWalletBalance: 2500,
            upiVpa: 'artisan@okaxis',
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'SECURITY_RESERVE_VIOLATION')),
        );

        // Attempting to withdraw 400 must succeed
        final res = await api.withdrawWalletImps(
          artisanId: 'art_7721',
          amount: 400,
          currentWalletBalance: 2500,
          upiVpa: 'artisan@okaxis',
        );
        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['amountDebited'], 400);
        expect(data['remainingBalance'], 2100);
        expect(data['channel'], 'IMPS_INSTANT_24X7');
      });
    });
  });
}
