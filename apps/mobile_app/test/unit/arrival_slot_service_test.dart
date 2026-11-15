import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/arrival_slot_model.dart';
import 'package:karigaar_app/core/services/api_service.dart';

void main() {
  group('Ticket T-08 Unit Tests: Scheduled Arrival Slot Service (F-11 & Contract 9)', () {
    late KarigaarApiService apiService;

    setUp(() {
      apiService = const KarigaarApiService();
    });

    test('1. SlotCategory returns correct time windows and labels', () {
      expect(SlotCategory.emergency.label, 'Emergency Dispatch');
      expect(SlotCategory.emergency.defaultTimeWindow, 'Within 25 Mins');
      expect(SlotCategory.morning.defaultTimeWindow, '9:00 AM - 12:00 PM');
      expect(SlotCategory.afternoon.defaultTimeWindow, '1:00 PM - 4:00 PM');
      expect(SlotCategory.evening.defaultTimeWindow, '5:00 PM - 8:00 PM');
    });

    test('2. SlotCategory.fromString parses slot strings accurately', () {
      expect(SlotCategory.fromString('slot_emergency'), SlotCategory.emergency);
      expect(SlotCategory.fromString('EMERGENCY'), SlotCategory.emergency);
      expect(SlotCategory.fromString('slot_morning'), SlotCategory.morning);
      expect(SlotCategory.fromString('slot_afternoon'), SlotCategory.afternoon);
      expect(SlotCategory.fromString('slot_evening'), SlotCategory.evening);
    });

    test('3. ArrivalSlotModel.getUpcomingDays(7) generates 7 consecutive days starting today', () {
      final base = DateTime(2026, 11, 14);
      final days = ArrivalSlotModel.getUpcomingDays(7, base);

      expect(days.length, 7);
      expect(days[0], DateTime(2026, 11, 14));
      expect(days[1], DateTime(2026, 11, 15));
      expect(days[6], DateTime(2026, 11, 20));
    });

    test('4. ArrivalSlotModel.defaultSlotsForDate returns 4 categorized slots', () {
      final date = DateTime(2026, 11, 15);
      final slots = ArrivalSlotModel.defaultSlotsForDate(date);

      expect(slots.length, 4);
      expect(slots.map((s) => s.category).toList(), [
        SlotCategory.emergency,
        SlotCategory.morning,
        SlotCategory.afternoon,
        SlotCategory.evening,
      ]);
    });

    test('5. Past slot filtering: at 10:00 AM on today, morning slot is expired', () {
      final today = DateTime(2026, 11, 14);
      final now10am = DateTime(2026, 11, 14, 10, 0);

      final slots = ArrivalSlotModel.defaultSlotsForDate(today, now10am);
      final morning = slots.firstWhere((s) => s.category == SlotCategory.morning);
      final afternoon = slots.firstWhere((s) => s.category == SlotCategory.afternoon);

      expect(morning.isAvailable, isFalse);
      expect(morning.capacityStatus, 'Closed for Today');
      expect(afternoon.isAvailable, isTrue);
    });

    test('6. Past slot filtering: at 2:00 PM (14:00) on today, morning & afternoon slots are expired', () {
      final today = DateTime(2026, 11, 14);
      final now2pm = DateTime(2026, 11, 14, 14, 0);

      final slots = ArrivalSlotModel.defaultSlotsForDate(today, now2pm);
      final morning = slots.firstWhere((s) => s.category == SlotCategory.morning);
      final afternoon = slots.firstWhere((s) => s.category == SlotCategory.afternoon);
      final evening = slots.firstWhere((s) => s.category == SlotCategory.evening);

      expect(morning.isAvailable, isFalse);
      expect(afternoon.isAvailable, isFalse);
      expect(evening.isAvailable, isTrue);
    });

    test('7. Past slot filtering: at 6:00 PM (18:00) on today, all scheduled slots are expired', () {
      final today = DateTime(2026, 11, 14);
      final now6pm = DateTime(2026, 11, 14, 18, 0);

      final slots = ArrivalSlotModel.defaultSlotsForDate(today, now6pm);
      final morning = slots.firstWhere((s) => s.category == SlotCategory.morning);
      final afternoon = slots.firstWhere((s) => s.category == SlotCategory.afternoon);
      final evening = slots.firstWhere((s) => s.category == SlotCategory.evening);
      final emergency = slots.firstWhere((s) => s.category == SlotCategory.emergency);

      expect(morning.isAvailable, isFalse);
      expect(afternoon.isAvailable, isFalse);
      expect(evening.isAvailable, isFalse);
      expect(emergency.isAvailable, isTrue); // Emergency never expires
    });

    test('8. Emergency slot remains available 24/7 across all dates', () {
      final today = DateTime(2026, 11, 14);
      final nowMidnight = DateTime(2026, 11, 14, 23, 45);

      final slots = ArrivalSlotModel.defaultSlotsForDate(today, nowMidnight);
      final emergency = slots.firstWhere((s) => s.category == SlotCategory.emergency);

      expect(emergency.isAvailable, isTrue);
      expect(emergency.isEmergency, isTrue);
      expect(emergency.capacityStatus, contains('Instant Dispatch'));
    });

    test('9. Future dates have all slots available regardless of current hour', () {
      final tomorrow = DateTime(2026, 11, 15);
      final nowNight = DateTime(2026, 11, 14, 22, 0);

      final slots = ArrivalSlotModel.defaultSlotsForDate(tomorrow, nowNight);
      for (final slot in slots) {
        expect(slot.isAvailable, isTrue);
      }
    });

    test('10. ScheduledArrivalSlot serialization and deserialization (toJson / fromJson)', () {
      const slot = ScheduledArrivalSlot(
        slotId: 'slot_morning',
        category: SlotCategory.morning,
        timeWindow: '9:00 AM - 12:00 PM',
        capacityStatus: 'Available (4 spots)',
        isAvailable: true,
        startHour: 9,
        endHour: 12,
      );

      final json = slot.toJson();
      expect(json['slotId'], 'slot_morning');
      expect(json['category'], 'MORNING');
      expect(json['timeWindow'], '9:00 AM - 12:00 PM');

      final reconstructed = ScheduledArrivalSlot.fromJson(json);
      expect(reconstructed.slotId, slot.slotId);
      expect(reconstructed.category, slot.category);
      expect(reconstructed.timeWindow, slot.timeWindow);
      expect(reconstructed.isAvailable, isTrue);
    });

    test('11. ArrivalSlotModel serialization and deserialization preserves slot list', () {
      final model = ArrivalSlotModel(
        date: DateTime(2026, 11, 16),
        slots: ArrivalSlotModel.defaultSlotsForDate(DateTime(2026, 11, 16)),
      );

      final json = model.toJson();
      expect(json['date'], '2026-11-16');
      expect((json['slots'] as List).length, 4);

      final reconstructed = ArrivalSlotModel.fromJson(json);
      expect(reconstructed.date.year, 2026);
      expect(reconstructed.date.month, 11);
      expect(reconstructed.date.day, 16);
      expect(reconstructed.slots.length, 4);
    });

    test('12. Contract 9 API: getArrivalSlots returns conforming response structure', () async {
      final res = await apiService.getArrivalSlots(
        tradeId: 'trade_electrician',
        localityId: 'loc_anand_nagar',
        date: DateTime(2026, 11, 14),
      );

      expect(res['status'], 'SUCCESS');
      final data = res['data'] as Map<String, dynamic>;
      expect(data['tradeId'], 'trade_electrician');
      expect(data['localityId'], 'loc_anand_nagar');
      expect(data['date'], contains('2026-11-14'));
      final slots = data['slots'] as List<dynamic>;
      expect(slots.length, 4);
    });

    test('13. Contract 9 API: getArrivalSlots enforces parameter validation', () async {
      expect(
        () => apiService.getArrivalSlots(
          tradeId: '',
          localityId: 'loc_anand_nagar',
          date: DateTime.now(),
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 422)
              .having((e) => e.code, 'code', 'MISSING_TRADE_ID'),
        ),
      );

      expect(
        () => apiService.getArrivalSlots(
          tradeId: 'trade_electrician',
          localityId: '',
          date: DateTime.now(),
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 422)
              .having((e) => e.code, 'code', 'MISSING_LOCALITY_ID'),
        ),
      );
    });

    test('14. Contract 9 API: reserveArrivalSlot locks slot and returns reservation ID', () async {
      final res = await apiService.reserveArrivalSlot(
        bookingId: 'BK_NANDED_8821',
        tradeId: 'trade_electrician',
        date: DateTime(2026, 11, 14),
        slotId: 'slot_morning',
      );

      expect(res['status'], 'SUCCESS');
      final data = res['data'] as Map<String, dynamic>;
      expect(data['reservationId'], startsWith('res_slot_'));
      expect(data['bookingId'], 'BK_NANDED_8821');
      expect(data['scheduledSlot'], contains('Morning'));
      expect(data['lockExpiresAt'], isNotEmpty);
    });

    test('15. Contract 9 API: reserveArrivalSlot validates bookingId and slotId', () async {
      expect(
        () => apiService.reserveArrivalSlot(
          bookingId: '',
          tradeId: 'trade_electrician',
          date: DateTime.now(),
          slotId: 'slot_morning',
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 422)
              .having((e) => e.code, 'code', 'MISSING_BOOKING_ID'),
        ),
      );
    });
  });
}
