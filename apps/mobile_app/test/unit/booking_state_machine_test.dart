import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/booking_model.dart';

void main() {
  group('Booking 14-State Lifecycle & Security OTP Tests', () {
    test('BookingModel verifies doorstep Start Code 4921 correctly', () {
      final booking = BookingModel(
        bookingId: 'BK_01',
        customerId: 'cust_01',
        customerName: 'Asim',
        customerPhone: '+919822199882',
        tradeId: 'trade_electrician',
        tradeName: 'Electrician',
        localityId: 'loc_anand_nagar',
        localityName: 'Anand Nagar',
        address: 'Plot 14, Nanded',
        status: BookingStatus.artisanArrived,
        startOtp: '4921',
        completionOtp: '7294',
        createdAt: DateTime.now(),
      );

      expect(booking.verifyStartOtp('4921'), isTrue);
      expect(booking.verifyStartOtp(' 4921 '), isTrue);
      expect(booking.verifyStartOtp('1234'), isFalse);
    });

    test('BookingModel verifies Completion OTP 7294 correctly', () {
      final booking = BookingModel(
        bookingId: 'BK_01',
        customerId: 'cust_01',
        customerName: 'Asim',
        customerPhone: '+919822199882',
        tradeId: 'trade_electrician',
        tradeName: 'Electrician',
        localityId: 'loc_anand_nagar',
        localityName: 'Anand Nagar',
        address: 'Plot 14, Nanded',
        status: BookingStatus.completionPendingOtp,
        startOtp: '4921',
        completionOtp: '7294',
        createdAt: DateTime.now(),
      );

      expect(booking.verifyCompletionOtp('7294'), isTrue);
      expect(booking.verifyCompletionOtp('0000'), isFalse);
    });

    test('Dynamic bill builder accurately sums labor, parts, and ₹29 shield fee', () {
      final booking = BookingModel(
        bookingId: 'BK_01',
        customerId: 'cust_01',
        customerName: 'Asim',
        customerPhone: '+919822199882',
        tradeId: 'trade_electrician',
        tradeName: 'Electrician',
        localityId: 'loc_anand_nagar',
        localityName: 'Anand Nagar',
        address: 'Plot 14, Nanded',
        status: BookingStatus.workInProgress,
        laborFee: 249,
        safetyShieldFee: 29,
        parts: const [
          BillPartItem(
            id: 'part_01',
            name: 'Havells 32A MCB',
            unitPrice: 380,
            quantity: 1,
          ),
          BillPartItem(
            id: 'part_02',
            name: 'Finolex Wire (2m)',
            unitPrice: 60,
            quantity: 2,
          ),
        ],
        createdAt: DateTime.now(),
      );

      expect(booking.partsTotal, equals(380 + (60 * 2))); // 500
      expect(booking.totalAmount, equals(249 + 29 + 500)); // 778
    });

    test('14-state lifecycle active/inactive states partition properly', () {
      expect(BookingStatus.draft.isActive, isFalse);
      expect(BookingStatus.broadcasting.isActive, isTrue);
      expect(BookingStatus.artisanEnRoute.isActive, isTrue);
      expect(BookingStatus.artisanArrived.isActive, isTrue);
      expect(BookingStatus.workInProgress.isActive, isTrue);
      expect(BookingStatus.completed.isActive, isFalse);
      expect(BookingStatus.cancelledByCustomer.isActive, isFalse);
      expect(BookingStatus.settled.isActive, isFalse);
    });
  });
}
