import 'package:drift/drift.dart';

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get bloodGroup => text().nullable()();
  IntColumn get avgCycleLength => integer().withDefault(const Constant(28))();
  IntColumn get avgPeriodLength => integer().withDefault(const Constant(5))();
  TextColumn get primaryGoal => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
