import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_emoticon_picker.dart';
import '../../../../shared/widgets/bloom_grid_item.dart';
import 'package:intl/intl.dart';
import '../providers/daily_checkin_provider.dart';

class CheckinMoodPage extends ConsumerWidget {
  const CheckinMoodPage({super.key});

  final List<Map<String, dynamic>> symptoms = const [
    {'label': 'Cramps', 'icon': Icons.waves},
    {'label': 'Headache', 'icon': Icons.face},
    {'label': 'Bloating', 'icon': Icons.bubble_chart},
    {'label': 'Fatigue', 'icon': Icons.battery_alert},
    {'label': 'Mood', 'icon': Icons.mood_bad},
    {'label': 'Nausea', 'icon': Icons.sick},
    {'label': 'Acne', 'icon': Icons.face_retouching_natural},
    {'label': '+ More', 'icon': Icons.add},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyCheckinProvider);
    final selectedMood = state.mood;
    final selectedSymptoms = state.symptoms;

    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final extraDate = extra?['date'] as DateTime?;
    final targetDate = state.targetDate ?? extraDate ?? DateTime.now();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cleanTarget = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final isToday = cleanTarget.isAtSameMomentAs(today);
    final isYesterday = cleanTarget.isAtSameMomentAs(today.subtract(const Duration(days: 1)));

    final titleText = isToday
        ? 'How are you feeling today?'
        : (isYesterday
            ? 'How did you feel yesterday?'
            : 'How did you feel on ${DateFormat('MMM d').format(cleanTarget)}?');

    return Scaffold(
      appBar: const BloomAppBar(progress: 0.2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
              ),
              if (!isToday) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${isYesterday ? "Yesterday • " : ""}${DateFormat('EEEE, MMM d').format(cleanTarget)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              BloomEmoticonPicker(
                selectedMood: selectedMood,
                onMoodSelected: (mood) {
                  ref.read(dailyCheckinProvider.notifier).setMood(mood);
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Add symptoms',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '(Select all that apply)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    final label = symptom['label'] as String;
                    final isSelected = selectedSymptoms.contains(label);

                    return BloomGridItem(
                      label: label,
                      icon: symptom['icon'] as IconData,
                      isSelected: isSelected,
                      onTap: () {
                        if (label == '+ More') {
                          _showMoreSymptoms(context, ref);
                        } else {
                          ref.read(dailyCheckinProvider.notifier).toggleSymptom(label);
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              BloomButton(
                text: 'Next',
                onPressed: () {
                  if (selectedSymptoms.isNotEmpty) {
                    context.push('/checkin/ratings');
                  } else {
                    context.push('/checkin/lifestyle');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreSymptoms(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> moreSymptoms = [
      {'label': 'Backache', 'icon': Icons.accessibility_new},
      {'label': 'Tender breasts', 'icon': Icons.woman},
      {'label': 'Insomnia', 'icon': Icons.bedtime},
      {'label': 'Dizziness', 'icon': Icons.rotate_right},
      {'label': 'Cravings', 'icon': Icons.restaurant},
      {'label': 'Digestion', 'icon': Icons.spa},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More Symptoms',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: moreSymptoms.map((symptom) {
                  final label = symptom['label'] as String;
                  return Consumer(
                    builder: (context, ref, _) {
                      final isSelected = ref.watch(dailyCheckinProvider).symptoms.contains(label);
                      return GestureDetector(
                        onTap: () {
                          ref.read(dailyCheckinProvider.notifier).toggleSymptom(label);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.lightPink : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryPink : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                symptom['icon'] as IconData,
                                size: 20,
                                color: isSelected ? AppColors.primaryPink : AppColors.secondaryText,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                label,
                                style: TextStyle(
                                  color: isSelected ? AppColors.primaryPink : AppColors.text,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              BloomButton(
                text: 'Done',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
