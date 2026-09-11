import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/repositories/cycle_repository.dart';
import 'package:bloom/core/database/repositories/daily_log_repository.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
