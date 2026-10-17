import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final String? userName;
  final String? userEmail;
  final DateTime? dateOfBirth;
  final double? heightCm;
  final double? weightKg;
  final String? bloodGroup;
  final DateTime? lastPeriodDate;
  final String? periodDuration;
  final String? cycleDuration;
  final List<String> symptoms;
  final List<String> goals;

  OnboardingState({
    this.userName,
    this.userEmail,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.bloodGroup,
    this.lastPeriodDate,
    this.periodDuration,
    this.cycleDuration,
    this.symptoms = const [],
    this.goals = const [],
  });

  OnboardingState copyWith({
    String? userName,
    String? userEmail,
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? bloodGroup,
    DateTime? lastPeriodDate,
    String? periodDuration,
    String? cycleDuration,
    List<String>? symptoms,
    List<String>? goals,
  }) {
    return OnboardingState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bloodGroup: bloodGroup ?? this.bloodGroup,
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

  void setHealthDetails({
    DateTime? dateOfBirth,
    double? heightCm,
    double? weightKg,
    String? bloodGroup,
  }) {
    state = state.copyWith(
      dateOfBirth: dateOfBirth,
      heightCm: heightCm,
      weightKg: weightKg,
      bloodGroup: bloodGroup,
    );
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
