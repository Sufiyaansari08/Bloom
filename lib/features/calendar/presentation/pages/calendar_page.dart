import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../providers/calendar_provider.dart';
import '../widgets/bloom_calendar.dart';
import '../widgets/daily_summary_card.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);
    final userAsync = ref.watch(userProfileStreamProvider);

    final user = userAsync.value;
    final isPeriodPredictionEnabled = user?.periodPredictionEnabled ?? true;
    final isFertileWindowEnabled = user?.fertileWindowEnabled ?? true;
    final isOvulationEnabled = user?.ovulationPredictionEnabled ?? true;

    final isPeriodDay = state.periodDays.any((d) => isSameDay(d, state.selectedDay)) ||
        (isPeriodPredictionEnabled && state.expectedPeriodDays.any((d) => isSameDay(d, state.selectedDay)));
    final isFertileDay = isFertileWindowEnabled && state.fertileDays.any((d) => isSameDay(d, state.selectedDay));

    final showPeriodSummary = isPeriodPredictionEnabled && state.expectedPeriodDays.isNotEmpty;
    final showFertileSummary = isFertileWindowEnabled && state.fertileDays.isNotEmpty;
    final showOvulationSummary = isOvulationEnabled && state.ovulationDay != null;
    final hasAnySummary = showPeriodSummary || showFertileSummary || showOvulationSummary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // Padding for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calendar',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: AppColors.text,
                    ),
                    onPressed: () {
                      context.push('/reminders');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              BloomCalendar(
                focusedDay: state.focusedDay,
                selectedDay: state.selectedDay,
                periodDays: state.periodDays,
                expectedPeriodDays: isPeriodPredictionEnabled ? state.expectedPeriodDays : const [],
                fertileDays: isFertileWindowEnabled ? state.fertileDays : const [],
                ovulationDays: isOvulationEnabled ? state.ovulationDays : const [],
                ovulationDay: isOvulationEnabled ? state.ovulationDay : null,
                onDaySelected: notifier.onDaySelected,
                onPageChanged: notifier.onPageChanged,
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    if (state.periodDays.isNotEmpty || (isPeriodPredictionEnabled && state.expectedPeriodDays.isNotEmpty))
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryPink, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Period', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                        ],
                      ),
                    if (isFertileWindowEnabled && state.fertileDays.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Fertility', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                        ],
                      ),
                    if (isOvulationEnabled && state.ovulationDay != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Ovulation', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                        ],
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.lightPink,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('Today', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Daily Summary',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 16),
              DailySummaryCard(
                date: state.selectedDay,
                isPeriodDay: isPeriodDay,
                isFertileDay: isFertileDay,
                checkinData: ref.watch(dailyCheckinForSelectedDayProvider).value,
              ),
              const SizedBox(height: 32),
              Text(
                'Menstrual Summary',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 16),
              if (hasAnySummary)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      if (showPeriodSummary && state.nextPeriodStartDate != null) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPink.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.water_drop, color: AppColors.primaryPink, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Period expected ${state.nextPeriodStartDate!.day}-${(state.nextPeriodEndDate ?? state.nextPeriodStartDate!.add(const Duration(days: 4))).day} ${_getMonthName(state.nextPeriodStartDate!.month)}',
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (showFertileSummary) ...[
                        if (showPeriodSummary && state.nextPeriodStartDate != null) const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite_border, color: Colors.green, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final now = DateTime.now();
                                  final today = DateTime(now.year, now.month, now.day);
                                  final upcoming = state.fertileDays.where((d) => !d.isBefore(today.subtract(const Duration(days: 5)))).toList();
                                  final fStart = upcoming.isNotEmpty ? upcoming.first : state.fertileDays.first;
                                  final fEnd = upcoming.isNotEmpty ? upcoming.last : state.fertileDays.last;
                                  return Text(
                                    'Fertile window ${fStart.day}-${fEnd.day} ${_getMonthName(fStart.month)}',
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (showOvulationSummary && state.ovulationDay != null) ...[
                        if ((showPeriodSummary && state.nextPeriodStartDate != null) || showFertileSummary)
                          const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Ovulation expected on ${state.ovulationDay!.day} ${_getMonthName(state.ovulationDay!.month)}',
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.visibility_off_outlined, color: AppColors.secondaryText, size: 28),
                      SizedBox(height: 8),
                      Text(
                        'Predictions Disabled',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Period, fertility, and ovulation forecasts are turned off. You can re-enable them anytime in App Settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
