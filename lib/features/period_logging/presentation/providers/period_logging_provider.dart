import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeriodLoggingState {
  final String? flowLevel; // Spotting, Light, Medium, Heavy, Very heavy
  final int painLevel;
  final List<String> symptoms;

  PeriodLoggingState({
    this.flowLevel,
    this.painLevel = 5,
    this.symptoms = const [],
  });

  PeriodLoggingState copyWith({
    String? flowLevel,
    int? painLevel,
    List<String>? symptoms,
  }) {
    return PeriodLoggingState(
      flowLevel: flowLevel ?? this.flowLevel,
      painLevel: painLevel ?? this.painLevel,
      symptoms: symptoms ?? this.symptoms,
    );
  }
}

class PeriodLoggingNotifier extends StateNotifier<PeriodLoggingState> {
  PeriodLoggingNotifier() : super(PeriodLoggingState());

  void setFlowLevel(String flow) {
    state = state.copyWith(flowLevel: flow);
  }

  void setPainLevel(int pain) {
    state = state.copyWith(painLevel: pain);
  }

  void toggleSymptom(String symptom) {
    final updatedSymptoms = List<String>.from(state.symptoms);
    if (updatedSymptoms.contains(symptom)) {
      updatedSymptoms.remove(symptom);
    } else {
      updatedSymptoms.add(symptom);
    }
    state = state.copyWith(symptoms: updatedSymptoms);
  }

  void clear() {
    state = PeriodLoggingState();
  }
}

final periodLoggingProvider = StateNotifierProvider<PeriodLoggingNotifier, PeriodLoggingState>((ref) {
  return PeriodLoggingNotifier();
});
