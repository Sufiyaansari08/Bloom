import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/user_profiles_table.dart';
import 'tables/cycles_table.dart';
import 'tables/daily_logs_table.dart';
import 'tables/daily_symptoms_table.dart';
import 'tables/reminders_table.dart';
import 'tables/ai_insights_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  UserProfiles,
  Cycles,
  DailyLogs,
  DailySymptoms,
  Reminders,
  AiInsights,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'bloom_local_db',
    );
  }
}
