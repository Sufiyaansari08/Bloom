import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';

class SymptomsPatternsPage extends ConsumerStatefulWidget {
  const SymptomsPatternsPage({super.key});

  @override
  ConsumerState<SymptomsPatternsPage> createState() =>
      _SymptomsPatternsPageState();
}

class _SymptomsPatternsPageState extends ConsumerState<SymptomsPatternsPage> {
  int _selectedCycles = 6;
  bool _showAllSymptoms = false;

  @override
  Widget build(BuildContext context) {
    final cycles = ref.watch(allCyclesStreamProvider).value ?? [];
    final allLogs = ref.watch(allDailyLogsStreamProvider).value ?? [];
    final allSymptoms = ref.watch(allSymptomsStreamProvider).value ?? [];

    // Filter completed cycles
    final completedCycles = cycles
        .where((c) =>
            !c.isDeleted &&
            c.endDate != null &&
            c.cycleLength != null &&
            c.cycleLength! > 0)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    // Disclaimer if user selected a number of cycles not yet reached
    final String? disclaimerText;
    if (completedCycles.isEmpty) {
      disclaimerText = 'Your last $_selectedCycles cycles are not yet completed';
    } else if (completedCycles.length < _selectedCycles) {
      disclaimerText =
          'Your last $_selectedCycles cycles are not yet completed (showing ${completedCycles.length} completed)';
    } else {
      disclaimerText = null;
    }

    // Subset of completed cycles
    final recentSubset = completedCycles.length > _selectedCycles
        ? completedCycles.sublist(completedCycles.length - _selectedCycles)
        : completedCycles;

    final Map<String, DailyLog> logsById = {for (final l in allLogs) l.id: l};
    final Map<String, Cycle> cyclesById = {for (final c in cycles) c.id: c};

    // Filter relevant symptoms:
    // If completed cycles exist, symptoms linked to those cycles.
    // Otherwise, all logged symptoms.
    final List<DailySymptom> relevantSymptoms;
    if (recentSubset.isNotEmpty) {
      final cycleIds = recentSubset.map((c) => c.id).toSet();
      relevantSymptoms = allSymptoms.where((s) {
        final log = logsById[s.dailyLogId];
        return log != null && cycleIds.contains(log.cycleId);
      }).toList();
    } else {
      relevantSymptoms = allSymptoms;
    }

    // Group symptoms by name
    final Map<String, List<DailySymptom>> symptomsByName = {};
    for (final s in relevantSymptoms) {
      final name = s.symptomName.trim();
      if (name.isEmpty) continue;
      symptomsByName.putIfAbsent(name, () => []).add(s);
    }

    // Compute frequency statistics for each symptom
    final List<_SymptomFrequencyData> symptomFrequencyList = [];
    for (final entry in symptomsByName.entries) {
      final name = entry.key;
      final instances = entry.value;

      final int percentage;
      if (recentSubset.isNotEmpty) {
        final Set<String> distinctCyclesWithSymptom = {};
        for (final s in instances) {
          final log = logsById[s.dailyLogId];
          if (log != null && log.cycleId != null) {
            distinctCyclesWithSymptom.add(log.cycleId!);
          }
        }
        percentage = ((distinctCyclesWithSymptom.length / recentSubset.length) * 100)
            .round()
            .clamp(1, 100);
      } else {
        // Fallback when 0 completed cycles: percentage across distinct log days
        final totalDays = allLogs
            .map((l) => DateTime(l.date.year, l.date.month, l.date.day))
            .toSet()
            .length;
        final symptomDays = instances
            .map((s) {
              final log = logsById[s.dailyLogId];
              return log != null
                  ? DateTime(log.date.year, log.date.month, log.date.day)
                  : null;
            })
            .whereType<DateTime>()
            .toSet()
            .length;
        percentage = totalDays > 0
            ? ((symptomDays / totalDays) * 100).round().clamp(1, 100)
            : 100;
      }

      // Determine most common timing & phase
      final timingInfo = _calculateTimingInfo(instances, logsById, cyclesById);

      symptomFrequencyList.add(
        _SymptomFrequencyData(
          name: name,
          icon: _getSymptomIcon(name),
          percentage: percentage,
          instanceCount: instances.length,
          subtitle: timingInfo.subtitle,
          badgeText: timingInfo.badgeText,
          badgeColor: timingInfo.badgeColor,
        ),
      );
    }

    // Sort by percentage descending, then instance count descending
    symptomFrequencyList.sort((a, b) {
      final cmp = b.percentage.compareTo(a.percentage);
      if (cmp != 0) return cmp;
      return b.instanceCount.compareTo(a.instanceCount);
    });

    final visibleTimelineList = _showAllSymptoms || symptomFrequencyList.length <= 3
        ? symptomFrequencyList
        : symptomFrequencyList.take(3).toList();

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
          'Symptoms Patterns',
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
                title: 'Symptoms & Patterns',
                description:
                    'See which symptoms you log most often and when they typically occur during your cycle.',
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
                    return [3, 4, 5, 6, 7, 8].map((int value) {
                      return PopupMenuItem<int>(
                        value: value,
                        child: Text(
                          'Last $value cycles',
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
                        'Last $_selectedCycles cycles',
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
                      const SizedBox(width: 6),
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

            const SizedBox(height: 16),

            // CARD 1: Most common symptoms
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
                    'Most common symptoms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (symptomFrequencyList.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.bubble_chart_outlined,
                              size: 44,
                              color: AppColors.primaryPink.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No symptoms logged yet',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Log symptoms in your Daily Check-in to view patterns.',
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
                    ...List.generate(symptomFrequencyList.length, (index) {
                      final item = symptomFrequencyList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == symptomFrequencyList.length - 1 ? 0 : 16,
                        ),
                        child: _buildCommonSymptomRow(
                          item.icon,
                          item.name,
                          item.percentage,
                        ),
                      );
                    }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 2: When symptoms usually occur
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
                    'When symptoms usually occur',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (symptomFrequencyList.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 44,
                              color: AppColors.primaryPurple.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No timing patterns yet',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'As you log check-ins, Bloom will analyze your symptom timing.',
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
                  else ...[
                    ...List.generate(visibleTimelineList.length, (index) {
                      final item = visibleTimelineList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == visibleTimelineList.length - 1 ? 0 : 24,
                        ),
                        child: _buildTimelineSymptomRow(
                          item.icon,
                          item.name,
                          item.subtitle,
                          item.badgeText,
                          item.badgeColor,
                        ),
                      );
                    }),
                    if (symptomFrequencyList.length > 3) ...[
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _showAllSymptoms = !_showAllSymptoms;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: AppColors.primaryPurple.withValues(alpha: 0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            _showAllSymptoms ? 'Show less' : 'View all symptoms',
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _TimingInfo _calculateTimingInfo(
    List<DailySymptom> instances,
    Map<String, DailyLog> logsById,
    Map<String, Cycle> cyclesById,
  ) {
    int duringPeriodCount = 0;
    int beforePeriodCount = 0;
    int ovulationCount = 0;
    int follicularCount = 0;

    for (final s in instances) {
      final log = logsById[s.dailyLogId];
      if (log == null) continue;

      final cycle = log.cycleId != null ? cyclesById[log.cycleId] : null;
      if (cycle != null) {
        final daysSinceStart = log.date.difference(cycle.startDate).inDays + 1;
        final periodLen = cycle.periodLength ?? 5;
        final cycleLen = cycle.cycleLength ?? 28;

        if (daysSinceStart >= 1 && daysSinceStart <= periodLen) {
          duringPeriodCount++;
        } else if (daysSinceStart >= cycleLen - 4 && daysSinceStart <= cycleLen + 1) {
          beforePeriodCount++;
        } else if (daysSinceStart >= 12 && daysSinceStart <= 16) {
          ovulationCount++;
        } else {
          follicularCount++;
        }
      } else {
        duringPeriodCount++;
      }
    }

    // Determine highest frequency phase
    if (beforePeriodCount >= duringPeriodCount &&
        beforePeriodCount >= ovulationCount &&
        beforePeriodCount >= follicularCount &&
        beforePeriodCount > 0) {
      return _TimingInfo(
        subtitle: 'Usually 1-4 days before your period',
        badgeText: 'Before period',
        badgeColor: AppColors.primaryPink,
      );
    } else if (ovulationCount >= duringPeriodCount &&
        ovulationCount >= follicularCount &&
        ovulationCount > 0) {
      return _TimingInfo(
        subtitle: 'Usually mid-cycle around ovulation',
        badgeText: 'Ovulation',
        badgeColor: Colors.deepPurple,
      );
    } else if (follicularCount > duringPeriodCount && follicularCount > 0) {
      return _TimingInfo(
        subtitle: 'Usually after period in follicular phase',
        badgeText: 'Follicular',
        badgeColor: Colors.teal,
      );
    } else {
      return _TimingInfo(
        subtitle: 'Usually during the first 1-2 days of your period',
        badgeText: 'During period',
        badgeColor: AppColors.primaryPurple,
      );
    }
  }

  Widget _buildCommonSymptomRow(IconData icon, String label, int percentage) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (percentage / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$percentage%',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSymptomRow(
    IconData icon,
    String title,
    String subtitle,
    String badgeText,
    Color badgeColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 20),
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
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getSymptomIcon(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('cramp')) return Icons.waves;
    if (lower.contains('headache') || lower.contains('migraine')) {
      return Icons.face;
    }
    if (lower.contains('bloat')) return Icons.bubble_chart;
    if (lower.contains('fatigue') || lower.contains('tired')) {
      return Icons.battery_alert;
    }
    if (lower.contains('mood')) return Icons.mood_bad;
    if (lower.contains('acne') || lower.contains('skin')) {
      return Icons.face_retouching_natural;
    }
    if (lower.contains('nausea')) return Icons.sick;
    if (lower.contains('back')) return Icons.accessibility_new;
    if (lower.contains('breast') || lower.contains('tender')) {
      return Icons.woman;
    }
    if (lower.contains('sleep') || lower.contains('insomnia')) {
      return Icons.bedtime;
    }
    if (lower.contains('dizz')) return Icons.rotate_right;
    if (lower.contains('crav')) return Icons.restaurant;
    if (lower.contains('digest')) return Icons.spa;
    return Icons.healing;
  }
}

class _SymptomFrequencyData {
  final String name;
  final IconData icon;
  final int percentage;
  final int instanceCount;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;

  const _SymptomFrequencyData({
    required this.name,
    required this.icon,
    required this.percentage,
    required this.instanceCount,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
  });
}

class _TimingInfo {
  final String subtitle;
  final String badgeText;
  final Color badgeColor;

  const _TimingInfo({
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
  });
}
