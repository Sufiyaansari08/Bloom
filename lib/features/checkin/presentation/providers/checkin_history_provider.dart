import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'daily_checkin_provider.dart';

class CheckinHistoryNotifier extends StateNotifier<Map<DateTime, DailyCheckinState>> {
  CheckinHistoryNotifier() : super({});

  void saveCheckin(DateTime date, DailyCheckinState data) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    state = {
      ...state,
      normalizedDate: data,
    };
  }
}

final checkinHistoryProvider = StateNotifierProvider<CheckinHistoryNotifier, Map<DateTime, DailyCheckinState>>((ref) {
  return CheckinHistoryNotifier();
});
