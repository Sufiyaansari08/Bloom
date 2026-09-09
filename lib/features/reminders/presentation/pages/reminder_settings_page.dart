import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';

class ReminderSettingsPage extends ConsumerWidget {
  const ReminderSettingsPage({super.key});

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
          if (reminders.isEmpty) {
            return const Center(
              child: Text(
                'No reminders configured',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: reminders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = reminders[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getIcon(item.type),
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTitle(item.type),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getDescription(item.type, item.daysBefore),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Time: ${item.timeOfDay}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: item.isEnabled,
                      activeThumbColor: AppColors.primaryPurple,
                      onChanged: (val) {
                        ref.read(reminderRepositoryProvider).toggleReminder(item.id, val);
                      },
                    ),
                  ],
                ),
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
