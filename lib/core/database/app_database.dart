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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(userProfiles, userProfiles.avatarPath);
          await m.addColumn(userProfiles, userProfiles.phone);
          await m.addColumn(userProfiles, userProfiles.periodPredictionEnabled);
          await m.addColumn(userProfiles, userProfiles.ovulationPredictionEnabled);
          await m.addColumn(userProfiles, userProfiles.fertileWindowEnabled);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'bloom_local_db',
    );
  }
}
