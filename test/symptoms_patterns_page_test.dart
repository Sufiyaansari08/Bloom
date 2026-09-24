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
    String? flowIntensity,
  }) {
    return DailyLog(
      id: id,
      userId: 'test_user',
      cycleId: cycleId,
      date: date,
      flowIntensity: flowIntensity,
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

    testWidgets('0 completed cycles with symptoms logged in active cycle shows empty state and disclaimer on Last 6 cycles', (tester) async {
      final ongoingCycle = Cycle(
        id: 'curr_cycle',
        userId: 'test_user',
        startDate: DateTime.now().subtract(const Duration(days: 4)),
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
        createTestLog(id: 'log_curr1', cycleId: 'curr_cycle', date: DateTime.now().subtract(const Duration(days: 2))),
      ];

      final symptoms = [
        createTestSymptom(id: 's_curr1', logId: 'log_curr1', name: 'Bloating'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([ongoingCycle])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // On Last 6 cycles, completed cycles is 0:
      // Shows disclaimer
      expect(find.text('Your last 6 cycles are not yet completed'), findsOneWidget);
      // Empty state shown - NOT fake 10%!
      expect(find.text('No symptoms logged yet'), findsOneWidget);
      expect(find.text('10%'), findsNothing);
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

    testWidgets('Selecting Current cycle filters symptoms to active cycle and shows frequency percentage', (tester) async {
      final ongoingCycle = Cycle(
        id: 'curr_cycle',
        userId: 'test_user',
        startDate: DateTime.now().subtract(const Duration(days: 4)),
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
        createTestLog(id: 'log_curr1', cycleId: 'curr_cycle', date: DateTime.now().subtract(const Duration(days: 2))),
        createTestLog(id: 'log_curr2', cycleId: 'curr_cycle', date: DateTime.now().subtract(const Duration(days: 1))),
      ];

      final symptoms = [
        createTestSymptom(id: 's_curr1', logId: 'log_curr1', name: 'Cramps'),
        createTestSymptom(id: 's_curr2', logId: 'log_curr1', name: 'Bloating'),
        createTestSymptom(id: 's_curr3', logId: 'log_curr2', name: 'Cramps'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([ongoingCycle])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
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

      // Cramps is logged on 2 of 2 symptom days -> 100%
      expect(find.text('Cramps'), findsWidgets);
      expect(find.text('100%'), findsOneWidget);

      // Bloating is logged on 1 of 2 symptom days -> 50%
      expect(find.text('Bloating'), findsWidgets);
      expect(find.text('50%'), findsOneWidget);

      // Disclaimer is cleared
      expect(find.textContaining('not yet completed'), findsNothing);
    });

    testWidgets('Frequency is calculated based on total logged days (e.g. 2 of 10 days = 20%)', (tester) async {
      final cycle = createCompletedCycle(
        id: 'cycle_10d',
        start: DateTime(2026, 8, 1),
        end: DateTime(2026, 8, 28),
        length: 28,
        period: 5,
      );

      // 10 logged days in total
      final logs = List.generate(10, (i) {
        return createTestLog(
          id: 'log_$i',
          cycleId: 'cycle_10d',
          date: DateTime(2026, 8, 1 + i),
        );
      });

      // Headache logged on 2 of the 10 days
      // Cramps logged on 5 of the 10 days
      final symptoms = [
        createTestSymptom(id: 's_h1', logId: 'log_1', name: 'Headache'),
        createTestSymptom(id: 's_h2', logId: 'log_4', name: 'Headache'),
        createTestSymptom(id: 's_c1', logId: 'log_0', name: 'Cramps'),
        createTestSymptom(id: 's_c2', logId: 'log_1', name: 'Cramps'),
        createTestSymptom(id: 's_c3', logId: 'log_2', name: 'Cramps'),
        createTestSymptom(id: 's_c4', logId: 'log_3', name: 'Cramps'),
        createTestSymptom(id: 's_c5', logId: 'log_4', name: 'Cramps'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([cycle])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Last 1 cycle (Current cycle or 1 cycle dropdown doesn't have 1 for completed,
      // but completed cycle is shown with partial disclaimer on 6 cycles)
      // Headache: 2 days / 10 total days = 20%
      expect(find.text('Headache'), findsWidgets);
      expect(find.text('20%'), findsOneWidget);

      // Cramps: 5 days / 10 total days = 50%
      expect(find.text('Cramps'), findsWidgets);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('Only top 6 symptoms are displayed in Most common symptoms even if 8 symptoms logged', (tester) async {
      final cycle = createCompletedCycle(
        id: 'cycle_top6',
        start: DateTime(2026, 8, 1),
        end: DateTime(2026, 8, 28),
        length: 28,
        period: 5,
      );

      final logs = List.generate(10, (i) {
        return createTestLog(
          id: 'log_$i',
          cycleId: 'cycle_top6',
          date: DateTime(2026, 8, 1 + i),
        );
      });

      // 8 distinct symptoms with different frequencies
      final symptoms = <DailySymptom>[];
      final symptomConfigs = [
        ('Cramps', 8),
        ('Bloating', 7),
        ('Headache', 6),
        ('Fatigue', 5),
        ('Back pain', 4),
        ('Mood swings', 3),
        ('Acne', 2),
        ('Nausea', 1),
      ];

      int sIndex = 0;
      for (final config in symptomConfigs) {
        final name = config.$1;
        final count = config.$2;
        for (int i = 0; i < count; i++) {
          symptoms.add(
            createTestSymptom(
              id: 'sym_${sIndex++}',
              logId: 'log_$i',
              name: name,
            ),
          );
        }
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([cycle])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top 6 symptoms should be present
      expect(find.text('Cramps'), findsWidgets);
      expect(find.text('Bloating'), findsWidgets);
      expect(find.text('Headache'), findsWidgets);
      expect(find.text('Fatigue'), findsWidgets);
      expect(find.text('Back pain'), findsWidgets);
      expect(find.text('Mood swings'), findsWidgets);

      // Symptoms #7 and #8 (Acne, Nausea) should NOT be present in top 6
      expect(find.text('Acne'), findsNothing);
      expect(find.text('Nausea'), findsNothing);

      // Card 2 "View all symptoms" button should expand only up to the 6 top symptoms
      final viewAllFinder = find.text('View all symptoms');
      expect(viewAllFinder, findsOneWidget);
      await tester.ensureVisible(viewAllFinder);
      await tester.pumpAndSettle();
      await tester.tap(viewAllFinder);
      await tester.pumpAndSettle();

      // Even when expanded, Acne and Nausea must still NOT be displayed
      expect(find.text('Acne'), findsNothing);
      expect(find.text('Nausea'), findsNothing);
    });

    testWidgets('Cramps logged during period with flow intensity is classified as During period not Follicular', (tester) async {
      final ongoingCycle = Cycle(
        id: 'cycle_curr',
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

      // User logged period with flow intensity 'Medium' and Cramps
      final logs = [
        createTestLog(
          id: 'log_period',
          cycleId: 'cycle_curr',
          date: DateTime.now().subtract(const Duration(days: 2)),
          flowIntensity: 'Medium',
        ),
      ];

      final symptoms = [
        createTestSymptom(id: 's_cramp', logId: 'log_period', name: 'Cramps'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([ongoingCycle])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value(logs)),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value(symptoms)),
          ],
          child: const MaterialApp(
            home: SymptomsPatternsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Select Current cycle from dropdown
      await tester.tap(find.text('Last 6 cycles'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Current cycle'));
      await tester.pumpAndSettle();

      // Timing badge should be 'During period'
      expect(find.text('During period'), findsOneWidget);
      expect(find.text('Usually during the first 1-2 days of your period'), findsOneWidget);

      // Follicular must NOT appear
      expect(find.text('Follicular'), findsNothing);
      expect(find.text('Usually after period in follicular phase'), findsNothing);
    });
  });
}
