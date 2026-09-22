import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/core/database/database_seeder.dart';
import 'package:bloom/features/insights/presentation/pages/insights_page.dart';

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

  group('InsightsHeroCard & InsightsPage Dynamic Database Tests', () {
    testWidgets('First-time user (0 completed cycles) uses onboarding baseline & shows ±0 variation', (tester) async {
      final testUser = createTestUser(cycleLength: 29, periodLength: 5);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(<Cycle>[])),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: InsightsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Subtitle reflects onboarding
      expect(find.text('Based on onboarding profile'), findsOneWidget);

      // Hero Card Headline
      expect(find.text('Tracking your\nfirst cycles\nwith Bloom'), findsOneWidget);

      // Average stats from onboarding
      expect(find.text('29'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // Option B variation: ±0
      expect(find.text('±0'), findsOneWidget);
    });

    testWidgets('User with 1 completed cycle displays that cycle and baseline building headline', (tester) async {
      final testUser = createTestUser(cycleLength: 29, periodLength: 5);
      final cycle1 = createCompletedCycle(
        id: 'c1',
        start: DateTime(2026, 8, 1),
        end: DateTime(2026, 8, 27),
        length: 27,
        period: 4,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([cycle1])),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: InsightsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Based on your last cycle'), findsOneWidget);
      expect(find.text('Building your\npersonal cycle\nbaseline'), findsOneWidget);
      expect(find.text('27'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('±0'), findsOneWidget);
    });

    testWidgets('User with multiple completed cycles dynamically computes average & variation', (tester) async {
      final testUser = createTestUser(cycleLength: 28, periodLength: 5);
      // 4 cycles: 28, 30, 29, 31 (avg = 30, variation = ±1)
      final cycles = [
        createCompletedCycle(id: 'c4', start: DateTime(2026, 8, 1), end: DateTime(2026, 8, 31), length: 31, period: 5),
        createCompletedCycle(id: 'c3', start: DateTime(2026, 7, 3), end: DateTime(2026, 7, 31), length: 29, period: 5),
        createCompletedCycle(id: 'c2', start: DateTime(2026, 6, 3), end: DateTime(2026, 7, 2), length: 30, period: 4),
        createCompletedCycle(id: 'c1', start: DateTime(2026, 5, 6), end: DateTime(2026, 6, 2), length: 28, period: 5),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value(cycles)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: InsightsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Based on your last 4 cycles'), findsOneWidget);
      expect(find.text('Your cycle is\nconsistent and\nregular'), findsOneWidget);

      // Average cycle: (31 + 29 + 30 + 28) / 4 = 30
      expect(find.text('30'), findsOneWidget);

      // Average period: (5 + 5 + 4 + 5) / 4 = 5 (rounded)
      expect(find.text('5'), findsOneWidget);

      // Variation: mean 30, differences |31-30|=1, |29-30|=1, |30-30|=0, |28-30|=2. Sum=4/4=1 -> ±1
      expect(find.text('±1'), findsOneWidget);
    });

    test('DatabaseSeeder seeds user profile and reminders but NO mock cycles', () async {
      final db = AppDatabase(NativeDatabase.memory());
      await DatabaseSeeder.seedInitialData(db);

      final cycles = await db.select(db.cycles).get();
      expect(cycles, isEmpty);

      final user = await (db.select(db.userProfiles)..limit(1)).getSingleOrNull();
      expect(user, isNotNull);
      expect(user?.avgCycleLength, 29);
      expect(user?.avgPeriodLength, 5);

      await db.close();
    });

    test('DatabaseSeeder.purgeMockCycles removes mock cycles and leaves real cycles intact', () async {
      final db = AppDatabase(NativeDatabase.memory());
      // Insert 1 mock cycle and 1 real cycle
      await db.into(db.cycles).insert(
        CyclesCompanion.insert(
          id: 'mock_1',
          userId: 'u1',
          startDate: DateTime(2026, 2, 1),
          endDate: Value(DateTime(2026, 2, 28)),
          cycleLength: const Value(28),
          periodLength: const Value(4),
        ),
      );
      await db.into(db.cycles).insert(
        CyclesCompanion.insert(
          id: 'real_1',
          userId: 'u1',
          startDate: DateTime(2026, 9, 15),
          endDate: Value(DateTime(2026, 10, 14)),
          cycleLength: const Value(29),
          periodLength: const Value(5),
        ),
      );

      await DatabaseSeeder.purgeMockCycles(db);

      final remaining = await db.select(db.cycles).get();
      expect(remaining.length, 1);
      expect(remaining.first.id, 'real_1');

      await db.close();
    });
  });
}
