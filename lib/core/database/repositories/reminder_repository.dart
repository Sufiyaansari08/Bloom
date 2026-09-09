import 'package:drift/drift.dart';
import '../app_database.dart';

class ReminderRepository {
  final AppDatabase _db;

  ReminderRepository(this._db);

  Future<List<Reminder>> getAllReminders() async {
    return (_db.select(_db.reminders)..where((t) => t.isDeleted.equals(false))).get();
  }

  Stream<List<Reminder>> watchAllReminders() {
    return (_db.select(_db.reminders)..where((t) => t.isDeleted.equals(false))).watch();
  }

  Future<void> upsertReminder(RemindersCompanion reminder) async {
    await _db.into(_db.reminders).insertOnConflictUpdate(reminder);
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        isEnabled: Value(isEnabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
