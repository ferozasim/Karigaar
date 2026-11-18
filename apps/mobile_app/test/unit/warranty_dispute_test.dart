import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/services/api_service.dart';

void main() {
  const api = KarigaarApiService.instance;

  test('warranty pool receives 30 percent of platform labor take-rate', () {
    expect(api.calculateWarrantyReserveContributionPaise(10000), 3000);
    expect(api.calculateWarrantyReserveContributionPaise(1), 0);
    expect(() => api.calculateWarrantyReserveContributionPaise(-1),
        throwsA(isA<ApiException>()));
  });

  test('completion settlement reports the warranty reserve contribution',
      () async {
    final response = await api.verifyCustomerCompletion(
      bookingId: 'BK_01',
      completionOtp: '7294',
      laborAmountPaise: 100000,
      platformTakeRatePercent: 12,
    );
    final data = response['data'] as Map<String, dynamic>;
    expect(data['platformLaborTakeRatePaise'], 12000);
    expect(data['warrantyReserveContributionPaise'], 3600);
  });

  test('CSAT accepts 1-5 ratings and rejects invalid values', () async {
    final response = await api.submitPostJobCsat(
      bookingId: 'BK_01',
      overallRating: 4,
      cleanlinessRating: 5,
      sawdustRating: 3,
      feedbackNote: 'Clean work',
    );
    expect((response['data'] as Map<String, dynamic>)['overallRating'], 4);
    await expectLater(
      api.submitPostJobCsat(
        bookingId: 'BK_01',
        overallRating: 6,
        cleanlinessRating: 5,
        sawdustRating: 5,
      ),
      throwsA(isA<ApiException>()),
    );
  });

  test('claim applies deductible, cover ceiling, and 30-day window', () async {
    final result = await api.raiseWarrantyClaim(
      bookingId: 'BK_01',
      requestedAmountPaise: 200000,
      damageCoverAmountPaise: 2500000,
      completedAt: DateTime.now().subtract(const Duration(days: 6)),
      warrantyEligible: true,
      reason: 'Damage recurred',
    );
    expect(
      (result['data'] as Map<String, dynamic>)['eligiblePayoutPaise'],
      175000,
    );

    await expectLater(
      api.raiseWarrantyClaim(
        bookingId: 'BK_01',
        requestedAmountPaise: 200000,
        damageCoverAmountPaise: 2500000,
        completedAt: DateTime.now().subtract(const Duration(days: 31)),
        warrantyEligible: true,
      ),
      throwsA(isA<ApiException>()),
    );
  });
}
