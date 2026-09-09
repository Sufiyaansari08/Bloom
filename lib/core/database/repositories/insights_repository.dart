import 'package:drift/drift.dart';
import '../app_database.dart';

class InsightsRepository {
  final AppDatabase _db;

  InsightsRepository(this._db);

  Future<List<AiInsight>> getInsightsForCategory(String category) async {
    return (_db.select(_db.aiInsights)
          ..where((t) => t.isDeleted.equals(false) & t.category.equals(category))
          ..orderBy([(t) => OrderingTerm(expression: t.generatedDate, mode: OrderingMode.desc)]))
        .get();
  }

  Stream<List<AiInsight>> watchInsightsForCategory(String category) {
    return (_db.select(_db.aiInsights)
          ..where((t) => t.isDeleted.equals(false) & t.category.equals(category))
          ..orderBy([(t) => OrderingTerm(expression: t.generatedDate, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<AiInsight?> getLatestInsight(String category) async {
    return (_db.select(_db.aiInsights)
          ..where((t) => t.isDeleted.equals(false) & t.category.equals(category))
          ..orderBy([(t) => OrderingTerm(expression: t.generatedDate, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> saveInsight(AiInsightsCompanion insight) async {
    await _db.into(_db.aiInsights).insertOnConflictUpdate(insight);
  }
}
