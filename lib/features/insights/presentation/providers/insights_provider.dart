import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InsightTab { cycle, symptoms, mood }

class InsightsNotifier extends StateNotifier<InsightTab> {
  InsightsNotifier() : super(InsightTab.cycle);

  void setTab(InsightTab tab) {
    state = tab;
  }
}

final insightsProvider = StateNotifierProvider<InsightsNotifier, InsightTab>((ref) {
  return InsightsNotifier();
});
