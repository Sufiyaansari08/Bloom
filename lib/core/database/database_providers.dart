import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import 'repositories/user_repository.dart';
import 'repositories/cycle_repository.dart';
import 'repositories/daily_log_repository.dart';
import 'repositories/symptom_repository.dart';
import 'repositories/reminder_repository.dart';
import 'repositories/insights_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(databaseProvider));
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepository(ref.watch(databaseProvider));
});

final dailyLogRepositoryProvider = Provider<DailyLogRepository>((ref) {
  return DailyLogRepository(ref.watch(databaseProvider));
});

final symptomRepositoryProvider = Provider<SymptomRepository>((ref) {
  return SymptomRepository(ref.watch(databaseProvider));
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(databaseProvider));
});

final insightsRepositoryProvider = Provider<InsightsRepository>((ref) {
  return InsightsRepository(ref.watch(databaseProvider));
});

// Stream Providers for reactive UI
final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(userRepositoryProvider).watchUserProfile();
});

final allCyclesStreamProvider = StreamProvider<List<Cycle>>((ref) {
  return ref.watch(cycleRepositoryProvider).watchAllCycles();
});

final currentCycleStreamProvider = StreamProvider<Cycle?>((ref) {
  return ref.watch(cycleRepositoryProvider).watchCurrentCycle();
});

final allRemindersStreamProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(reminderRepositoryProvider).watchAllReminders();
});

final allDailyLogsStreamProvider = StreamProvider<List<DailyLog>>((ref) {
  return ref.watch(dailyLogRepositoryProvider).watchAllDailyLogs();
});

final symptomsForLogStreamProvider = StreamProvider.family<List<DailySymptom>, String>((ref, logId) {
  return ref.watch(symptomRepositoryProvider).watchSymptomsForLog(logId);
});
