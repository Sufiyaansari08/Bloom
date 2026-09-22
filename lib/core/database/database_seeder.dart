import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static const _uuid = Uuid();

  static Future<void> seedInitialData(AppDatabase db) async {
    // Purge any legacy mock cycles if present
    await purgeMockCycles(db);

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

    // 2. Mock cycles removed to ensure fresh start and dynamic profile settings.


    // 3. Seed Reminders
    final reminders = [
      {'type': 'period_start', 'time': '09:00', 'days': 2, 'enabled': true},
      {'type': 'ovulation', 'time': '09:00', 'days': 1, 'enabled': true},
      {'type': 'fertile_window', 'time': '09:00', 'days': 1, 'enabled': true},
      {'type': 'daily_log', 'time': '21:00', 'days': 0, 'enabled': true},
      {'type': 'cycle_summary', 'time': '10:00', 'days': 0, 'enabled': true},
      {'type': 'quiet_hours', 'time': '22:00 - 07:00', 'days': 0, 'enabled': false},
    ];

    for (final r in reminders) {
      await db.into(db.reminders).insert(
        RemindersCompanion.insert(
          id: _uuid.v4(),
          userId: userId,
          type: r['type'] as String,
          timeOfDay: r['time'] as String,
          daysBefore: Value(r['days'] as int),
          isEnabled: Value(r['enabled'] as bool),
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

  /// Removes hardcoded legacy mock cycles (Feb 2026 - Jul 2026) and their associated logs/symptoms
  static Future<void> purgeMockCycles(AppDatabase db) async {
    final mockStartDates = [
      DateTime(2026, 2, 1),
      DateTime(2026, 3, 1),
      DateTime(2026, 3, 31),
      DateTime(2026, 4, 29),
      DateTime(2026, 5, 30),
      DateTime(2026, 6, 29),
      DateTime(2026, 7, 28),
    ];

    try {
      final cyclesToDelete = await (db.select(db.cycles)
            ..where((t) => t.startDate.isIn(mockStartDates)))
          .get();

      if (cyclesToDelete.isNotEmpty) {
        final cycleIds = cyclesToDelete.map((c) => c.id).toList();

        final logsToDelete = await (db.select(db.dailyLogs)
              ..where((t) => t.cycleId.isIn(cycleIds)))
            .get();
        final logIds = logsToDelete.map((l) => l.id).toList();

        if (logIds.isNotEmpty) {
          await (db.delete(db.dailySymptoms)
                ..where((t) => t.dailyLogId.isIn(logIds)))
              .go();
          await (db.delete(db.dailyLogs)..where((t) => t.id.isIn(logIds))).go();
        }

        await (db.delete(db.cycles)..where((t) => t.id.isIn(cycleIds))).go();
      }
    } catch (_) {
      // Ignore if table or columns not ready during migrations
    }
  }
}
