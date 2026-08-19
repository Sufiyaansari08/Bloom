import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final String userName;
  final int cycleDay;
  final int daysUntilPeriod;
  final String periodDateRange;
  final String fertileWindowRange;
  final int symptomsLogged;
  final int painLevel;
  final String mood;

  HomeState({
    this.userName = 'Username',
    this.cycleDay = 24,
    this.daysUntilPeriod = 4,
    this.periodDateRange = 'May 28 - Jun 1',
    this.fertileWindowRange = 'Jun 10 - Jun 16',
    this.symptomsLogged = 3,
    this.painLevel = 5,
    this.mood = 'Okay',
  });
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState());
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
