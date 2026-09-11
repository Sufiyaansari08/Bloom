import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/widgets/bloom_button.dart';

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(allRemindersStreamProvider);
    final userAsync = ref.watch(userProfileStreamProvider);
    final currentCycleAsync = ref.watch(currentCycleStreamProvider);
    final allCyclesAsync = ref.watch(allCyclesStreamProvider);
    final dailyLogsAsync = ref.watch(allDailyLogsStreamProvider);

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
          final currentCycle = currentCycleAsync.value;
          final allCycles = allCyclesAsync.value ?? [];
          final logs = dailyLogsAsync.value ?? [];

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final avgCycleLen = user?.avgCycleLength ?? 29;
          final avgPeriodLen = user?.avgPeriodLength ?? 5;

          // Determine cycle reference point
          DateTime cycleStart;
          if (currentCycle != null) {
            cycleStart = currentCycle.startDate;
          } else if (allCycles.isNotEmpty) {
            cycleStart = allCycles.first.startDate;
          } else {
            cycleStart = now.subtract(const Duration(days: 14));
          }

          final diff = today.difference(DateTime(cycleStart.year, cycleStart.month, cycleStart.day)).inDays + 1;
          final cycleDay = diff > 0 ? diff : 1;
          final daysUntilPeriod = avgCycleLen - cycleDay;

          // Ovulation: estimated 14 days before next period start
          final ovulationDay = avgCycleLen - 14;
          final daysUntilOvulation = ovulationDay - cycleDay;

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

          // Period logged check:
          // User has logged period if currently in first days of newly logged cycle or has flow today
          final daysSinceCycleStart = today.difference(DateTime(cycleStart.year, cycleStart.month, cycleStart.day)).inDays;
          final hasFlowToday = todayLog?.flowIntensity != null && todayLog!.flowIntensity != 'None';
          final isCurrentlyInLoggedPeriod = currentCycle != null && daysSinceCycleStart >= 0 && daysSinceCycleStart < avgPeriodLen;
          final isPeriodLogged = hasFlowToday || isCurrentlyInLoggedPeriod;

          // Filter only reminders that are strictly due/necessary
          final dueReminders = enabledReminders.where((r) {
            return _isReminderDue(
              r: r,
              cycleDay: cycleDay,
              avgCycleLen: avgCycleLen,
              daysUntilPeriod: daysUntilPeriod,
              daysUntilOvulation: daysUntilOvulation,
              isPeriodLogged: isPeriodLogged,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final items = dueReminders.map((r) {
            final reminderDate = (r.updatedAt.year == now.year && r.updatedAt.month == now.month && r.updatedAt.day == now.day)
                ? now
                : (r.updatedAt.isAfter(now) ? now : r.updatedAt);
            final dateStr = _formatNotificationDate(reminderDate, now);
            final timeStr = _formatNotificationTime(reminderDate);

            return _getReminderItem(
              r,
              dateStr,
              timeStr,
              daysUntilPeriod,
              daysUntilOvulation,
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
                    child: _ReminderCardWidget(item: item),
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
    required int cycleDay,
    required int avgCycleLen,
    required int daysUntilPeriod,
    required int daysUntilOvulation,
    required bool isPeriodLogged,
    required bool hasCheckedInToday,
    required DateTime today,
  }) {
    if (!r.isEnabled || r.type == 'quiet_hours') return false;

    switch (r.type) {
      case 'period_start':
        // Starts from the days the user selected (e.g., 1 or 2 days before)
        // and continues until the user logs the period
        if (isPeriodLogged) return false;
        return daysUntilPeriod <= r.daysBefore;

      case 'daily_log':
        // Daily check-in reminder comes daily until the user logs for today
        return !hasCheckedInToday;

      case 'ovulation':
        // Ovulation reminder comes only when ovulation is tomorrow or today
        return daysUntilOvulation >= 0 && daysUntilOvulation <= 1;

      case 'fertile_window':
        // Starts 1 day prior to fertile window through the active fertile window (until ovulation day)
        return daysUntilOvulation >= 0 && daysUntilOvulation <= 6;

      case 'cycle_summary':
        // Monthly cycle summary comes after every month or cycle completion
        final isMonthlySummaryTime = today.day <= 3 || today.day >= 28;
        final isCycleCompleted = cycleDay >= avgCycleLen;
        return isMonthlySummaryTime || isCycleCompleted;

      default:
        return false;
    }
  }

  _ReminderDisplayItem _getReminderItem(
    Reminder r,
    String exactDate,
    String exactTime,
    int daysUntilPeriod,
    int daysUntilOvulation,
  ) {
    IconData icon;
    Color color;
    String title;
    String description;

    switch (r.type) {
      case 'period_start':
        icon = Icons.water_drop_outlined;
        color = AppColors.primaryPink;
        title = 'Expected period alert';
        if (daysUntilPeriod <= 0) {
          description = 'You may get your period today.';
        } else if (daysUntilPeriod == 1) {
          description = 'You may get your period in 1 day.';
        } else {
          description = 'You may get your period in $daysUntilPeriod days.';
        }
        break;

      case 'ovulation':
        icon = Icons.auto_awesome;
        color = const Color(0xFFF4C059);
        title = 'Ovulation reminder';
        if (daysUntilOvulation <= 0) {
          description = 'You may have your ovulation today.';
        } else if (daysUntilOvulation == 1) {
          description = 'You may have your ovulation tomorrow.';
        } else {
          description = 'You may have your ovulation in $daysUntilOvulation days.';
        }
        break;

      case 'fertile_window':
        icon = Icons.spa_outlined;
        color = const Color(0xFF2E7D32);
        title = 'Fertile window reminder';
        if (daysUntilOvulation == 6) {
          description = 'Your fertile window begins tomorrow.';
        } else if (daysUntilOvulation == 0) {
          description = 'Today is your peak fertile day (ovulation day).';
        } else {
          description = 'You are currently in your fertile window today.';
        }
        break;

      case 'daily_log':
        icon = Icons.edit_note;
        color = AppColors.primaryPurple;
        title = 'Daily check-in reminder';
        description = 'Remember to log your mood, flow, and symptoms for today.';
        break;

      case 'cycle_summary':
      default:
        icon = Icons.insights_outlined;
        color = const Color(0xFF1E88E5);
        title = 'Monthly cycle summary';
        description = 'Your cycle summary and personalized insights are ready.';
        break;
    }

    return _ReminderDisplayItem(
      title: title,
      description: description,
      date: exactDate,
      time: exactTime,
      icon: icon,
      color: color,
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
  bool _isExpanded = false;

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
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
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
                              child: Row(
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
  final String title;
  final String description;
  final String date;
  final String time;
  final IconData icon;
  final Color color;

  const _ReminderDisplayItem({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.icon,
    required this.color,
  });
}
