import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../services/secure_token_storage.dart';

class SyncResult {
  final bool isSuccess;
  final String message;
  final DateTime? serverSyncTime;

  const SyncResult({
    required this.isSuccess,
    required this.message,
    this.serverSyncTime,
  });
}

class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  final Dio _dio = ApiClient.instance.dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _lastSyncKey = 'bloom_last_sync_time';

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<String?> getLastSyncTime() async {
    return await _storage.read(key: _lastSyncKey);
  }

  Future<void> setLastSyncTime(String isoTime) async {
    await _storage.write(key: _lastSyncKey, value: isoTime);
  }

  /// Master sync: Pushes offline edits to cloud and pulls remote cloud changes.
  Future<SyncResult> syncAll(AppDatabase db) async {
    if (_isSyncing) {
      return const SyncResult(isSuccess: false, message: 'Sync already in progress');
    }

    final hasSession = await SecureTokenStorage.instance.hasValidSession();
    if (!hasSession) {
      return const SyncResult(isSuccess: false, message: 'User is not logged in');
    }

    _isSyncing = true;
    try {
      // Step 1: Push dirty local records
      await pushDirtyRecords(db);

      // Step 2: Pull remote deltas
      final pullResult = await pullChanges(db);

      return pullResult;
    } catch (e) {
      debugPrint('SyncService.syncAll error: $e');
      return SyncResult(isSuccess: false, message: e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Pushes records modified or created while offline (where isSynced == false).
  Future<void> pushDirtyRecords(AppDatabase db) async {
    final unsyncedCycles = await (db.select(db.cycles)..where((t) => t.isSynced.equals(false))).get();
    final unsyncedLogs = await (db.select(db.dailyLogs)..where((t) => t.isSynced.equals(false))).get();
    final unsyncedSymptoms = await (db.select(db.dailySymptoms)..where((t) => t.isSynced.equals(false))).get();
    final unsyncedReminders = await (db.select(db.reminders)..where((t) => t.isSynced.equals(false))).get();
    final unsyncedInsights = await (db.select(db.aiInsights)..where((t) => t.isSynced.equals(false))).get();
    final unsyncedProfile = await (db.select(db.userProfiles)..where((t) => t.isSynced.equals(false))..limit(1)).getSingleOrNull();

    final hasDirtyRecords = unsyncedCycles.isNotEmpty ||
        unsyncedLogs.isNotEmpty ||
        unsyncedSymptoms.isNotEmpty ||
        unsyncedReminders.isNotEmpty ||
        unsyncedInsights.isNotEmpty ||
        unsyncedProfile != null;

    if (!hasDirtyRecords) {
      debugPrint('SyncService: No dirty records to push');
      return;
    }

    final clientSyncTime = DateTime.now().toUtc().toIso8601String();

    final payload = {
      'client_sync_time': clientSyncTime,
      'data': {
        if (unsyncedProfile != null)
          'user_profile': {
            'id': unsyncedProfile.id,
            'name': unsyncedProfile.name,
            if (unsyncedProfile.email != null) 'email': unsyncedProfile.email,
            if (unsyncedProfile.phone != null) 'phone': unsyncedProfile.phone,
            if (unsyncedProfile.avatarPath != null) 'avatar_path': unsyncedProfile.avatarPath,
            if (unsyncedProfile.dateOfBirth != null)
              'date_of_birth': unsyncedProfile.dateOfBirth!.toIso8601String().split('T').first,
            if (unsyncedProfile.heightCm != null) 'height_cm': unsyncedProfile.heightCm,
            if (unsyncedProfile.weightKg != null) 'weight_kg': unsyncedProfile.weightKg,
            if (unsyncedProfile.bloodGroup != null) 'blood_group': unsyncedProfile.bloodGroup,
            'avg_cycle_length': unsyncedProfile.avgCycleLength,
            'avg_period_length': unsyncedProfile.avgPeriodLength,
            'period_prediction_enabled': unsyncedProfile.periodPredictionEnabled,
            'ovulation_prediction_enabled': unsyncedProfile.ovulationPredictionEnabled,
            'fertile_window_enabled': unsyncedProfile.fertileWindowEnabled,
            'updated_at': unsyncedProfile.updatedAt.toUtc().toIso8601String(),
            'is_deleted': unsyncedProfile.isDeleted,
          },
        'cycles': unsyncedCycles.map((c) => {
          'id': c.id,
          'start_date': c.startDate.toIso8601String().split('T').first,
          if (c.endDate != null) 'end_date': c.endDate!.toIso8601String().split('T').first,
          if (c.cycleLength != null) 'cycle_length': c.cycleLength,
          if (c.periodLength != null) 'period_length': c.periodLength,
          'is_predicted': c.isPredicted,
          'created_at': c.createdAt.toUtc().toIso8601String(),
          'updated_at': c.updatedAt.toUtc().toIso8601String(),
          'is_deleted': c.isDeleted,
        }).toList(),
        'daily_logs': unsyncedLogs.map((l) => {
          'id': l.id,
          if (l.cycleId != null) 'cycle_id': l.cycleId,
          'date': l.date.toIso8601String().split('T').first,
          if (l.flowIntensity != null) 'flow_intensity': l.flowIntensity,
          if (l.painLevel != null) 'pain_level': l.painLevel,
          if (l.mood != null) 'mood': l.mood,
          if (l.sleepHours != null) 'sleep_hours': l.sleepHours,
          if (l.waterIntake != null) 'water_intake': l.waterIntake,
          if (l.stressLevel != null) 'stress_level': l.stressLevel,
          if (l.activityLevel != null) 'activity_level': l.activityLevel,
          if (l.remedies != null) 'remedies': l.remedies,
          if (l.painAfter1Hr != null) 'pain_after_1hr': l.painAfter1Hr,
          if (l.notes != null) 'notes': l.notes,
          'created_at': l.createdAt.toUtc().toIso8601String(),
          'updated_at': l.updatedAt.toUtc().toIso8601String(),
          'is_deleted': l.isDeleted,
        }).toList(),
        'daily_symptoms': unsyncedSymptoms.map((s) => {
          'id': s.id,
          'daily_log_id': s.dailyLogId,
          'symptom_name': s.symptomName,
          if (s.severity != null) 'severity': s.severity,
          'created_at': s.createdAt.toUtc().toIso8601String(),
          'updated_at': s.updatedAt.toUtc().toIso8601String(),
          'is_deleted': s.isDeleted,
        }).toList(),
        'reminders': unsyncedReminders.map((r) => {
          'id': r.id,
          'type': r.type,
          'time_of_day': r.timeOfDay,
          'days_before': r.daysBefore,
          'is_enabled': r.isEnabled,
          'created_at': r.createdAt.toUtc().toIso8601String(),
          'updated_at': r.updatedAt.toUtc().toIso8601String(),
          'is_deleted': r.isDeleted,
        }).toList(),
        'ai_insights': unsyncedInsights.map((i) => {
          'id': i.id,
          'category': i.category,
          if (i.cyclePhase != null) 'cycle_phase': i.cyclePhase,
          if (i.headline != null) 'headline': i.headline,
          'insight_text': i.insightText,
          'generated_date': i.generatedDate.toIso8601String().split('T').first,
          'created_at': i.createdAt.toUtc().toIso8601String(),
          'updated_at': i.updatedAt.toUtc().toIso8601String(),
          'is_deleted': i.isDeleted,
        }).toList(),
      },
    };

    final response = await _dio.post(ApiConstants.syncPush, data: payload);

    if (response.statusCode == 200 && response.data != null) {
      final processed = response.data['processed'] as Map<String, dynamic>?;

      // Mark confirmed IDs as synced
      if (processed != null) {
        if (unsyncedProfile != null && processed['user_profile'] == true) {
          await (db.update(db.userProfiles)..where((t) => t.id.equals(unsyncedProfile.id)))
              .write(const UserProfilesCompanion(isSynced: Value(true)));
        }

        final confirmedCycles = List<String>.from(processed['cycles'] ?? []);
        if (confirmedCycles.isNotEmpty) {
          await (db.update(db.cycles)..where((t) => t.id.isIn(confirmedCycles)))
              .write(const CyclesCompanion(isSynced: Value(true)));
        }

        final confirmedLogs = List<String>.from(processed['daily_logs'] ?? []);
        if (confirmedLogs.isNotEmpty) {
          await (db.update(db.dailyLogs)..where((t) => t.id.isIn(confirmedLogs)))
              .write(const DailyLogsCompanion(isSynced: Value(true)));
        }

        final confirmedSymptoms = List<String>.from(processed['daily_symptoms'] ?? []);
        if (confirmedSymptoms.isNotEmpty) {
          await (db.update(db.dailySymptoms)..where((t) => t.id.isIn(confirmedSymptoms)))
              .write(const DailySymptomsCompanion(isSynced: Value(true)));
        }

        final confirmedReminders = List<String>.from(processed['reminders'] ?? []);
        if (confirmedReminders.isNotEmpty) {
          await (db.update(db.reminders)..where((t) => t.id.isIn(confirmedReminders)))
              .write(const RemindersCompanion(isSynced: Value(true)));
        }

        final confirmedInsights = List<String>.from(processed['ai_insights'] ?? []);
        if (confirmedInsights.isNotEmpty) {
          await (db.update(db.aiInsights)..where((t) => t.id.isIn(confirmedInsights)))
              .write(const AiInsightsCompanion(isSynced: Value(true)));
        }
      }
    }
  }

  /// Pulls delta changes from backend cloud database since last sync timestamp.
  Future<SyncResult> pullChanges(AppDatabase db) async {
    final lastSync = await getLastSyncTime();
    final queryParams = lastSync != null ? {'since': lastSync} : <String, dynamic>{};

    final response = await _dio.get(ApiConstants.syncPull, queryParameters: queryParams);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final changes = data['changes'] as Map<String, dynamic>? ?? {};
      final serverSyncTimeStr = data['server_sync_time']?.toString();

      // Upsert Cycles
      final rawCycles = changes['cycles'] as List<dynamic>? ?? [];
      for (final raw in rawCycles) {
        if (raw is Map<String, dynamic>) {
          await db.into(db.cycles).insertOnConflictUpdate(
            CyclesCompanion(
              id: Value(raw['id'].toString()),
              userId: Value(raw['user_id']?.toString() ?? ''),
              startDate: Value(DateTime.parse(raw['start_date'].toString())),
              endDate: Value(raw['end_date'] != null ? DateTime.parse(raw['end_date'].toString()) : null),
              cycleLength: Value(raw['cycle_length'] as int?),
              periodLength: Value(raw['period_length'] as int?),
              isPredicted: Value(raw['is_predicted'] == true),
              createdAt: Value(raw['created_at'] != null ? DateTime.parse(raw['created_at'].toString()) : DateTime.now()),
              updatedAt: Value(raw['updated_at'] != null ? DateTime.parse(raw['updated_at'].toString()) : DateTime.now()),
              isSynced: const Value(true),
              isDeleted: Value(raw['is_deleted'] == true),
            ),
          );
        }
      }

      // Upsert Daily Logs
      final rawLogs = changes['daily_logs'] as List<dynamic>? ?? [];
      for (final raw in rawLogs) {
        if (raw is Map<String, dynamic>) {
          await db.into(db.dailyLogs).insertOnConflictUpdate(
            DailyLogsCompanion(
              id: Value(raw['id'].toString()),
              userId: Value(raw['user_id']?.toString() ?? ''),
              cycleId: Value(raw['cycle_id']?.toString()),
              date: Value(DateTime.parse(raw['date'].toString())),
              flowIntensity: Value(raw['flow_intensity']?.toString()),
              painLevel: Value(raw['pain_level'] as int?),
              mood: Value(raw['mood']?.toString()),
              sleepHours: Value((raw['sleep_hours'] as num?)?.toDouble()),
              waterIntake: Value(raw['water_intake']?.toString()),
              stressLevel: Value(raw['stress_level'] as int?),
              activityLevel: Value(raw['activity_level']?.toString()),
              remedies: Value(raw['remedies']?.toString()),
              painAfter1Hr: Value(raw['pain_after_1hr'] as int?),
              notes: Value(raw['notes']?.toString()),
              createdAt: Value(raw['created_at'] != null ? DateTime.parse(raw['created_at'].toString()) : DateTime.now()),
              updatedAt: Value(raw['updated_at'] != null ? DateTime.parse(raw['updated_at'].toString()) : DateTime.now()),
              isSynced: const Value(true),
              isDeleted: Value(raw['is_deleted'] == true),
            ),
          );
        }
      }

      // Upsert Daily Symptoms
      final rawSymptoms = changes['daily_symptoms'] as List<dynamic>? ?? [];
      for (final raw in rawSymptoms) {
        if (raw is Map<String, dynamic>) {
          await db.into(db.dailySymptoms).insertOnConflictUpdate(
            DailySymptomsCompanion(
              id: Value(raw['id'].toString()),
              dailyLogId: Value(raw['daily_log_id'].toString()),
              symptomName: Value(raw['symptom_name'].toString()),
              severity: Value(raw['severity'] as int?),
              createdAt: Value(raw['created_at'] != null ? DateTime.parse(raw['created_at'].toString()) : DateTime.now()),
              updatedAt: Value(raw['updated_at'] != null ? DateTime.parse(raw['updated_at'].toString()) : DateTime.now()),
              isSynced: const Value(true),
              isDeleted: Value(raw['is_deleted'] == true),
            ),
          );
        }
      }

      // Upsert Reminders
      final rawReminders = changes['reminders'] as List<dynamic>? ?? [];
      for (final raw in rawReminders) {
        if (raw is Map<String, dynamic>) {
          await db.into(db.reminders).insertOnConflictUpdate(
            RemindersCompanion(
              id: Value(raw['id'].toString()),
              userId: Value(raw['user_id']?.toString() ?? ''),
              type: Value(raw['type'].toString()),
              timeOfDay: Value(raw['time_of_day'].toString()),
              daysBefore: Value((raw['days_before'] as int?) ?? 1),
              isEnabled: Value(raw['is_enabled'] != false),
              createdAt: Value(raw['created_at'] != null ? DateTime.parse(raw['created_at'].toString()) : DateTime.now()),
              updatedAt: Value(raw['updated_at'] != null ? DateTime.parse(raw['updated_at'].toString()) : DateTime.now()),
              isSynced: const Value(true),
              isDeleted: Value(raw['is_deleted'] == true),
            ),
          );
        }
      }

      // Upsert AI Insights
      final rawInsights = changes['ai_insights'] as List<dynamic>? ?? [];
      for (final raw in rawInsights) {
        if (raw is Map<String, dynamic>) {
          await db.into(db.aiInsights).insertOnConflictUpdate(
            AiInsightsCompanion(
              id: Value(raw['id'].toString()),
              userId: Value(raw['user_id']?.toString() ?? ''),
              category: Value(raw['category'].toString()),
              cyclePhase: Value(raw['cycle_phase']?.toString()),
              headline: Value(raw['headline']?.toString()),
              insightText: Value(raw['insight_text'].toString()),
              generatedDate: Value(DateTime.parse(raw['generated_date'].toString())),
              createdAt: Value(raw['created_at'] != null ? DateTime.parse(raw['created_at'].toString()) : DateTime.now()),
              updatedAt: Value(raw['updated_at'] != null ? DateTime.parse(raw['updated_at'].toString()) : DateTime.now()),
              isSynced: const Value(true),
              isDeleted: Value(raw['is_deleted'] == true),
            ),
          );
        }
      }

      // Update sync watermark
      if (serverSyncTimeStr != null) {
        await setLastSyncTime(serverSyncTimeStr);
      }

      return SyncResult(
        isSuccess: true,
        message: 'Sync completed successfully',
        serverSyncTime: serverSyncTimeStr != null ? DateTime.tryParse(serverSyncTimeStr) : null,
      );
    }

    return const SyncResult(isSuccess: false, message: 'Invalid pull response from server');
  }

  /// Wipes all tracking data remotely and clears local records while preserving account.
  Future<bool> wipeTrackingData(AppDatabase db) async {
    try {
      final response = await _dio.post(ApiConstants.wipeTrackingData);
      if (response.statusCode == 200) {
        // Clear local tracking data
        await db.delete(db.cycles).go();
        await db.delete(db.dailyLogs).go();
        await db.delete(db.dailySymptoms).go();
        await db.delete(db.aiInsights).go();
        await _storage.delete(key: _lastSyncKey);
        return true;
      }
    } catch (e) {
      debugPrint('SyncService.wipeTrackingData error: $e');
    }
    return false;
  }

  /// Exports complete GDPR JSON archive from the server.
  Future<Map<String, dynamic>?> exportUserData() async {
    try {
      final response = await _dio.get(ApiConstants.userExport);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('SyncService.exportUserData error: $e');
    }
    return null;
  }
}
