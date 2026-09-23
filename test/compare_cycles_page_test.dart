import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/insights/presentation/pages/compare_cycles_page.dart';

void main() {
  Cycle createTestCycle({
    required String id,
    required DateTime start,
    DateTime? end,
    int? length,
    int? period,
  }) {
    return Cycle(
      id: id,
      userId: 'test_user',
      startDate: start,
      endDate: end,
      cycleLength: length,
      periodLength: period,
      isPredicted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  DailyLog createTestLog({
    required String id,
    required String cycleId,
    required DateTime date,
    double? sleepHours,
    int? stressLevel,
    int? painLevel,
  }) {
    return DailyLog(
      id: id,
      userId: 'test_user',
      cycleId: cycleId,
      date: date,
      sleepHours: sleepHours,
      stressLevel: stressLevel,
      painLevel: painLevel,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  DailySymptom createTestSymptom({
    required String id,
    required String logId,
    required String name,
  }) {
    return DailySymptom(
      id: id,
      dailyLogId: logId,
      symptomName: name,
      createdAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  group('CompareCyclesPage Real Database Tests', () {
    testWidgets('0 cycles shows (No cycle recorded), -- table, and empty difference guidance', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(<Cycle>[])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(<DailySymptom>[])),
          ],
          child: const MaterialApp(
            home: CompareCyclesPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Table headers
      expect(find.text('(No cycle recorded)'), findsNWidgets(2));

      // Table cells have --
      expect(find.text('--'), findsWidgets);

      // What's different guidance
      expect(
        find.text('Track and complete your cycles to compare your symptoms, mood, and cycle lengths over time.'),
        findsOneWidget,
      );

      // Tap "Select any cycles" with 0 cycles
      await tester.tap(find.text('Select any cycles'));
      await tester.pumpAndSettle();

      // Dialog prompts user
      expect(find.text('You need at least 2 cycles recorded to compare selected cycles.'), findsOneWidget);
    });

    testWidgets('Current vs Previous compares real metrics and generates difference text', (tester) async {
      final cycles = [
        // Previous cycle (completed): Jul 1 - Jul 28
        createTestCycle(
          id: 'c1',
          start: DateTime(2026, 7, 1),
          end: DateTime(2026, 7, 28),
          length: 28,
          period: 5,
        ),
        // Current cycle (ongoing): Jul 29 - Present
        createTestCycle(
          id: 'c2',
          start: DateTime(2026, 7, 29),
          end: null,
          length: null,
          period: 5,
        ),
      ];

      final logs = [
        // Cycle 1: pain 5, sleep 7.0h, stress 4
        createTestLog(
          id: 'l1',
          cycleId: 'c1',
          date: DateTime(2026, 7, 1),
          painLevel: 5,
          sleepHours: 7.0,
          stressLevel: 4,
        ),
        // Cycle 2: pain 8, sleep 6.0h, stress 7
        createTestLog(
          id: 'l2',
          cycleId: 'c2',
          date: DateTime(2026, 7, 29),
          painLevel: 8,
          sleepHours: 6.0,
          stressLevel: 7,
        ),
      ];

      final symptoms = [
        createTestSymptom(id: 's1', logId: 'l1', name: 'Headache'),
        createTestSymptom(id: 's2', logId: 'l2', name: 'Bloating'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: CompareCyclesPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Headers: Current (Jul 29 - Present) and Previous (Jul 1 - Jul 28)
      expect(find.text('Current'), findsOneWidget);
      expect(find.text('(Jul 29 - Present)'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('(Jul 1 - Jul 28)'), findsOneWidget);

      // Period length
      expect(find.text('5 days'), findsWidgets);

      // Pain
      expect(find.text('8.0 / 10'), findsOneWidget);
      expect(find.text('5.0 / 10'), findsOneWidget);

      // Symptoms: Current has Bloating (Yes) and no Headache (No); Previous has Headache (Yes) and no Bloating (No)
      expect(find.text('Yes'), findsNWidgets(2));
      expect(find.text('No'), findsNWidgets(2));

      // Sleep
      expect(find.text('6h'), findsOneWidget);
      expect(find.text('7h'), findsOneWidget);

      // Stress
      expect(find.text('7.0 / 10'), findsOneWidget);
      expect(find.text('4.0 / 10'), findsOneWidget);

      // What's different text generates dynamic differences
      expect(find.textContaining('average pain was higher (+3.0)'), findsOneWidget);
      expect(find.textContaining('sleep was shorter (-60m)'), findsOneWidget);
    });

    testWidgets('Select any cycles dialog allows choosing custom cycles to compare', (tester) async {
      final cycles = [
        createTestCycle(
          id: 'c1',
          start: DateTime(2026, 5, 1),
          end: DateTime(2026, 5, 28),
          length: 28,
          period: 5,
        ),
        createTestCycle(
          id: 'c2',
          start: DateTime(2026, 5, 29),
          end: DateTime(2026, 6, 27),
          length: 30,
          period: 4,
        ),
        createTestCycle(
          id: 'c3',
          start: DateTime(2026, 6, 28),
          end: DateTime(2026, 7, 26),
          length: 29,
          period: 5,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(<DailySymptom>[])),
          ],
          child: const MaterialApp(
            home: CompareCyclesPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.text('Select any cycles'));
      await tester.pumpAndSettle();

      // Dialog is open with "Select Cycle 1" and "Select Cycle 2"
      expect(find.text('Select Cycle 1'), findsOneWidget);
      expect(find.text('Select Cycle 2'), findsOneWidget);

      // Tap Proceed
      await tester.tap(find.text('Proceed'));
      await tester.pumpAndSettle();

      // Switched to Tab 1
      expect(find.text('Cycle 3'), findsOneWidget);
      expect(find.text('Cycle 2'), findsOneWidget);
      expect(find.text('29 days'), findsOneWidget);
      expect(find.text('30 days'), findsOneWidget);
    });
  });
}
