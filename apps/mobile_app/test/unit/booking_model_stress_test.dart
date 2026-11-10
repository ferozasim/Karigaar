import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/booking_model.dart';

void main() {
  group('BookingModel Adversarial Stress Tests', () {
    late BookingModel standardBooking;

    setUp(() {
      standardBooking = BookingModel(
        bookingId: 'BK_STRESS_001',
        customerId: 'cust_stress_01',
        customerName: 'Asim Farooqui',
        customerPhone: '+919822199882',
        tradeId: 'trade_electrician',
        tradeName: 'Electrician',
        localityId: 'loc_anand_nagar',
        localityName: 'Anand Nagar',
        address: 'Plot 14, Near Water Tank, Anand Nagar, Nanded',
        status: BookingStatus.artisanArrived,
        startOtp: '4921',
        completionOtp: '7294',
        baseInspectionFee: 199,
        laborFee: 249,
        safetyShieldFee: 29,
        createdAt: DateTime(2026, 11, 6, 12, 0, 0),
      );
    });

    group('Doorstep Start OTP (4921) Adversarial Verification', () {
      test('accepts exact code 4921', () {
        expect(standardBooking.verifyStartOtp('4921'), isTrue);
      });

      test('accepts valid code with leading/trailing whitespaces and tabs', () {
        expect(standardBooking.verifyStartOtp(' 4921'), isTrue);
        expect(standardBooking.verifyStartOtp('4921 '), isTrue);
        expect(standardBooking.verifyStartOtp('  4921  '), isTrue);
        expect(standardBooking.verifyStartOtp('\t4921\n'), isTrue);
        expect(standardBooking.verifyStartOtp('\r\n4921\r\n'), isTrue);
      });

      test('rejects off-by-one and numeric variations', () {
        expect(standardBooking.verifyStartOtp('4920'), isFalse);
        expect(standardBooking.verifyStartOtp('4922'), isFalse);
        expect(standardBooking.verifyStartOtp('0000'), isFalse);
        expect(standardBooking.verifyStartOtp('1234'), isFalse);
        expect(standardBooking.verifyStartOtp('7294'), isFalse); // completion otp
        expect(standardBooking.verifyStartOtp('492'), isFalse);
        expect(standardBooking.verifyStartOtp('49210'), isFalse);
        expect(standardBooking.verifyStartOtp('04921'), isFalse);
        expect(standardBooking.verifyStartOtp('4 9 2 1'), isFalse);
      });

      test('rejects empty, blank, and null-like strings', () {
        expect(standardBooking.verifyStartOtp(''), isFalse);
        expect(standardBooking.verifyStartOtp(' '), isFalse);
        expect(standardBooking.verifyStartOtp('    '), isFalse);
        expect(standardBooking.verifyStartOtp('null'), isFalse);
        expect(standardBooking.verifyStartOtp('undefined'), isFalse);
        expect(standardBooking.verifyStartOtp('NaN'), isFalse);
      });

      test('rejects alphabetic and alphanumeric characters', () {
        expect(standardBooking.verifyStartOtp('abcd'), isFalse);
        expect(standardBooking.verifyStartOtp('ABCD'), isFalse);
        expect(standardBooking.verifyStartOtp('4921a'), isFalse);
        expect(standardBooking.verifyStartOtp('a4921'), isFalse);
        expect(standardBooking.verifyStartOtp('OTP4921'), isFalse);
      });

      test('rejects SQL injection vectors safely', () {
        const sqlPayloads = [
          "' OR '1'='1",
          "' OR 1=1 --",
          "4921' OR '1'='1",
          "4921; DROP TABLE bookings;--",
          "admin' --",
          "1' UNION SELECT * FROM users--",
        ];
        for (final payload in sqlPayloads) {
          expect(standardBooking.verifyStartOtp(payload), isFalse, reason: 'Failed on SQL payload: $payload');
        }
      });

      test('rejects XSS and HTML markup vectors safely', () {
        const xssPayloads = [
          '<script>alert(1)</script>',
          '4921<script>',
          '<img src=x onerror=alert(1)>',
          '<svg/onload=alert(1)>',
          'javascript:alert(1)',
          '"><script>alert(String.fromCharCode(88,83,83))</script>',
        ];
        for (final payload in xssPayloads) {
          expect(standardBooking.verifyStartOtp(payload), isFalse, reason: 'Failed on XSS payload: $payload');
        }
      });

      test('rejects unicode homoglyphs and localized numerals', () {
        // Devanagari numerals ४९२१
        expect(standardBooking.verifyStartOtp('४९२१'), isFalse);
        // Fullwidth numbers ４９２１
        expect(standardBooking.verifyStartOtp('４９２１'), isFalse);
        // Arabic-Indic numerals ٤٩٢١
        expect(standardBooking.verifyStartOtp('٤٩२١'), isFalse);
        // Zero-width space injection
        expect(standardBooking.verifyStartOtp('4\u200B921'), isFalse);
        expect(standardBooking.verifyStartOtp('4921\u0000'), isFalse);
      });

      test('resists DoS on massive payload inputs', () {
        final massiveString = '4921' * 50000; // 200,000 characters
        final start = DateTime.now();
        final result = standardBooking.verifyStartOtp(massiveString);
        final elapsed = DateTime.now().difference(start);

        expect(result, isFalse);
        expect(elapsed.inMilliseconds, lessThan(500), reason: 'Verification took too long: ${elapsed.inMilliseconds}ms');
      });
    });

    group('Completion OTP (7294) Adversarial Verification', () {
      test('accepts exact code 7294 and trimmed variants', () {
        expect(standardBooking.verifyCompletionOtp('7294'), isTrue);
        expect(standardBooking.verifyCompletionOtp(' 7294 '), isTrue);
        expect(standardBooking.verifyCompletionOtp('\t7294\n'), isTrue);
      });

      test('rejects start OTP 4921 or invalid numbers', () {
        expect(standardBooking.verifyCompletionOtp('4921'), isFalse);
        expect(standardBooking.verifyCompletionOtp('0000'), isFalse);
        expect(standardBooking.verifyCompletionOtp('7295'), isFalse);
        expect(standardBooking.verifyCompletionOtp('729'), isFalse);
      });

      test('rejects adversarial injection and empty strings', () {
        expect(standardBooking.verifyCompletionOtp(''), isFalse);
        expect(standardBooking.verifyCompletionOtp('   '), isFalse);
        expect(standardBooking.verifyCompletionOtp("7294' OR 1=1 --"), isFalse);
        expect(standardBooking.verifyCompletionOtp('<script>alert(1)</script>'), isFalse);
        expect(standardBooking.verifyCompletionOtp('७२९४'), isFalse); // Devanagari
      });
    });

    group('14-State Booking Lifecycle & State Transitions', () {
      test('all 14 BookingStatus enum values have non-empty human-readable labels', () {
        for (final status in BookingStatus.values) {
          expect(status.label, isNotEmpty);
          expect(status.label.length, greaterThan(3));
        }
      });

      test('isActive partitions active vs terminal/quiescent states correctly', () {
        final expectedActiveStates = {
          BookingStatus.broadcasting,
          BookingStatus.claimed,
          BookingStatus.assigned,
          BookingStatus.artisanEnRoute,
          BookingStatus.artisanArrived,
          BookingStatus.workInProgress,
          BookingStatus.partsPendingApproval,
          BookingStatus.completionPendingOtp,
          BookingStatus.disputed,
        };

        final expectedInactiveStates = {
          BookingStatus.draft,
          BookingStatus.completed,
          BookingStatus.cancelledByCustomer,
          BookingStatus.cancelledByArtisan,
          BookingStatus.settled,
        };

        for (final status in BookingStatus.values) {
          if (expectedActiveStates.contains(status)) {
            expect(status.isActive, isTrue, reason: '$status should be active');
          } else if (expectedInactiveStates.contains(status)) {
            expect(status.isActive, isFalse, reason: '$status should be inactive');
          } else {
            fail('Uncategorized status: $status');
          }
        }
      });

      test('sequential state lifecycle progression preserves invariants', () {
        var current = standardBooking.copyWith(status: BookingStatus.draft);
        expect(current.status, equals(BookingStatus.draft));
        expect(current.status.isActive, isFalse);

        current = current.copyWith(status: BookingStatus.broadcasting);
        expect(current.status.isActive, isTrue);

        current = current.copyWith(
          status: BookingStatus.claimed,
          assignedArtisanId: 'art_001',
          assignedArtisanName: 'Ganesh Kadam',
          assignedArtisanPhone: '+919822012345',
        );
        expect(current.assignedArtisanName, equals('Ganesh Kadam'));

        current = current.copyWith(status: BookingStatus.artisanEnRoute);
        expect(current.status, equals(BookingStatus.artisanEnRoute));

        current = current.copyWith(
          status: BookingStatus.artisanArrived,
          arrivalTime: DateTime.now(),
        );
        expect(current.arrivalTime, isNotNull);

        // Handshake verification
        expect(current.verifyStartOtp('4921'), isTrue);
        current = current.copyWith(status: BookingStatus.workInProgress);

        // Add bill part
        current = current.copyWith(
          status: BookingStatus.partsPendingApproval,
          parts: [
            const BillPartItem(
              id: 'p_101',
              name: 'Schneider 32A MCB',
              unitPrice: 420,
              quantity: 2,
            ),
          ],
        );
        expect(current.partsTotal, equals(840));

        current = current.copyWith(status: BookingStatus.completionPendingOtp);
        expect(current.verifyCompletionOtp('7294'), isTrue);

        current = current.copyWith(
          status: BookingStatus.completed,
          completionTime: DateTime.now(),
        );
        expect(current.status.isActive, isFalse);
        expect(current.completionTime, isNotNull);

        current = current.copyWith(status: BookingStatus.settled);
        expect(current.status.isActive, isFalse);
        expect(current.status.label, contains('Settled'));
      });
    });

    group('Dynamic Bill Builder Stress Tests', () {
      test('accurately calculates sum with zero parts', () {
        final booking = standardBooking.copyWith(parts: const []);
        expect(booking.partsTotal, equals(0));
        expect(booking.totalAmount, equals(standardBooking.laborFee + standardBooking.safetyShieldFee));
      });

      test('handles 50 dynamic parts without overflow or rounding error', () {
        final partsList = List.generate(
          50,
          (i) => BillPartItem(
            id: 'part_$i',
            name: 'Item #$i',
            unitPrice: 150 + (i * 10),
            quantity: (i % 3) + 1,
          ),
        );

        final expectedPartsSum = partsList.fold<int>(0, (acc, p) => acc + (p.unitPrice * p.quantity));

        final booking = standardBooking.copyWith(parts: partsList);
        expect(booking.partsTotal, equals(expectedPartsSum));
        expect(booking.totalAmount, equals(standardBooking.laborFee + standardBooking.safetyShieldFee + expectedPartsSum));
      });

      test('BillPartItem json serialization and deserialization roundtrip', () {
        const item = BillPartItem(
          id: 'part_test_1',
          name: 'Finolex 4 sq mm Wire',
          unitPrice: 450,
          quantity: 3,
          receiptPhotoUrl: 'https://cdn.karigaar.in/receipts/rec_01.jpg',
          isApproved: true,
        );

        final json = item.toJson();
        final deserialized = BillPartItem.fromJson(json);

        expect(deserialized.id, equals(item.id));
        expect(deserialized.name, equals(item.name));
        expect(deserialized.unitPrice, equals(item.unitPrice));
        expect(deserialized.quantity, equals(item.quantity));
        expect(deserialized.receiptPhotoUrl, equals(item.receiptPhotoUrl));
        expect(deserialized.isApproved, equals(item.isApproved));
        expect(deserialized.total, equals(1350));
      });
    });
  });
}
