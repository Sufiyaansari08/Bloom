import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/insights/presentation/pages/symptoms_patterns_page.dart';

void main() {
  Cycle createCompletedCycle({
    required String id,
    required DateTime start,
    required DateTime end,
    required int length,
    required int period,
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
  }) {
    return DailyLog(
      id: id,
      userId: 'test_user',
      cycleId: cycleId,
      date: date,
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

  group('SymptomsPatternsPage Real Database Tests', () {
    testWidgets('0 symptoms shows empty states and dropdown disclaimer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(<Cycle>[])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(<DailySymptom>[])),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Disclaimer
      expect(find.text('Your last 6 cycles are not yet completed'), findsOneWidget);
      // Empty state Card 1
      expect(find.text('No symptoms logged yet'), findsOneWidget);
      // Empty state Card 2
      expect(find.text('No timing patterns yet'), findsOneWidget);
    });

    testWidgets('Logged symptoms calculate frequency and display timing badges', (tester) async {
      final cycles = [
        createCompletedCycle(
          id: 'cycle1',
          start: DateTime(2026, 7, 1),
          end: DateTime(2026, 7, 28),
          length: 28,
          period: 5,
        ),
        createCompletedCycle(
          id: 'cycle2',
          start: DateTime(2026, 7, 29),
          end: DateTime(2026, 8, 25),
          length: 28,
          period: 5,
        ),
      ];

      final logs = [
        // Cycle 1, Day 1: Cramps and Bloating
        createTestLog(id: 'log1', cycleId: 'cycle1', date: DateTime(2026, 7, 1)),
        // Cycle 2, Day 2: Cramps
        createTestLog(id: 'log2', cycleId: 'cycle2', date: DateTime(2026, 7, 30)),
      ];

      final symptoms = [
        createTestSymptom(id: 's1', logId: 'log1', name: 'Cramps'),
        createTestSymptom(id: 's2', logId: 'log1', name: 'Bloating'),
        createTestSymptom(id: 's3', logId: 'log2', name: 'Cramps'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Partial disclaimer for 6 cycles (2 completed)
      expect(find.text('Your last 6 cycles are not yet completed (showing 2 completed)'), findsOneWidget);

      // Cramps: 2 out of 2 cycles = 100%
      expect(find.text('Cramps'), findsWidgets);
      expect(find.text('100%'), findsOneWidget);

      // Bloating: 1 out of 2 cycles = 50%
      expect(find.text('Bloating'), findsWidgets);
      expect(find.text('50%'), findsOneWidget);

      // Timing badge: Day 1 and Day 2 are within period length (5 days)
      expect(find.text('During period'), findsWidgets);
    });

    testWidgets('Selecting cycle count that is met clears the disclaimer', (tester) async {
      final cycles = [
        createCompletedCycle(id: 'c1', start: DateTime(2026, 5, 1), end: DateTime(2026, 5, 28), length: 28, period: 5),
        createCompletedCycle(id: 'c2', start: DateTime(2026, 5, 29), end: DateTime(2026, 6, 25), length: 28, period: 5),
        createCompletedCycle(id: 'c3', start: DateTime(2026, 6, 26), end: DateTime(2026, 7, 23), length: 28, period: 5),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(<DailySymptom>[])),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Default is 6 cycles, 3 completed -> shows disclaimer
      expect(find.text('Your last 6 cycles are not yet completed (showing 3 completed)'), findsOneWidget);

      // Select "Last 3 cycles"
      await tester.tap(find.text('Last 6 cycles'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Last 3 cycles').last);
      await tester.pumpAndSettle();

      // Now 3 >= 3 -> disclaimer is cleared!
      expect(find.textContaining('not yet completed'), findsNothing);
    });
  });
}
