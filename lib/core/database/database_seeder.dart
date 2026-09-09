import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static const _uuid = Uuid();

  static Future<void> seedInitialData(AppDatabase db) async {
    // Check if data already exists
    final existingUser = await (db.select(db.userProfiles)..limit(1)).getSingleOrNull();
    if (existingUser != null) {
      return; // Already seeded!
    }

    final userId = _uuid.v4();
    final now = DateTime.now();

    // 1. Seed User Profile
    await db.into(db.userProfiles).insert(
      UserProfilesCompanion.insert(
        id: userId,
        name: 'Guest',
        email: const Value('guest@example.com'),
        dateOfBirth: Value(DateTime(2002, 1, 12)),
        heightCm: const Value(165.0),
        weightKg: const Value(60.0),
        bloodGroup: const Value('O+'),
        avgCycleLength: const Value(29),
        avgPeriodLength: const Value(5),
        primaryGoal: const Value('track_period'),
      ),
    );

    // 2. Seed 6 Historical Cycles + 1 Current Cycle
    final cycleData = [
      {'start': DateTime(2026, 2, 1), 'end': DateTime(2026, 2, 28), 'len': 28, 'period': 4},
      {'start': DateTime(2026, 3, 1), 'end': DateTime(2026, 3, 30), 'len': 30, 'period': 5},
      {'start': DateTime(2026, 3, 31), 'end': DateTime(2026, 4, 28), 'len': 29, 'period': 5},
      {'start': DateTime(2026, 4, 29), 'end': DateTime(2026, 5, 29), 'len': 31, 'period': 6},
      {'start': DateTime(2026, 5, 30), 'end': DateTime(2026, 6, 28), 'len': 30, 'period': 4},
      {'start': DateTime(2026, 6, 29), 'end': DateTime(2026, 7, 27), 'len': 29, 'period': 5},
      {'start': DateTime(2026, 7, 28), 'end': null, 'len': null, 'period': 5}, // Ongoing cycle
    ];

    for (final c in cycleData) {
      final cId = _uuid.v4();
      final startDate = c['start'] as DateTime;
      final endDate = c['end'] as DateTime?;
      final cycleLen = c['len'] as int?;
      final periodLen = c['period'] as int?;

      await db.into(db.cycles).insert(
        CyclesCompanion.insert(
          id: cId,
          userId: userId,
          startDate: startDate,
          endDate: Value(endDate),
          cycleLength: Value(cycleLen),
          periodLength: Value(periodLen),
        ),
      );

      // Seed Period Daily Logs for each cycle
      for (int day = 0; day < (periodLen ?? 5); day++) {
        final logDate = startDate.add(Duration(days: day));
        final logId = _uuid.v4();

        await db.into(db.dailyLogs).insert(
          DailyLogsCompanion.insert(
            id: logId,
            userId: userId,
            cycleId: Value(cId),
            date: logDate,
            flowIntensity: Value(day == 0 ? 'medium' : (day == 1 ? 'heavy' : 'light')),
            painLevel: Value(day < 2 ? 6 : 2),
            mood: Value(day < 2 ? 'not_great' : 'good'),
            sleepHours: const Value(6.5),
            waterIntake: const Value('1.5 L'),
            stressLevel: const Value(6),
            activityLevel: const Value('moderate'),
            remedies: Value(day < 2 ? 'Heating pad, Tea' : 'Rest'),
            painAfter1Hr: Value(day < 2 ? 3 : 1),
          ),
        );

        if (day < 2) {
          await db.into(db.dailySymptoms).insert(
            DailySymptomsCompanion.insert(
              id: _uuid.v4(),
              dailyLogId: logId,
              symptomName: 'Cramps',
              severity: const Value(7),
            ),
          );
          await db.into(db.dailySymptoms).insert(
            DailySymptomsCompanion.insert(
              id: _uuid.v4(),
              dailyLogId: logId,
              symptomName: 'Bloating',
              severity: const Value(5),
            ),
          );
        }
      }
    }

    // 3. Seed Reminders
    final reminders = [
      {'type': 'period_start', 'time': '09:00', 'days': 2},
      {'type': 'fertile_window', 'time': '09:00', 'days': 1},
      {'type': 'daily_log', 'time': '21:00', 'days': 0},
      {'type': 'medication', 'time': '08:00', 'days': 0},
    ];

    for (final r in reminders) {
      await db.into(db.reminders).insert(
        RemindersCompanion.insert(
          id: _uuid.v4(),
          userId: userId,
          type: r['type'] as String,
          timeOfDay: r['time'] as String,
          daysBefore: Value(r['days'] as int),
          isEnabled: const Value(true),
        ),
      );
    }

    // 4. Seed AI Insights
    final insights = [
      {
        'category': 'home_summary',
        'phase': 'follicular',
        'headline': 'High Energy Phase',
        'text': 'Your estrogen levels are steadily rising. This is a great time for high-focus tasks and light workouts!',
      },
      {
        'category': 'compare_cycles',
        'phase': null,
        'headline': 'Cycle Comparison',
        'text': 'Your average pain is lower and stress level is slightly higher in this cycle compared to the previous one.',
      },
      {
        'category': 'pain_insights',
        'phase': 'menstrual',
        'headline': 'Pain Trend',
        'text': 'Cramps peak during Day 1-2 of your period. Using a heating pad provides up to 50% relief within 1 hour.',
      },
      {
        'category': 'mood_trends',
        'phase': 'luteal',
        'headline': 'Mood Pattern',
        'text': 'You reported mild mood swings 2-3 days before menstruation. Prioritizing 8 hours of sleep can ease sensitivity.',
      },
      {
        'category': 'lifestyle',
        'phase': null,
        'headline': 'Sleep & Hydration',
        'text': 'Higher stress days correlate with <6 hours of sleep. Maintaining 1.5L+ hydration helps stabilize energy levels.',
      },
      {
        'category': 'doctor_report',
        'phase': null,
        'headline': 'Clinical Summary',
        'text': 'Fairly regular cycle with an average length of 29 days (±2 days variation). Moderate pain during the first 2 days of menstruation.',
      },
    ];

    for (final i in insights) {
      await db.into(db.aiInsights).insert(
        AiInsightsCompanion.insert(
          id: _uuid.v4(),
          userId: userId,
          category: i['category'] as String,
          cyclePhase: Value(i['phase']),
          headline: Value(i['headline']),
          insightText: i['text'] as String,
          generatedDate: now,
        ),
      );
    }
  }
}
