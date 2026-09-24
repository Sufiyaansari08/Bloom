import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/insights/presentation/pages/lifestyle_insights_page.dart';

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
    double? sleepHours,
    String? waterIntake,
    String? activityLevel,
    int? stressLevel,
    int? painLevel,
    String? mood,
  }) {
    return DailyLog(
      id: id,
      userId: 'test_user',
      cycleId: cycleId,
      date: date,
      sleepHours: sleepHours,
      waterIntake: waterIntake,
      activityLevel: activityLevel,
      stressLevel: stressLevel,
      painLevel: painLevel,
      mood: mood,
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

  group('LifestyleInsightsPage Real Database Tests', () {
    testWidgets('0 cycles and 0 logs shows empty states, -- averages, and disclaimer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(<Cycle>[])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(<DailyLog>[])),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(<DailySymptom>[])),
          ],
          child: const MaterialApp(
            home: LifestyleInsightsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Disclaimer
      expect(find.text('Your last 6 cycles are not yet completed'), findsOneWidget);

      // Card 1 Averages
      expect(find.text('--'), findsNWidgets(4));

      // Card 2 Empty state
      expect(find.text('No lifestyle patterns yet'), findsOneWidget);

      // Card 3 Pro Banner
      expect(find.text('Unlock with Bloom Pro'), findsOneWidget);
    });

    testWidgets('Logged lifestyle data computes real averages and unlocked correlations', (tester) async {
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
        // Cycle 1: low sleep (5.0h) with headache, high stress (8) with pain (7), moderate activity
        createTestLog(
          id: 'log1',
          cycleId: 'cycle1',
          date: DateTime(2026, 7, 1),
          sleepHours: 5.0,
          waterIntake: '2.0 L',
          activityLevel: 'Moderate',
          stressLevel: 8,
          painLevel: 7,
          mood: 'Bad',
        ),
        // Cycle 2: normal sleep (7.5h), 2.0 L water, moderate activity, stress 4, pain 1
        createTestLog(
          id: 'log2',
          cycleId: 'cycle2',
          date: DateTime(2026, 8, 1),
          sleepHours: 7.5,
          waterIntake: '2.0 L',
          activityLevel: 'Moderate',
          stressLevel: 4,
          painLevel: 1,
          mood: 'Good',
        ),
      ];

      final symptoms = [
        createTestSymptom(id: 's1', logId: 'log1', name: 'Headache'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: LifestyleInsightsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Card 1 Averages:
      // Sleep: (5.0 + 7.5) / 2 = 6.25h -> 6h 15m
      expect(find.text('6h 15m'), findsOneWidget);
      // Water: 2.0 L
      expect(find.text('2.0 L'), findsOneWidget);
      // Activity: Moderate
      expect(find.text('Moderate'), findsOneWidget);
      // Stress: (8 + 4) / 2 = 6.0 / 10
      expect(find.text('6.0 / 10'), findsOneWidget);

      // Card 2 Correlations:
      expect(find.text('Sleep & Headaches'), findsOneWidget);
      expect(find.text('Stress & Pain'), findsOneWidget);
      expect(find.text('Activity & Energy'), findsOneWidget);

      // Pro banner is still visible
      expect(find.text('Unlock with Bloom Pro'), findsOneWidget);
    });

    testWidgets('Selecting cycle count that is met clears disclaimer', (tester) async {
      final cycles = [
        createCompletedCycle(
          id: 'c1',
          start: DateTime(2026, 6, 1),
          end: DateTime(2026, 6, 28),
          length: 28,
          period: 5,
        ),
        createCompletedCycle(
          id: 'c2',
          start: DateTime(2026, 6, 29),
          end: DateTime(2026, 7, 26),
          length: 28,
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
            home: LifestyleInsightsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 6 selected, 2 completed -> disclaimer visible
      expect(
        find.text('Your last 6 cycles are not yet completed (showing 2 completed)'),
        findsOneWidget,
      );

      // Select "Last 2 cycles"
      await tester.tap(find.text('Last 6 cycles'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Last 2 cycles').last);
      await tester.pumpAndSettle();

      // Disclaimer should now be gone!
      expect(find.textContaining('not yet completed'), findsNothing);
    });

    testWidgets('Selecting Current cycle filters lifestyle metrics to active cycle', (tester) async {
      final ongoingCycle = Cycle(
        id: 'curr_cycle',
        userId: 'test_user',
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        endDate: null,
        cycleLength: null,
        periodLength: null,
        isPredicted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
        isDeleted: false,
      );

      final logs = [
        createTestLog(
          id: 'log_curr1',
          cycleId: 'curr_cycle',
          date: DateTime.now().subtract(const Duration(days: 1)),
          sleepHours: 8.0,
          waterIntake: '2.0 L',
          activityLevel: 'Moderate',
          stressLevel: 3,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([ongoingCycle])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(<DailySymptom>[])),
          ],
          child: const MaterialApp(
            home: LifestyleInsightsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open dropdown and select 'Current cycle'
      await tester.tap(find.text('Last 6 cycles'));
      await tester.pumpAndSettle();

      expect(find.text('Current cycle'), findsOneWidget);
      await tester.tap(find.text('Current cycle'));
      await tester.pumpAndSettle();

      // Header updates to Current cycle
      expect(find.text('Current cycle'), findsOneWidget);

      // Averages calculated from active cycle log
      expect(find.text('8h'), findsOneWidget);
      expect(find.text('2.0 L'), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);
      expect(find.text('3.0 / 10'), findsOneWidget);

      // Disclaimer is cleared
      expect(find.textContaining('not yet completed'), findsNothing);
    });
  });
}
