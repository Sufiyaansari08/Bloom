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
    if (sleepStr == null) return null;
    final match = RegExp(r'(\d+)h(?:\s*(\d+)m)?').firstMatch(sleepStr);
    if (match != null) {
      final hours = double.tryParse(match.group(1) ?? '0') ?? 0;
      final mins = double.tryParse(match.group(2) ?? '0') ?? 0;
      return hours + (mins / 60.0);
    }
    return double.tryParse(sleepStr);
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
        cycleId: Value(currentCycle?.id),
        date: Value(cleanDate),
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
