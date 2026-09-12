import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../calendar/presentation/providers/calendar_provider.dart';

final dismissedRemindersProvider =
    StateProvider<Set<String>>((ref) => <String>{});

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dismissedIds = ref.watch(dismissedRemindersProvider);
    final remindersAsync = ref.watch(allRemindersStreamProvider);
    final userAsync = ref.watch(userProfileStreamProvider);
    final dailyLogsAsync = ref.watch(allDailyLogsStreamProvider);

    final user = userAsync.value;
    final allReminders = remindersAsync.value ?? [];
    if (user != null && allReminders.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(reminderRepositoryProvider).ensureStandardReminders(user.id);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Reminders',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.text),
            tooltip: 'Reminder Settings',
            onPressed: () => context.push('/reminder_settings'),
          ),
        ],
      ),
      body: remindersAsync.when(
        data: (reminders) {
          final quietHours = reminders.where((r) => r.type == 'quiet_hours').firstOrNull;
          final enabledReminders = reminders
              .where((r) => r.isEnabled && r.type != 'quiet_hours')
              .toList();

          if (enabledReminders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.lightPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_off_outlined,
                        color: AppColors.primaryPurple,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Active Reminders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have disabled all notification reminders. Tap below to turn on your alerts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    BloomButton(
                      text: 'Manage Reminders',
                      onPressed: () => context.push('/reminder_settings'),
                    ),
                  ],
                ),
              ),
            );
          }

          final user = userAsync.value;
          final logs = dailyLogsAsync.value ?? [];
          final calendarState = ref.watch(calendarProvider);

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final avgPeriodLen = user?.avgPeriodLength ?? 5;

          // Today's daily log check
          final todayLog = logs.where((log) =>
            log.date.year == today.year &&
            log.date.month == today.month &&
            log.date.day == today.day
          ).firstOrNull;

          final hasCheckedInToday = todayLog != null && (
            (todayLog.mood != null && todayLog.mood != 'None') ||
            (todayLog.painLevel != null && todayLog.painLevel! > 0) ||
            (todayLog.flowIntensity != null && todayLog.flowIntensity != 'None') ||
            (todayLog.waterIntake != null && todayLog.waterIntake!.isNotEmpty) ||
            (todayLog.sleepHours != null && todayLog.sleepHours! > 0)
          );

          // Period ongoing check:
          // User is on period if flow logged today or logged within current period length
          final hasFlowToday = todayLog?.flowIntensity != null && todayLog!.flowIntensity != 'None';
          final hasRecentFlow = logs.any((l) =>
            l.flowIntensity != null &&
            l.flowIntensity != 'None' &&
            today.difference(DateTime(l.date.year, l.date.month, l.date.day)).inDays >= 0 &&
            today.difference(DateTime(l.date.year, l.date.month, l.date.day)).inDays < avgPeriodLen
          );
          final isPeriodOngoing = hasFlowToday || hasRecentFlow;

          // Next period calculation from calendarState
          final nextPeriodDate = calendarState.nextPeriodStartDate;
          final daysUntilPeriod = nextPeriodDate != null ? nextPeriodDate.difference(today).inDays : 999;

          // Ovulation calculation from calendarState
          final ovulationDate = calendarState.ovulationDay;
          final daysUntilOvulation = ovulationDate != null ? ovulationDate.difference(today).inDays : 999;

          // Fertile window calculation from calendarState
          final upcomingFertile = calendarState.fertileDays.where((d) => !d.isBefore(today)).toList();
          final firstFertileWindow = <DateTime>[];
          if (upcomingFertile.isNotEmpty) {
            firstFertileWindow.add(upcomingFertile.first);
            for (int i = 1; i < upcomingFertile.length; i++) {
              if (upcomingFertile[i].difference(firstFertileWindow.last).inDays == 1) {
                firstFertileWindow.add(upcomingFertile[i]);
              } else {
                break;
              }
            }
          }
          final fertileStart = firstFertileWindow.isNotEmpty ? firstFertileWindow.first : null;
          final fertileEnd = firstFertileWindow.isNotEmpty ? firstFertileWindow.last : null;
          final daysUntilFertile = fertileStart != null ? fertileStart.difference(today).inDays : 999;
          final isFertileActiveToday = fertileStart != null && fertileEnd != null && !today.isBefore(fertileStart) && !today.isAfter(fertileEnd);

          // Filter only reminders that are strictly due/necessary and not dismissed
          final dueReminders = enabledReminders.where((r) {
            final reminderKey =
                '${r.type}_${today.year}_${today.month}_${today.day}';
            if (dismissedIds.contains(reminderKey)) return false;

            return _isReminderDue(
              r: r,
              daysUntilPeriod: daysUntilPeriod,
              daysUntilOvulation: daysUntilOvulation,
              daysUntilFertile: daysUntilFertile,
              isFertileActiveToday: isFertileActiveToday,
              isPeriodOngoing: isPeriodOngoing,
              isPeriodLate: calendarState.isPeriodLate,
              hasCheckedInToday: hasCheckedInToday,
              today: today,
            );
          }).toList();

          if (dueReminders.isEmpty) {
            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  if (quietHours != null && quietHours.isEnabled) ...[
                    _buildQuietHoursBanner(quietHours),
                    const SizedBox(height: 24),
                  ],
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF2E7D32),
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'All Caught Up!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No notifications are due right now. Alerts only appear when necessary, like when your period or ovulation is approaching, or for your daily check-in.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          BloomButton(
                            text: 'Reminder Settings',
                            onPressed: () => context.push('/reminder_settings'),
                          ),
                          if (dismissedIds.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            TextButton.icon(
                              onPressed: () {
                                ref
                                    .read(dismissedRemindersProvider.notifier)
                                    .state = {};
                              },
                              icon: const Icon(
                                Icons.restore,
                                size: 16,
                                color: AppColors.primaryPurple,
                              ),
                              label: const Text(
                                'Restore dismissed alerts',
                                style: TextStyle(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final items = dueReminders.map((r) {
            final reminderKey =
                '${r.type}_${today.year}_${today.month}_${today.day}';
            final reminderDate = (r.updatedAt.year == now.year &&
                    r.updatedAt.month == now.month &&
                    r.updatedAt.day == now.day)
                ? now
                : (r.updatedAt.isAfter(now) ? now : r.updatedAt);
            final dateStr = _formatNotificationDate(reminderDate, now);
            final timeStr = r.timeOfDay.isNotEmpty
                ? _formatTime12H(r.timeOfDay)
                : _formatNotificationTime(reminderDate);

            return _getReminderItem(
              context,
              r,
              dateStr,
              timeStr,
              daysUntilPeriod,
              daysUntilOvulation,
              daysUntilFertile,
              calendarState.isPeriodLate,
              calendarState.daysLate,
              fertileStart,
              hasCheckedInToday,
              reminderKey,
            );
          }).toList();

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                if (quietHours != null && quietHours.isEnabled) ...[
                  _buildQuietHoursBanner(quietHours),
                  const SizedBox(height: 16),
                ],

                const Text(
                  'Notifications & Reminders',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                ...items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5350),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Dismiss',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        ref
                            .read(dismissedRemindersProvider.notifier)
                            .update((state) => {...state, item.id});
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.title} dismissed'),
                            duration: const Duration(seconds: 4),
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: Colors.amberAccent,
                              onPressed: () {
                                ref
                                    .read(dismissedRemindersProvider.notifier)
                                    .update(
                                      (state) => state
                                          .where((id) => id != item.id)
                                          .toSet(),
                                    );
                              },
                            ),
                          ),
                        );
                      },
                      child: _ReminderCardWidget(item: item),
                    ),
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  String _formatNotificationDate(DateTime date, DateTime now) {
    final targetDay = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (targetDay == today) {
      return 'Today';
    } else if (targetDay == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String _formatNotificationTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  Widget _buildQuietHoursBanner(Reminder quietHours) {
    return Material(
      color: AppColors.lightPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            const Icon(Icons.nightlight_round, color: AppColors.primaryPurple, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quiet hours are active',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Notifications and alerts are silenced during ${_formatQuietHours(quietHours.timeOfDay)}.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isReminderDue({
    required Reminder r,
    required int daysUntilPeriod,
    required int daysUntilOvulation,
    required int daysUntilFertile,
    required bool isFertileActiveToday,
    required bool isPeriodOngoing,
    required bool isPeriodLate,
    required bool hasCheckedInToday,
    required DateTime today,
  }) {
    if (!r.isEnabled || r.type == 'quiet_hours') return false;

    switch (r.type) {
      case 'period_start':
        if (isPeriodOngoing) return false;
        if (isPeriodLate) return true;
        return daysUntilPeriod <= r.daysBefore && daysUntilPeriod >= 0;

      case 'daily_log':
        return true;

      case 'ovulation':
        if (isPeriodOngoing) return false;
        return daysUntilOvulation >= 0 && daysUntilOvulation <= 1;

      case 'fertile_window':
        if (isPeriodOngoing) return false;
        return daysUntilFertile == 1 || isFertileActiveToday;

      case 'cycle_summary':
        final isMonthlySummaryTime = today.day <= 3 || today.day >= 28;
        return isMonthlySummaryTime;

      default:
        return false;
    }
  }

  _ReminderDisplayItem _getReminderItem(
    BuildContext context,
    Reminder r,
    String exactDate,
    String exactTime,
    int daysUntilPeriod,
    int daysUntilOvulation,
    int daysUntilFertile,
    bool isPeriodLate,
    int daysLate,
    DateTime? fertileStart,
    bool hasCheckedInToday,
    String id,
  ) {
    IconData icon;
    Color color;
    String title;
    String description;
    bool isCompleted = false;
    String? actionLabel;
    VoidCallback? onAction;

    switch (r.type) {
      case 'period_start':
        icon = Icons.water_drop_outlined;
        color = AppColors.primaryPink;
        title = 'Expected period alert';
        if (isPeriodLate) {
          description = 'Your period is $daysLate ${daysLate == 1 ? "day" : "days"} late.';
        } else if (daysUntilPeriod <= 0) {
          description = 'You may get your period today.';
        } else if (daysUntilPeriod == 1) {
          description = 'You may get your period tomorrow.';
        } else {
          description = 'You may get your period in $daysUntilPeriod days.';
        }
        actionLabel = 'View Calendar';
        onAction = () => context.go('/calendar');
        break;

      case 'ovulation':
        icon = Icons.auto_awesome;
        color = const Color(0xFFF4C059);
        title = 'Ovulation reminder';
        if (daysUntilOvulation <= 0) {
          description = 'Today is your predicted ovulation day.';
        } else if (daysUntilOvulation == 1) {
          description = 'You may have your ovulation tomorrow.';
        } else {
          description = 'You may have your ovulation in $daysUntilOvulation days.';
        }
        actionLabel = 'View Calendar';
        onAction = () => context.go('/calendar');
        break;

      case 'fertile_window':
        icon = Icons.spa_outlined;
        color = const Color(0xFF2E7D32);
        title = 'Fertile window reminder';
        if (daysUntilFertile == 1 && fertileStart != null) {
          description = 'Your fertile window begins tomorrow (${DateFormat('MMM d').format(fertileStart)}).';
        } else if (daysUntilOvulation == 0) {
          description = 'Today is your peak fertile day (ovulation day).';
        } else {
          description = 'You are currently in your fertile window today.';
        }
        actionLabel = 'View Calendar';
        onAction = () => context.go('/calendar');
        break;

      case 'daily_log':
        if (hasCheckedInToday) {
          icon = Icons.check_circle_outline;
          color = const Color(0xFF2E7D32);
          title = 'Daily check-in completed';
          description = "You've already logged your health data for today. Great job keeping your cycle tracking up to date!";
          isCompleted = true;
          actionLabel = 'Edit Check-in';
          onAction = () => context.push('/checkin/mood');
        } else {
          icon = Icons.edit_note;
          color = AppColors.primaryPurple;
          title = 'Daily check-in reminder';
          description = 'Remember to log your mood, flow, and symptoms for today.';
          isCompleted = false;
          actionLabel = 'Log Check-in Now';
          onAction = () => context.push('/checkin/mood');
        }
        break;

      case 'cycle_summary':
      default:
        icon = Icons.insights_outlined;
        color = const Color(0xFF1E88E5);
        title = 'Monthly cycle summary';
        description = 'Your cycle summary and personalized insights are ready.';
        actionLabel = 'View Insights';
        onAction = () => context.push('/insights');
        break;
    }

    return _ReminderDisplayItem(
      id: id,
      title: title,
      description: description,
      date: exactDate,
      time: exactTime,
      icon: icon,
      color: color,
      isCompleted: isCompleted,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  String _formatQuietHours(String timeStr) {
    try {
      if (timeStr.contains('-')) {
        final parts = timeStr.split('-');
        return '${_formatTime12H(parts[0].trim())} – ${_formatTime12H(parts[1].trim())}';
      }
      return timeStr;
    } catch (_) {
      return timeStr;
    }
  }

  String _formatTime12H(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final dt = DateTime(2026, 1, 1, hour, minute);
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return timeStr;
    }
  }
}

class _ReminderCardWidget extends StatefulWidget {
  final _ReminderDisplayItem item;

  const _ReminderCardWidget({required this.item});

  @override
  State<_ReminderCardWidget> createState() => _ReminderCardWidgetState();
}

class _ReminderCardWidgetState extends State<_ReminderCardWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (item.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 12, color: Color(0xFF2E7D32)),
                                SizedBox(width: 3),
                                Text(
                                  'Logged',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Due Today',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                        height: 1.3,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: _isExpanded
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_outlined, size: 13, color: item.color),
                                      const SizedBox(width: 5),
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(Icons.access_time, size: 13, color: item.color),
                                      const SizedBox(width: 5),
                                      Text(
                                        item.time,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.actionLabel != null && item.onAction != null) ...[
                                    const SizedBox(height: 12),
                                    InkWell(
                                      onTap: item.onAction,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: item.color.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: item.color.withValues(alpha: 0.3)),
                                        ),
                                        child: Text(
                                          item.actionLabel!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: item.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderDisplayItem {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final IconData icon;
  final Color color;
  final bool isCompleted;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _ReminderDisplayItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.icon,
    required this.color,
    this.isCompleted = false,
    this.actionLabel,
    this.onAction,
  });
}
