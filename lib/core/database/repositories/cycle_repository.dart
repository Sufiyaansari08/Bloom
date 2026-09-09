import 'package:drift/drift.dart';
import '../app_database.dart';

class CycleRepository {
  final AppDatabase _db;

  CycleRepository(this._db);

  Future<List<Cycle>> getAllCycles() async {
    return (_db.select(_db.cycles)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)]))
        .get();
  }

  Stream<List<Cycle>> watchAllCycles() {
    return (_db.select(_db.cycles)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<Cycle?> getCurrentCycle() async {
    return (_db.select(_db.cycles)
          ..where((t) => t.isDeleted.equals(false) & t.endDate.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<Cycle?> watchCurrentCycle() {
    return (_db.select(_db.cycles)
          ..where((t) => t.isDeleted.equals(false) & t.endDate.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<void> insertCycle(CyclesCompanion cycle) async {
    await _db.into(_db.cycles).insertOnConflictUpdate(cycle);
  }

  Future<void> updateCycle(CyclesCompanion cycle) async {
    await _db.update(_db.cycles).replace(cycle);
  }

  Future<void> completeCycle(String cycleId, DateTime endDate, int cycleLength, int periodLength) async {
    await (_db.update(_db.cycles)..where((t) => t.id.equals(cycleId))).write(
      CyclesCompanion(
        endDate: Value(endDate),
        cycleLength: Value(cycleLength),
        periodLength: Value(periodLength),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
