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
  final bool isPeriodLate;
  final int daysLate;

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
    this.isPeriodLate = false,
    this.daysLate = 0,
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
    bool? isPeriodLate,
    int? daysLate,
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
      ovulationDay: clearOvulationDay
          ? null
          : (ovulationDay ?? this.ovulationDay),
      nextPeriodStartDate: clearPeriodSummary
          ? null
          : (nextPeriodStartDate ?? this.nextPeriodStartDate),
      nextPeriodEndDate: clearPeriodSummary
          ? null
          : (nextPeriodEndDate ?? this.nextPeriodEndDate),
      isPeriodLate: isPeriodLate ?? this.isPeriodLate,
      daysLate: daysLate ?? this.daysLate,
    );
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  final Ref ref;

  CalendarNotifier(this.ref)
    : super(
        CalendarState(
          selectedDay: DateTime.now(),
          focusedDay: DateTime.now(),
          periodDays: [],
          fertileDays: [],
        ),
      ) {
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

    final allDailyLogs = ref.read(allDailyLogsStreamProvider).value ?? [];

    final List<DateTime> allExpectedPeriodDays = [];
    final List<DateTime> allFertileDays = [];
    final List<DateTime> allOvulationDays = [];
    DateTime? nextOvulation;
    DateTime? nextPeriodStart;
    DateTime? nextPeriodEnd;

    // Check if period is late:
    // Ongoing cycle started at currentCycle.startDate
    // The period concluding this cycle was expected at currentCycle.startDate + avgCycleLen
    bool isPeriodLate = false;
    int daysLate = 0;
    DateTime? lateExpectedPeriodStart;

    if (currentCycle != null) {
      final cleanCycleStart = DateTime(
        currentCycle.startDate.year,
        currentCycle.startDate.month,
        currentCycle.startDate.day,
      );
      final expectedDate = cleanCycleStart.add(Duration(days: avgCycleLen));

      // Check if user has already logged a period flow on or around expectedDate
      final hasLoggedFlow = allDailyLogs.any(
        (l) =>
            l.flowIntensity != null &&
            l.flowIntensity != 'None' &&
            !DateTime(
              l.date.year,
              l.date.month,
              l.date.day,
            ).isBefore(expectedDate.subtract(const Duration(days: 3))),
      );

      if (!hasLoggedFlow && today.isAfter(expectedDate)) {
        isPeriodLate = true;
        daysLate = today.difference(expectedDate).inDays;
        lateExpectedPeriodStart = expectedDate;
      }
    }

    if (isPeriodLate && lateExpectedPeriodStart != null) {
      // Period is overdue: keep the expected period days visible and project 1 next cycle
      nextPeriodStart = lateExpectedPeriodStart;
      nextPeriodEnd = lateExpectedPeriodStart.add(
        Duration(days: avgPeriodLen - 1),
      );

      if (isPeriodPredictionEnabled) {
        // Cycle 1: Overdue period days
        for (int p = 0; p < avgPeriodLen; p++) {
          allExpectedPeriodDays.add(
            lateExpectedPeriodStart.add(Duration(days: p)),
          );
        }

        // Cycle 2: Next upcoming cycle period
        final nextStart = lateExpectedPeriodStart.add(
          Duration(days: avgCycleLen),
        );
        for (int p = 0; p < avgPeriodLen; p++) {
          allExpectedPeriodDays.add(nextStart.add(Duration(days: p)));
        }
      }

      // Next cycle ovulation & fertile window
      final nextOvulationDate = lateExpectedPeriodStart.add(
        Duration(days: avgCycleLen * 2 - 14),
      );
      final nextFertileStart = lateExpectedPeriodStart.add(
        Duration(days: avgCycleLen * 2 - 16),
      );
      if (isOvulationEnabled) {
        allOvulationDays.add(nextOvulationDate);
        nextOvulation = nextOvulationDate;
      }
      if (isFertileWindowEnabled) {
        for (int f = 0; f < 6; f++) {
          allFertileDays.add(nextFertileStart.add(Duration(days: f)));
        }
      }
    } else {
      // Standard prediction flow
      // Align reference point if cycleStart was far in the past
      DateTime cycleRef = DateTime(
        cycleStart.year,
        cycleStart.month,
        cycleStart.day,
      );
      while (cycleRef.add(Duration(days: avgCycleLen)).isBefore(today)) {
        cycleRef = cycleRef.add(Duration(days: avgCycleLen));
      }

      // Check if the current cycle's period has already ended in the past
      final currentPeriodEnd = cycleRef.add(Duration(days: avgPeriodLen - 1));
      final currentPeriodHasEnded = currentPeriodEnd.isBefore(today);

      // Current Active Cycle fertile window & ovulation (if active or upcoming)
      final curFertileStart = cycleRef.add(Duration(days: avgCycleLen - 16));
      final curFertileEnd = curFertileStart.add(const Duration(days: 6));
      final curOvulation = cycleRef.add(Duration(days: avgCycleLen - 14));

      if (isFertileWindowEnabled && !curFertileEnd.isBefore(today)) {
        for (int f = 0; f < 6; f++) {
          allFertileDays.add(curFertileStart.add(Duration(days: f)));
        }
      }

      if (isOvulationEnabled &&
          !curOvulation.isBefore(today.subtract(const Duration(days: 1)))) {
        allOvulationDays.add(curOvulation);
        nextOvulation = curOvulation;
      }

      // Strictly predict for upcoming 2 cycles
      final startCycleOffset = currentPeriodHasEnded ? 1 : 0;
      const upcomingCyclesCount = 2;

      for (int i = 0; i < upcomingCyclesCount; i++) {
        final cycleIndex = startCycleOffset + i;
        final periodStart = cycleRef.add(
          Duration(days: avgCycleLen * cycleIndex),
        );
        final ovulation = periodStart.add(Duration(days: avgCycleLen - 14));
        final fertileStart = periodStart.add(Duration(days: avgCycleLen - 16));

        if (isPeriodPredictionEnabled) {
          for (int p = 0; p < avgPeriodLen; p++) {
            allExpectedPeriodDays.add(periodStart.add(Duration(days: p)));
          }
        }

        // If cycleIndex == 0, current cycle fertile & ovulation were already evaluated above
        if (cycleIndex > 0) {
          if (isFertileWindowEnabled) {
            for (int f = 0; f < 6; f++) {
              allFertileDays.add(fertileStart.add(Duration(days: f)));
            }
          }

          if (isOvulationEnabled) {
            allOvulationDays.add(ovulation);
            if (nextOvulation == null &&
                !ovulation.isBefore(today.subtract(const Duration(days: 1)))) {
              nextOvulation = ovulation;
            }
          }
        }

        // First upcoming period on or after today
        if (isPeriodPredictionEnabled && nextPeriodStart == null) {
          if (!periodStart.isBefore(
            today.subtract(Duration(days: avgPeriodLen - 1)),
          )) {
            nextPeriodStart = periodStart;
            nextPeriodEnd = periodStart.add(Duration(days: avgPeriodLen - 1));
          }
        }
      }
    }

    if (isOvulationEnabled &&
        nextOvulation == null &&
        allOvulationDays.isNotEmpty) {
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
      isPeriodLate: isPeriodLate,
      daysLate: daysLate,
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    state = state.copyWith(selectedDay: selectedDay, focusedDay: focusedDay);
  }

  void onPageChanged(DateTime focusedDay) {
    state = state.copyWith(focusedDay: focusedDay);
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) {
    return CalendarNotifier(ref);
  },
);

final dailyCheckinForSelectedDayProvider =
    Provider<AsyncValue<DailyCheckinState?>>((ref) {
      final selectedDay = ref.watch(calendarProvider).selectedDay;
      final logsAsync = ref.watch(allDailyLogsStreamProvider);

      return logsAsync.when(
        data: (logs) {
          final log = logs
              .where(
                (l) =>
                    l.date.year == selectedDay.year &&
                    l.date.month == selectedDay.month &&
                    l.date.day == selectedDay.day,
              )
              .firstOrNull;
          if (log == null) return const AsyncValue.data(null);

          final symptomsAsync = ref.watch(symptomsForLogStreamProvider(log.id));

          return symptomsAsync.when(
            data: (symptoms) {
              final hasAnyCheckin =
                  log.mood != null ||
                  log.sleepHours != null ||
                  log.waterIntake != null ||
                  log.activityLevel != null ||
                  (log.notes != null && log.notes!.isNotEmpty) ||
                  symptoms.isNotEmpty;

              if (!hasAnyCheckin) {
                return const AsyncValue.data(null);
              }

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
