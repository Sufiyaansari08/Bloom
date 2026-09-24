import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';

class PainInsightsPage extends ConsumerStatefulWidget {
  const PainInsightsPage({super.key});

  @override
  ConsumerState<PainInsightsPage> createState() => _PainInsightsPageState();
}

class _PainInsightsPageState extends ConsumerState<PainInsightsPage> {
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileStreamProvider).value;
    final cycles = ref.watch(allCyclesStreamProvider).value ?? [];
    final allLogs = ref.watch(allDailyLogsStreamProvider).value ?? [];

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

    // Calculate cycle or weekly pain averages and spots for the line chart
    final List<double> cycleAverages = [];
    final List<FlSpot> spots = [];
    final Map<int, double> cyclesWithPain = {};
    int chartMaxX = _selectedCycles;

    if (_selectedCycles == 1) {
      if (currentCycle != null) {
        final int avgCompletedLen = completedCycles.isNotEmpty
            ? (completedCycles
                        .map((c) => c.cycleLength ?? 28)
                        .reduce((a, b) => a + b) /
                    completedCycles.length)
                .round()
            : (user?.avgCycleLength ?? 28);
        final int declaredLen = user?.avgCycleLength ?? 28;
        final int currentLen = currentCycle.cycleLength ?? 0;
        final int effectiveCycleLen =
            math.max(currentLen, math.max(avgCompletedLen, declaredLen));

        // Allow 5 or 6 weeks only if the user's cycle length is 36-37+ days (or 29-35 days for 5 weeks)
        final int maxCycleWeeks;
        if (effectiveCycleLen >= 36) {
          maxCycleWeeks = 6;
        } else if (effectiveCycleLen >= 29) {
          maxCycleWeeks = 5;
        } else {
          maxCycleWeeks = 4;
        }

        final cLogs = validLogs
            .where((l) =>
                l.painLevel != null &&
                l.painLevel! > 0 &&
                _isLogForCycle(l, currentCycle))
            .toList();

        final Map<int, List<int>> weekPainMap = {};
        for (final l in cLogs) {
          final d = DateTime(l.date.year, l.date.month, l.date.day)
                  .difference(DateTime(
                    currentCycle.startDate.year,
                    currentCycle.startDate.month,
                    currentCycle.startDate.day,
                  ))
                  .inDays +
              1;
          final w = math.max(1, math.min(maxCycleWeeks, ((d - 1) ~/ 7) + 1));
          weekPainMap.putIfAbsent(w, () => []).add(l.painLevel!);
        }

        chartMaxX = maxCycleWeeks;

        if (cLogs.isNotEmpty) {
          for (int w = 1; w <= maxCycleWeeks; w++) {
            if (weekPainMap.containsKey(w)) {
              final wAvg = weekPainMap[w]!.reduce((a, b) => a + b) /
                  weekPainMap[w]!.length;
              final rounded = double.parse(wAvg.toStringAsFixed(1));
              spots.add(FlSpot(w.toDouble(), rounded));
              cyclesWithPain[w] = rounded;
            } else {
              spots.add(FlSpot(w.toDouble(), 0.0));
            }
          }
        }
      } else {
        chartMaxX = 4;
      }
    } else {
      for (int i = 0; i < targetedCycles.length; i++) {
        final c = targetedCycles[i];
        final cLogs = validLogs
            .where((l) =>
                l.painLevel != null &&
                l.painLevel! > 0 &&
                _isLogForCycle(l, c))
            .toList();

        if (cLogs.isNotEmpty) {
          final cAvg = cLogs.map((l) => l.painLevel!).reduce((a, b) => a + b) /
              cLogs.length;
          final rounded = double.parse(cAvg.toStringAsFixed(1));
          cycleAverages.add(rounded);
          spots.add(FlSpot((i + 1).toDouble(), rounded));
          cyclesWithPain[i + 1] = rounded;
        } else {
          cycleAverages.add(0.0);
          spots.add(FlSpot((i + 1).toDouble(), 0.0));
        }
      }
    }

    // All pain logs belonging to targeted cycles
    final List<DailyLog> allRecentPainLogs = [
      for (final c in targetedCycles)
        ...validLogs.where((l) =>
            l.painLevel != null &&
            l.painLevel! > 0 &&
            _isLogForCycle(l, c)),
    ];

    // Card 1: Average pain score
    final double overallAveragePain;
    final String averagePainStr;
    if (allRecentPainLogs.isNotEmpty) {
      overallAveragePain = allRecentPainLogs
              .map((l) => l.painLevel!)
              .reduce((a, b) => a + b) /
          allRecentPainLogs.length;
      averagePainStr = overallAveragePain.toStringAsFixed(1);
    } else {
      overallAveragePain = 0.0;
      averagePainStr = '0.0';
    }

    // Row 2: 3 Small Stat Boxes
    final String highestPainVal;
    final String highestPainSub;
    final String lowestPainVal;
    final String lowestPainSub;
    final String mostPainfulVal;
    final String mostPainfulSub;

    if (cyclesWithPain.isNotEmpty) {
      var maxEntry = cyclesWithPain.entries.first;
      var minEntry = cyclesWithPain.entries.first;
      for (final entry in cyclesWithPain.entries) {
        if (entry.value > maxEntry.value) maxEntry = entry;
        if (entry.value < minEntry.value) minEntry = entry;
      }
      highestPainVal = maxEntry.value.toStringAsFixed(1);
      highestPainSub = _selectedCycles == 1 ? 'Week ${maxEntry.key}' : 'Cycle ${maxEntry.key}';
      lowestPainVal = minEntry.value.toStringAsFixed(1);
      lowestPainSub = _selectedCycles == 1 ? 'Week ${minEntry.key}' : 'Cycle ${minEntry.key}';

      // Most painful cycle day calculation
      final Map<int, List<int>> painByCycleDay = {};
      for (final c in targetedCycles) {
        final cLogs = validLogs.where((l) =>
            l.painLevel != null &&
            l.painLevel! > 0 &&
            _isLogForCycle(l, c));
        for (final l in cLogs) {
          final day = DateTime(l.date.year, l.date.month, l.date.day)
                  .difference(DateTime(
                    c.startDate.year,
                    c.startDate.month,
                    c.startDate.day,
                  ))
                  .inDays +
              1;
          if (day >= 1) {
            painByCycleDay.putIfAbsent(day, () => []).add(l.painLevel!);
          }
        }
      }

      if (painByCycleDay.isNotEmpty) {
        int mostPainfulDay = 1;
        double maxDayAvg = -1.0;
        for (final entry in painByCycleDay.entries) {
          final avg =
              entry.value.reduce((a, b) => a + b) / entry.value.length;
          if (avg > maxDayAvg) {
            maxDayAvg = avg;
            mostPainfulDay = entry.key;
          }
        }
        final periodLen = user?.avgPeriodLength ?? 5;
        mostPainfulVal = 'Day $mostPainfulDay';
        mostPainfulSub = mostPainfulDay <= periodLen ? 'of period' : 'of cycle';
      } else {
        mostPainfulVal = '--';
        mostPainfulSub = 'No data';
      }
    } else {
      highestPainVal = '--';
      highestPainSub = 'No data';
      lowestPainVal = '--';
      lowestPainSub = 'No data';
      mostPainfulVal = '--';
      mostPainfulSub = 'No data';
    }

    // Card 2: Pain by phase (average)
    final List<int> beforePeriodPain = [];
    final List<int> duringPeriodPain = [];
    final List<int> afterPeriodPain = [];
    final List<int> ovulationPain = [];

    for (final c in targetedCycles) {
      final cLen = c.cycleLength ?? user?.avgCycleLength ?? 28;
      final pLen = c.periodLength ?? user?.avgPeriodLength ?? 5;
      final cLogs = validLogs.where((l) =>
          l.painLevel != null &&
          l.painLevel! > 0 &&
          _isLogForCycle(l, c));

      for (final l in cLogs) {
        final d = DateTime(l.date.year, l.date.month, l.date.day)
                .difference(DateTime(
                  c.startDate.year,
                  c.startDate.month,
                  c.startDate.day,
                ))
                .inDays +
            1;

        final hasFlow = l.flowIntensity != null &&
            l.flowIntensity!.isNotEmpty &&
            l.flowIntensity != 'None';

        if (hasFlow || (d >= 1 && d <= pLen)) {
          duringPeriodPain.add(l.painLevel!);
        } else if (d >= cLen - 3 && d <= cLen + 1) {
          beforePeriodPain.add(l.painLevel!);
        } else if (d >= 12 && d <= 16) {
          ovulationPain.add(l.painLevel!);
        } else if (d > pLen && d < 12) {
          afterPeriodPain.add(l.painLevel!);
        } else {
          beforePeriodPain.add(l.painLevel!);
        }
      }
    }

    double calcPhaseAvg(List<int> list) {
      if (list.isEmpty) return 0.0;
      return list.reduce((a, b) => a + b) / list.length;
    }

    final beforeAvg = calcPhaseAvg(beforePeriodPain);
    final duringAvg = calcPhaseAvg(duringPeriodPain);
    final afterAvg = calcPhaseAvg(afterPeriodPain);
    final ovulationAvg = calcPhaseAvg(ovulationPain);

    // Card 3: Pain intensity distribution
    int mildCount = 0;
    int moderateCount = 0;
    int severeCount = 0;
    int verySevereCount = 0;

    for (final l in allRecentPainLogs) {
      final p = l.painLevel!;
      if (p <= 3) {
        mildCount++;
      } else if (p <= 6) {
        moderateCount++;
      } else if (p <= 8) {
        severeCount++;
      } else {
        verySevereCount++;
      }
    }

    final totalPainLogs = allRecentPainLogs.length;
    final int mildPct;
    final int moderatePct;
    final int severePct;
    final int verySeverePct;
    if (totalPainLogs > 0) {
      mildPct = ((mildCount / totalPainLogs) * 100).round();
      moderatePct = ((moderateCount / totalPainLogs) * 100).round();
      severePct = ((severeCount / totalPainLogs) * 100).round();
      verySeverePct = (100 - mildPct - moderatePct - severePct).clamp(0, 100);
    } else {
      mildPct = 0;
      moderatePct = 0;
      severePct = 0;
      verySeverePct = 0;
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
          'Pain Insights',
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
                title: 'Pain Insights',
                description:
                    'Analyze your pain levels to understand severity and duration throughout your cycle phases.',
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
            const SizedBox(height: 16),

            // CARD 1: Average pain score with Line Chart
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
                    'Average pain score',
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
                        averagePainStr,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '/ 10',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPainCategoryColor(overallAveragePain)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getPainCategoryText(overallAveragePain),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPainCategoryColor(overallAveragePain),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 150,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              color: AppColors.border,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 2,
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
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final intVal = value.toInt();
                                if (intVal >= 1 &&
                                    intVal <= chartMaxX &&
                                    value == intVal.toDouble()) {
                                  final label = _selectedCycles == 1
                                      ? 'W$intVal'
                                      : 'C$intVal';
                                  return SideTitleWidget(
                                    meta: meta,
                                    space: 8,
                                    child: Text(
                                      label,
                                      style: const TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 1,
                        maxX: chartMaxX.toDouble(),
                        minY: 0,
                        maxY: 10,
                        lineBarsData: spots.isEmpty
                            ? []
                            : [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: spots.length > 1,
                                  color: AppColors.primaryPink,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 4,
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        strokeColor: AppColors.primaryPink,
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.primaryPink
                                        .withValues(alpha: 0.1),
                                  ),
                                ),
                              ],
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
                _buildSmallStatBox('Highest pain', highestPainVal, highestPainSub),
                const SizedBox(width: 8),
                _buildSmallStatBox('Lowest pain', lowestPainVal, lowestPainSub),
                const SizedBox(width: 8),
                _buildSmallStatBox('Most painful', mostPainfulVal, mostPainfulSub),
              ],
            ),

            const SizedBox(height: 16),

            // CARD 2: Pain by phase (average)
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
                    'Pain by phase (average)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPhasePainRow('Before period', beforeAvg),
                  const SizedBox(height: 16),
                  _buildPhasePainRow('During period', duringAvg),
                  const SizedBox(height: 16),
                  _buildPhasePainRow('After period', afterAvg),
                  const SizedBox(height: 16),
                  _buildPhasePainRow('Ovulation time', ovulationAvg),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 3: Pain intensity distribution
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
                    'Pain intensity distribution',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stacked Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: totalPainLogs == 0
                        ? Container(
                            height: 16,
                            color: AppColors.border.withValues(alpha: 0.5),
                          )
                        : Row(
                            children: [
                              if (mildCount > 0)
                                Expanded(
                                  flex: math.max(mildPct, 1),
                                  child: Container(
                                    height: 16,
                                    color: AppColors.success,
                                  ),
                                ),
                              if (moderateCount > 0)
                                Expanded(
                                  flex: math.max(moderatePct, 1),
                                  child: Container(
                                    height: 16,
                                    color: const Color(0xFFF4C059),
                                  ),
                                ),
                              if (severeCount > 0)
                                Expanded(
                                  flex: math.max(severePct, 1),
                                  child: Container(
                                    height: 16,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              if (verySevereCount > 0)
                                Expanded(
                                  flex: math.max(verySeverePct, 1),
                                  child: Container(
                                    height: 16,
                                    color: AppColors.primaryPink,
                                  ),
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendItem('Mild', '$mildPct%', AppColors.success),
                      _buildLegendItem(
                          'Moderate', '$moderatePct%', const Color(0xFFF4C059)),
                      _buildLegendItem(
                          'Severe', '$severePct%', AppColors.primaryPurple),
                      _buildLegendItem(
                          'V.Severe', '$verySeverePct%', AppColors.primaryPink),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPainCategoryColor(double score) {
    if (score == 0.0) return AppColors.secondaryText;
    if (score <= 3.0) return AppColors.success;
    if (score <= 6.0) return const Color(0xFFF4C059);
    if (score <= 8.0) return AppColors.primaryPurple;
    return AppColors.primaryPink;
  }

  String _getPainCategoryText(double score) {
    if (score == 0.0) return 'No Pain Logged';
    if (score <= 3.0) return 'Mild';
    if (score <= 6.0) return 'Moderate';
    if (score <= 8.0) return 'Severe';
    return 'Very Severe';
  }

  Widget _buildSmallStatBox(String title, String value, String subtitle) {
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
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhasePainRow(String label, double score) {
    final color = _getPainCategoryColor(score);
    final widthFactor = (score / 10.0).clamp(0.0, 1.0);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: score > 0 ? color : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            score.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
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
}
