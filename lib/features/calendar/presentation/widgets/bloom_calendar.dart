import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';

class BloomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<DateTime> periodDays;
  final List<DateTime> fertileDays;
  final DateTime? ovulationDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const BloomCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.periodDays,
    required this.fertileDays,
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

  bool _isFertileDay(DateTime day) {
    return fertileDays.any((fertileDay) => _isSameDay(fertileDay, day));
  }

  bool _isOvulationDay(DateTime day) {
    return ovulationDay != null && _isSameDay(ovulationDay!, day);
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
          defaultBuilder: (context, date, events) {
            if (_isPeriodDay(date)) {
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
