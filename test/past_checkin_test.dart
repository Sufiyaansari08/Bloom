import 'package:bloom/features/calendar/presentation/widgets/daily_summary_card.dart';
import 'package:bloom/features/checkin/presentation/pages/checkin_notes_page.dart';
import 'package:bloom/features/checkin/presentation/providers/daily_checkin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('Past Day & Yesterday Daily Check-in Tests', () {
    testWidgets('DailySummaryCard displays "Log for Yesterday" prompt when yesterday has no check-in', (tester) async {
      bool checkinTapped = false;
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(
                date: yesterday,
                isPeriodDay: false,
                isFertileDay: false,
                onCheckinForDay: () {
                  checkinTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Daily Check-in • Yesterday'), findsOneWidget);
      expect(find.text("You missed check-in for yesterday. Tap to log it now."), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);

      await tester.tap(find.text('Daily Check-in • Yesterday'));
      expect(checkinTapped, isTrue);
    });

    testWidgets('DailySummaryCard displays "You missed check-in for <date>. Tap to log it now." for older past date', (tester) async {
      bool checkinTapped = false;
      final pastDate = DateTime.now().subtract(const Duration(days: 3));
      final dateFormatted = DateFormat('MMM d').format(pastDate);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(
                date: pastDate,
                isPeriodDay: false,
                isFertileDay: false,
                onCheckinForDay: () {
                  checkinTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Daily Check-in • $dateFormatted'), findsOneWidget);
      expect(find.text('You missed check-in for $dateFormatted. Tap to log it now.'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);

      await tester.tap(find.text('Daily Check-in • $dateFormatted'));
      expect(checkinTapped, isTrue);
    });

    testWidgets('DailySummaryCard displays edit button when check-in already exists for that day', (tester) async {
      bool editTapped = false;
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(
                date: yesterday,
                isPeriodDay: false,
                isFertileDay: false,
                checkinData: DailyCheckinState(mood: 'Good', symptoms: ['Cramps']),
                onCheckinForDay: () {
                  editTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Feeling Good'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      expect(editTapped, isTrue);
    });

    testWidgets('CheckinNotesPage displays "Any notes for yesterday?" when targetDate is yesterday', (tester) async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dailyCheckinProvider.overrideWith((ref) {
              final notifier = DailyCheckinNotifier(ref);
              notifier.setTargetDate(yesterday);
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: CheckinNotesPage(),
          ),
        ),
      );

      expect(find.text('Any notes for yesterday?'), findsOneWidget);
    });

    testWidgets('DailySummaryCard displays "Ovulation expected today • Day 9" with suitable subtext and no + icon', (tester) async {
      final today = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(
                date: today,
                isPeriodDay: false,
                isFertileDay: true,
                isOvulationDay: true,
                cycleDay: 9,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Ovulation expected today • Day 9'), findsOneWidget);
      expect(find.text('Peak fertility • Highest chance of conception'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      // Ensure no + icon is present on this status card
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('DailySummaryCard displays Cycle Day 5 without + icon', (tester) async {
      final today = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(
                date: today,
                isPeriodDay: false,
                isFertileDay: false,
                isOvulationDay: false,
                cycleDay: 5,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Cycle Day 5'), findsOneWidget);
      expect(find.text('Day 5 of your menstrual cycle'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
      // Ensure no + icon is present on this status card
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('DailySummaryCard displays Fertile Window • Day 7 without + icon', (tester) async {
      final today = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(
                date: today,
                isPeriodDay: false,
                isFertileDay: true,
                isOvulationDay: false,
                cycleDay: 7,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Fertile Window • Day 7'), findsOneWidget);
      expect(find.text('High chance of pregnancy'), findsOneWidget);
      expect(find.byIcon(Icons.spa_outlined), findsOneWidget);
      // Ensure no + icon is present on this status card
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
      expect(find.byIcon(Icons.add), findsNothing);
    });
  });
}
