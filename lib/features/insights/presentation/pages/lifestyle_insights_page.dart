import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';

class LifestyleInsightsPage extends ConsumerStatefulWidget {
  const LifestyleInsightsPage({super.key});

  @override
  ConsumerState<LifestyleInsightsPage> createState() =>
      _LifestyleInsightsPageState();
}

class _LifestyleInsightsPageState extends ConsumerState<LifestyleInsightsPage> {
  int _selectedCycles = 6;

  bool _isLogForCycle(DailyLog log, Cycle cycle) {
    if (log.cycleId != null && log.cycleId == cycle.id) return true;
    final logDate = DateTime(log.date.year, log.date.month, log.date.day);
    final startDate = DateTime(
      cycle.startDate.year,
      cycle.startDate.month,
      cycle.startDate.day,
    );
    if (logDate.isBefore(startDate)) return false;
    if (cycle.endDate != null) {
      final endDate = DateTime(
        cycle.endDate!.year,
        cycle.endDate!.month,
        cycle.endDate!.day,
      );
      return !logDate.isAfter(endDate);
    }
    return true;
  }

  double? _parseWaterLiters(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'Select') return null;
    if (raw.contains('< 1.0')) return 0.8;
    if (raw.contains('1.5')) return 1.5;
    if (raw.contains('2.0')) return 2.0;
    if (raw.contains('2.5')) return 2.5;
    if (raw.contains('> 3.0')) return 3.2;
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(raw);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }

  @override
  Widget build(BuildContext context) {
    final cycles = ref.watch(allCyclesStreamProvider).value ?? [];
    final allLogs = ref.watch(allDailyLogsStreamProvider).value ?? [];
    final allSymptoms = ref.watch(allSymptomsStreamProvider).value ?? [];

    final activeCycles = cycles.where((c) => !c.isDeleted).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final completedCycles = activeCycles
        .where((c) =>
            c.endDate != null &&
            c.cycleLength != null &&
            c.cycleLength! > 0)
        .toList();

    final currentCycle = activeCycles.where((c) => c.endDate == null).lastOrNull ??
        activeCycles.lastOrNull;

    final List<Cycle> targetedCycles;
    final String? disclaimerText;

    if (_selectedCycles == 1) {
      if (currentCycle != null) {
        targetedCycles = [currentCycle];
        disclaimerText = null;
      } else {
        targetedCycles = [];
        disclaimerText = 'No cycle data available';
      }
    } else {
      if (completedCycles.isEmpty) {
        disclaimerText = 'Your last $_selectedCycles cycles are not yet completed';
        targetedCycles = [];
      } else if (completedCycles.length < _selectedCycles) {
        disclaimerText =
            'Your last $_selectedCycles cycles are not yet completed (showing ${completedCycles.length} completed)';
        targetedCycles = completedCycles;
      } else {
        disclaimerText = null;
        targetedCycles = completedCycles.sublist(
            completedCycles.length - _selectedCycles);
      }
    }

    final validLogs = allLogs.where((l) => !l.isDeleted).toList();

    // Relevant logs for targeted cycles
    final List<DailyLog> relevantLogs = [
      for (final c in targetedCycles)
        ...validLogs.where((l) => _isLogForCycle(l, c)),
    ];

    // Card 1: Calculations for your averages
    // Sleep
    final sleepLogs = relevantLogs
        .where((l) => l.sleepHours != null && l.sleepHours! > 0)
        .toList();
    final String sleepVal;
    if (sleepLogs.isNotEmpty) {
      final avgSleep =
          sleepLogs.map((l) => l.sleepHours!).reduce((a, b) => a + b) /
              sleepLogs.length;
      final h = avgSleep.floor();
      final m = ((avgSleep - h) * 60).round();
      sleepVal = m > 0 ? '${h}h ${m}m' : '${h}h';
    } else {
      sleepVal = '--';
    }

    // Water intake
    final waterList = relevantLogs
        .map((l) => _parseWaterLiters(l.waterIntake))
        .whereType<double>()
        .toList();
    final String waterVal;
    if (waterList.isNotEmpty) {
      final avgWater =
          waterList.reduce((a, b) => a + b) / waterList.length;
      waterVal = '${avgWater.toStringAsFixed(1)} L';
    } else {
      waterVal = '--';
    }

    // Activity
    final activityLogs = relevantLogs
        .where((l) =>
            l.activityLevel != null &&
            l.activityLevel!.isNotEmpty &&
            l.activityLevel != 'Select')
        .map((l) => l.activityLevel!)
        .toList();
    final String activityVal;
    if (activityLogs.isNotEmpty) {
      final counts = <String, int>{};
      for (final a in activityLogs) {
        counts[a] = (counts[a] ?? 0) + 1;
      }
      var maxAct = activityLogs.first;
      var maxCount = -1;
      for (final entry in counts.entries) {
        if (entry.value > maxCount) {
          maxCount = entry.value;
          maxAct = entry.key;
        }
      }
      activityVal = maxAct;
    } else {
      activityVal = '--';
    }

    // Stress level
    final stressLogs = relevantLogs
        .where((l) => l.stressLevel != null)
        .map((l) => l.stressLevel!)
        .toList();
    final String stressVal;
    if (stressLogs.isNotEmpty) {
      final avgStress =
          stressLogs.reduce((a, b) => a + b) / stressLogs.length;
      stressVal = '${avgStress.toStringAsFixed(1)} / 10';
    } else {
      stressVal = '--';
    }

    // Card 2: Lifestyle & symptoms correlation engine
    final Map<String, List<String>> symptomsByLogId = {};
    for (final s in allSymptoms) {
      if (!s.isDeleted) {
        symptomsByLogId
            .putIfAbsent(s.dailyLogId, () => [])
            .add(s.symptomName.toLowerCase());
      }
    }

    final List<_CorrelationItem> correlationList = [];
    final bool hasAnyLifestyleData = sleepLogs.isNotEmpty ||
        waterList.isNotEmpty ||
        activityLogs.isNotEmpty ||
        stressLogs.isNotEmpty;

    if (hasAnyLifestyleData) {
      // 1. Sleep Correlation
      if (sleepLogs.isNotEmpty) {
        int lowSleepHeadaches = 0;
        int lowSleepFatigue = 0;
        for (final l in sleepLogs) {
          if (l.sleepHours! < 6.5) {
            final syms = symptomsByLogId[l.id] ?? [];
            if (syms.any((s) => s.contains('headache') || s.contains('migraine'))) {
              lowSleepHeadaches++;
            }
            if (syms.any((s) => s.contains('fatigue') || s.contains('tired'))) {
              lowSleepFatigue++;
            }
          }
        }

        if (lowSleepHeadaches > 0) {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.face,
              title: 'Sleep & Headaches',
              subtitle: 'Less sleep days had more headaches',
              color: AppColors.primaryPink,
            ),
          );
        } else if (lowSleepFatigue > 0) {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.battery_alert,
              title: 'Sleep & Fatigue',
              subtitle: 'Days with less sleep had higher fatigue',
              color: Colors.indigo,
            ),
          );
        } else {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.nights_stay_outlined,
              title: 'Sleep & Recovery',
              subtitle: 'Consistent sleep supported your daily energy',
              color: Colors.indigo,
            ),
          );
        }
      }

      // 2. Stress Correlation
      if (stressLogs.isNotEmpty) {
        double highStressPainSum = 0;
        int highStressPainCount = 0;
        int highStressLowMoodCount = 0;

        for (final l in relevantLogs.where((l) => l.stressLevel != null)) {
          if (l.stressLevel! >= 6) {
            if (l.painLevel != null && l.painLevel! > 0) {
              highStressPainSum += l.painLevel!;
              highStressPainCount++;
            }
            final mood = l.mood?.toLowerCase() ?? '';
            if (mood.contains('not') || mood.contains('bad')) {
              highStressLowMoodCount++;
            }
          }
        }

        if (highStressPainCount > 0 &&
            (highStressPainSum / highStressPainCount) >= 4.0) {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.psychology,
              title: 'Stress & Pain',
              subtitle: 'Higher stress associated with higher pain',
              color: Colors.orange,
            ),
          );
        } else if (highStressLowMoodCount > 0) {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.sentiment_dissatisfied,
              title: 'Stress & Mood',
              subtitle: 'Higher stress days frequently coincided with lower mood',
              color: Colors.orange,
            ),
          );
        } else {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.spa,
              title: 'Stress Management',
              subtitle: 'Lower stress days correlated with milder symptoms',
              color: Colors.orange,
            ),
          );
        }
      }

      // 3. Activity Correlation
      if (activityLogs.isNotEmpty) {
        int activeHighMoodCount = 0;

        for (final l in relevantLogs.where((l) => l.activityLevel != null)) {
          final act = l.activityLevel!.toLowerCase();
          if (act == 'high' || act == 'moderate') {
            final mood = l.mood?.toLowerCase() ?? '';
            if (mood == 'great' || mood == 'good') {
              activeHighMoodCount++;
            }
          }
        }

        if (activeHighMoodCount > 0) {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.bolt,
              title: 'Activity & Energy',
              subtitle: 'More active days had higher energy',
              color: Colors.teal,
            ),
          );
        } else {
          correlationList.add(
            const _CorrelationItem(
              icon: Icons.directions_walk,
              title: 'Activity & Well-being',
              subtitle: 'Regular movement supported your overall cycle flow',
              color: Colors.teal,
            ),
          );
        }
      }

      // 4. Hydration Correlation (if fewer than 3 items, add hydration)
      if (correlationList.length < 3 && waterList.isNotEmpty) {
        correlationList.add(
          const _CorrelationItem(
            icon: Icons.local_drink_outlined,
            title: 'Hydration & Cramps',
            subtitle: 'Higher water intake correlated with reduced bloating',
            color: Colors.lightBlue,
          ),
        );
      }
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
          'Lifestyle Insights',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.text),
            onPressed: () {
              showPageInfoDialog(
                context,
                title: 'Lifestyle Insights',
                description:
                    'See how your sleep, hydration, and exercise habits correlate with your cycle phases.',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: PopupMenuButton<int>(
                  initialValue: _selectedCycles,
                  position: PopupMenuPosition.under,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onSelected: (int newValue) {
                    setState(() {
                      _selectedCycles = newValue;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return [1, 2, 3, 4, 5, 6, 7, 8].map((int value) {
                      return PopupMenuItem<int>(
                        value: value,
                        child: Text(
                          value == 1 ? 'Current cycle' : 'Last $value cycles',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedCycles == 1
                            ? 'Current cycle'
                            : 'Last $_selectedCycles cycles',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryPurple,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Disclaimer banner when selected count is not yet reached
            if (disclaimerText != null) ...[
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryPink.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 15,
                        color: AppColors.primaryPurple,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          disclaimerText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // CARD 1: Your averages
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your averages',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAverageRow(
                    Icons.nights_stay_outlined,
                    'Sleep',
                    sleepVal,
                    Colors.indigo,
                  ),
                  const SizedBox(height: 20),
                  _buildAverageRow(
                    Icons.local_drink_outlined,
                    'Water intake',
                    waterVal,
                    Colors.lightBlue,
                  ),
                  const SizedBox(height: 20),
                  _buildAverageRow(
                    Icons.directions_walk,
                    'Activity level',
                    activityVal,
                    Colors.green,
                  ),
                  const SizedBox(height: 20),
                  _buildAverageRow(
                    Icons.sentiment_dissatisfied,
                    'Stress level',
                    stressVal,
                    AppColors.primaryPink,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 2: Lifestyle & symptoms correlation (Fully Unlocked)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lifestyle & symptoms correlation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (correlationList.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.insights_outlined,
                              size: 44,
                              color:
                                  AppColors.primaryPurple.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No lifestyle patterns yet',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Log your daily check-ins (sleep, hydration, activity) to discover personalized correlations.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...List.generate(correlationList.length, (index) {
                      final item = correlationList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == correlationList.length - 1 ? 0 : 20,
                        ),
                        child: _buildCorrelationRow(
                          item.icon,
                          item.title,
                          item.subtitle,
                          item.color,
                        ),
                      );
                    }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 3: Unlock with Bloom Pro
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unlock with Bloom Pro',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'See how your lifestyle affects your symptoms and mood.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.diamond_outlined,
                        color: AppColors.primaryPurple,
                        size: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Upgrade Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.white),
                        ],
                      ),
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

  Widget _buildAverageRow(
      IconData icon, String title, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildCorrelationRow(
      IconData icon, String title, String subtitle, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CorrelationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _CorrelationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
