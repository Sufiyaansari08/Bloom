import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';

class InsightsHeroCard extends ConsumerWidget {
  const InsightsHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);
    final user = userAsync.value;
    final cyclesAsync = ref.watch(allCyclesStreamProvider);
    final cycles = cyclesAsync.value ?? [];

    // Filter completed cycles
    final completedCycles = cycles
        .where(
          (c) =>
              !c.isDeleted &&
              c.endDate != null &&
              c.cycleLength != null &&
              c.cycleLength! > 0,
        )
        .toList();
    completedCycles.sort((a, b) => b.startDate.compareTo(a.startDate));

    final recentCompleted = completedCycles.take(6).toList();

    // 1. Average Cycle Length: Real average if completed cycles exist, else onboarding baseline
    final int avgCycleLength;
    if (recentCompleted.isNotEmpty) {
      avgCycleLength =
          (recentCompleted.map((c) => c.cycleLength!).reduce((a, b) => a + b) /
                  recentCompleted.length)
              .round();
    } else {
      avgCycleLength = user?.avgCycleLength ?? 28;
    }

    // 2. Average Period Length: Real average if recorded, else onboarding baseline
    final int avgPeriodLength;
    final periodLengths = recentCompleted
        .where((c) => c.periodLength != null && c.periodLength! > 0)
        .map((c) => c.periodLength!)
        .toList();
    if (periodLengths.isNotEmpty) {
      avgPeriodLength =
          (periodLengths.reduce((a, b) => a + b) / periodLengths.length)
              .round();
    } else {
      avgPeriodLength = user?.avgPeriodLength ?? 5;
    }

    // 3. Cycle Variation (Option B) & Adaptive Headline
    final String variationValue;
    final String headline;

    if (recentCompleted.length < 2) {
      variationValue = '±0';
      if (recentCompleted.isEmpty) {
        headline = 'Tracking your\nfirst cycles\nwith Bloom';
      } else {
        headline = 'Building your\npersonal cycle\nbaseline';
      }
    } else {
      final mean = avgCycleLength.toDouble();
      final devSum = recentCompleted
          .map((c) => (c.cycleLength! - mean).abs())
          .reduce((a, b) => a + b);
      final variation = (devSum / recentCompleted.length).round();
      variationValue = '±$variation';

      if (variation <= 2) {
        headline = 'Your cycle is\nconsistent and\nregular';
      } else if (variation <= 4) {
        headline = 'Your cycle is\nwithin typical\nhealthy range';
      } else {
        headline = 'Your cycle length\nvaries by a\nfew days';
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          // Top Section: Title and Image
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 24, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        headline,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/welcome_illustration.png',
                      width: 115,
                      height: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Section: Floating Stats Box
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn('Average cycle', '$avgCycleLength', 'days'),
                _buildStatColumn('Average period', '$avgPeriodLength', 'days'),
                _buildStatColumn('Cycle variation', variationValue, 'days'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
