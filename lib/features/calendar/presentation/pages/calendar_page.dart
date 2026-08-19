import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/calendar_provider.dart';
import '../../../checkin/presentation/providers/checkin_history_provider.dart';
import '../widgets/bloom_calendar.dart';
import '../widgets/daily_summary_card.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);

    final isPeriodDay = state.periodDays.any((d) => isSameDay(d, state.selectedDay));
    final isFertileDay = state.fertileDays.any((d) => isSameDay(d, state.selectedDay));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // Padding for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 24),
              BloomCalendar(
                focusedDay: state.focusedDay,
                selectedDay: state.selectedDay,
                periodDays: state.periodDays,
                fertileDays: state.fertileDays,
                ovulationDay: state.ovulationDay ?? 
                    (state.fertileDays.isNotEmpty ? state.fertileDays[state.fertileDays.length ~/ 2] : null),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryPink, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('Period', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('Fertility', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      ],
                    ),
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
                checkinData: ref.watch(checkinHistoryProvider)[DateTime.utc(state.selectedDay.year, state.selectedDay.month, state.selectedDay.day)],
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    if (state.periodDays.isNotEmpty) ...[
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
                              'Period expected ${state.periodDays.first.day}-${state.periodDays.last.day} ${_getMonthName(state.periodDays.first.month)}',
                              style: const TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (state.fertileDays.isNotEmpty) ...[
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
                            child: Text(
                              'Fertile window ${state.fertileDays.first.day}-${state.fertileDays.last.day} ${_getMonthName(state.fertileDays.first.month)}',
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
                    if (state.ovulationDay != null || state.fertileDays.isNotEmpty) ...[
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
                              'Ovulation expected on ${(state.ovulationDay ?? state.fertileDays[state.fertileDays.length ~/ 2]).day} ${_getMonthName((state.ovulationDay ?? state.fertileDays[state.fertileDays.length ~/ 2]).month)}',
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
