import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';

class CyclePatternsPage extends ConsumerStatefulWidget {
  const CyclePatternsPage({super.key});

  @override
  ConsumerState<CyclePatternsPage> createState() => _CyclePatternsPageState();
}

class _CyclePatternsPageState extends ConsumerState<CyclePatternsPage> {
  int _selectedCycles = 6;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileStreamProvider).value;
    final cycles = ref.watch(allCyclesStreamProvider).value ?? [];

    // Filter completed cycles
    final completedCycles = cycles
        .where((c) =>
            !c.isDeleted &&
            c.endDate != null &&
            c.cycleLength != null &&
            c.cycleLength! > 0)
        .toList();
    // Chronological order (oldest to newest) for chart display
    completedCycles.sort((a, b) => a.startDate.compareTo(b.startDate));

    // Take the most recent _selectedCycles
    final recentSubset = completedCycles.length > _selectedCycles
        ? completedCycles.sublist(completedCycles.length - _selectedCycles)
        : completedCycles;

    final int averageCycle;
    final int shortestCycle;
    final int longestCycle;
    final int averagePeriod;
    final String variationValue;
    final String consistencyText;
    final double consistencyProgress;
    final String aboutText;

    if (recentSubset.isNotEmpty) {
      final lengths = recentSubset.map((c) => c.cycleLength!).toList();
      averageCycle = (lengths.reduce((a, b) => a + b) / lengths.length).round();
      shortestCycle = lengths.reduce((a, b) => a < b ? a : b);
      longestCycle = lengths.reduce((a, b) => a > b ? a : b);

      final periodLengths = recentSubset
          .where((c) => c.periodLength != null && c.periodLength! > 0)
          .map((c) => c.periodLength!)
          .toList();
      if (periodLengths.isNotEmpty) {
        averagePeriod =
            (periodLengths.reduce((a, b) => a + b) / periodLengths.length)
                .round();
      } else {
        averagePeriod = user?.avgPeriodLength ?? 5;
      }

      if (recentSubset.length < 2) {
        variationValue = '±0';
        consistencyText = 'Building your cycle baseline.';
        consistencyProgress = 1.0;
        aboutText =
            'You have 1 cycle recorded ($averageCycle days). Continued tracking will uncover your personalized patterns.';
      } else {
        final mean = averageCycle.toDouble();
        final devSum = recentSubset
            .map((c) => (c.cycleLength! - mean).abs())
            .reduce((a, b) => a + b);
        final variation = (devSum / recentSubset.length).round();
        variationValue = '±$variation';

        if (variation <= 2) {
          consistencyText = 'Your cycles are very regular and consistent.';
          consistencyProgress = 0.95;
        } else if (variation <= 4) {
          consistencyText = 'Your cycles are fairly consistent.';
          consistencyProgress = 0.80;
        } else {
          consistencyText = 'Your cycle length varies from month to month.';
          consistencyProgress = 0.55;
        }

        final diff = longestCycle - shortestCycle;
        if (diff == 0) {
          aboutText =
              'All your tracked cycles have a consistent length of $averageCycle days.';
        } else if (diff <= 3) {
          aboutText =
              'Your cycle length has been stable with small variations between $shortestCycle and $longestCycle days.';
        } else {
          aboutText =
              'Your cycles range between $shortestCycle and $longestCycle days (${diff} days difference).';
        }
      }
    } else {
      // Zero completed cycles: strictly use onboarding baseline
      averageCycle = user?.avgCycleLength ?? 28;
      shortestCycle = user?.avgCycleLength ?? 28;
      longestCycle = user?.avgCycleLength ?? 28;
      averagePeriod = user?.avgPeriodLength ?? 5;
      variationValue = '±0';
      consistencyText = 'Tracking your first cycles with Bloom.';
      consistencyProgress = 1.0;
      aboutText =
          'Your baseline cycle length is currently set to $averageCycle days based on your onboarding profile.';
    }

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

    final double chartMaxY = recentSubset.isEmpty
        ? 35.0
        : math.max(longestCycle.toDouble() + 5.0, 35.0);

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
          'Cycle Patterns',
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
                title: 'Cycle Patterns',
                description:
                    'Review the lengths of your previous cycles to understand variations and establish a baseline.',
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

            // CARD 1: Average Cycle Length with Bar Chart
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
                    'Average cycle length',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$averageCycle',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'days',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: chartMaxY,
                        gridData: const FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 7,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 7,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: recentSubset.isNotEmpty,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt() - 1;
                                if (idx < 0 || idx >= recentSubset.length) {
                                  return const SizedBox.shrink();
                                }
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  child: Text(
                                    'C${idx + 1}',
                                    style: const TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: recentSubset.isEmpty
                            ? const []
                            : List.generate(recentSubset.length, (index) {
                                final c = recentSubset[index];
                                return _buildBarData(
                                  index + 1,
                                  c.cycleLength!.toDouble(),
                                );
                              }),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ROW 2: 3 Small Stat Boxes
            Row(
              children: [
                _buildSmallStatBox('Shortest cycle', '$shortestCycle'),
                const SizedBox(width: 8),
                _buildSmallStatBox('Longest cycle', '$longestCycle'),
                const SizedBox(width: 8),
                _buildSmallStatBox('Average period', '$averagePeriod'),
              ],
            ),

            const SizedBox(height: 16),

            // CARD 2: Cycle Variation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cycle variation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              variationValue,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'days',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          consistencyText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 8,
                          color: AppColors.border,
                        ),
                        CircularProgressIndicator(
                          value: consistencyProgress,
                          strokeWidth: 8,
                          color: AppColors.primaryPurple,
                          strokeCap: StrokeCap.round,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 3: About your cycles
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About your cycles',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          aboutText,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.local_florist,
                    color: AppColors.primaryPink.withValues(alpha: 0.5),
                    size: 48,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStatBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(width: 2),
                const Text(
                  'days',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primaryPink,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
