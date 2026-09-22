import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';

class MoodTrendsPage extends ConsumerStatefulWidget {
  const MoodTrendsPage({super.key});

  @override
  ConsumerState<MoodTrendsPage> createState() => _MoodTrendsPageState();
}

class _MoodTrendsPageState extends ConsumerState<MoodTrendsPage> {
  int _selectedCycles = 6;

  bool _isLogForCycle(DailyLog log, Cycle cycle) {
    if (log.cycleId != null && log.cycleId == cycle.id) return true;
    final logDate = DateTime(log.date.year, log.date.month, log.date.day);
    final startDate = DateTime(
      cycle.startDate.year,
      cycle.startDate.month,
      cycle.startDate.day,
    );
    final endDate = cycle.endDate != null
        ? DateTime(
            cycle.endDate!.year,
            cycle.endDate!.month,
            cycle.endDate!.day,
          )
        : startDate.add(Duration(days: (cycle.cycleLength ?? 28) - 1));
    return !logDate.isBefore(startDate) && !logDate.isAfter(endDate);
  }

  String? _normalizeMood(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.isEmpty || trimmed == 'none') return null;
    if (trimmed == 'great') return 'Great';
    if (trimmed == 'good') return 'Good';
    if (trimmed == 'okay') return 'Okay';
    if (trimmed == 'not great' || trimmed == 'not_great' || trimmed == 'notgreat') {
      return 'Not great';
    }
    if (trimmed == 'bad') return 'Bad';
    return null;
  }

  String _getPredominantMood(List<String> list) {
    final counts = <String, int>{};
    for (final m in list) {
      counts[m] = (counts[m] ?? 0) + 1;
    }
    var maxMood = list.first;
    var maxCount = -1;
    for (final entry in counts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        maxMood = entry.key;
      }
    }
    return maxMood;
  }

  (IconData, Color, String) _getMoodDisplay(String mood) {
    switch (mood) {
      case 'Great':
        return (Icons.sentiment_very_satisfied, AppColors.success, 'Great');
      case 'Good':
        return (Icons.sentiment_satisfied_alt, Colors.blue, 'Good');
      case 'Okay':
        return (Icons.sentiment_neutral, const Color(0xFFF4C059), 'Okay');
      case 'Not great':
        return (Icons.sentiment_dissatisfied, AppColors.primaryPurple, 'Not Great');
      case 'Bad':
        return (Icons.mood_bad, AppColors.primaryPink, 'Bad');
      default:
        return (Icons.sentiment_satisfied, AppColors.secondaryText, mood);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileStreamProvider).value;
    final cycles = ref.watch(allCyclesStreamProvider).value ?? [];
    final allLogs = ref.watch(allDailyLogsStreamProvider).value ?? [];

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

    final validLogs = allLogs.where((l) => !l.isDeleted).toList();

    // All mood logs belonging to the recent completed cycles
    final List<DailyLog> relevantMoodLogs = [
      for (final c in recentSubset)
        ...validLogs.where((l) =>
            _normalizeMood(l.mood) != null &&
            _isLogForCycle(l, c)),
    ];

    // Card 1: Mood distribution counts
    int greatCount = 0;
    int goodCount = 0;
    int okayCount = 0;
    int notGreatCount = 0;
    int badCount = 0;

    for (final l in relevantMoodLogs) {
      final norm = _normalizeMood(l.mood);
      if (norm == 'Great') greatCount++;
      if (norm == 'Good') goodCount++;
      if (norm == 'Okay') okayCount++;
      if (norm == 'Not great') notGreatCount++;
      if (norm == 'Bad') badCount++;
    }

    final totalMoods = relevantMoodLogs.length;
    final int greatPct;
    final int goodPct;
    final int okayPct;
    final int notGreatPct;
    final int badPct;

    if (totalMoods > 0) {
      greatPct = ((greatCount / totalMoods) * 100).round();
      goodPct = ((goodCount / totalMoods) * 100).round();
      okayPct = ((okayCount / totalMoods) * 100).round();
      notGreatPct = ((notGreatCount / totalMoods) * 100).round();
      badPct = (100 - greatPct - goodPct - okayPct - notGreatPct).clamp(0, 100);
    } else {
      greatPct = 0;
      goodPct = 0;
      okayPct = 0;
      notGreatPct = 0;
      badPct = 0;
    }

    final List<PieChartSectionData> pieSections = [];
    if (totalMoods == 0) {
      pieSections.add(
        PieChartSectionData(
          value: 1,
          color: AppColors.border.withValues(alpha: 0.5),
          radius: 16,
          showTitle: false,
        ),
      );
    } else {
      if (greatCount > 0) {
        pieSections.add(PieChartSectionData(
          value: greatCount.toDouble(),
          color: AppColors.success,
          radius: 16,
          showTitle: false,
        ));
      }
      if (goodCount > 0) {
        pieSections.add(PieChartSectionData(
          value: goodCount.toDouble(),
          color: Colors.blue,
          radius: 16,
          showTitle: false,
        ));
      }
      if (okayCount > 0) {
        pieSections.add(PieChartSectionData(
          value: okayCount.toDouble(),
          color: const Color(0xFFF4C059),
          radius: 16,
          showTitle: false,
        ));
      }
      if (notGreatCount > 0) {
        pieSections.add(PieChartSectionData(
          value: notGreatCount.toDouble(),
          color: AppColors.primaryPurple,
          radius: 16,
          showTitle: false,
        ));
      }
      if (badCount > 0) {
        pieSections.add(PieChartSectionData(
          value: badCount.toDouble(),
          color: AppColors.primaryPink,
          radius: 16,
          showTitle: false,
        ));
      }
    }

    // Card 2: Mood by cycle phase
    final List<String> beforePeriodMoods = [];
    final List<String> duringPeriodMoods = [];
    final List<String> afterPeriodMoods = [];
    final List<String> ovulationMoods = [];

    for (final c in recentSubset) {
      final cLen = c.cycleLength ?? user?.avgCycleLength ?? 28;
      final pLen = c.periodLength ?? user?.avgPeriodLength ?? 5;
      final cLogs = validLogs.where((l) =>
          _normalizeMood(l.mood) != null &&
          _isLogForCycle(l, c));

      for (final l in cLogs) {
        final mood = _normalizeMood(l.mood)!;
        final d = DateTime(l.date.year, l.date.month, l.date.day)
                .difference(DateTime(
                  c.startDate.year,
                  c.startDate.month,
                  c.startDate.day,
                ))
                .inDays +
            1;

        if (d >= 1 && d <= pLen) {
          duringPeriodMoods.add(mood);
        } else if (d >= cLen - 3 && d <= cLen + 1) {
          beforePeriodMoods.add(mood);
        } else if (d >= 12 && d <= 16) {
          ovulationMoods.add(mood);
        } else if (d > pLen && d < 12) {
          afterPeriodMoods.add(mood);
        } else {
          beforePeriodMoods.add(mood);
        }
      }
    }

    // Card 3: Dynamic insight text
    final String insightText;
    if (totalMoods == 0) {
      insightText =
          'Keep logging your daily mood to discover personalized emotional patterns across your cycle.';
    } else {
      final beforeLow =
          beforePeriodMoods.where((m) => m == 'Not great' || m == 'Bad').length;
      final duringLow =
          duringPeriodMoods.where((m) => m == 'Not great' || m == 'Bad').length;
      final afterHigh =
          afterPeriodMoods.where((m) => m == 'Great' || m == 'Good').length;

      if (beforeLow > 0 && beforeLow >= duringLow) {
        insightText = 'You tend to feel lower mood before your period.';
      } else if (duringLow > 0) {
        insightText =
            'You tend to feel lower mood during the first days of your period.';
      } else if (afterHigh > 0) {
        insightText =
            'Your mood and energy tend to peak after your period during the follicular phase.';
      } else {
        insightText =
            'Your mood remains mostly positive and stable across your cycle.';
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
          'Mood Trends',
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
                title: 'Mood Trends',
                description:
                    'Track how your mood changes across your cycle to identify patterns and emotional shifts.',
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

            // CARD 1: Mood distribution
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
                    'Mood distribution',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              startDegreeOffset: 270,
                              sections: pieSections,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLegendRow('Great', '$greatPct%', AppColors.success),
                            const SizedBox(height: 8),
                            _buildLegendRow('Good', '$goodPct%', Colors.blue),
                            const SizedBox(height: 8),
                            _buildLegendRow('Okay', '$okayPct%', const Color(0xFFF4C059)),
                            const SizedBox(height: 8),
                            _buildLegendRow(
                                'Not Great', '$notGreatPct%', AppColors.primaryPurple),
                            const SizedBox(height: 8),
                            _buildLegendRow('Bad', '$badPct%', AppColors.primaryPink),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 2: Mood by cycle phase (average)
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
                    'Mood by cycle phase (average)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (beforePeriodMoods.isEmpty &&
                      duringPeriodMoods.isEmpty &&
                      afterPeriodMoods.isEmpty &&
                      ovulationMoods.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.sentiment_satisfied_outlined,
                              size: 44,
                              color: AppColors.primaryPurple.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No mood patterns yet',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Log your mood in daily check-ins to see how your cycle affects how you feel.',
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
                    if (beforePeriodMoods.isNotEmpty) ...[
                      () {
                        final mood = _getPredominantMood(beforePeriodMoods);
                        final display = _getMoodDisplay(mood);
                        return _buildTimelineMoodRow(
                          display.$1,
                          display.$3,
                          'Usually 1-4 days before your period',
                          'Before period',
                          display.$2,
                        );
                      }(),
                    ],
                    if (duringPeriodMoods.isNotEmpty) ...[
                      if (beforePeriodMoods.isNotEmpty) const SizedBox(height: 24),
                      () {
                        final mood = _getPredominantMood(duringPeriodMoods);
                        final display = _getMoodDisplay(mood);
                        return _buildTimelineMoodRow(
                          display.$1,
                          display.$3,
                          'Usually during the first days of your period',
                          'During period',
                          display.$2,
                        );
                      }(),
                    ],
                    if (afterPeriodMoods.isNotEmpty) ...[
                      if (beforePeriodMoods.isNotEmpty || duringPeriodMoods.isNotEmpty)
                        const SizedBox(height: 24),
                      () {
                        final mood = _getPredominantMood(afterPeriodMoods);
                        final display = _getMoodDisplay(mood);
                        return _buildTimelineMoodRow(
                          display.$1,
                          display.$3,
                          'Usually 2-5 days after your period',
                          'After period',
                          display.$2,
                        );
                      }(),
                    ],
                    if (ovulationMoods.isNotEmpty) ...[
                      if (beforePeriodMoods.isNotEmpty ||
                          duringPeriodMoods.isNotEmpty ||
                          afterPeriodMoods.isNotEmpty)
                        const SizedBox(height: 24),
                      () {
                        final mood = _getPredominantMood(ovulationMoods);
                        final display = _getMoodDisplay(mood);
                        return _buildTimelineMoodRow(
                          display.$1,
                          display.$3,
                          'Usually mid-cycle around ovulation',
                          'Ovulation',
                          display.$2,
                        );
                      }(),
                    ],
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 3: Your insight
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your insight',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 110.0),
                        child: Text(
                          insightText,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/low_mood_avatar_white_edited.jpg',
                      height: 100,
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

  Widget _buildLegendRow(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineMoodRow(
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
            color: badgeColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: badgeColor, size: 20),
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
}
