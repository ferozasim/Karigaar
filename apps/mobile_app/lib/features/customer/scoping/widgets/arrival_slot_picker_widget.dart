import 'package:flutter/material.dart';
import '../../../../l10n/localized_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/arrival_slot_model.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Scheduled Arrival Slot Picker Widget conforming to F-11 specifications.
/// Includes 7-day horizontal date carousel, categorized time windows,
/// auto-expired past slot filtering for today, and partner capacity indicators.
class ArrivalSlotPickerWidget extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final ScheduledArrivalSlot? initialSlot;
  final DateTime? currentTime;
  final void Function(DateTime date, ScheduledArrivalSlot slot)? onSlotSelected;

  const ArrivalSlotPickerWidget({
    super.key,
    this.initialDate,
    this.initialSlot,
    this.currentTime,
    this.onSlotSelected,
  });

  @override
  ConsumerState<ArrivalSlotPickerWidget> createState() =>
      _ArrivalSlotPickerWidgetState();
}

class _ArrivalSlotPickerWidgetState
    extends ConsumerState<ArrivalSlotPickerWidget> {
  late DateTime _selectedDate;
  ScheduledArrivalSlot? _selectedSlot;
  late List<DateTime> _upcomingDays;

  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    final now = widget.currentTime ?? DateTime.now();
    _upcomingDays = ArrivalSlotModel.getUpcomingDays(7, now);

    final baseDate = widget.initialDate ?? now;
    _selectedDate = DateTime(baseDate.year, baseDate.month, baseDate.day);

    _selectedSlot = widget.initialSlot;
    if (_selectedSlot == null) {
      final defaultSlots =
          ArrivalSlotModel.defaultSlotsForDate(_selectedDate, widget.currentTime);
      _selectedSlot = defaultSlots.firstWhere(
        (s) => s.isAvailable && !s.isEmergency,
        orElse: () => defaultSlots.first,
      );
    }
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      ref.read(selectedArrivalDateProvider.notifier).state = date;

      // Re-evaluate slots for newly selected date
      final slots =
          ArrivalSlotModel.defaultSlotsForDate(date, widget.currentTime);
      if (_selectedSlot == null ||
          !slots.any((s) => s.slotId == _selectedSlot!.slotId && s.isAvailable)) {
        _selectedSlot = slots.firstWhere(
          (s) => s.isAvailable && !s.isEmergency,
          orElse: () => slots.first,
        );
      }
      ref.read(selectedArrivalSlotProvider.notifier).state = _selectedSlot;
      if (_selectedSlot != null) {
        widget.onSlotSelected?.call(_selectedDate, _selectedSlot!);
      }
    });
  }

  void _onSlotChanged(ScheduledArrivalSlot slot) {
    if (!slot.isAvailable) return;
    setState(() {
      _selectedSlot = slot;
      ref.read(selectedArrivalSlotProvider.notifier).state = slot;
      widget.onSlotSelected?.call(_selectedDate, slot);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = widget.currentTime ?? DateTime.now();
    final slots =
        ArrivalSlotModel.defaultSlotsForDate(_selectedDate, widget.currentTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                localizedStrings(context).flowArrivalDateSlot,
                style: AppTypography.headlineSm.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              fit: FlexFit.loose,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurfaceTint,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '7-Day Window',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 7-Day Horizontal Date Carousel
        SizedBox(
          height: 78,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _upcomingDays.length,
            itemBuilder: (context, index) {
              final date = _upcomingDays[index];
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;
              final isToday = date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;

              final weekday = _weekdays[date.weekday - 1];
              final month = _months[date.month - 1];

              return GestureDetector(
                key: Key('date_chip_${date.year}_${date.month}_${date.day}'),
                onTap: () => _onDateChanged(date),
                child: Container(
                  width: 68,
                  margin: EdgeInsets.only(
                    right: 8,
                    left: index == 0 ? 0 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderSubtle,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            margin: const EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.secondarySurfaceTint,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              localizedStrings(context).flowToday,
                              style: AppTypography.labelSm.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.secondary,
                              ),
                            ),
                          )
                        else
                          Text(
                            weekday,
                            style: AppTypography.labelSm.copyWith(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.textMuted,
                            ),
                          ),
                        Text(
                          '${date.day}',
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          month,
                          style: AppTypography.labelSm.copyWith(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white70
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Categorized Time Slot Cards
        ...slots.map((slot) {
          final isSelected = _selectedSlot?.slotId == slot.slotId;
          final isExpired = !slot.isAvailable;
          final isEmergency = slot.isEmergency;

          return GestureDetector(
            key: Key('slot_card_${slot.slotId}'),
            onTap: isExpired ? null : () => _onSlotChanged(slot),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isExpired
                    ? AppColors.surfaceSubtle.withValues(alpha: 0.6)
                    : isSelected
                        ? (isEmergency
                            ? const Color(0xFFFFFBEB)
                            : AppColors.surfaceSubtle)
                        : AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isExpired
                      ? AppColors.borderSubtle
                      : isSelected
                          ? (isEmergency
                              ? AppColors.secondary
                              : AppColors.primary)
                          : AppColors.borderSubtle,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isExpired
                        ? Icons.block_rounded
                        : isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                    color: isExpired
                        ? AppColors.textSubtle
                        : isSelected
                            ? (isEmergency
                                ? AppColors.secondary
                                : AppColors.primary)
                            : AppColors.textSubtle,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (isEmergency)
                              Flexible(
                                fit: FlexFit.loose,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondarySurfaceTint,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      localizedStrings(context).flowEmergency,
                                      style: AppTypography.labelSm.copyWith(
                                        color: AppColors.secondary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                slot.timeWindow,
                                style: AppTypography.labelMd.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isExpired
                                      ? AppColors.textMuted
                                      : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isExpired
                                  ? Icons.access_time_filled_rounded
                                  : isEmergency
                                      ? Icons.bolt_rounded
                                      : Icons.people_alt_outlined,
                              size: 13,
                              color: isExpired
                                  ? AppColors.textMuted
                                  : isEmergency
                                      ? AppColors.secondary
                                      : AppColors.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                slot.capacityStatus,
                                style: AppTypography.labelSm.copyWith(
                                  fontSize: 11,
                                  color: isExpired
                                      ? AppColors.textMuted
                                      : isEmergency
                                          ? AppColors.secondary
                                          : AppColors.tertiary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected && !isExpired)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isEmergency
                            ? AppColors.secondary
                            : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
