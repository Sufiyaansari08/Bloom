import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/calendar/presentation/providers/calendar_provider.dart';
import 'package:bloom/features/reminders/presentation/pages/reminders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCalendarNotifier extends StateNotifier<CalendarState> implements CalendarNotifier {
  MockCalendarNotifier(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Reminders Due Badge Tests', () {
    testWidgets('Fertile window and Ovulation reminders do NOT show Due Today badge', (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final dummyUser = UserProfile(
        id: 'test_user',
        name: 'Test User',
        email: 'test@example.com',
        avgCycleLength: 28,
        avgPeriodLength: 5,
        periodPredictionEnabled: true,
        ovulationPredictionEnabled: true,
        fertileWindowEnabled: true,
        createdAt: today,
        updatedAt: today,
        isSynced: false,
        isDeleted: false,
      );

      final remindersList = [
        Reminder(
          id: 'rem_ovulation',
          userId: 'test_user',
          type: 'ovulation',
          timeOfDay: '09:00',
          daysBefore: 0,
          isEnabled: true,
          createdAt: today,
          updatedAt: today,
          isSynced: false,
          isDeleted: false,
        ),
        Reminder(
          id: 'rem_fertile',
          userId: 'test_user',
          type: 'fertile_window',
          timeOfDay: '09:00',
          daysBefore: 0,
          isEnabled: true,
          createdAt: today,
          updatedAt: today,
          isSynced: false,
          isDeleted: false,
        ),
      ];

      final calendarState = CalendarState(
        selectedDay: today,
        focusedDay: today,
        ovulationDay: today,
        fertileDays: [today],
        periodDays: [],
        expectedPeriodDays: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allRemindersStreamProvider.overrideWith((ref) => Stream.value(remindersList)),
            userProfileStreamProvider.overrideWith((ref) => Stream.value(dummyUser)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value([])),
            calendarProvider.overrideWith((ref) => MockCalendarNotifier(calendarState)),
          ],
          child: const MaterialApp(
            home: RemindersPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Ovulation reminder'), findsOneWidget);
      expect(find.text('Fertile window reminder'), findsOneWidget);
      // Neither fertile window nor ovulation reminder should display 'Due Today'
      expect(find.text('Due Today'), findsNothing);
    });

    testWidgets('Daily check-in reminder DOES show Due Today when uncompleted', (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final dummyUser = UserProfile(
        id: 'test_user',
        name: 'Test User',
        email: 'test@example.com',
        avgCycleLength: 28,
        avgPeriodLength: 5,
        periodPredictionEnabled: true,
        ovulationPredictionEnabled: true,
        fertileWindowEnabled: true,
        createdAt: today,
        updatedAt: today,
        isSynced: false,
        isDeleted: false,
      );

      final remindersList = [
        Reminder(
          id: 'rem_daily_log',
          userId: 'test_user',
          type: 'daily_log',
          timeOfDay: '20:00',
          daysBefore: 0,
          isEnabled: true,
          createdAt: today,
          updatedAt: today,
          isSynced: false,
          isDeleted: false,
        ),
      ];

      final calendarState = CalendarState(
        selectedDay: today,
        focusedDay: today,
        ovulationDay: null,
        fertileDays: [],
        periodDays: [],
        expectedPeriodDays: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allRemindersStreamProvider.overrideWith((ref) => Stream.value(remindersList)),
            userProfileStreamProvider.overrideWith((ref) => Stream.value(dummyUser)),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value([])),
            calendarProvider.overrideWith((ref) => MockCalendarNotifier(calendarState)),
          ],
          child: const MaterialApp(
            home: RemindersPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Daily check-in reminder'), findsOneWidget);
      expect(find.text('Due Today'), findsOneWidget);
    });
  });
}
