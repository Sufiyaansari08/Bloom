import 'package:drift/drift.dart';

class AiInsights extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get category => text()(); // 'home_summary', 'compare_cycles', 'pain_insights', 'mood_trends', 'lifestyle', 'doctor_report'
  TextColumn get cyclePhase => text().nullable()(); // 'menstrual', 'follicular', 'ovulatory', 'luteal'
  TextColumn get headline => text().nullable()();
  TextColumn get insightText => text()();
  DateTimeColumn get generatedDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
