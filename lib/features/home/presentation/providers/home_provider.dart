import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';

class HomeState {
  final String userName;
  final int cycleDay;
  final int daysUntilPeriod;
  final String periodDateRange;
  final String fertileWindowRange;
  final int symptomsLogged;
  final int painLevel;
  final String mood;
  final bool isPeriodLate;
  final bool isPeriodOngoing;
  final int periodDay;

  HomeState({
    this.userName = 'Guest',
    this.cycleDay = 1,
    this.daysUntilPeriod = 0,
    this.periodDateRange = '--',
    this.fertileWindowRange = '--',
    this.symptomsLogged = 0,
    this.painLevel = 0,
    this.mood = 'None',
    this.isPeriodLate = false,
    this.isPeriodOngoing = false,
    this.periodDay = 1,
  });
}

final homeProvider = Provider<HomeState>((ref) {
  final userAsync = ref.watch(userProfileStreamProvider);
  final currentCycleAsync = ref.watch(currentCycleStreamProvider);
  final allCyclesAsync = ref.watch(allCyclesStreamProvider);
  final logsAsync = ref.watch(allDailyLogsStreamProvider);

  final userName = userAsync.value?.name ?? 'Guest';
  final currentCycle = currentCycleAsync.value ??
      allCyclesAsync.value?.where((c) => c.endDate == null).firstOrNull ??
      allCyclesAsync.value?.firstOrNull;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final logs = logsAsync.value ?? [];

  // Find today's log if any
  final todayLog = logs
      .where(
        (log) =>
            log.date.year == today.year &&
            log.date.month == today.month &&
            log.date.day == today.day,
      )
      .firstOrNull;

  int symptomsLoggedCount = 0;
  if (todayLog != null) {
    final symptomsAsync = ref.watch(todaySymptomsStreamProvider(todayLog.id));
    symptomsLoggedCount = symptomsAsync.value?.length ?? 0;
  }

  DateTime start;
  if (currentCycle != null) {
    start = DateTime(
      currentCycle.startDate.year,
      currentCycle.startDate.month,
      currentCycle.startDate.day,
    );
  } else if (allCyclesAsync.value != null && allCyclesAsync.value!.isNotEmpty) {
    final c = allCyclesAsync.value!.first;
    start = DateTime(c.startDate.year, c.startDate.month, c.startDate.day);
  } else {
    start = today.subtract(const Duration(days: 14));
  }

  final loggedPeriodDates = logs
      .where((l) => l.flowIntensity != null && l.flowIntensity != 'None')
      .map((l) => DateTime(l.date.year, l.date.month, l.date.day))
      .toList()
    ..sort((a, b) => a.compareTo(b));

  if (loggedPeriodDates.isNotEmpty) {
    final latestPeriodDate = loggedPeriodDates.last;
    DateTime latestPeriodStart = latestPeriodDate;
    for (int i = loggedPeriodDates.length - 1; i >= 0; i--) {
      final d = loggedPeriodDates[i];
      if (latestPeriodStart.difference(d).inDays <= 3) {
        latestPeriodStart = d;
      } else {
        break;
      }
    }
    if (latestPeriodStart.isAfter(start) &&
        latestPeriodStart.difference(start).inDays >= 12) {
      start = latestPeriodStart;
    }
  }

  final diff = today.difference(start).inDays + 1;
  final cycleDay = diff > 0 ? diff : 1;
  final avgCycleLen = userAsync.value?.avgCycleLength ?? 29;
  final avgPeriodLen = (currentCycle?.periodLength ?? userAsync.value?.avgPeriodLength) ?? 5;
  final daysUntil = avgCycleLen - cycleDay;

  final nextPeriodStart = start.add(Duration(days: avgCycleLen));
  final nextPeriodEnd = nextPeriodStart.add(
    Duration(days: avgPeriodLen - 1),
  );
  final periodRange =
      '${DateFormat('MMM d').format(nextPeriodStart)} - ${DateFormat('MMM d').format(nextPeriodEnd)}';

  final fertileStart = start.add(Duration(days: avgCycleLen - 16));
  final fertileEnd = start.add(Duration(days: avgCycleLen - 11));
  final fertileRange =
      '${DateFormat('MMM d').format(fertileStart)} - ${DateFormat('MMM d').format(fertileEnd)}';

  final hasFlowToday = todayLog?.flowIntensity != null &&
      todayLog?.flowIntensity != 'None' &&
      todayLog!.flowIntensity!.isNotEmpty;
  final hasExplicitNoFlow = todayLog?.flowIntensity == 'None';

  // Period is late if daysUntil < 0 AND user has not logged flow today
  final isPeriodLate = daysUntil < 0 && !hasFlowToday;

  // Period is ongoing if:
  // 1. User has logged flow for today, OR
  // 2. Today is within expected period length (cycleDay <= avgPeriodLen) and not explicitly marked 'None'
  // AND period is not late
  final bool isPeriodOngoing = !isPeriodLate &&
      (hasFlowToday || (cycleDay <= avgPeriodLen && !hasExplicitNoFlow));

  return HomeState(
    userName: userName,
    cycleDay: cycleDay,
    daysUntilPeriod: daysUntil,
    isPeriodLate: isPeriodLate,
    isPeriodOngoing: isPeriodOngoing,
    periodDay: cycleDay,
    periodDateRange: periodRange,
    fertileWindowRange: fertileRange,
    symptomsLogged: symptomsLoggedCount,
    painLevel: todayLog?.painLevel ?? 0,
    mood: todayLog?.mood ?? 'None',
  );
});

final todaySymptomsStreamProvider =
    StreamProvider.family<List<DailySymptom>, String>((ref, logId) {
      return ref.watch(symptomRepositoryProvider).watchSymptomsForLog(logId);
    });
