import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/insights/presentation/pages/cycle_patterns_page.dart';

void main() {
  UserProfile createTestUser({int cycleLength = 29, int periodLength = 5}) {
    return UserProfile(
      id: 'test_user',
      name: 'Test',
      avgCycleLength: cycleLength,
      avgPeriodLength: periodLength,
      periodPredictionEnabled: true,
      ovulationPredictionEnabled: true,
      fertileWindowEnabled: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

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

  group('CyclePatternsPage Real Database Tests', () {
    testWidgets('0 completed cycles uses onboarding profile, shows blank chart, and displays disclaimer', (tester) async {
      final testUser = createTestUser(cycleLength: 29, periodLength: 5);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(<Cycle>[])),
          ],
          child: const MaterialApp(
            home: CyclePatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Average cycle: 29
      expect(find.text('29'), findsWidgets);
      // Average period: 5
      expect(find.text('5'), findsOneWidget);
      // Variation: ±0
      expect(find.text('±0'), findsOneWidget);
      // Dropdown shows Last 6 cycles by default
      expect(find.text('Last 6 cycles'), findsOneWidget);
      // Disclaimer shown because 0 cycles < 6
      expect(find.text('Your last 6 cycles are not yet completed'), findsOneWidget);
      // Chart has 0 cycle labels (C1 not present)
      expect(find.text('C1'), findsNothing);
    });

    testWidgets('1 completed cycle shows 1 bar, cycle data, and partial disclaimer', (tester) async {
      final testUser = createTestUser(cycleLength: 29, periodLength: 5);
      final cycles = [
        createCompletedCycle(
          id: 'c1',
          start: DateTime(2026, 8, 1),
          end: DateTime(2026, 8, 27),
          length: 27,
          period: 4,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
          ],
          child: const MaterialApp(
            home: CyclePatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Cycle stats
      expect(find.text('27'), findsWidgets);
      expect(find.text('4'), findsWidgets);
      expect(find.text('±0'), findsOneWidget);

      // Disclaimer showing 1 completed
      expect(find.text('Your last 6 cycles are not yet completed (showing 1 completed)'), findsOneWidget);

      // C1 appears on the bar chart
      expect(find.text('C1'), findsOneWidget);
    });

    testWidgets('Multiple completed cycles calculates stats and clears disclaimer when range is met', (tester) async {
      final testUser = createTestUser(cycleLength: 28, periodLength: 5);
      // 4 cycles: 28, 30, 29, 31 (avg = 30, min = 28, max = 31)
      final cycles = [
        createCompletedCycle(id: 'c1', start: DateTime(2026, 5, 1), end: DateTime(2026, 5, 28), length: 28, period: 5),
        createCompletedCycle(id: 'c2', start: DateTime(2026, 5, 29), end: DateTime(2026, 6, 27), length: 30, period: 4),
        createCompletedCycle(id: 'c3', start: DateTime(2026, 6, 28), end: DateTime(2026, 7, 26), length: 29, period: 5),
        createCompletedCycle(id: 'c4', start: DateTime(2026, 7, 27), end: DateTime(2026, 8, 26), length: 31, period: 5),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
          ],
          child: const MaterialApp(
            home: CyclePatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 4 cycles exist, so for default 6 it shows disclaimer:
      expect(find.text('Your last 6 cycles are not yet completed (showing 4 completed)'), findsOneWidget);

      // Average: 30
      expect(find.text('30'), findsWidgets);
      // Shortest: 28
      expect(find.text('28'), findsWidgets);
      // Longest: 31
      expect(find.text('31'), findsWidgets);
      // Variation: ±1
      expect(find.text('±1'), findsOneWidget);

      // All 4 bars on chart
      expect(find.text('C1'), findsOneWidget);
      expect(find.text('C2'), findsOneWidget);
      expect(find.text('C3'), findsOneWidget);
      expect(find.text('C4'), findsOneWidget);

      // Switch dropdown to "Last 2 cycles"
      await tester.tap(find.text('Last 6 cycles'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Last 2 cycles').last);
      await tester.pumpAndSettle();

      // For 2 cycles, only 2 bars shown (C1, C2) and no disclaimer
      expect(find.text('Last 2 cycles'), findsOneWidget);
      expect(find.textContaining('not yet completed'), findsNothing);
    });
  });
}
