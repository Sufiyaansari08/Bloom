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

  Future<void> updateCycleStartDate(String cycleId, DateTime newStartDate) async {
    final cleanDate = DateTime(newStartDate.year, newStartDate.month, newStartDate.day);
    await (_db.update(_db.cycles)..where((t) => t.id.equals(cycleId))).write(
      CyclesCompanion(
        startDate: Value(cleanDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCycle(String cycleId) async {
    await (_db.update(_db.cycles)..where((t) => t.id.equals(cycleId))).write(
      CyclesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> reopenCycle(String cycleId) async {
    await (_db.update(_db.cycles)..where((t) => t.id.equals(cycleId))).write(
      const CyclesCompanion(
        endDate: Value(null),
        cycleLength: Value(null),
      ),
    );
  }

  Future<Cycle?> getPreviousCompletedCycle() async {
    return (_db.select(_db.cycles)
          ..where((t) => t.isDeleted.equals(false) & t.endDate.isNotNull())
          ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Finds the cycle that covers [date], if any.
  Future<Cycle?> getCycleForDate(DateTime date) async {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final allCycles = await getAllCycles();
    for (final cycle in allCycles) {
      final start = DateTime(cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
      if (cycle.endDate != null) {
        final end = DateTime(cycle.endDate!.year, cycle.endDate!.month, cycle.endDate!.day);
        if (!cleanDate.isBefore(start) && !cleanDate.isAfter(end)) {
          return cycle;
        }
      } else {
        if (!cleanDate.isBefore(start)) {
          return cycle;
        }
      }
    }
    return null;
  }

  /// Intelligently resolves or creates the cycle for a period flow log on [date].
  /// Handles:
  /// - Logging within an ongoing cycle (Day 1..14)
  /// - Logging a new cycle that started in the future (>= 15 days after ongoing start)
  /// - Logging an early start (1-4 days before an existing cycle)
  /// - Logging past cycles (e.g. Aug 17 when ongoing is Sep 12)
  Future<String> getOrCreateCycleForPeriodDate(
    DateTime date, {
    int? avgCycleLength,
    int? avgPeriodLength,
    String? userId,
  }) async {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final allCycles = await getAllCycles(); // sorted by startDate DESC
    final defaultUserId = userId ?? 'default_user';
    final defaultCycleLen = avgCycleLength ?? 29;
    final defaultPeriodLen = avgPeriodLength ?? 5;

    // 1. If there are NO cycles at all:
    if (allCycles.isEmpty) {
      final newId = '${cleanDate.millisecondsSinceEpoch}_cycle';
      await insertCycle(
        CyclesCompanion.insert(
          id: newId,
          userId: defaultUserId,
          startDate: cleanDate,
          cycleLength: Value(defaultCycleLen),
          periodLength: Value(defaultPeriodLen),
        ),
      );
      return newId;
    }

    // 2. Check if cleanDate falls within any existing cycle
    for (final cycle in allCycles) {
      final start = DateTime(cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
      if (cycle.endDate != null) {
        final end = DateTime(cycle.endDate!.year, cycle.endDate!.month, cycle.endDate!.day);
        if (!cleanDate.isBefore(start) && !cleanDate.isAfter(end)) {
          return cycle.id;
        }
      } else {
        // Ongoing cycle
        if (!cleanDate.isBefore(start)) {
          final diff = cleanDate.difference(start).inDays;
          if (diff >= 15) {
            // New cycle starting! Complete the previous ongoing cycle
            await completeCycle(
              cycle.id,
              cleanDate.subtract(const Duration(days: 1)),
              diff,
              cycle.periodLength ?? defaultPeriodLen,
            );
            final newId = '${cleanDate.millisecondsSinceEpoch}_cycle';
            await insertCycle(
              CyclesCompanion.insert(
                id: newId,
                userId: defaultUserId,
                startDate: cleanDate,
                cycleLength: Value(defaultCycleLen),
                periodLength: Value(defaultPeriodLen),
              ),
            );
            return newId;
          } else {
            // Within current cycle
            return cycle.id;
          }
        }
      }
    }

    // 3. Check if cleanDate is slightly before an existing cycle's startDate (1 to 4 days before)
    // E.g. period started earlier than anticipated
    for (final cycle in allCycles) {
      final start = DateTime(cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
      final daysBefore = start.difference(cleanDate).inDays;
      if (daysBefore >= 1 && daysBefore <= 4) {
        await updateCycleStartDate(cycle.id, cleanDate);
        return cycle.id;
      }
    }

    // 4. cleanDate is in the past before a cycle by >= 5 days
    // Find the next cycle in chronological order that starts after cleanDate
    final cyclesAfter = allCycles.where((c) => c.startDate.isAfter(cleanDate)).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    if (cyclesAfter.isNotEmpty) {
      final nextCycle = cyclesAfter.first;
      final nextStart = DateTime(nextCycle.startDate.year, nextCycle.startDate.month, nextCycle.startDate.day);
      final daysDiff = nextStart.difference(cleanDate).inDays;

      if (daysDiff >= 15) {
        // Past completed cycle!
        final cycleEnd = nextStart.subtract(const Duration(days: 1));
        final newId = '${cleanDate.millisecondsSinceEpoch}_cycle';
        await insertCycle(
          CyclesCompanion.insert(
            id: newId,
            userId: defaultUserId,
            startDate: cleanDate,
            endDate: Value(cycleEnd),
            cycleLength: Value(daysDiff),
            periodLength: Value(defaultPeriodLen),
          ),
        );
        return newId;
      } else {
        // Between 5 and 14 days before nextCycle: adjust nextCycle start date
        await updateCycleStartDate(nextCycle.id, cleanDate);
        return nextCycle.id;
      }
    }

    // 5. Fallback: create a new cycle
    final newId = '${cleanDate.millisecondsSinceEpoch}_cycle';
    await insertCycle(
      CyclesCompanion.insert(
        id: newId,
        userId: defaultUserId,
        startDate: cleanDate,
        cycleLength: Value(defaultCycleLen),
        periodLength: Value(defaultPeriodLen),
      ),
    );
    return newId;
  }
}
