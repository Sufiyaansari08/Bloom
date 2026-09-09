import 'package:drift/drift.dart';

class DailyLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get cycleId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get flowIntensity => text().nullable()();
  IntColumn get painLevel => integer().nullable()();
  TextColumn get mood => text().nullable()();
  RealColumn get sleepHours => real().nullable()();
  TextColumn get waterIntake => text().nullable()();
  IntColumn get stressLevel => integer().nullable()();
  TextColumn get activityLevel => text().nullable()();
  TextColumn get remedies => text().nullable()();
  IntColumn get painAfter1Hr => integer().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
