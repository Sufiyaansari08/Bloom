import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/repositories/cycle_repository.dart';
import 'package:bloom/features/calendar/presentation/widgets/daily_summary_card.dart';

void main() {
  late AppDatabase db;
  late CycleRepository cycleRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    cycleRepo = CycleRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Past Period Logging & Cycle Creation Tests', () {
    test('Logging period on a past date (Aug 17) creates a completed past cycle when Sep 12 ongoing cycle exists', () async {
      // 1. Existing ongoing cycle starting Sep 12
      final ongoingCycleId = await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 9, 12),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );
      expect(ongoingCycleId, isNotEmpty);

      var currentCycle = await cycleRepo.getCurrentCycle();
      expect(currentCycle, isNotNull);
      expect(currentCycle!.startDate, DateTime(2026, 9, 12));
      expect(currentCycle.endDate, isNull);

      // 2. User logs past period on Aug 17 (26 days before Sep 12)
      final pastCycleId = await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 8, 17),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );

      // Must be a separate, completed past cycle
      expect(pastCycleId, isNot(equals(ongoingCycleId)));

      final allCycles = await cycleRepo.getAllCycles();
      expect(allCycles.length, 2);

      // Most recent cycle is still the ongoing September cycle
      expect(allCycles[0].startDate, DateTime(2026, 9, 12));
      expect(allCycles[0].endDate, isNull);

      // Past cycle runs from Aug 17 to Sep 11 (26 days)
      final pastCycle = allCycles[1];
      expect(pastCycle.id, pastCycleId);
      expect(pastCycle.startDate, DateTime(2026, 8, 17));
      expect(pastCycle.endDate, DateTime(2026, 9, 11));
      expect(pastCycle.cycleLength, 26);
    });

    test('Logging Aug 18 links to the existing Aug 17 cycle without creating a new cycle', () async {
      // Setup Sep 12 ongoing and Aug 17 past cycle
      await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 9, 12),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );
      final aug17CycleId = await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 8, 17),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );

      // Now log Day 2 (Aug 18)
      final aug18CycleId = await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 8, 18),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );

      // Must link to the EXACT same August cycle
      expect(aug18CycleId, equals(aug17CycleId));

      final allCycles = await cycleRepo.getAllCycles();
      expect(allCycles.length, 2);
    });

    test('Cycle day calculation correctly identifies Aug 17 (Day 1), Aug 18 (Day 2), Sep 9 (Day 24), Sep 12 (Day 1)', () async {
      await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 9, 12),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );
      await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 8, 17),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );

      final allCycles = await cycleRepo.getAllCycles();

      int? getCycleDay(DateTime target) {
        final cleanTarget = DateTime(target.year, target.month, target.day);
        for (final cycle in allCycles) {
          final cleanStart = DateTime(cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
          if (cycle.endDate != null) {
            final cleanEnd = DateTime(cycle.endDate!.year, cycle.endDate!.month, cycle.endDate!.day);
            if (!cleanTarget.isBefore(cleanStart) && !cleanTarget.isAfter(cleanEnd)) {
              return cleanTarget.difference(cleanStart).inDays + 1;
            }
          } else {
            if (!cleanTarget.isBefore(cleanStart)) {
              return cleanTarget.difference(cleanStart).inDays + 1;
            }
          }
        }
        return null;
      }

      // Aug 17 is Day 1 of August cycle
      expect(getCycleDay(DateTime(2026, 8, 17)), 1);

      // Aug 18 is Day 2 of August cycle
      expect(getCycleDay(DateTime(2026, 8, 18)), 2);

      // Sep 9 is Day 24 of August cycle (Luteal phase)
      expect(getCycleDay(DateTime(2026, 9, 9)), 24);

      // Sep 12 is Day 1 of September cycle
      expect(getCycleDay(DateTime(2026, 9, 12)), 1);

      // Aug 10 (before any tracked cycle) has no cycle day
      expect(getCycleDay(DateTime(2026, 8, 10)), isNull);
    });

    test('Period arriving 3 days early (Sep 9) adjusts the ongoing cycle start date to Sep 9', () async {
      final sep12CycleId = await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 9, 12),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );

      // Period started 3 days early on Sep 9
      final resolvedId = await cycleRepo.getOrCreateCycleForPeriodDate(
        DateTime(2026, 9, 9),
        avgCycleLength: 29,
        avgPeriodLength: 5,
        userId: 'test_user',
      );

      expect(resolvedId, sep12CycleId);

      final currentCycle = await cycleRepo.getCurrentCycle();
      expect(currentCycle, isNotNull);
      expect(currentCycle!.startDate, DateTime(2026, 9, 9));
    });
  });

  group('DailySummaryCard UI Widget Tests', () {
    testWidgets('Displays "Log Period" and not "Set as Period Start (Day 1)" on unassigned date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailySummaryCard(
              date: DateTime(2026, 8, 10),
              isPeriodDay: false,
              isLoggedPeriodDay: false,
              isFertileDay: false,
              isOvulationDay: false,
              cycleDay: null,
              isCycleStart: false,
              isPeriodLate: false,
              onLogPeriodForDay: () {},
            ),
          ),
        ),
      );

      expect(find.text('Log Period'), findsOneWidget);
      expect(find.text('Record bleeding/flow for this date'), findsOneWidget);
      expect(find.text('Set as Period Start (Day 1)'), findsNothing);
    });

    testWidgets('Displays "Log Period (Day 2)" on Day 2 of period', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailySummaryCard(
              date: DateTime(2026, 8, 18),
              isPeriodDay: false,
              isLoggedPeriodDay: false,
              isFertileDay: false,
              isOvulationDay: false,
              cycleDay: 2,
              periodDay: 2,
              isCycleStart: false,
              isPeriodLate: false,
              onLogPeriodForDay: () {},
            ),
          ),
        ),
      );

      expect(find.text('Log Period (Day 2)'), findsOneWidget);
      expect(find.text('Record bleeding/flow for Day 2'), findsOneWidget);
      expect(find.text('Set as Period Start (Day 1)'), findsNothing);
    });

    testWidgets('Displays "Cycle Day 24" and "Log Period" (not Day 24 or Day 1) on Day 24 (Sep 9)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailySummaryCard(
              date: DateTime(2026, 9, 9),
              isPeriodDay: false,
              isLoggedPeriodDay: false,
              isFertileDay: false,
              isOvulationDay: false,
              cycleDay: 24,
              periodDay: null,
              isCycleStart: false,
              isPeriodLate: false,
              onLogPeriodForDay: () {},
            ),
          ),
        ),
      );

      expect(find.text('Cycle Day 24'), findsOneWidget);
      expect(find.text('Day 24 of your menstrual cycle'), findsOneWidget);
      expect(find.text('Log Period'), findsOneWidget);
      expect(find.text('Set as Period Start (Day 1)'), findsNothing);
    });

    testWidgets('Displays "Period Day 1 • Flow logged: Medium" when flow is logged', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailySummaryCard(
              date: DateTime(2026, 8, 17),
              isPeriodDay: true,
              isLoggedPeriodDay: true,
              loggedFlow: 'Medium',
              isFertileDay: false,
              isOvulationDay: false,
              cycleDay: 1,
              isCycleStart: true,
              isPeriodLate: false,
              onLogPeriodForDay: () {},
            ),
          ),
        ),
      );

      expect(find.text('Period Day 1'), findsOneWidget);
      expect(find.text('Flow logged: Medium'), findsOneWidget);
      expect(find.text('Set as Period Start (Day 1)'), findsNothing);
    });
  });
}
