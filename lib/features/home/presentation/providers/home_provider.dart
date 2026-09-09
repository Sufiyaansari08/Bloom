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

  HomeState({
    this.userName = 'Guest',
    this.cycleDay = 14,
    this.daysUntilPeriod = 15,
    this.periodDateRange = 'Aug 26 - Aug 30',
    this.fertileWindowRange = 'Sep 06 - Sep 12',
    this.symptomsLogged = 2,
    this.painLevel = 2,
    this.mood = 'Good',
  });
}

final homeProvider = Provider<HomeState>((ref) {
  final userAsync = ref.watch(userProfileStreamProvider);
  final currentCycleAsync = ref.watch(currentCycleStreamProvider);

  final userName = userAsync.value?.name ?? 'Guest';
  final currentCycle = currentCycleAsync.value;

  if (currentCycle != null) {
    final now = DateTime.now();
    final start = currentCycle.startDate;
    final diff = now.difference(start).inDays + 1;
    final cycleDay = diff > 0 ? diff : 1;
    final avgCycleLen = userAsync.value?.avgCycleLength ?? 29;
    final daysUntil = avgCycleLen - cycleDay;

    final nextPeriodStart = start.add(Duration(days: avgCycleLen));
    final nextPeriodEnd = nextPeriodStart.add(Duration(days: (userAsync.value?.avgPeriodLength ?? 5) - 1));
    final periodRange = '${DateFormat('MMM d').format(nextPeriodStart)} - ${DateFormat('MMM d').format(nextPeriodEnd)}';

    final fertileStart = start.add(Duration(days: avgCycleLen - 16));
    final fertileEnd = start.add(Duration(days: avgCycleLen - 11));
    final fertileRange = '${DateFormat('MMM d').format(fertileStart)} - ${DateFormat('MMM d').format(fertileEnd)}';

    final logsAsync = ref.watch(allDailyLogsStreamProvider);
    final logs = logsAsync.value ?? [];
    
    // Find today's log if any
    final nowTime = DateTime.now();
    final todayLog = logs.where((log) => log.date.year == nowTime.year && log.date.month == nowTime.month && log.date.day == nowTime.day).firstOrNull;

    int symptomsLoggedCount = 0;
    if (todayLog != null) {
      final symptomsAsync = ref.watch(todaySymptomsStreamProvider(todayLog.id));
      symptomsLoggedCount = symptomsAsync.value?.length ?? 0;
    }

    return HomeState(
      userName: userName,
      cycleDay: cycleDay,
      daysUntilPeriod: daysUntil > 0 ? daysUntil : 0,
      periodDateRange: periodRange,
      fertileWindowRange: fertileRange,
      symptomsLogged: symptomsLoggedCount,
      painLevel: todayLog?.painLevel ?? 0,
      mood: todayLog?.mood ?? 'None',
    );
  }

  return HomeState(userName: userName);
});

final todaySymptomsStreamProvider = StreamProvider.family<List<DailySymptom>, String>((ref, logId) {
  return ref.watch(symptomRepositoryProvider).watchSymptomsForLog(logId);
});
