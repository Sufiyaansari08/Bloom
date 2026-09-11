import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_flow_option.dart';
import '../../../../shared/widgets/bloom_slider.dart';
import '../../../../shared/widgets/bloom_grid_item.dart';
import '../providers/period_logging_provider.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

class PeriodLogPage extends ConsumerWidget {
  const PeriodLogPage({super.key});

  final List<Map<String, dynamic>> flowOptions = const [
    {'label': 'Spotting', 'opacity': 0.2},
    {'label': 'Light', 'opacity': 0.4},
    {'label': 'Medium', 'opacity': 0.6},
    {'label': 'Heavy', 'opacity': 0.8},
    {'label': 'Very heavy', 'opacity': 1.0},
  ];

  final List<Map<String, dynamic>> symptoms = const [
    {'label': 'Cramps', 'icon': Icons.waves},
    {'label': 'Headache', 'icon': Icons.face},
    {'label': 'Bloating', 'icon': Icons.bubble_chart},
    {'label': 'Fatigue', 'icon': Icons.battery_alert},
    {'label': 'More', 'icon': Icons.add},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(periodLoggingProvider);
    final selectedFlow = state.flowLevel;
    final painLevel = state.painLevel;
    final selectedSymptoms = state.symptoms;

    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final rawStartDate = extra?['startDate'] as DateTime? ?? DateTime.now();
    final startDate = DateTime(rawStartDate.year, rawStartDate.month, rawStartDate.day);
    final now = DateTime.now();
    final isToday = startDate.year == now.year && startDate.month == now.month && startDate.day == now.day;

    return Scaffold(
      appBar: const BloomAppBar(progress: 1.0), // Can adjust if part of a longer flow
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isToday ? 'Log for Day 1' : 'Log for ${DateFormat('MMM d').format(startDate)}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'How is your flow?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    ...flowOptions.map((option) {
                      final label = option['label'] as String;
                      final opacity = option['opacity'] as double;
                      return BloomFlowOption(
                        label: label,
                        dropOpacity: opacity,
                        isSelected: selectedFlow == label,
                        onTap: () {
                          ref.read(periodLoggingProvider.notifier).setFlowLevel(label);
                        },
                      );
                    }),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pain level',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '$painLevel / 10',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BloomSlider(
                      value: painLevel.toDouble(),
                      onChanged: (val) {
                        ref.read(periodLoggingProvider.notifier).setPainLevel(val.toInt());
                      },
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Any symptoms?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(Select all that apply)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100, // Fixed height for horizontal scroll
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: symptoms.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final symptom = symptoms[index];
                          final label = symptom['label'] as String;
                          final isSelected = selectedSymptoms.contains(label);

                          return SizedBox(
                            width: 80, // Fixed width for each item
                            child: BloomGridItem(
                              label: label,
                              icon: symptom['icon'] as IconData,
                              isSelected: isSelected,
                              onTap: () {
                                if (label == 'More') {
                                  _showMoreSymptoms(context, ref);
                                } else {
                                  ref.read(periodLoggingProvider.notifier).toggleSymptom(label);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24), // Extra padding at the bottom of the scroll view
                  ],
                ),
              ),
              const SizedBox(height: 16), // Prevents overlap with the Save button
              BloomButton(
                text: 'Save',
                backgroundColor: AppColors.primaryPink,
                onPressed: () async {
                  final userRepo = ref.read(userRepositoryProvider);
                  final user = await userRepo.getUserProfile();

                  if (user != null) {
                    final cycleRepo = ref.read(cycleRepositoryProvider);
                    final currentCycle = await cycleRepo.getCurrentCycle();

                    String cycleId;
                    
                    // If there's an ongoing cycle and startDate is close (e.g. correcting start date), update it.
                    // If startDate is > 15 days after currentCycle.startDate, complete previous cycle and start a new one.
                    if (currentCycle != null) {
                      final dayDiff = startDate.difference(currentCycle.startDate).inDays;
                      if (dayDiff > 15) {
                        // Complete previous cycle
                        await cycleRepo.completeCycle(
                          currentCycle.id, 
                          startDate.subtract(const Duration(days: 1)), 
                          dayDiff, 
                          user.avgPeriodLength,
                        );
                        
                        // Create new cycle
                        cycleId = DateTime.now().millisecondsSinceEpoch.toString();
                        await cycleRepo.insertCycle(
                          CyclesCompanion.insert(
                            id: cycleId,
                            userId: user.id,
                            startDate: startDate,
                            cycleLength: drift.Value(user.avgCycleLength),
                            periodLength: drift.Value(user.avgPeriodLength),
                          )
                        );
                      } else {
                        // Adjust existing current cycle start date to the selected start date
                        await cycleRepo.updateCycleStartDate(currentCycle.id, startDate);
                        cycleId = currentCycle.id;
                      }
                    } else {
                      // No current cycle at all
                      cycleId = DateTime.now().millisecondsSinceEpoch.toString();
                      await cycleRepo.insertCycle(
                        CyclesCompanion.insert(
                          id: cycleId,
                          userId: user.id,
                          startDate: startDate,
                          cycleLength: drift.Value(user.avgCycleLength),
                          periodLength: drift.Value(user.avgPeriodLength),
                        )
                      );
                    }

                    final dailyLogRepo = ref.read(dailyLogRepositoryProvider);
                    final logId = '${startDate.millisecondsSinceEpoch}_log';

                    await dailyLogRepo.upsertDailyLog(
                      DailyLogsCompanion.insert(
                        id: logId,
                        userId: user.id,
                        cycleId: drift.Value(cycleId),
                        date: startDate,
                        flowIntensity: drift.Value(selectedFlow),
                        painLevel: drift.Value(painLevel),
                      )
                    );
                  }

                  ref.read(periodLoggingProvider.notifier).clear();
                  if (context.mounted) {
                    context.go('/home'); // Complete flow, back to home
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
      {'label': 'Acne', 'icon': Icons.face_retouching_natural},
      {'label': 'Backache', 'icon': Icons.accessibility_new},
      {'label': 'Mood swings', 'icon': Icons.mood_bad},
      {'label': 'Tender breasts', 'icon': Icons.woman},
      {'label': 'Nausea', 'icon': Icons.sick},
      {'label': 'Insomnia', 'icon': Icons.bedtime},
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
                      final isSelected = ref.watch(periodLoggingProvider).symptoms.contains(label);
                      return GestureDetector(
                        onTap: () {
                          ref.read(periodLoggingProvider.notifier).toggleSymptom(label);
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
