import 'package:drift/drift.dart';
import '../app_database.dart';

class SymptomRepository {
  final AppDatabase _db;

  SymptomRepository(this._db);

  Future<List<DailySymptom>> getSymptomsForLog(String dailyLogId) async {
    return (_db.select(_db.dailySymptoms)
          ..where((t) => t.isDeleted.equals(false) & t.dailyLogId.equals(dailyLogId)))
        .get();
  }

  Stream<List<DailySymptom>> watchSymptomsForLog(String dailyLogId) {
    return (_db.select(_db.dailySymptoms)
          ..where((t) => t.isDeleted.equals(false) & t.dailyLogId.equals(dailyLogId)))
        .watch();
  }

  Future<List<DailySymptom>> getAllSymptoms() async {
    return (_db.select(_db.dailySymptoms)
          ..where((t) => t.isDeleted.equals(false)))
        .get();
  }

  Stream<List<DailySymptom>> watchAllSymptoms() {
    return (_db.select(_db.dailySymptoms)
          ..where((t) => t.isDeleted.equals(false)))
        .watch();
  }

  Future<void> setSymptomsForLog(String dailyLogId, List<DailySymptomsCompanion> symptoms) async {
    await _db.transaction(() async {
      // Soft-delete or remove existing symptoms for this log
      await (_db.delete(_db.dailySymptoms)..where((t) => t.dailyLogId.equals(dailyLogId))).go();
      for (final s in symptoms) {
        await _db.into(_db.dailySymptoms).insert(s);
      }
    });
  }
}
