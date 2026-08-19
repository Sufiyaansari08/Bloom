import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  DailyCheckinNotifier() : super(DailyCheckinState());

  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  void toggleSymptom(String symptom) {
    final updatedSymptoms = List<String>.from(state.symptoms);
    if (updatedSymptoms.contains(symptom)) {
      updatedSymptoms.remove(symptom);
      // Remove rating if symptom is removed
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
  
  void clear() {
    state = DailyCheckinState();
  }
}

final dailyCheckinProvider = StateNotifierProvider<DailyCheckinNotifier, DailyCheckinState>((ref) {
  return DailyCheckinNotifier();
});
