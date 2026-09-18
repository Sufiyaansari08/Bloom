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
      NotificationService.instance.cancel(NotificationService.idPeriodTodayAlert);
    }
  }

  // 3. Sync Fertile Window Alert
  final fertileReminder = reminderMap['fertile_window'];
  if (fertileReminder != null) {
    final fertileStart = _findFertileStart(calendarState.fertileDays, today);

    if (fertileReminder.isEnabled && fertileStart != null && !isPeriodOngoing) {
      NotificationService.instance.scheduleFertileAlert(
        fertileStart: fertileStart,
        isEnabled: fertileReminder.isEnabled,
        isDiscrete: isDiscrete,
      );
    } else {
      NotificationService.instance.cancel(NotificationService.idFertileAlert);
      NotificationService.instance.cancel(NotificationService.idFertileTodayAlert);
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
      NotificationService.instance.cancel(NotificationService.idOvulationEveAlert);
    }
  }

  // 5. Sync Monthly Cycle Summary & Completed Cycle Notifications
  final cycleSummaryReminder = reminderMap['cycle_summary'];
  if (cycleSummaryReminder != null && cycleSummaryReminder.isEnabled) {
    final cyclesAsync = ref.watch(allCyclesStreamProvider);
    final cycles = cyclesAsync.value ?? [];
    final completedCycles = cycles
        .where((c) => !c.isDeleted && c.endDate != null)
        .toList();
    completedCycles.sort((a, b) => b.endDate!.compareTo(a.endDate!));

    if (completedCycles.isNotEmpty) {
      final newest = completedCycles.first;
      // If cycle completed recently (within 48 hours) and not yet notified
      final isRecentlyCompleted =
          DateTime.now().difference(newest.updatedAt).inHours < 48;

      if (isRecentlyCompleted &&
          !NotificationService.hasNotifiedCycle(newest.id)) {
        NotificationService.markCycleNotified(newest.id);
        NotificationService.instance.showCycleSummaryNotification(
          isDiscrete: isDiscrete,
        );
      }
    }

    int hour = 10;
    int minute = 0;
    try {
      final parts = cycleSummaryReminder.timeOfDay.split(':');
      hour = int.parse(parts[0]);
      minute = int.parse(parts[1]);
    } catch (_) {}

    NotificationService.instance.scheduleMonthlyCycleSummary(
      hour: hour,
      minute: minute,
      isEnabled: cycleSummaryReminder.isEnabled,
      isDiscrete: isDiscrete,
    );
  } else {
    NotificationService.instance.cancel(NotificationService.idCycleSummary);
  }
});

DateTime? _findFertileStart(List<DateTime> fertileDays, DateTime today) {
  if (fertileDays.isEmpty) return null;

  final starts = <DateTime>[];
  for (final day in fertileDays) {
    final prevDay =
        DateTime(day.year, day.month, day.day).subtract(const Duration(days: 1));
    final hasPrev = fertileDays.any((d) =>
        d.year == prevDay.year &&
        d.month == prevDay.month &&
        d.day == prevDay.day);
    if (!hasPrev) {
      starts.add(DateTime(day.year, day.month, day.day));
    }
  }

  for (final start in starts) {
    final eve = start.subtract(const Duration(days: 1));
    final isEveToday =
        today.year == eve.year && today.month == eve.month && today.day == eve.day;
    if (!today.isAfter(start) || isEveToday) {
      return start;
    }
  }

  return starts.isNotEmpty ? starts.first : null;
}
