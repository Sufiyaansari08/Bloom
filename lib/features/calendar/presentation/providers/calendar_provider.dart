import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarState {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final List<DateTime> periodDays;
  final List<DateTime> fertileDays;
  final DateTime? ovulationDay;

  CalendarState({
    required this.selectedDay,
    required this.focusedDay,
    this.periodDays = const [],
    this.fertileDays = const [],
    this.ovulationDay,
  });

  CalendarState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<DateTime>? periodDays,
    List<DateTime>? fertileDays,
    DateTime? ovulationDay,
  }) {
    return CalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      periodDays: periodDays ?? this.periodDays,
      fertileDays: fertileDays ?? this.fertileDays,
      ovulationDay: ovulationDay ?? this.ovulationDay,
    );
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier() : super(CalendarState(
    selectedDay: DateTime.now(),
    focusedDay: DateTime.now(),
    // Mock data for UI demonstration
    periodDays: [
      DateTime.now().subtract(const Duration(days: 2)),
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 2)),
    ],
    fertileDays: [
      DateTime.now().add(const Duration(days: 10)),
      DateTime.now().add(const Duration(days: 11)),
      DateTime.now().add(const Duration(days: 12)),
      DateTime.now().add(const Duration(days: 13)),
      DateTime.now().add(const Duration(days: 14)),
    ],
    ovulationDay: DateTime.now().add(const Duration(days: 12)),
  ));

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    state = state.copyWith(
      selectedDay: selectedDay,
      focusedDay: focusedDay,
    );
  }

  void onPageChanged(DateTime focusedDay) {
    state = state.copyWith(focusedDay: focusedDay);
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier();
});
