import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/services/api_service.dart';

void main() {
  group('Ticket T-05: Payment Gateway & Escrow Unit Tests', () {
    const api = KarigaarApiService();

    group('Pillar 1: UPI Pre-Authorization Mandate Lifecycle', () {
      test('1. UpiMandateStatus enum defines canonical states and helper getters', () {
        expect(UpiMandateStatus.values, containsAll([
          UpiMandateStatus.created,
          UpiMandateStatus.authorized,
          UpiMandateStatus.captured,
          UpiMandateStatus.released,
          UpiMandateStatus.revoked,
        ]));

        expect(UpiMandateStatus.authorized.isSecured, isTrue);
        expect(UpiMandateStatus.created.isSecured, isFalse);
        expect(UpiMandateStatus.captured.isCaptured, isTrue);
        expect(UpiMandateStatus.released.isReleased, isTrue);
        expect(UpiMandateStatus.revoked.isRevoked, isTrue);
      });

      test('2. createUpiPreAuthMandate succeeds with valid standard VPA', () async {
        final res = await api.createUpiPreAuthMandate(
          bookingId: 'BK_NANDED_8821',
          customerId: 'cust_01',
          upiVpa: 'asim.farooqui@okaxis',
          amount: 99,
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['bookingId'], 'BK_NANDED_8821');
        expect(data['customerId'], 'cust_01');
        expect(data['upiVpa'], 'asim.farooqui@okaxis');
        expect(data['amount'], 99);
        expect(data['mandateStatus'], 'AUTHORIZED');
        expect(data['transitFeeProtected'], isTrue);
        expect(data['gateway'], contains('UPI_AUTOPAY'));
      });

      test('3. createUpiPreAuthMandate accepts varied valid bank VPAs (GPay, PhonePe, Paytm)', () async {
        final validVpas = [
          'user@okaxis',
          '9822012345@ybl',
          'merchant.service@paytm',
          'artisan_pro@icici',
          'karigaar-trust@hdfcbank',
        ];

        for (final vpa in validVpas) {
          final res = await api.createUpiPreAuthMandate(
            bookingId: 'BK_TEST',
            customerId: 'cust_test',
            upiVpa: vpa,
          );
          expect((res['data'] as Map<String, dynamic>)['upiVpa'], vpa);
          expect((res['data'] as Map<String, dynamic>)['mandateStatus'], 'AUTHORIZED');
        }
      });

      test('4. createUpiPreAuthMandate rejects malformed VPA addresses', () async {
        final invalidVpas = [
          '',
          'invalidVpaNoAtSymbol',
          '@bank',
          'user@',
          'user@b',
          'user name@bank',
          'user@bank@extra',
        ];

        for (final vpa in invalidVpas) {
          expect(
            () => api.createUpiPreAuthMandate(
              bookingId: 'BK_TEST',
              customerId: 'cust_test',
              upiVpa: vpa,
            ),
            throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_VPA')),
            reason: 'VPA "$vpa" must be rejected by regex validator',
          );
        }
      });

      test('5. captureUpiMandate captures ₹99 with ₹80 artisan and ₹19 platform fee split', () async {
        final res = await api.captureUpiMandate(
          bookingId: 'BK_NANDED_8821',
          mandateId: 'man_9921',
          reason: 'DOORSTEP_ACCESS_DENIED',
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['mandateId'], 'man_9921');
        expect(data['mandateStatus'], 'CAPTURED');
        expect(data['debitedAmount'], 99.0);
        expect(data['creditedToArtisan'], 80.0);
        expect(data['platformFee'], 19.0);
        expect(data['reason'], 'DOORSTEP_ACCESS_DENIED');
      });

      test('6. releaseUpiMandate releases standby hold upon successful completion', () async {
        final res = await api.releaseUpiMandate(
          bookingId: 'BK_NANDED_8821',
          mandateId: 'man_9921',
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['mandateStatus'], 'RELEASED');
        expect(data['holdAmountReleased'], 99.0);
        expect(data['message'], contains('released successfully'));
      });

      test('7. revokeUpiMandate marks mandate state as REVOKED', () async {
        final res = await api.revokeUpiMandate(
          bookingId: 'BK_NANDED_8821',
          mandateId: 'man_9921',
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['mandateStatus'], 'REVOKED');
      });
    });

    group('Pillar 2: Doorstep Access Denial & Dwell Invariants', () {
      test('8. triggerDoorstepAccessDenied succeeds when dwellMinutes >= 15', () async {
        final res = await api.triggerDoorstepAccessDenied(
          bookingId: 'BK_NANDED_8821',
          dwellMinutes: 16,
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['state'], 'DOORSTEP_ACCESS_DENIED');
        final compensation = data['transitCompensation'] as Map<String, dynamic>;
        expect(compensation['totalDebitedFromPreAuthMandate'], 99.0);
        expect(compensation['creditedToArtisanGuildWallet'], 80.0);
        expect(compensation['platformCancellationProcessingFee'], 19.0);
      });

      test('9. triggerDoorstepAccessDenied rejects dwell time < 15 minutes', () async {
        expect(
          () => api.triggerDoorstepAccessDenied(
            bookingId: 'BK_NANDED_8821',
            dwellMinutes: 14,
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'DWELL_TIME_INSUFFICIENT')),
        );
      });
    });

    group('Pillar 3: RBI 2FA Parts & Financial Math', () {
      test('10. requestPart2FaApproval generates approval token and 2% PG surcharge', () async {
        final res = await api.requestPart2FaApproval(
          bookingId: 'BK_NANDED_8821',
          partName: 'Schneider 32A Double Pole MCB',
          price: 380,
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['partName'], 'Schneider 32A Double Pole MCB');
        expect(data['price'], 380);
        expect(data['approvalStatus'], 'PENDING_CUSTOMER_2FA_APPROVAL');
        expect(data['customerApprovalPromptDispatched'], isTrue);
        expect(data['partsGatewayConvenienceFee'], (380 * 0.02).round()); // 8
        expect(data['approvalToken'], startsWith('appr_2fa_'));
      });

      test('11. requestPart2FaApproval rejects invalid part names or negative prices', () async {
        expect(
          () => api.requestPart2FaApproval(
            bookingId: 'BK_NANDED_8821',
            partName: '',
            price: 100,
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_PART_DETAILS')),
        );

        expect(
          () => api.requestPart2FaApproval(
            bookingId: 'BK_NANDED_8821',
            partName: 'Valid Part',
            price: 0,
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_PART_DETAILS')),
        );
      });

      test('12. submitDecoupledInvoice computes exact 2% surcharge, 18% GST and grandTotal', () async {
        const parts = [
          BillPartItem(
            id: 'p1',
            name: 'Havells 32A MCB',
            unitPrice: 380,
            quantity: 1,
            receiptPhotoUrl: 'receipt_mcb.jpg',
            hardwareStoreName: 'Gupta Electricals',
          ),
          BillPartItem(
            id: 'p2',
            name: 'Finolex 2.5 sq mm Wire (5m)',
            unitPrice: 220,
            quantity: 1,
            receiptPhotoUrl: 'receipt_wire.jpg',
            hardwareStoreName: 'Gupta Electricals',
          ),
        ];
        // laborBase = 249
        // partsTotal = 380 + 220 = 600
        // partsSurcharge = (600 * 0.02).round() = 12
        // subtotal = 249 + 600 + 12 = 861
        // gst18 = (861 * 0.18).round() = 154.98 -> 155
        // grandTotal = 861 + 155 = 1016

        final res = await api.submitDecoupledInvoice(
          bookingId: 'BK_NANDED_8821',
          parts: parts,
          laborBase: 249,
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['state'], 'INVOICE_SUBMITTED');
        expect(data['laborBase'], 249);
        expect(data['partsTotal'], 600);
        expect(data['partsGatewaySurcharge2Percent'], 12);
        expect(data['gst18Percent'], 155);
        expect(data['grandTotal'], 1016);
        expect(data['completionOtpExpected'], '7294');
      });
    });

    group('Pillar 4: Decoupled Verification & OTP Release', () {
      test('13. verifyCustomerCompletion validates OTP 7294 and releases escrow', () async {
        final res = await api.verifyCustomerCompletion(
          bookingId: 'BK_NANDED_8821',
          completionOtp: '7294',
          customerRating: 5,
          feedbackNote: 'Master artisan work, very clean.',
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['state'], 'PAYMENT_RELEASED');
        expect(data['escrowSettled'], isTrue);
        expect(data['customerRating'], 5);
        expect(data['feedbackNote'], 'Master artisan work, very clean.');
      });

      test('14. verifyCustomerCompletion rejects invalid completion OTPs', () async {
        expect(
          () => api.verifyCustomerCompletion(
            bookingId: 'BK_NANDED_8821',
            completionOtp: '9999',
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_COMPLETION_OTP')),
        );
      });
    });

    group('Pillar 5: IMPS Rolling Security Reserve Invariant', () {
      test('15. withdrawWalletImps rejects withdrawal violating ₹2,000 reserve', () async {
        // Balance = 4,620.00, Reserve = 2,000.00, Max Available = 2,620.00
        // Attempting to withdraw 2,621.00 must throw SECURITY_RESERVE_VIOLATION
        expect(
          () => api.withdrawWalletImps(
            artisanId: 'art_nanded_01',
            amount: 2621.0,
            currentWalletBalance: 4620.0,
            upiId: 'artisan@okaxis',
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'SECURITY_RESERVE_VIOLATION')),
        );
      });

      test('16. withdrawWalletImps succeeds when balance remains >= ₹2,000', () async {
        // Balance = 4,620.00, Withdraw = 2,620.00 -> Remaining = 2,000.00 (exactly at reserve)
        final res = await api.withdrawWalletImps(
          artisanId: 'art_nanded_01',
          amount: 2620.0,
          currentWalletBalance: 4620.0,
          upiId: 'artisan@okaxis',
        );

        expect(res['status'], 'SUCCESS');
        final data = res['data'] as Map<String, dynamic>;
        expect(data['amountDebited'], 2620.0);
        expect(data['remainingBalance'], 2000.0);
        expect(data['channel'], 'IMPS_INSTANT_24X7');
        expect(data['status'], 'TRANSFERRED');
      });

      test('17. withdrawWalletImps rejects negative amount or missing UPI ID', () async {
        expect(
          () => api.withdrawWalletImps(
            artisanId: 'art_01',
            amount: -100,
            currentWalletBalance: 5000,
            upiId: 'artisan@okaxis',
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_AMOUNT')),
        );

        expect(
          () => api.withdrawWalletImps(
            artisanId: 'art_01',
            amount: 500,
            currentWalletBalance: 5000,
            upiId: '',
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'MISSING_UPI_ID')),
        );
      });
    });

    group('Model Entity Tests: BookingModel & BillPartItem', () {
      test('18. BookingModel retains mandate, breakdown, and dwell attributes', () {
        final booking = BookingModel(
          bookingId: 'BK_TEST',
          customerId: 'c1',
          customerName: 'Customer',
          customerPhone: '+919822000000',
          tradeId: 'trade_electrician',
          tradeName: 'Electrician',
          localityId: 'loc_anand_nagar',
          localityName: 'Anand Nagar',
          address: 'Main Street',
          status: BookingStatus.artisanArrived,
          mandateStatus: UpiMandateStatus.authorized,
          mandateId: 'man_123',
          upiVpa: 'cust@okaxis',
          partsGatewaySurcharge: 12,
          gstAmount: 155,
          grandTotal: 1016,
          dwellMinutesAtDestination: 17,
          createdAt: DateTime.now(),
        );

        expect(booking.mandateStatus, UpiMandateStatus.authorized);
        expect(booking.mandateId, 'man_123');
        expect(booking.upiVpa, 'cust@okaxis');
        expect(booking.partsGatewaySurcharge, 12);
        expect(booking.gstAmount, 155);
        expect(booking.grandTotal, 1016);
        expect(booking.dwellMinutesAtDestination, 17);
      });

      test('19. BillPartItem serializes and deserializes 2FA and hardware store fields', () {
        const item = BillPartItem(
          id: 'p1',
          name: 'Finolex Wire',
          unitPrice: 220,
          quantity: 2,
          receiptPhotoUrl: 'photo.jpg',
          hardwareStoreName: 'Gupta Electricals',
          isApproved: true,
          is2FaApproved: true,
        );

        expect(item.total, 440);
        final json = item.toJson();
        expect(json['is2FaApproved'], isTrue);
        expect(json['hardwareStoreName'], 'Gupta Electricals');

        final reconstructed = BillPartItem.fromJson(json);
        expect(reconstructed.id, 'p1');
        expect(reconstructed.name, 'Finolex Wire');
        expect(reconstructed.hardwareStoreName, 'Gupta Electricals');
        expect(reconstructed.is2FaApproved, isTrue);
      });
    });
  });
}
