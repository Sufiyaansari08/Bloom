import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/insights/presentation/pages/pain_insights_page.dart';

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
    int? painLevel,
  }) {
    return DailyLog(
      id: id,
      userId: 'test_user',
      cycleId: cycleId,
      date: date,
      painLevel: painLevel,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  UserProfile createTestProfile({
    int cycleLength = 28,
    int periodLength = 5,
  }) {
    return UserProfile(
      id: 'test_user',
      name: 'Bloom User',
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

  group('PainInsightsPage Real Database Tests', () {
    testWidgets('0 cycles and 0 logs shows blank chart, 0.0 average, -- stats, and disclaimer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(createTestProfile())),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(<Cycle>[])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
          ],
          child: const MaterialApp(
            home: PainInsightsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Disclaimer
      expect(find.text('Your last 6 cycles are not yet completed'), findsOneWidget);

      // Average pain score
      expect(find.text('0.0'), findsWidgets);
      expect(find.text('No Pain Logged'), findsOneWidget);

      // Small Stat Boxes
      expect(find.text('Highest pain'), findsOneWidget);
      expect(find.text('Lowest pain'), findsOneWidget);
      expect(find.text('Most painful'), findsOneWidget);
      expect(find.text('--'), findsNWidgets(3));
      expect(find.text('No data'), findsNWidgets(3));

      // Legend in Distribution
      expect(find.text('Mild'), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);
      expect(find.text('Severe'), findsOneWidget);
      expect(find.text('V.Severe'), findsOneWidget);
      expect(find.text('0%'), findsNWidgets(4));
    });

    testWidgets('Logged pain across completed cycles computes cycle averages and distributions', (tester) async {
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
        // Cycle 1: Day 1 (pain 8), Day 2 (pain 6) -> cycle avg = 7.0
        createTestLog(
          id: 'log1',
          cycleId: 'cycle1',
          date: DateTime(2026, 7, 1),
          painLevel: 8,
        ),
        createTestLog(
          id: 'log2',
          cycleId: 'cycle1',
          date: DateTime(2026, 7, 2),
          painLevel: 6,
        ),
        // Cycle 2: Day 14 (pain 4) -> cycle avg = 4.0
        createTestLog(
          id: 'log3',
          cycleId: 'cycle2',
          date: DateTime(2026, 8, 11),
          painLevel: 4,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(createTestProfile())),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
          ],
          child: const MaterialApp(
            home: PainInsightsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Disclaimer showing completed count
      expect(
        find.text('Your last 6 cycles are not yet completed (showing 2 completed)'),
        findsOneWidget,
      );

      // Overall average pain = (8 + 6 + 4) / 3 = 6.0
      expect(find.text('6.0'), findsOneWidget);
      expect(find.text('Moderate'), findsWidgets);

      // Highest pain is Cycle 1 (7.0), Lowest is Cycle 2 (4.0)
      expect(find.text('7.0'), findsWidgets);
      expect(find.text('Cycle 1'), findsOneWidget);
      expect(find.text('4.0'), findsWidgets);
      expect(find.text('Cycle 2'), findsOneWidget);

      // Most painful day is Day 1 of period (avg 8.0)
      expect(find.text('Day 1'), findsOneWidget);
      expect(find.text('of period'), findsOneWidget);

      // Pain by phase
      expect(find.text('During period'), findsOneWidget);
      expect(find.text('Ovulation time'), findsOneWidget);

      // Distribution: 2 out of 3 moderate (67%), 1 out of 3 severe (33%)
      expect(find.text('67%'), findsOneWidget);
      expect(find.text('33%'), findsOneWidget);
    });

    testWidgets('Completed cycles equal to selected cycles has no disclaimer', (tester) async {
      final cycles = List.generate(
        3,
        (i) => createCompletedCycle(
          id: 'c$i',
          start: DateTime(2026, 5 + i, 1),
          end: DateTime(2026, 5 + i, 28),
          length: 28,
          period: 5,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(createTestProfile())),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
          ],
          child: const MaterialApp(
            home: PainInsightsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Default is 6 cycles, 3 completed -> disclaimer visible
      expect(
        find.text('Your last 6 cycles are not yet completed (showing 3 completed)'),
        findsOneWidget,
      );

      // Tap dropdown to select 3 cycles
      await tester.tap(find.text('Last 6 cycles'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Last 3 cycles'));
      await tester.pumpAndSettle();

      // Disclaimer should now be gone!
      expect(find.textContaining('not yet completed'), findsNothing);
    });
  });
}
