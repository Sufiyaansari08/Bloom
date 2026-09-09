import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final String? userName;
  final String? userEmail;
  final DateTime? lastPeriodDate;
  final String? periodDuration;
  final String? cycleDuration;
  final List<String> symptoms;
  final List<String> goals;

  OnboardingState({
    this.userName,
    this.userEmail,
    this.lastPeriodDate,
    this.periodDuration,
    this.cycleDuration,
    this.symptoms = const [],
    this.goals = const [],
  });

  OnboardingState copyWith({
    String? userName,
    String? userEmail,
    DateTime? lastPeriodDate,
    String? periodDuration,
    String? cycleDuration,
    List<String>? symptoms,
    List<String>? goals,
  }) {
    return OnboardingState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      periodDuration: periodDuration ?? this.periodDuration,
      cycleDuration: cycleDuration ?? this.cycleDuration,
      symptoms: symptoms ?? this.symptoms,
      goals: goals ?? this.goals,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  void setUserName(String name) {
    state = state.copyWith(userName: name);
  }

  void setUserEmail(String email) {
    state = state.copyWith(userEmail: email);
  }

  void setLastPeriodDate(DateTime date) {
    state = state.copyWith(lastPeriodDate: date);
  }

  void setPeriodDuration(String duration) {
    state = state.copyWith(periodDuration: duration);
  }

  void setCycleDuration(String duration) {
    state = state.copyWith(cycleDuration: duration);
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

  void toggleGoal(String goal) {
    final updatedGoals = List<String>.from(state.goals);
    if (updatedGoals.contains(goal)) {
      updatedGoals.remove(goal);
    } else {
      updatedGoals.add(goal);
    }
    state = state.copyWith(goals: updatedGoals);
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
