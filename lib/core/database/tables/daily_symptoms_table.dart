import 'package:drift/drift.dart';

class DailySymptoms extends Table {
  TextColumn get id => text()();
  TextColumn get dailyLogId => text()();
  TextColumn get symptomName => text()();
  IntColumn get severity => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
