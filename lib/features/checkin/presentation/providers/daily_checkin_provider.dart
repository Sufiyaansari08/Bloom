import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';

class DailyCheckinState {
  final String? mood; // Great, Good, Okay, Not great, Bad
  final List<String> symptoms;
  final Map<String, int> symptomRatings;
  final String? sleep;
  final String? waterIntake;
  final String? activity;
  final int stressLevel;
  final List<String> remedies;
  final int painAfter1Hour;
  final String notes;

  DailyCheckinState({
    this.mood,
    this.symptoms = const [],
    this.symptomRatings = const {},
    this.sleep,
    this.waterIntake,
    this.activity,
    this.stressLevel = 5,
    this.remedies = const [],
    this.painAfter1Hour = 5,
    this.notes = '',
  });

  DailyCheckinState copyWith({
    String? mood,
    List<String>? symptoms,
    Map<String, int>? symptomRatings,
    String? sleep,
    String? waterIntake,
    String? activity,
    int? stressLevel,
    List<String>? remedies,
    int? painAfter1Hour,
    String? notes,
  }) {
    return DailyCheckinState(
      mood: mood ?? this.mood,
      symptoms: symptoms ?? this.symptoms,
      symptomRatings: symptomRatings ?? this.symptomRatings,
      sleep: sleep ?? this.sleep,
      waterIntake: waterIntake ?? this.waterIntake,
      activity: activity ?? this.activity,
      stressLevel: stressLevel ?? this.stressLevel,
      remedies: remedies ?? this.remedies,
      painAfter1Hour: painAfter1Hour ?? this.painAfter1Hour,
      notes: notes ?? this.notes,
    );
  }
}

class DailyCheckinNotifier extends StateNotifier<DailyCheckinState> {
  final Ref _ref;
  static const _uuid = Uuid();

  DailyCheckinNotifier(this._ref) : super(DailyCheckinState());

  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  void toggleSymptom(String symptom) {
    final updatedSymptoms = List<String>.from(state.symptoms);
    if (updatedSymptoms.contains(symptom)) {
      updatedSymptoms.remove(symptom);
      final updatedRatings = Map<String, int>.from(state.symptomRatings);
      updatedRatings.remove(symptom);
      state = state.copyWith(symptoms: updatedSymptoms, symptomRatings: updatedRatings);
    } else {
      updatedSymptoms.add(symptom);
      state = state.copyWith(symptoms: updatedSymptoms);
    }
  }

  void setSymptomRating(String symptom, int rating) {
    final updatedRatings = Map<String, int>.from(state.symptomRatings);
    updatedRatings[symptom] = rating;
    state = state.copyWith(symptomRatings: updatedRatings);
  }

  void setLifestyle({String? sleep, String? waterIntake, String? activity, int? stressLevel}) {
    state = state.copyWith(
      sleep: sleep ?? state.sleep,
      waterIntake: waterIntake ?? state.waterIntake,
      activity: activity ?? state.activity,
      stressLevel: stressLevel ?? state.stressLevel,
    );
  }

  void toggleRemedy(String remedy) {
    final updatedRemedies = List<String>.from(state.remedies);
    if (updatedRemedies.contains(remedy)) {
      updatedRemedies.remove(remedy);
    } else {
      updatedRemedies.add(remedy);
    }
    state = state.copyWith(remedies: updatedRemedies);
  }

  void setPainAfter1Hour(int pain) {
    state = state.copyWith(painAfter1Hour: pain);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  double? _parseSleep(String? sleepStr) {
    if (sleepStr == null || sleepStr.isEmpty || sleepStr == 'Select') return null;

    // Check for range like "5 - 6 h" or "7 - 8 h"
    final rangeMatch = RegExp(r'(\d+(?:\.\d+)?)\s*-\s*(\d+(?:\.\d+)?)\s*h?').firstMatch(sleepStr);
    if (rangeMatch != null) {
      final low = double.tryParse(rangeMatch.group(1)!) ?? 0;
      final high = double.tryParse(rangeMatch.group(2)!) ?? 0;
      return (low + high) / 2.0; // e.g. 5 - 6 h -> 5.5, 7 - 8 h -> 7.5
    }

    // Check for "< 5 h" or "<5h"
    final lessMatch = RegExp(r'<\s*(\d+(?:\.\d+)?)\s*h?').firstMatch(sleepStr);
    if (lessMatch != null) {
      final val = double.tryParse(lessMatch.group(1)!) ?? 5;
      return val - 0.5; // e.g. < 5 h -> 4.5
    }

    // Check for "> 8 h" or ">8h"
    final greaterMatch = RegExp(r'>\s*(\d+(?:\.\d+)?)\s*h?').firstMatch(sleepStr);
    if (greaterMatch != null) {
      final val = double.tryParse(greaterMatch.group(1)!) ?? 8;
      return val + 0.5; // e.g. > 8 h -> 8.5
    }

    // Check for "6 h 30 m", "8 h 00 m", "6h 30m"
    final hmMatch = RegExp(r'(\d+)\s*h(?:\s*(\d+)\s*m)?').firstMatch(sleepStr);
    if (hmMatch != null) {
      final hours = double.tryParse(hmMatch.group(1) ?? '0') ?? 0;
      final mins = double.tryParse(hmMatch.group(2) ?? '0') ?? 0;
      return hours + (mins / 60.0); // e.g. 6 h 30 m -> 6.5, 8 h 00 m -> 8.0
    }

    // Direct double fallback
    return double.tryParse(sleepStr.replaceAll(RegExp(r'[^\d.]'), ''));
  }

  Future<void> saveToDatabase(DateTime date) async {
    final logRepo = _ref.read(dailyLogRepositoryProvider);
    final symptomRepo = _ref.read(symptomRepositoryProvider);
    final userRepo = _ref.read(userRepositoryProvider);
    final cycleRepo = _ref.read(cycleRepositoryProvider);

    final user = await userRepo.getUserProfile();
    final userId = user?.id ?? _uuid.v4();
    final currentCycle = await cycleRepo.getCurrentCycle();

    final cleanDate = DateTime(date.year, date.month, date.day);
    final existingLog = await logRepo.getLogForDate(cleanDate);
    final logId = existingLog?.id ?? _uuid.v4();
    final sleepHours = _parseSleep(state.sleep);

    await logRepo.upsertDailyLog(
      DailyLogsCompanion(
        id: Value(logId),
        userId: Value(userId),
        cycleId: Value(currentCycle?.id ?? existingLog?.cycleId),
        date: Value(cleanDate),
        flowIntensity: existingLog?.flowIntensity != null ? Value(existingLog!.flowIntensity) : const Value.absent(),
        painLevel: existingLog?.painLevel != null ? Value(existingLog!.painLevel) : const Value.absent(),
        mood: Value(state.mood),
        sleepHours: Value(sleepHours),
        waterIntake: Value(state.waterIntake),
        stressLevel: Value(state.stressLevel),
        activityLevel: Value(state.activity),
        remedies: Value(state.remedies.isEmpty ? null : state.remedies.join(', ')),
        painAfter1Hr: Value(state.painAfter1Hour),
        notes: Value(state.notes.isEmpty ? null : state.notes),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Save individual symptoms
    final symptomCompanions = state.symptoms.map((symptom) {
      final rating = state.symptomRatings[symptom] ?? 5;
      return DailySymptomsCompanion.insert(
        id: _uuid.v4(),
        dailyLogId: logId,
        symptomName: symptom,
        severity: Value(rating),
      );
    }).toList();

    await symptomRepo.setSymptomsForLog(logId, symptomCompanions);
  }

  void clear() {
    state = DailyCheckinState();
  }
}

final dailyCheckinProvider = StateNotifierProvider<DailyCheckinNotifier, DailyCheckinState>((ref) {
  return DailyCheckinNotifier(ref);
});
