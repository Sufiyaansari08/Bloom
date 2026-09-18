import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/repositories/cycle_repository.dart';
import 'package:bloom/core/database/repositories/daily_log_repository.dart';
import 'package:bloom/features/period_logging/presentation/widgets/period_flow_pain_bottom_sheet.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PeriodFlowPainBottomSheet Widget Tests', () {
    testWidgets('Step 1 displays all flow options and transitions to Step 2 on selection', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PeriodFlowPainBottomSheetContent(
              date: DateTime(2026, 9, 17),
              cycleDay: 4,
              showDisclaimer: false,
            ),
          ),
        ),
      );

      // Verify Step 1 elements
      expect(find.text('Log Period Flow'), findsOneWidget);
      expect(find.text('Step 1 of 2 • Day 4'), findsOneWidget);
      expect(find.text('Spotting'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Heavy'), findsOneWidget);
      expect(find.text('Very heavy'), findsOneWidget);

      // No disclaimer should be shown when showDisclaimer is false
      expect(find.textContaining('Logging period for today'), findsNothing);

      // Tap 'Medium' to transition to Step 2
      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      // Verify Step 2 elements
      expect(find.text('Rate Your Pain'), findsOneWidget);
      expect(find.text('Step 2 of 2 • Day 4'), findsOneWidget);
      expect(find.text('Flow: Medium'), findsOneWidget);
      expect(find.text('Save Period Log'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Back at Step 1
      expect(find.text('Log Period Flow'), findsOneWidget);
    });

    testWidgets('Shows disclaimer on home page bottom sheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PeriodFlowPainBottomSheetContent(
              date: DateTime.now(),
              cycleDay: 4,
              showDisclaimer: true,
            ),
          ),
        ),
      );

      // Disclaimer should be present
      expect(find.textContaining('Logging period for '), findsOneWidget);
      expect(find.text('Calendar page'), findsOneWidget);
    });

    testWidgets('Step 2 allows selecting pain level and submitting', (tester) async {
      PeriodFlowPainResult? submittedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    submittedResult = await showModalBottomSheet<PeriodFlowPainResult>(
                      context: context,
                      builder: (ctx) => PeriodFlowPainBottomSheetContent(
                        date: DateTime(2026, 9, 17),
                        cycleDay: 3,
                      ),
                    );
                  },
                  child: const Text('Open Sheet'),
                );
              },
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Select 'Heavy' flow
      await tester.ensureVisible(find.text('Heavy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Heavy'));
      await tester.pumpAndSettle();

      expect(find.text('Rate Your Pain'), findsOneWidget);
      expect(find.text('Flow: Heavy'), findsOneWidget);

      // Tap 'Save Period Log'
      await tester.ensureVisible(find.text('Save Period Log'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Period Log'));
      await tester.pumpAndSettle();

      expect(submittedResult, isNotNull);
      expect(submittedResult?.flow, 'Heavy');
      expect(submittedResult?.painLevel, 5); // default 5
    });
  });

  group('Cycle and DailyLog Persistence Tests', () {
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

    test('Logging Day 4 period flow and pain preserves cycle startDate (does not reset to Day 1)', () async {
      final cycleStart = DateTime(2026, 9, 14);
      final day4Date = DateTime(2026, 9, 17);

      // Insert existing cycle starting on 14th
      await cycleRepo.insertCycle(
        CyclesCompanion.insert(
          id: 'cycle_active',
          userId: 'user_1',
          startDate: cycleStart,
          cycleLength: const drift.Value(28),
          periodLength: const drift.Value(5),
        ),
      );

      // Day 4 log with Medium flow and pain 4
      await dailyLogRepo.upsertDailyLog(
        DailyLogsCompanion.insert(
          id: 'log_day4',
          userId: 'user_1',
          cycleId: const drift.Value('cycle_active'),
          date: day4Date,
          flowIntensity: const drift.Value('Medium'),
          painLevel: const drift.Value(4),
        ),
      );

      // Verify log has both flow and pain
      final log = await dailyLogRepo.getLogForDate(day4Date);
      expect(log?.flowIntensity, 'Medium');
      expect(log?.painLevel, 4);

      // Verify cycle startDate was NOT changed to the 17th
      final cycle = await cycleRepo.getCurrentCycle();
      expect(cycle?.startDate, cycleStart);
      expect(day4Date.difference(cycle!.startDate).inDays + 1, 4); // Still Day 4!
    });

    test('Deleting Day 1 period log removes the orphan cycle and reopens previous cycle', () async {
      final prevStart = DateTime(2026, 7, 28);
      final prevEnd = DateTime(2026, 9, 11);
      final newStart = DateTime(2026, 9, 12);

      // Previous completed cycle
      await cycleRepo.insertCycle(
        CyclesCompanion.insert(
          id: 'cycle_prev',
          userId: 'user_1',
          startDate: prevStart,
          endDate: drift.Value(prevEnd),
          cycleLength: const drift.Value(45),
          periodLength: const drift.Value(5),
        ),
      );

      // New cycle created on 12th as Day 1
      await cycleRepo.insertCycle(
        CyclesCompanion.insert(
          id: 'cycle_new_12',
          userId: 'user_1',
          startDate: newStart,
          cycleLength: const drift.Value(29),
          periodLength: const drift.Value(5),
        ),
      );

      // Daily log on 12th
      await dailyLogRepo.upsertDailyLog(
        DailyLogsCompanion.insert(
          id: 'log_12',
          userId: 'user_1',
          cycleId: const drift.Value('cycle_new_12'),
          date: newStart,
          flowIntensity: const drift.Value('Medium'),
          painLevel: const drift.Value(3),
        ),
      );

      // Confirm initial state
      var current = await cycleRepo.getCurrentCycle();
      expect(current?.id, 'cycle_new_12');
      expect(current?.startDate, newStart);

      // Remove flow for 12th
      await dailyLogRepo.removePeriodFlowForDate(newStart);

      // Apply cycle cleanup logic (same as _handleRemovePeriod)
      final allLogs = await dailyLogRepo.getAllDailyLogs();
      final remainingPeriodLogs = allLogs.where((l) {
        final d = DateTime(l.date.year, l.date.month, l.date.day);
        return !DateUtils.isSameDay(d, newStart) &&
            l.flowIntensity != null &&
            l.flowIntensity != 'None' &&
            l.flowIntensity!.isNotEmpty;
      }).toList();

      final currentCycle = await cycleRepo.getCurrentCycle();
      if (currentCycle != null) {
        final cleanCycleStart = DateTime(
          currentCycle.startDate.year,
          currentCycle.startDate.month,
          currentCycle.startDate.day,
        );

        if (DateUtils.isSameDay(newStart, cleanCycleStart)) {
          final otherLogsInCycle = remainingPeriodLogs.where((l) {
            final d = DateTime(l.date.year, l.date.month, l.date.day);
            final diff = d.difference(cleanCycleStart).inDays;
            return diff > 0 && diff < 15;
          }).toList();

          if (otherLogsInCycle.isEmpty) {
            final prevCycle = await cycleRepo.getPreviousCompletedCycle();
            await cycleRepo.deleteCycle(currentCycle.id);
            if (prevCycle != null) {
              await cycleRepo.reopenCycle(prevCycle.id);
            }
          }
        }
      }

      // Verify cycle_new_12 was deleted and cycle_prev was reopened
      current = await cycleRepo.getCurrentCycle();
      expect(current?.id, 'cycle_prev');
      expect(current?.startDate, prevStart);
      expect(current?.endDate, isNull);

      // 12th is no longer the cycle start!
      expect(current?.startDate, isNot(newStart));
    });
  });
}
