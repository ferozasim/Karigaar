/// Category of service arrival window conforming to F-11 specifications.
enum SlotCategory {
  emergency,
  morning,
  afternoon,
  evening;

  String get label {
    switch (this) {
      case SlotCategory.emergency:
        return 'Emergency Dispatch';
      case SlotCategory.morning:
        return 'Morning Slot';
      case SlotCategory.afternoon:
        return 'Afternoon Slot';
      case SlotCategory.evening:
        return 'Evening Slot';
    }
  }

  String get defaultTimeWindow {
    switch (this) {
      case SlotCategory.emergency:
        return 'Within 25 Mins';
      case SlotCategory.morning:
        return '9:00 AM - 12:00 PM';
      case SlotCategory.afternoon:
        return '1:00 PM - 4:00 PM';
      case SlotCategory.evening:
        return '5:00 PM - 8:00 PM';
    }
  }

  int get defaultStartHour {
    switch (this) {
      case SlotCategory.emergency:
        return 0; // Emergency is 24/7 or current time
      case SlotCategory.morning:
        return 9;
      case SlotCategory.afternoon:
        return 13;
      case SlotCategory.evening:
        return 17;
    }
  }

  int get defaultEndHour {
    switch (this) {
      case SlotCategory.emergency:
        return 24;
      case SlotCategory.morning:
        return 12;
      case SlotCategory.afternoon:
        return 16;
      case SlotCategory.evening:
        return 20;
    }
  }

  static SlotCategory fromString(String val) {
    final lower = val.toLowerCase().trim();
    if (lower.contains('emergency')) return SlotCategory.emergency;
    if (lower.contains('morning')) return SlotCategory.morning;
    if (lower.contains('afternoon')) return SlotCategory.afternoon;
    if (lower.contains('evening')) return SlotCategory.evening;
    return SlotCategory.morning;
  }
}

/// A specific scheduled arrival time window.
class ScheduledArrivalSlot {
  final String slotId;
  final SlotCategory category;
  final String timeWindow;
  final String capacityStatus;
  final bool isAvailable;
  final int startHour;
  final int endHour;

  const ScheduledArrivalSlot({
    required this.slotId,
    required this.category,
    required this.timeWindow,
    required this.capacityStatus,
    this.isAvailable = true,
    required this.startHour,
    required this.endHour,
  });

  bool get isEmergency => category == SlotCategory.emergency;

  /// Determines if this slot has expired based on current local date and time.
  /// For today's date, if current time is past startHour, regular scheduled slots expire.
  bool isExpired(DateTime date, [DateTime? now]) {
    final current = now ?? DateTime.now();
    final isToday = date.year == current.year &&
        date.month == current.month &&
        date.day == current.day;

    if (!isToday) {
      // Future dates do not expire by hour; past dates are all expired
      final targetDate = DateTime(date.year, date.month, date.day);
      final todayDate = DateTime(current.year, current.month, current.day);
      return targetDate.isBefore(todayDate);
    }

    // Emergency slot never expires during active operational hours
    if (isEmergency) return false;

    // A scheduled slot expires if the current hour is past the startHour
    return current.hour >= startHour;
  }

  ScheduledArrivalSlot copyWith({
    String? slotId,
    SlotCategory? category,
    String? timeWindow,
    String? capacityStatus,
    bool? isAvailable,
    int? startHour,
    int? endHour,
  }) {
    return ScheduledArrivalSlot(
      slotId: slotId ?? this.slotId,
      category: category ?? this.category,
      timeWindow: timeWindow ?? this.timeWindow,
      capacityStatus: capacityStatus ?? this.capacityStatus,
      isAvailable: isAvailable ?? this.isAvailable,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
    );
  }

  factory ScheduledArrivalSlot.fromJson(Map<String, dynamic> json) {
    final cat = SlotCategory.fromString(json['category'] as String? ?? 'MORNING');
    return ScheduledArrivalSlot(
      slotId: json['slotId'] as String,
      category: cat,
      timeWindow: json['timeWindow'] as String? ?? cat.defaultTimeWindow,
      capacityStatus: json['capacityStatus'] as String? ?? 'Available',
      isAvailable: json['isAvailable'] as bool? ?? true,
      startHour: (json['startHour'] as num?)?.toInt() ?? cat.defaultStartHour,
      endHour: (json['endHour'] as num?)?.toInt() ?? cat.defaultEndHour,
    );
  }

  Map<String, dynamic> toJson() => {
        'slotId': slotId,
        'category': category.name.toUpperCase(),
        'timeWindow': timeWindow,
        'capacityStatus': capacityStatus,
        'isAvailable': isAvailable,
        'startHour': startHour,
        'endHour': endHour,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledArrivalSlot &&
          runtimeType == other.runtimeType &&
          slotId == other.slotId;

  @override
  int get hashCode => slotId.hashCode;

  @override
  String toString() =>
      'ScheduledArrivalSlot(id: $slotId, window: $timeWindow, available: $isAvailable)';
}

/// 7-day Arrival Matrix Model conforming to PROJECT.md Contract 9.
class ArrivalSlotModel {
  final DateTime date;
  final List<ScheduledArrivalSlot> slots;

  const ArrivalSlotModel({
    required this.date,
    required this.slots,
  });

  /// Generate default slots for a given date, dynamically marking past slots as expired for today.
  static List<ScheduledArrivalSlot> defaultSlotsForDate(
    DateTime date, [
    DateTime? now,
  ]) {
    final current = now ?? DateTime.now();
    final isToday = date.year == current.year &&
        date.month == current.month &&
        date.day == current.day;

    const emergency = ScheduledArrivalSlot(
      slotId: 'slot_emergency',
      category: SlotCategory.emergency,
      timeWindow: 'Within 25 Mins',
      capacityStatus: 'Instant Dispatch (3 Master Artisans)',
      isAvailable: true,
      startHour: 0,
      endHour: 24,
    );

    final morningExpired = isToday && current.hour >= 9;
    final morning = ScheduledArrivalSlot(
      slotId: 'slot_morning',
      category: SlotCategory.morning,
      timeWindow: '9:00 AM - 12:00 PM',
      capacityStatus: morningExpired ? 'Closed for Today' : 'Available (4 spots)',
      isAvailable: !morningExpired,
      startHour: 9,
      endHour: 12,
    );

    final afternoonExpired = isToday && current.hour >= 13;
    final afternoon = ScheduledArrivalSlot(
      slotId: 'slot_afternoon',
      category: SlotCategory.afternoon,
      timeWindow: '1:00 PM - 4:00 PM',
      capacityStatus:
          afternoonExpired ? 'Closed for Today' : 'Filling Fast (1 spot left)',
      isAvailable: !afternoonExpired,
      startHour: 13,
      endHour: 16,
    );

    final eveningExpired = isToday && current.hour >= 17;
    final evening = ScheduledArrivalSlot(
      slotId: 'slot_evening',
      category: SlotCategory.evening,
      timeWindow: '5:00 PM - 8:00 PM',
      capacityStatus: eveningExpired ? 'Closed for Today' : 'Available (5 spots)',
      isAvailable: !eveningExpired,
      startHour: 17,
      endHour: 20,
    );

    return [emergency, morning, afternoon, evening];
  }

  /// Returns 7 consecutive dates (Today + 6 upcoming days).
  static List<DateTime> getUpcomingDays([int count = 7, DateTime? start]) {
    final base = start ?? DateTime.now();
    final cleanBase = DateTime(base.year, base.month, base.day);
    return List.generate(count, (index) => cleanBase.add(Duration(days: index)));
  }

  factory ArrivalSlotModel.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String? ?? DateTime.now().toIso8601String();
    final parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
    final rawSlots = json['slots'] as List<dynamic>? ?? [];
    return ArrivalSlotModel(
      date: parsedDate,
      slots: rawSlots
          .map((s) => ScheduledArrivalSlot.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date':
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'slots': slots.map((s) => s.toJson()).toList(),
      };
}
