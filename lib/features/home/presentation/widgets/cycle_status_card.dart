import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CycleStatusCard extends StatelessWidget {
  final int cycleDay;
  final int daysUntilPeriod;
  final String periodDateRange;
  final String fertileWindowRange;
  final bool isPeriodLate;
  final bool isPeriodOngoing;
  final int periodDay;

  const CycleStatusCard({
    super.key,
    required this.cycleDay,
    required this.daysUntilPeriod,
    required this.periodDateRange,
    required this.fertileWindowRange,
    this.isPeriodLate = false,
    this.isPeriodOngoing = false,
    this.periodDay = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            bottom: 0,
            child: Image.asset(
              'assets/images/cycle_card_bg.png',
              width: 180,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cycle Day $cycleDay',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: AppColors.text.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPeriodLate
                      ? 'Period is ${daysUntilPeriod.abs()} ${daysUntilPeriod.abs() == 1 ? "day" : "days"} late'
                      : (isPeriodOngoing
                          ? 'Period Day $periodDay'
                          : (daysUntilPeriod == 0
                              ? 'Period expected today'
                              : 'Period in $daysUntilPeriod ${daysUntilPeriod == 1 ? "day" : "days"}')),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryPink,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPeriodOngoing
                          ? 'Upcoming Period: $periodDateRange'
                          : (isPeriodLate
                              ? 'Period: $periodDateRange (Expected)'
                              : 'Period: $periodDateRange'),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.text.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fertile window: $fertileWindowRange',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.text.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
