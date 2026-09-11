import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../checkin/presentation/providers/daily_checkin_provider.dart';

class CalendarState {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final List<DateTime> periodDays;
  final List<DateTime> expectedPeriodDays;
  final List<DateTime> fertileDays;
  final List<DateTime> ovulationDays;
  final DateTime? ovulationDay;
  final DateTime? nextPeriodStartDate;
  final DateTime? nextPeriodEndDate;

  CalendarState({
    required this.selectedDay,
    required this.focusedDay,
    this.periodDays = const [],
    this.expectedPeriodDays = const [],
    this.fertileDays = const [],
    this.ovulationDays = const [],
    this.ovulationDay,
    this.nextPeriodStartDate,
    this.nextPeriodEndDate,
  });

  CalendarState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<DateTime>? periodDays,
    List<DateTime>? expectedPeriodDays,
    List<DateTime>? fertileDays,
    List<DateTime>? ovulationDays,
    DateTime? ovulationDay,
    DateTime? nextPeriodStartDate,
    DateTime? nextPeriodEndDate,
    bool clearOvulationDay = false,
    bool clearPeriodSummary = false,
  }) {
    return CalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      periodDays: periodDays ?? this.periodDays,
      expectedPeriodDays: expectedPeriodDays ?? this.expectedPeriodDays,
      fertileDays: fertileDays ?? this.fertileDays,
      ovulationDays: ovulationDays ?? this.ovulationDays,
      ovulationDay: clearOvulationDay ? null : (ovulationDay ?? this.ovulationDay),
      nextPeriodStartDate: clearPeriodSummary ? null : (nextPeriodStartDate ?? this.nextPeriodStartDate),
      nextPeriodEndDate: clearPeriodSummary ? null : (nextPeriodEndDate ?? this.nextPeriodEndDate),
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
      _recomputeCyclePredictions();
    }, fireImmediately: true);

    ref.listen(allCyclesStreamProvider, (previous, next) {
      _recomputeCyclePredictions();
    }, fireImmediately: true);

    ref.listen(userProfileStreamProvider, (previous, next) {
      _recomputeCyclePredictions();
    }, fireImmediately: true);
  }

  void _recomputeCyclePredictions() {
    final currentCycle = ref.read(currentCycleStreamProvider).value;
    final allCycles = ref.read(allCyclesStreamProvider).value ?? [];
    final user = ref.read(userProfileStreamProvider).value;

    final isPeriodPredictionEnabled = user?.periodPredictionEnabled ?? true;
    final isOvulationEnabled = user?.ovulationPredictionEnabled ?? true;
    final isFertileWindowEnabled = user?.fertileWindowEnabled ?? true;

    final avgCycleLen = user?.avgCycleLength ?? 29;
    final avgPeriodLen = user?.avgPeriodLength ?? 5;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Determine reference cycle start date
    DateTime cycleStart;
    if (currentCycle != null) {
      cycleStart = currentCycle.startDate;
    } else if (allCycles.isNotEmpty) {
      cycleStart = allCycles.first.startDate;
    } else {
      cycleStart = now.subtract(const Duration(days: 14));
    }

    final List<DateTime> allExpectedPeriodDays = [];
    final List<DateTime> allFertileDays = [];
    final List<DateTime> allOvulationDays = [];
    DateTime? nextOvulation;
    DateTime? nextPeriodStart;
    DateTime? nextPeriodEnd;

    // Project predictions forward across cycles (up to 12 cycles = 1 year)
    DateTime cycleRef = DateTime(cycleStart.year, cycleStart.month, cycleStart.day);

    // If cycleStart is far in the past, align reference point
    while (cycleRef.isBefore(today.subtract(const Duration(days: 60)))) {
      cycleRef = cycleRef.add(Duration(days: avgCycleLen));
    }

    for (int c = 0; c < 12; c++) {
      final periodStart = cycleRef.add(Duration(days: avgCycleLen));
      final ovulation = cycleRef.add(Duration(days: avgCycleLen - 14));
      final fertileStart = cycleRef.add(Duration(days: avgCycleLen - 16));

      if (isPeriodPredictionEnabled) {
        for (int p = 0; p < avgPeriodLen; p++) {
          allExpectedPeriodDays.add(periodStart.add(Duration(days: p)));
        }
      }

      if (isFertileWindowEnabled) {
        for (int f = 0; f < 6; f++) {
          allFertileDays.add(fertileStart.add(Duration(days: f)));
        }
      }

      if (isOvulationEnabled) {
        allOvulationDays.add(ovulation);
      }

      // First upcoming ovulation on or after today
      if (isOvulationEnabled && nextOvulation == null) {
        if (!ovulation.isBefore(today.subtract(const Duration(days: 1)))) {
          nextOvulation = ovulation;
        }
      }

      // First upcoming period on or after today
      if (isPeriodPredictionEnabled && nextPeriodStart == null) {
        if (!periodStart.isBefore(today.subtract(Duration(days: avgPeriodLen)))) {
          nextPeriodStart = periodStart;
          nextPeriodEnd = periodStart.add(Duration(days: avgPeriodLen - 1));
        }
      }

      cycleRef = periodStart;
    }

    if (isOvulationEnabled && nextOvulation == null && allOvulationDays.isNotEmpty) {
      nextOvulation = allOvulationDays.first;
    }

    state = state.copyWith(
      fertileDays: allFertileDays,
      ovulationDays: allOvulationDays,
      ovulationDay: nextOvulation,
      clearOvulationDay: !isOvulationEnabled || nextOvulation == null,
      expectedPeriodDays: allExpectedPeriodDays,
      nextPeriodStartDate: nextPeriodStart,
      nextPeriodEndDate: nextPeriodEnd,
      clearPeriodSummary: !isPeriodPredictionEnabled || nextPeriodStart == null,
    );
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
