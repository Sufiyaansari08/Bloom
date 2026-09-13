import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/services/notification_service.dart';
import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../profile/presentation/providers/privacy_security_provider.dart';

final notificationSyncProvider = Provider<void>((ref) {
  final remindersAsync = ref.watch(allRemindersStreamProvider);
  final calendarState = ref.watch(calendarProvider);
  final dailyLogsAsync = ref.watch(allDailyLogsStreamProvider);
  final secState = ref.watch(privacySecurityProvider);
  final isDiscrete = secState.isDiscreteNotificationsEnabled;

  final reminders = remindersAsync.value;
  if (reminders == null || reminders.isEmpty) return;

  final reminderMap = {for (final r in reminders) r.type: r};
  final logs = dailyLogsAsync.value ?? [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Check if period is ongoing
  final todayLog = logs.where((l) =>
    l.date.year == today.year &&
    l.date.month == today.month &&
    l.date.day == today.day
  ).firstOrNull;

  final hasFlowToday = todayLog?.flowIntensity != null && todayLog!.flowIntensity != 'None';
  final hasRecentFlow = logs.any((l) =>
    l.flowIntensity != null &&
    l.flowIntensity != 'None' &&
    today.difference(DateTime(l.date.year, l.date.month, l.date.day)).inDays >= 0 &&
    today.difference(DateTime(l.date.year, l.date.month, l.date.day)).inDays < 5
  );
  final isPeriodOngoing = hasFlowToday || hasRecentFlow;

  // 1. Sync Daily Check-in Notification
  final dailyReminder = reminderMap['daily_log'];
  if (dailyReminder != null) {
    if (!dailyReminder.isEnabled) {
      NotificationService.instance.cancel(NotificationService.idDailyCheckIn);
    } else {
      int hour = 21;
      int minute = 0;
      try {
        final parts = dailyReminder.timeOfDay.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      } catch (_) {}

      NotificationService.instance.scheduleDailyCheckIn(
        hour: hour,
        minute: minute,
        isEnabled: dailyReminder.isEnabled,
        isDiscrete: isDiscrete,
      );
    }
  }

  // 2. Sync Expected Period Alert
  final periodReminder = reminderMap['period_start'];
  if (periodReminder != null) {
    final nextPeriod = calendarState.nextPeriodStartDate;
    if (periodReminder.isEnabled && nextPeriod != null && !isPeriodOngoing) {
      NotificationService.instance.schedulePeriodAlert(
        periodDate: nextPeriod,
        daysBefore: periodReminder.daysBefore,
        isEnabled: periodReminder.isEnabled,
        isDiscrete: isDiscrete,
      );
    } else {
      NotificationService.instance.cancel(NotificationService.idPeriodAlert);
    }
  }

  // 3. Sync Fertile Window Alert
  final fertileReminder = reminderMap['fertile_window'];
  if (fertileReminder != null) {
    final upcomingFertile = calendarState.fertileDays.where((d) => !d.isBefore(today)).toList();
    final fertileStart = upcomingFertile.isNotEmpty ? upcomingFertile.first : null;

    if (fertileReminder.isEnabled && fertileStart != null && !isPeriodOngoing) {
      NotificationService.instance.scheduleFertileAlert(
        fertileStart: fertileStart,
        isEnabled: fertileReminder.isEnabled,
        isDiscrete: isDiscrete,
      );
    } else {
      NotificationService.instance.cancel(NotificationService.idFertileAlert);
    }
  }

  // 4. Sync Ovulation Alert
  final ovulationReminder = reminderMap['ovulation'];
  if (ovulationReminder != null) {
    final ovulationDay = calendarState.ovulationDay;
    if (ovulationReminder.isEnabled && ovulationDay != null && !isPeriodOngoing) {
      NotificationService.instance.scheduleOvulationAlert(
        ovulationDate: ovulationDay,
        isEnabled: ovulationReminder.isEnabled,
        isDiscrete: isDiscrete,
      );
    } else {
      NotificationService.instance.cancel(NotificationService.idOvulationAlert);
    }
  }
});
