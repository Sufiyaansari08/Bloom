import 'package:drift/drift.dart';
import '../app_database.dart';

class DailyLogRepository {
  final AppDatabase _db;

  DailyLogRepository(this._db);

  DateTime _stripTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  Future<DailyLog?> getLogForDate(DateTime date) async {
    final cleanDate = _stripTime(date);
    return (_db.select(_db.dailyLogs)
          ..where((t) => t.isDeleted.equals(false) & t.date.equals(cleanDate))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<DailyLog?> watchLogForDate(DateTime date) {
    final cleanDate = _stripTime(date);
    return (_db.select(_db.dailyLogs)
          ..where((t) => t.isDeleted.equals(false) & t.date.equals(cleanDate))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<List<DailyLog>> getLogsForCycle(String cycleId) async {
    return (_db.select(_db.dailyLogs)
          ..where((t) => t.isDeleted.equals(false) & t.cycleId.equals(cycleId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .get();
  }

  Stream<List<DailyLog>> watchLogsForCycle(String cycleId) {
    return (_db.select(_db.dailyLogs)
          ..where((t) => t.isDeleted.equals(false) & t.cycleId.equals(cycleId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .watch();
  }

  Future<List<DailyLog>> getLogsForDateRange(DateTime start, DateTime end) async {
    final cleanStart = _stripTime(start);
    final cleanEnd = _stripTime(end);
    return (_db.select(_db.dailyLogs)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.date.isBiggerOrEqualValue(cleanStart) &
              t.date.isSmallerOrEqualValue(cleanEnd))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .get();
  }

  Stream<List<DailyLog>> watchLogsForDateRange(DateTime start, DateTime end) {
    final cleanStart = _stripTime(start);
    final cleanEnd = _stripTime(end);
    return (_db.select(_db.dailyLogs)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.date.isBiggerOrEqualValue(cleanStart) &
              t.date.isSmallerOrEqualValue(cleanEnd))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .watch();
  }

  Stream<List<DailyLog>> watchAllDailyLogs() {
    return (_db.select(_db.dailyLogs)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .watch();
  }

  Future<void> upsertDailyLog(DailyLogsCompanion log) async {
    await _db.into(_db.dailyLogs).insertOnConflictUpdate(log);
  }
}
