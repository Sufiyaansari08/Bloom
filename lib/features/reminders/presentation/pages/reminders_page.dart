import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  IconData _getIcon(String type) {
    switch (type) {
      case 'period_start':
        return Icons.water_drop_outlined;
      case 'fertile_window':
        return Icons.egg_outlined;
      case 'daily_log':
        return Icons.edit_note;
      case 'medication':
        return Icons.medication_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  String _getTitle(String type) {
    switch (type) {
      case 'period_start':
        return 'Period prediction alert';
      case 'fertile_window':
        return 'Fertile window reminder';
      case 'daily_log':
        return 'Log daily symptoms';
      case 'medication':
        return 'Medication / Pill reminder';
      default:
        return 'Health reminder';
    }
  }

  String _getDescription(String type, int days) {
    switch (type) {
      case 'period_start':
        return 'Alert $days days before period is expected to start.';
      case 'fertile_window':
        return 'Notification when your fertile window opens.';
      case 'daily_log':
        return 'Quick evening check-in for your mood and pain.';
      case 'medication':
        return 'Daily reminder for your wellness supplements or pills.';
      default:
        return 'Keep your health logs up to date.';
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'period_start':
      case 'daily_log':
        return AppColors.primaryPink;
      case 'fertile_window':
        return Colors.green;
      case 'medication':
        return Colors.blue;
      default:
        return AppColors.primaryPurple;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(allRemindersStreamProvider);

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
      ),
      body: remindersAsync.when(
        data: (reminders) {
          final activeReminders = reminders.where((r) => r.isEnabled).toList();

          if (activeReminders.isEmpty) {
            return const Center(
              child: Text(
                'No active reminders configured.',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: activeReminders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final r = activeReminders[index];
              return ReminderBox(
                title: _getTitle(r.type),
                description: _getDescription(r.type, r.daysBefore),
                date: 'Active',
                time: r.timeOfDay,
                icon: _getIcon(r.type),
                color: _getColor(r.type),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class ReminderBox extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final IconData icon;
  final Color color;

  const ReminderBox({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  State<ReminderBox> createState() => _ReminderBoxState();
}

class _ReminderBoxState extends State<ReminderBox> {
  bool _showTime = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showTime = !_showTime;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: widget.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: _showTime
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: AppColors.secondaryText),
                                const SizedBox(width: 4),
                                Text(
                                  widget.time,
                                  style: const TextStyle(
                                    fontSize: 12,
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
    );
  }
}
