import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';

class ReminderRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

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

  Future<void> updateReminderTime(String id, String timeOfDay) async {
    await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        timeOfDay: Value(timeOfDay),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateReminderDaysBefore(String id, int daysBefore) async {
    await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        daysBefore: Value(daysBefore),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> ensureStandardReminders(String userId) async {
    final existing = await getAllReminders();
    final existingTypes = existing.map((r) => r.type).toSet();

    final defaults = [
      {'type': 'period_start', 'time': '09:00', 'days': 2, 'enabled': true},
      {'type': 'ovulation', 'time': '09:00', 'days': 1, 'enabled': true},
      {'type': 'fertile_window', 'time': '09:00', 'days': 1, 'enabled': true},
      {'type': 'daily_log', 'time': '21:00', 'days': 0, 'enabled': true},
      {'type': 'cycle_summary', 'time': '10:00', 'days': 0, 'enabled': true},
      {'type': 'quiet_hours', 'time': '22:00 - 07:00', 'days': 0, 'enabled': false},
    ];

    for (final def in defaults) {
      final type = def['type'] as String;
      if (!existingTypes.contains(type)) {
        await _db.into(_db.reminders).insert(
          RemindersCompanion.insert(
            id: _uuid.v4(),
            userId: userId,
            type: type,
            timeOfDay: def['time'] as String,
            daysBefore: Value(def['days'] as int),
            isEnabled: Value(def['enabled'] as bool),
          ),
        );
      }
    }
  }
}
