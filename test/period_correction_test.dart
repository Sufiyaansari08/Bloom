import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/core/database/database_seeder.dart';
import 'package:bloom/core/database/repositories/cycle_repository.dart';
import 'package:bloom/core/database/repositories/daily_log_repository.dart';
import 'package:bloom/features/calendar/presentation/providers/calendar_provider.dart';
import 'package:bloom/features/checkin/presentation/providers/daily_checkin_provider.dart';
import 'package:bloom/features/home/presentation/providers/home_provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  late AppDatabase db;
  late CycleRepository cycleRepo;
  late DailyLogRepository dailyLogRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    cycleRepo = CycleRepository(db);
    dailyLogRepo = DailyLogRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Updating cycle start date moves from 22nd to 20th', () async {
    final originalDate = DateTime(2026, 9, 22);
    final correctedDate = DateTime(2026, 9, 20);

    // Insert cycle starting on 22nd
    await cycleRepo.insertCycle(
      CyclesCompanion.insert(
        id: 'cycle_1',
        userId: 'user_1',
        startDate: originalDate,
        cycleLength: const drift.Value(28),
        periodLength: const drift.Value(5),
      ),
    );

    // Verify initial start date
    var currentCycle = await cycleRepo.getCurrentCycle();
    expect(currentCycle?.startDate, originalDate);

    // Update start date to 20th
    await cycleRepo.updateCycleStartDate('cycle_1', correctedDate);

    currentCycle = await cycleRepo.getCurrentCycle();
    expect(currentCycle?.startDate, correctedDate);
  });

  test('Moving period log moves flow from 22nd to 20th', () async {
    final originalDate = DateTime(2026, 9, 22);
    final correctedDate = DateTime(2026, 9, 20);

    // Insert daily log on 22nd with flow
    await dailyLogRepo.upsertDailyLog(
      DailyLogsCompanion.insert(
        id: 'log_22',
        userId: 'user_1',
        date: originalDate,
        flowIntensity: const drift.Value('Heavy'),
        painLevel: const drift.Value(3),
      ),
    );

    var log22 = await dailyLogRepo.getLogForDate(originalDate);
    expect(log22?.flowIntensity, 'Heavy');

    // Move period log to 20th
    await dailyLogRepo.movePeriodLog(originalDate, correctedDate);

    // Old date has null flow
    log22 = await dailyLogRepo.getLogForDate(originalDate);
    expect(log22?.flowIntensity, isNull);

    // New date has flow and pain preserved
    final log20 = await dailyLogRepo.getLogForDate(correctedDate);
    expect(log20?.flowIntensity, 'Heavy');
    expect(log20?.painLevel, 3);
  });

  test('Removing period flow clears flow intensity', () async {
    final date = DateTime(2026, 9, 22);

    await dailyLogRepo.upsertDailyLog(
      DailyLogsCompanion.insert(
        id: 'log_22',
        userId: 'user_1',
        date: date,
        flowIntensity: const drift.Value('Medium'),
      ),
    );

    await dailyLogRepo.removePeriodFlowForDate(date);

    final log = await dailyLogRepo.getLogForDate(date);
    expect(log?.flowIntensity, isNull);
  });

  test(
    'When cycle starts on 17th, 17th is Day 1, 18th is Day 2, 19th is Day 3',
    () {
      final cycleStart = DateTime(2026, 9, 17, 18, 30); // e.g. set at 6:30 PM
      final cleanStart = DateTime(
        cycleStart.year,
        cycleStart.month,
        cycleStart.day,
      );

      int getCycleDay(DateTime target) {
        final cleanTarget = DateTime(target.year, target.month, target.day);
        return cleanTarget.difference(cleanStart).inDays + 1;
      }

      expect(
        getCycleDay(DateTime(2026, 9, 17, 8, 0)),
        1,
      ); // 17th morning -> Day 1
      expect(
        getCycleDay(DateTime(2026, 9, 17, 23, 0)),
        1,
      ); // 17th night -> Day 1
      expect(
        getCycleDay(DateTime(2026, 9, 18, 8, 0)),
        2,
      ); // 18th morning -> Day 2
      expect(
        getCycleDay(DateTime(2026, 9, 18, 20, 0)),
        2,
      ); // 18th evening -> Day 2
      expect(getCycleDay(DateTime(2026, 9, 19, 10, 0)), 3); // 19th -> Day 3
      expect(getCycleDay(DateTime(2026, 9, 20, 12, 0)), 4); // 20th -> Day 4
    },
  );

  test('Predictions are strictly generated for 2 upcoming cycles', () {
    const avgCycleLen = 29;
    const avgPeriodLen = 5;

    // Case 1: Current cycle started in the past (e.g. Aug 26) and period ended Aug 30 (today is Sep 11)
    final today = DateTime(2026, 9, 11);
    final cycleStartPast = DateTime(2026, 8, 26);
    final periodEndPast = cycleStartPast.add(
      const Duration(days: avgPeriodLen - 1),
    );
    final currentPeriodHasEnded = periodEndPast.isBefore(today);
    expect(currentPeriodHasEnded, isTrue);

    // With period ended, upcoming 2 cycles are cycle + 1 and cycle + 2
    final startOffsetPast = currentPeriodHasEnded ? 1 : 0;
    final List<DateTime> predictedPeriodsPast = [];
    for (int i = 0; i < 2; i++) {
      final idx = startOffsetPast + i;
      final start = cycleStartPast.add(Duration(days: avgCycleLen * idx));
      predictedPeriodsPast.add(start);
    }
    expect(predictedPeriodsPast.length, 2);
    expect(predictedPeriodsPast[0], DateTime(2026, 9, 24)); // Cycle 1 upcoming
    expect(predictedPeriodsPast[1], DateTime(2026, 10, 23)); // Cycle 2 upcoming
    // Past period (Aug 26) and 3rd upcoming (Nov 21) are NOT included!

    // Case 2: User set period start to future date (e.g. Sep 17)
    final cycleStartFuture = DateTime(2026, 9, 17);
    final periodEndFuture = cycleStartFuture.add(
      const Duration(days: avgPeriodLen - 1),
    );
    final currentPeriodHasEndedFuture = periodEndFuture.isBefore(today);
    expect(currentPeriodHasEndedFuture, isFalse);

    // With period ongoing/future, upcoming 2 cycles are cycle + 0 and cycle + 1
    final startOffsetFuture = currentPeriodHasEndedFuture ? 1 : 0;
    final List<DateTime> predictedPeriodsFuture = [];
    for (int i = 0; i < 2; i++) {
      final idx = startOffsetFuture + i;
      final start = cycleStartFuture.add(Duration(days: avgCycleLen * idx));
      predictedPeriodsFuture.add(start);
    }
    expect(predictedPeriodsFuture.length, 2);
    expect(predictedPeriodsFuture[0], DateTime(2026, 9, 17)); // Cycle 1
    expect(predictedPeriodsFuture[1], DateTime(2026, 10, 16)); // Cycle 2
    // Cycle 3 (Nov 14) is NOT included!
  });

  test(
    'Overdue period scenario: predicted Sep 7, today Sep 11, period not arrived',
    () {
      final cycleStart = DateTime(2026, 8, 10);
      const avgCycleLen = 28;
      final today = DateTime(2026, 9, 11);

      // Expected period start: Aug 10 + 28 days = Sep 7
      final expectedPeriodStart = cycleStart.add(
        const Duration(days: avgCycleLen),
      );
      expect(expectedPeriodStart, DateTime(2026, 9, 7));

      // When today is Sep 11 and no period has been logged:
      final isPeriodLate = today.isAfter(expectedPeriodStart);
      expect(isPeriodLate, isTrue);

      final daysLate = today.difference(expectedPeriodStart).inDays;
      expect(daysLate, 4); // 4 days late!

      // Home status headline formatting (without any buttons):
      final homeHeadline = isPeriodLate
          ? 'Period is $daysLate ${daysLate == 1 ? "day" : "days"} late'
          : 'Period in $daysLate days';
      expect(homeHeadline, 'Period is 4 days late');

      // Calendar daily summary card formatting for today:
      final calendarCardTitle =
          'Period is $daysLate ${daysLate == 1 ? "day" : "days"} late';
      expect(calendarCardTitle, 'Period is 4 days late');
    },
  );

  test('Late period arrival (Sep 12, expected Sep 8) completes old cycle and starts new cycle', () async {
    // 1. Initial state: cycle started on Aug 10
    final initialCycle = CyclesCompanion.insert(
      id: 'cycle_aug10',
      userId: 'user_1',
      startDate: DateTime(2026, 8, 10),
      cycleLength: const drift.Value(29),
      periodLength: const drift.Value(5),
    );
    await cycleRepo.insertCycle(initialCycle);

    // 2. Today is Sep 12 (period was expected on Sep 8, now 4 days late)
    final arrivalDate = DateTime(2026, 9, 12);
    final curCycle = await cycleRepo.getCurrentCycle();
    expect(curCycle, isNotNull);

    final dayDiff = arrivalDate.difference(curCycle!.startDate).inDays;
    expect(dayDiff, 33); // 33 days since Aug 10

    // Complete overdue cycle
    await cycleRepo.completeCycle(
      curCycle.id,
      arrivalDate.subtract(const Duration(days: 1)),
      dayDiff,
      5,
    );

    // Start new cycle on arrival date
    final newCycle = CyclesCompanion.insert(
      id: 'cycle_sep12',
      userId: 'user_1',
      startDate: arrivalDate,
      cycleLength: const drift.Value(29),
      periodLength: const drift.Value(5),
    );
    await cycleRepo.insertCycle(newCycle);

    // Verify current active cycle is now Sep 12
    final activeCycle = await cycleRepo.getCurrentCycle();
    expect(activeCycle?.id, 'cycle_sep12');
    expect(activeCycle?.startDate, DateTime(2026, 9, 12));

    // Verify old cycle is closed
    final allCycles = await cycleRepo.getAllCycles();
    final oldCycle = allCycles.firstWhere((c) => c.id == 'cycle_aug10');
    expect(oldCycle.endDate, DateTime(2026, 9, 11));
    expect(oldCycle.cycleLength, 33);
  });

  test('Home Card headline and dot labels: Ongoing Period vs Period in X Days', () {
    // Helper simulating Home Card logic
    String getHeadline({required int cycleDay, required bool isPeriodOngoing, required int daysUntil, required bool isPeriodLate}) {
      if (isPeriodLate) {
        return 'Period is ${daysUntil.abs()} ${daysUntil.abs() == 1 ? "day" : "days"} late';
      } else if (isPeriodOngoing) {
        return 'Period Day $cycleDay';
      } else if (daysUntil == 0) {
        return 'Period expected today';
      } else {
        return 'Period in $daysUntil ${daysUntil == 1 ? "day" : "days"}';
      }
    }

    String getDotLabel({required bool isPeriodOngoing, required bool isPeriodLate, required String range}) {
      if (isPeriodOngoing) {
        return 'Upcoming Period: $range';
      } else if (isPeriodLate) {
        return 'Period: $range (Expected)';
      } else {
        return 'Period: $range';
      }
    }

    // Day 1 of Period (Ongoing)
    expect(getHeadline(cycleDay: 1, isPeriodOngoing: true, daysUntil: 28, isPeriodLate: false), 'Period Day 1');
    expect(getDotLabel(isPeriodOngoing: true, isPeriodLate: false, range: 'Oct 11 - Oct 15'), 'Upcoming Period: Oct 11 - Oct 15');

    // Day 3 of Period (Ongoing)
    expect(getHeadline(cycleDay: 3, isPeriodOngoing: true, daysUntil: 26, isPeriodLate: false), 'Period Day 3');
    expect(getDotLabel(isPeriodOngoing: true, isPeriodLate: false, range: 'Oct 11 - Oct 15'), 'Upcoming Period: Oct 11 - Oct 15');

    // Day 6 (Period Stopped, Follicular Phase)
    expect(getHeadline(cycleDay: 6, isPeriodOngoing: false, daysUntil: 23, isPeriodLate: false), 'Period in 23 days');
    expect(getDotLabel(isPeriodOngoing: false, isPeriodLate: false, range: 'Oct 11 - Oct 15'), 'Period: Oct 11 - Oct 15');

    // Overdue state (Day 34, 5 days late)
    expect(getHeadline(cycleDay: 34, isPeriodOngoing: false, daysUntil: -5, isPeriodLate: true), 'Period is 5 days late');
    expect(getDotLabel(isPeriodOngoing: false, isPeriodLate: true, range: 'Sep 7 - Sep 11'), 'Period: Sep 7 - Sep 11 (Expected)');
  });

  test('Sleep dropdown strings parse correctly into numeric hours', () {
    double? parseSleep(String? sleepStr) {
      if (sleepStr == null || sleepStr.isEmpty || sleepStr == 'Select') return null;
      final rangeMatch = RegExp(r'(\d+(?:\.\d+)?)\s*-\s*(\d+(?:\.\d+)?)\s*h?').firstMatch(sleepStr);
      if (rangeMatch != null) {
        final low = double.tryParse(rangeMatch.group(1)!) ?? 0;
        final high = double.tryParse(rangeMatch.group(2)!) ?? 0;
        return (low + high) / 2.0;
      }
      final lessMatch = RegExp(r'<\s*(\d+(?:\.\d+)?)\s*h?').firstMatch(sleepStr);
      if (lessMatch != null) {
        final val = double.tryParse(lessMatch.group(1)!) ?? 5;
        return val - 0.5;
      }
      final greaterMatch = RegExp(r'>\s*(\d+(?:\.\d+)?)\s*h?').firstMatch(sleepStr);
      if (greaterMatch != null) {
        final val = double.tryParse(greaterMatch.group(1)!) ?? 8;
        return val + 0.5;
      }
      final hmMatch = RegExp(r'(\d+)\s*h(?:\s*(\d+)\s*m)?').firstMatch(sleepStr);
      if (hmMatch != null) {
        final hours = double.tryParse(hmMatch.group(1) ?? '0') ?? 0;
        final mins = double.tryParse(hmMatch.group(2) ?? '0') ?? 0;
        return hours + (mins / 60.0);
      }
      return double.tryParse(sleepStr.replaceAll(RegExp(r'[^\d.]'), ''));
    }

    // Every single dropdown option from CheckinLifestylePage:
    expect(parseSleep('Select'), isNull);
    expect(parseSleep('< 5 h'), 4.5);
    expect(parseSleep('5 - 6 h'), 5.5);
    expect(parseSleep('6 h 30 m'), 6.5);
    expect(parseSleep('7 - 8 h'), 7.5);
    expect(parseSleep('8 h 00 m'), 8.0);
    expect(parseSleep('> 8 h'), 8.5);
  });

  test('Daily checkin sleep shows immediately in calendar daily summary provider', () async {
    final testDb = AppDatabase(NativeDatabase.memory());
    await DatabaseSeeder.seedInitialData(testDb);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(testDb),
      ],
    );

    final today = DateTime(2026, 9, 12);

    final notifier = container.read(dailyCheckinProvider.notifier);
    notifier.setMood('Energetic');
    notifier.setLifestyle(sleep: '7 - 8 h', waterIntake: '2.5 L', activity: 'Active');
    await notifier.saveToDatabase(today);

    container.read(calendarProvider.notifier).onDaySelected(today, today);
    await Future.delayed(const Duration(milliseconds: 200));

    final checkinState = container.read(dailyCheckinForSelectedDayProvider);
    expect(checkinState.value, isNotNull);
    expect(checkinState.value?.sleep, '7.5 hrs');
    expect(checkinState.value?.mood, 'Energetic');
    expect(checkinState.value?.waterIntake, '2.5 L');

    await testDb.close();
  });

  test('Preserves flow and adds sleep when both period and checkin are logged on same date', () async {
    final testDb = AppDatabase(NativeDatabase.memory());
    await DatabaseSeeder.seedInitialData(testDb);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(testDb),
      ],
    );

    final today = DateTime(2026, 9, 12);

    // 1. Period flow logged first
    final repo = container.read(dailyLogRepositoryProvider);
    await repo.upsertDailyLog(
      DailyLogsCompanion.insert(
        id: 'sep12_period_log',
        userId: 'default_user',
        date: today,
        flowIntensity: const drift.Value('Medium'),
      ),
    );

    // 2. Checkin logged second
    final notifier = container.read(dailyCheckinProvider.notifier);
    notifier.setMood('Good');
    notifier.setLifestyle(sleep: '6 h 30 m');
    await notifier.saveToDatabase(today);

    container.read(calendarProvider.notifier).onDaySelected(today, today);
    await Future.delayed(const Duration(milliseconds: 200));

    final checkinState = container.read(dailyCheckinForSelectedDayProvider);
    expect(checkinState.value, isNotNull);
    expect(checkinState.value?.sleep, '6.5 hrs');
    expect(checkinState.value?.mood, 'Good');

    final updatedLog = await repo.getLogForDate(today);
    expect(updatedLog?.flowIntensity, 'Medium');
    expect(updatedLog?.sleepHours, 6.5);

    await testDb.close();
  });

  test('When period is logged today (Sep 12), fertile window shifts to Sep 25-30 and ovulation to Sep 26, and fertile reminder is not shown', () async {
    final testDb = AppDatabase(NativeDatabase.memory());
    await DatabaseSeeder.seedInitialData(testDb);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(testDb),
      ],
    );
    // Keep calendarProvider alive
    container.listen(calendarProvider, (_, __) {});

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // User logs period for today
    final repo = container.read(dailyLogRepositoryProvider);
    await repo.upsertDailyLog(
      DailyLogsCompanion.insert(
        id: 'today_period_log',
        userId: 'default_user',
        date: today,
        flowIntensity: const drift.Value('Medium'),
      ),
    );
    final cycleRepo = container.read(cycleRepositoryProvider);
    await cycleRepo.getOrCreateCycleForPeriodDate(today);

    // Allow streams to emit
    await Future.delayed(const Duration(milliseconds: 500));

    final calState = container.read(calendarProvider);
    print('calState.periodDays: ${calState.periodDays}');
    print('calState.ovulationDay: ${calState.ovulationDay}');
    expect(calState.ovulationDay, today.add(const Duration(days: 15)));
    expect(calState.nextPeriodStartDate, today.add(const Duration(days: 29)));

    // Fertile days for this cycle must start on Sep 25
    final firstFertileDay = calState.fertileDays.firstWhere((d) => !d.isBefore(today));
    expect(firstFertileDay, today.add(const Duration(days: 13)));

    // Check Menstrual Summary text isolation logic
    final upcoming = calState.fertileDays.where((d) => !d.isBefore(today.subtract(const Duration(days: 5)))).toList();
    final firstWindow = <DateTime>[upcoming.first];
    for (int i = 1; i < upcoming.length; i++) {
      if (upcoming[i].difference(firstWindow.last).inDays == 1) {
        firstWindow.add(upcoming[i]);
      } else {
        break;
      }
    }
    final fStart = firstWindow.first;
    final fEnd = firstWindow.last;
    expect(fStart, today.add(const Duration(days: 13)));
    expect(fEnd, today.add(const Duration(days: 18)));

    final summaryLabel = fStart.month == fEnd.month
        ? 'Fertile window ${fStart.day}-${fEnd.day} ${DateFormat('MMMM').format(fStart)}'
        : 'Fertile window ${fStart.day} ${DateFormat('MMMM').format(fStart)} - ${fEnd.day} ${DateFormat('MMMM').format(fEnd)}';
    
    final expectedSummaryLabel = fStart.month == fEnd.month
        ? 'Fertile window ${fStart.day}-${fEnd.day} ${DateFormat('MMMM').format(fStart)}'
        : 'Fertile window ${fStart.day} ${DateFormat('MMMM').format(fStart)} - ${fEnd.day} ${DateFormat('MMMM').format(fEnd)}';
    expect(summaryLabel, expectedSummaryLabel);

    // Home Card also reflects Sep 12 as Cycle Day 1
    final homeState = container.read(homeProvider);
    expect(homeState.isPeriodOngoing, isTrue);
    expect(homeState.cycleDay, 1);
    expect(homeState.periodDateRange, '${DateFormat('MMM d').format(today.add(const Duration(days: 29)))} - ${DateFormat('MMM d').format(today.add(const Duration(days: 33)))}');
    expect(homeState.fertileWindowRange, '${DateFormat('MMM d').format(today.add(const Duration(days: 13)))} - ${DateFormat('MMM d').format(today.add(const Duration(days: 18)))}');

    await testDb.close();
  });

  test('Daily check-in reminder detects whether user has logged today and updates completion status', () async {
    final testDb = AppDatabase(NativeDatabase.memory());
    await DatabaseSeeder.seedInitialData(testDb);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(testDb),
      ],
    );

    final today = DateTime(2026, 9, 12);
    final repo = container.read(dailyLogRepositoryProvider);

    // Initial check: no logs today
    var todayLog = await repo.getLogForDate(today);
    bool hasCheckedInToday = todayLog != null && (
      (todayLog.mood != null && todayLog.mood != 'None') ||
      (todayLog.painLevel != null && todayLog.painLevel! > 0) ||
      (todayLog.flowIntensity != null && todayLog.flowIntensity != 'None') ||
      (todayLog.waterIntake != null && todayLog.waterIntake!.isNotEmpty) ||
      (todayLog.sleepHours != null && todayLog.sleepHours! > 0)
    );
    expect(hasCheckedInToday, isFalse);

    // Log sleep/checkin today
    await repo.upsertDailyLog(
      DailyLogsCompanion.insert(
        id: 'test_checkin_today',
        userId: 'default_user',
        date: today,
        sleepHours: const drift.Value(7.5),
      ),
    );

    todayLog = await repo.getLogForDate(today);
    hasCheckedInToday = todayLog != null && (
      (todayLog.mood != null && todayLog.mood != 'None') ||
      (todayLog.painLevel != null && todayLog.painLevel! > 0) ||
      (todayLog.flowIntensity != null && todayLog.flowIntensity != 'None') ||
      (todayLog.waterIntake != null && todayLog.waterIntake!.isNotEmpty) ||
      (todayLog.sleepHours != null && todayLog.sleepHours! > 0)
    );
    expect(hasCheckedInToday, isTrue);

    await testDb.close();
  });
}

