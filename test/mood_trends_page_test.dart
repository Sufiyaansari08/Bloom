import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/insights/presentation/pages/mood_trends_page.dart';

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
    String? mood,
  }) {
    return DailyLog(
      id: id,
      userId: 'test_user',
      cycleId: cycleId,
      date: date,
      mood: mood,
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

  group('MoodTrendsPage Real Database Tests', () {
    testWidgets('0 cycles and 0 logs shows empty states, 0% legend, and disclaimer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(createTestProfile())),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(<Cycle>[])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
          ],
          child: const MaterialApp(
            home: MoodTrendsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Disclaimer
      expect(find.text('Your last 6 cycles are not yet completed'), findsOneWidget);

      // Card 1 Legend
      expect(find.text('Great'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);
      expect(find.text('Not Great'), findsOneWidget);
      expect(find.text('Bad'), findsOneWidget);
      expect(find.text('0%'), findsNWidgets(5));

      // Card 2 Empty State
      expect(find.text('No mood patterns yet'), findsOneWidget);

      // Card 3 First-time insight
      expect(
        find.text('Keep logging your daily mood to discover personalized emotional patterns across your cycle.'),
        findsOneWidget,
      );
    });

    testWidgets('Logged moods across completed cycles calculates distribution, phase rows, and insight', (tester) async {
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
        // Cycle 1: Day 1 (Bad, During period), Day 27 (Not great, Before period)
        createTestLog(
          id: 'log1',
          cycleId: 'cycle1',
          date: DateTime(2026, 7, 1),
          mood: 'Bad',
        ),
        createTestLog(
          id: 'log2',
          cycleId: 'cycle1',
          date: DateTime(2026, 7, 27),
          mood: 'Not great',
        ),
        // Cycle 2: Day 7 (Great, After period), Day 14 (Good, Ovulation)
        createTestLog(
          id: 'log3',
          cycleId: 'cycle2',
          date: DateTime(2026, 8, 4), // 7 days from Jul 29 (Jul 29 is Day 1 -> Aug 4 is Day 7)
          mood: 'Great',
        ),
        createTestLog(
          id: 'log4',
          cycleId: 'cycle2',
          date: DateTime(2026, 8, 11), // 14 days from Jul 29 -> Aug 11 is Day 14
          mood: 'Good',
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
            home: MoodTrendsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Disclaimer showing completed count
      expect(
        find.text('Your last 6 cycles are not yet completed (showing 2 completed)'),
        findsOneWidget,
      );

      // Card 1 Legend: 4 total moods -> each is 25% (except Okay which is 0%)
      expect(find.text('25%'), findsNWidgets(4));
      expect(find.text('0%'), findsOneWidget);

      // Card 2 Phase rows
      expect(find.text('Before period'), findsOneWidget);
      expect(find.text('During period'), findsOneWidget);
      expect(find.text('After period'), findsOneWidget);
      expect(find.text('Ovulation'), findsOneWidget);

      // Card 3 Insight text
      expect(
        find.text('You tend to feel lower mood before your period.'),
        findsOneWidget,
      );
    });

    testWidgets('Selecting cycle count that is met clears disclaimer', (tester) async {
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
            home: MoodTrendsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 6 selected, 3 completed -> disclaimer visible
      expect(
        find.text('Your last 6 cycles are not yet completed (showing 3 completed)'),
        findsOneWidget,
      );

      // Switch dropdown to 3 cycles
      await tester.tap(find.text('Last 6 cycles'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Last 3 cycles'));
      await tester.pumpAndSettle();

      // Disclaimer should be hidden
      expect(find.textContaining('not yet completed'), findsNothing);
    });
  });
}
