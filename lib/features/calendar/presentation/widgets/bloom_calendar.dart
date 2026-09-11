import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';

class BloomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<DateTime> periodDays;
  final List<DateTime> expectedPeriodDays;
  final List<DateTime> fertileDays;
  final List<DateTime> ovulationDays;
  final DateTime? ovulationDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const BloomCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.periodDays,
    this.expectedPeriodDays = const [],
    required this.fertileDays,
    this.ovulationDays = const [],
    this.ovulationDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return isSameDay(a, b);
  }

  bool _isPeriodDay(DateTime day) {
    return periodDays.any((periodDay) => _isSameDay(periodDay, day));
  }

  bool _isExpectedPeriodDay(DateTime day) {
    return expectedPeriodDays.any((expectedDay) => _isSameDay(expectedDay, day));
  }

  bool _isAnyPeriodDay(DateTime day) {
    return _isPeriodDay(day) || _isExpectedPeriodDay(day);
  }

  bool _isFertileDay(DateTime day) {
    return fertileDays.any((fertileDay) => _isSameDay(fertileDay, day));
  }

  bool _isOvulationDay(DateTime day) {
    return ovulationDays.any((d) => _isSameDay(d, day)) ||
        (ovulationDay != null && _isSameDay(ovulationDay!, day));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => _isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primaryPurple),
          rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.primaryPurple),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.w600),
          weekendStyle: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.w600),
        ),
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: AppColors.lightPink,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) {
            if (_isAnyPeriodDay(date)) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryPurple, width: 2.5),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (_isOvulationDay(date)) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryPurple, width: 2.5),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (_isFertileDay(date)) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryPurple, width: 2.5),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primaryPurple,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
          todayBuilder: (context, date, events) {
            if (_isAnyPeriodDay(date)) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (_isOvulationDay(date)) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (_isFertileDay(date)) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1.5),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          defaultBuilder: (context, date, events) {
            // Period red circle (both logged and expected predicted period days)
            if (_isAnyPeriodDay(date)) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (_isOvulationDay(date)) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (_isFertileDay(date)) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              );
            }
            return null; // Fallback to default
          },
        ),
      ),
    );
  }
}
