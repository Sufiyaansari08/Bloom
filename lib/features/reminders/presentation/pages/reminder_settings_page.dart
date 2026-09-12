import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';

class ReminderSettingsPage extends ConsumerStatefulWidget {
  const ReminderSettingsPage({super.key});

  @override
  ConsumerState<ReminderSettingsPage> createState() =>
      _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends ConsumerState<ReminderSettingsPage> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final remindersAsync = ref.watch(allRemindersStreamProvider);
    final userAsync = ref.watch(userProfileStreamProvider);

    final user = userAsync.value;
    if (user != null && !_initialized) {
      _initialized = true;
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
          'Reminder Settings',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: remindersAsync.when(
        data: (reminders) {
          final reminderMap = {for (final r in reminders) r.type: r};

          final periodReminder = reminderMap['period_start'];
          final ovulationReminder = reminderMap['ovulation'];
          final fertileReminder = reminderMap['fertile_window'];
          final dailyLogReminder = reminderMap['daily_log'];
          final cycleSummaryReminder = reminderMap['cycle_summary'];
          final quietHoursReminder = reminderMap['quiet_hours'];

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage Notifications',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Section 1: Cycle & Health Reminders Card
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // 1. Expected period reminder (with days-before selector)
                        _buildPeriodReminderTile(periodReminder),
                        const Divider(color: AppColors.border, height: 1),

                        // 2. Ovulation reminder
                        _buildReminderTile(
                          icon: Icons.auto_awesome,
                          title: 'Ovulation reminder',
                          subtitle: 'Alert on estimated ovulation day',
                          reminder: ovulationReminder,
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // 3. Fertile window reminder
                        _buildReminderTile(
                          icon: Icons.spa_outlined,
                          title: 'Fertile window reminder',
                          subtitle: 'Alert 1 day prior & during fertile window',
                          reminder: fertileReminder,
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // 4. Daily check-in reminder
                        _buildReminderTile(
                          icon: Icons.edit_note,
                          title: 'Daily check-in reminder',
                          subtitle: 'Notify to log symptoms & mood',
                          reminder: dailyLogReminder,
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // 5. Monthly cycle summary
                        _buildReminderTile(
                          icon: Icons.insights_outlined,
                          title: 'Monthly cycle summary',
                          subtitle: 'Monthly overview of your cycle trends',
                          reminder: cycleSummaryReminder,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Section 2: Preferences Card (Quiet Hours with time range)
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: (quietHoursReminder?.isEnabled ?? false)
                                      ? AppColors.lightPurple
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.bedtime_outlined,
                                  color: (quietHoursReminder?.isEnabled ?? false)
                                      ? AppColors.primaryPurple
                                      : AppColors.secondaryText,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quiet hours',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.text,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Mute notification sounds and vibrations',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: quietHoursReminder?.isEnabled ?? false,
                                activeTrackColor: AppColors.primaryPurple,
                                onChanged: (val) async {
                                  if (quietHoursReminder != null) {
                                    await ref
                                        .read(reminderRepositoryProvider)
                                        .toggleReminder(
                                          quietHoursReminder.id,
                                          val,
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                          if (quietHoursReminder != null &&
                              quietHoursReminder.isEnabled) ...[
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(left: 54),
                              child: InkWell(
                                onTap: () => _editQuietHours(
                                  context,
                                  quietHoursReminder,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightPurple,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryPurple.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.nightlight_round,
                                        size: 14,
                                        color: AppColors.primaryPurple,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatQuietHours(
                                          quietHoursReminder.timeOfDay,
                                        ),
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.edit,
                                        size: 12,
                                        color: AppColors.primaryPurple,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildPeriodReminderTile(Reminder? reminder) {
    final isEnabled = reminder?.isEnabled ?? false;
    final days = reminder?.daysBefore ?? 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppColors.lightPurple
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.water_drop_outlined,
                  color: isEnabled
                      ? AppColors.primaryPurple
                      : AppColors.secondaryText,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expected period reminder',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Alert $days ${days == 1 ? "day" : "days"} before predicted start',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                activeTrackColor: AppColors.primaryPurple,
                onChanged: (val) async {
                  if (reminder != null) {
                    await ref
                        .read(reminderRepositoryProvider)
                        .toggleReminder(reminder.id, val);
                  }
                },
              ),
            ],
          ),
          if (isEnabled && reminder != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 54),
              child: (reminder.type == 'daily_log' || reminder.type == 'cycle_summary')
                  ? InkWell(
                      onTap: () => _editSingleReminderTime(context, reminder),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primaryPurple.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.primaryPurple,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime12H(reminder.timeOfDay),
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.edit,
                              size: 12,
                              color: AppColors.primaryPurple,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primaryPurple.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.primaryPurple,
                          ),
                          const SizedBox(width: 6),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: days,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 14,
                                color: AppColors.primaryPurple,
                              ),
                              isDense: true,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryPurple,
                              ),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              selectedItemBuilder: (BuildContext context) {
                                const options = [1, 2, 3, 5, 7];
                                return options.map<Widget>((int val) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '$val ${val == 1 ? "day" : "days"} before',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryPurple,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              items: [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    '1 day before',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.text,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text(
                                    '2 days before',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.text,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text(
                                    '3 days before',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.text,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 5,
                                  child: Text(
                                    '5 days before',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.text,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 7,
                                  child: Text(
                                    '7 days before',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.text,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (int? newVal) async {
                                if (newVal != null) {
                                  await ref
                                      .read(reminderRepositoryProvider)
                                      .updateReminderDaysBefore(reminder.id, newVal);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editSingleReminderTime(
    BuildContext context,
    Reminder reminder,
  ) async {
    final picked = await _pickTime(context, reminder.timeOfDay);
    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      await ref
          .read(reminderRepositoryProvider)
          .updateReminderTime(reminder.id, formatted);
    }
  }

  Widget _buildReminderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Reminder? reminder,
  }) {
    final isEnabled = reminder?.isEnabled ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEnabled ? AppColors.lightPurple : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isEnabled
                  ? AppColors.primaryPurple
                  : AppColors.secondaryText,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            activeTrackColor: AppColors.primaryPurple,
            onChanged: (val) async {
              if (reminder != null) {
                await ref
                    .read(reminderRepositoryProvider)
                    .toggleReminder(reminder.id, val);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _editQuietHours(BuildContext context, Reminder reminder) async {
    String startStr = '22:00';
    String endStr = '07:00';
    if (reminder.timeOfDay.contains('-')) {
      final parts = reminder.timeOfDay.split('-');
      startStr = parts[0].trim();
      endStr = parts[1].trim();
    }

    final start = await _pickTime(context, startStr);
    if (start == null || !context.mounted) return;

    final end = await _pickTime(context, endStr);
    if (end == null || !context.mounted) return;

    final formattedStart =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final formattedEnd =
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    final result = '$formattedStart - $formattedEnd';

    await ref
        .read(reminderRepositoryProvider)
        .updateReminderTime(reminder.id, result);
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, String current24h) async {
    TimeOfDay initial = const TimeOfDay(hour: 22, minute: 0);
    try {
      final parts = current24h.split(':');
      initial = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (_) {}

    return showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
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
