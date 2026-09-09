import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../checkin/presentation/providers/daily_checkin_provider.dart';

class CalendarState {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final List<DateTime> periodDays;
  final List<DateTime> expectedPeriodDays;
  final List<DateTime> fertileDays;
  final DateTime? ovulationDay;

  CalendarState({
    required this.selectedDay,
    required this.focusedDay,
    this.periodDays = const [],
    this.expectedPeriodDays = const [],
    this.fertileDays = const [],
    this.ovulationDay,
  });

  CalendarState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<DateTime>? periodDays,
    List<DateTime>? expectedPeriodDays,
    List<DateTime>? fertileDays,
    DateTime? ovulationDay,
  }) {
    return CalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      periodDays: periodDays ?? this.periodDays,
      expectedPeriodDays: expectedPeriodDays ?? this.expectedPeriodDays,
      fertileDays: fertileDays ?? this.fertileDays,
      ovulationDay: ovulationDay ?? this.ovulationDay,
    );
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  final Ref ref;

  CalendarNotifier(this.ref) : super(CalendarState(
    selectedDay: DateTime.now(),
    focusedDay: DateTime.now(),
    periodDays: [],
    fertileDays: [],
  )) {
    ref.listen(allDailyLogsStreamProvider, (previous, next) {
      if (next.value != null) {
        final logs = next.value!;
        final periodDays = logs
            .where((log) => log.flowIntensity != null)
            .map((log) => log.date)
            .toList();
        state = state.copyWith(periodDays: periodDays);
      }
    }, fireImmediately: true);

    ref.listen(currentCycleStreamProvider, (previous, next) {
      if (next.value != null) {
        final cycle = next.value!;
        final user = ref.read(userProfileStreamProvider).value;
        final avgCycleLen = user?.avgCycleLength ?? 28;
        final avgPeriodLen = user?.avgPeriodLength ?? 5;
        
        final start = cycle.startDate;
        
        // Fertile window calculation
        final fertileDays = List.generate(6, (i) => start.add(Duration(days: avgCycleLen - 16 + i)));
        final ovulationDay = start.add(Duration(days: avgCycleLen - 14));
        
        // Expected period calculation
        final nextPeriodStart = start.add(Duration(days: avgCycleLen));
        final expectedPeriodDays = List.generate(avgPeriodLen, (i) => nextPeriodStart.add(Duration(days: i)));
        
        state = state.copyWith(
          fertileDays: fertileDays, 
          ovulationDay: ovulationDay,
          expectedPeriodDays: expectedPeriodDays,
        );
      }
    }, fireImmediately: true);
  }

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
  return CalendarNotifier(ref);
});

final dailyCheckinForSelectedDayProvider = Provider<AsyncValue<DailyCheckinState?>>((ref) {
  final selectedDay = ref.watch(calendarProvider).selectedDay;
  final logsAsync = ref.watch(allDailyLogsStreamProvider);
  
  return logsAsync.when(
    data: (logs) {
      final log = logs.where((l) => l.date.year == selectedDay.year && l.date.month == selectedDay.month && l.date.day == selectedDay.day).firstOrNull;
      if (log == null) return const AsyncValue.data(null);
      
      final symptomsAsync = ref.watch(symptomsForLogStreamProvider(log.id));
      
      return symptomsAsync.when(
        data: (symptoms) {
          final state = DailyCheckinState(
            mood: log.mood,
            sleep: log.sleepHours != null ? '${log.sleepHours} hrs' : null,
            waterIntake: log.waterIntake,
            activity: log.activityLevel,
            notes: log.notes ?? '',
            symptoms: symptoms.map((s) => s.symptomName).toList(),
          );
          return AsyncValue.data(state);
        },
        loading: () => const AsyncValue.loading(),
        error: (err, stack) => AsyncValue.error(err, stack),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
