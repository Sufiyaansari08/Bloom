import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../providers/calendar_provider.dart';
import '../widgets/bloom_calendar.dart';
import '../widgets/daily_summary_card.dart';
import 'package:bloom/features/period_logging/presentation/widgets/period_flow_pain_bottom_sheet.dart';
import 'package:bloom/features/checkin/presentation/providers/daily_checkin_provider.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);
    final userAsync = ref.watch(userProfileStreamProvider);
    final allDailyLogsAsync = ref.watch(allDailyLogsStreamProvider);

    final user = userAsync.value;
    final allDailyLogs = allDailyLogsAsync.value ?? [];
    final isPeriodPredictionEnabled = user?.periodPredictionEnabled ?? true;
    final isFertileWindowEnabled = user?.fertileWindowEnabled ?? true;
    final isOvulationEnabled = user?.ovulationPredictionEnabled ?? true;

    final selectedDayClean = DateTime(state.selectedDay.year, state.selectedDay.month, state.selectedDay.day);
    final selectedDayLogs = allDailyLogs.where((l) {
      final d = DateTime(l.date.year, l.date.month, l.date.day);
      return d.isAtSameMomentAs(selectedDayClean);
    }).toList();
    final logWithFlow = selectedDayLogs.where((l) => l.flowIntensity != null && l.flowIntensity != 'None').firstOrNull;
    final isLoggedPeriodDay = logWithFlow != null;
    final loggedFlow = logWithFlow?.flowIntensity;

    final allCyclesAsync = ref.watch(allCyclesStreamProvider);
    final allCycles = allCyclesAsync.value ?? [];

    int? cycleDayForSelected;
    bool isCycleStartForSelected = false;

    // 1. Gather all official database cycle starts
    final List<DateTime> cycleStarts = allCycles
        .map((c) => DateTime(c.startDate.year, c.startDate.month, c.startDate.day))
        .toList();

    // 2. Discover "missing" cycles from daily logs that were never closed in DB
    final loggedPeriodDates = allDailyLogs
        .where((l) => l.flowIntensity != null && l.flowIntensity != 'None')
        .map((l) => DateTime(l.date.year, l.date.month, l.date.day))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    if (loggedPeriodDates.isNotEmpty) {
      DateTime currentPeriodStart = loggedPeriodDates.first;
      if (!cycleStarts.contains(currentPeriodStart)) cycleStarts.add(currentPeriodStart);

      for (int i = 1; i < loggedPeriodDates.length; i++) {
        final d = loggedPeriodDates[i];
        if (d.difference(currentPeriodStart).inDays >= 12) {
          currentPeriodStart = d;
          if (!cycleStarts.contains(currentPeriodStart)) cycleStarts.add(currentPeriodStart);
        }
      }
    }

    cycleStarts.sort((a, b) => a.compareTo(b));

    // 3. Find which cycle the selectedDay belongs to
    for (int i = 0; i < cycleStarts.length; i++) {
      final start = cycleStarts[i];
      final nextStart = (i + 1 < cycleStarts.length) ? cycleStarts[i + 1] : null;

      if (!selectedDayClean.isBefore(start) && (nextStart == null || selectedDayClean.isBefore(nextStart))) {
        final diff = selectedDayClean.difference(start).inDays;
        cycleDayForSelected = diff + 1;
        isCycleStartForSelected = (diff == 0);
        break;
      }
    }

    int? periodDayForSelected;
    if (isLoggedPeriodDay) {
      int count = 1;
      DateTime check = selectedDayClean.subtract(const Duration(days: 1));
      while (allDailyLogs.any((l) =>
          DateUtils.isSameDay(l.date, check) &&
          l.flowIntensity != null &&
          l.flowIntensity != 'None' &&
          l.flowIntensity!.isNotEmpty)) {
        count++;
        check = check.subtract(const Duration(days: 1));
      }
      periodDayForSelected = count;
    } else {
      DateTime prevDay = selectedDayClean.subtract(const Duration(days: 1));
      final prevHadFlow = allDailyLogs.any((l) =>
          DateUtils.isSameDay(l.date, prevDay) &&
          l.flowIntensity != null &&
          l.flowIntensity != 'None' &&
          l.flowIntensity!.isNotEmpty);
      if (prevHadFlow) {
        int count = 2;
        DateTime check = prevDay.subtract(const Duration(days: 1));
        while (allDailyLogs.any((l) =>
            DateUtils.isSameDay(l.date, check) &&
            l.flowIntensity != null &&
            l.flowIntensity != 'None' &&
            l.flowIntensity!.isNotEmpty)) {
          count++;
          check = check.subtract(const Duration(days: 1));
        }
        periodDayForSelected = count;
      }
    }

    final isPeriodDay = state.periodDays.any((d) => isSameDay(d, state.selectedDay)) ||
        (isPeriodPredictionEnabled && state.expectedPeriodDays.any((d) => isSameDay(d, state.selectedDay)));
    final isFertileDay = isFertileWindowEnabled && state.fertileDays.any((d) => isSameDay(d, state.selectedDay));
    final isOvulationDay = isOvulationEnabled &&
        ((state.ovulationDay != null && isSameDay(state.ovulationDay!, state.selectedDay)) ||
            state.ovulationDays.any((d) => isSameDay(d, state.selectedDay)));

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
                isLoggedPeriodDay: isLoggedPeriodDay,
                loggedFlow: loggedFlow,
                isFertileDay: isFertileDay,
                isOvulationDay: isOvulationDay,
                cycleDay: cycleDayForSelected,
                periodDay: periodDayForSelected,
                isCycleStart: isCycleStartForSelected,
                isPeriodLate: state.isPeriodLate,
                daysLate: state.daysLate,
                expectedPeriodDate: state.nextPeriodStartDate,
                checkinData: ref.watch(dailyCheckinForSelectedDayProvider).value,
                onLogPeriodForDay: () => _handleLogPeriodForDay(context, ref, state.selectedDay, periodDayForSelected ?? 1),
                onSetAsPeriodStart: () => _handleLogPeriodForDay(context, ref, state.selectedDay, periodDayForSelected ?? 1),
                onChangePeriodDate: () => _handleChangePeriodDate(context, ref, state.selectedDay),
                onRemovePeriod: () => _handleRemovePeriod(context, ref, state.selectedDay),
                onCheckinForDay: () => _handleCheckinForDay(context, ref, state.selectedDay),
              ),
              const SizedBox(height: 32),
              Text(
                'Upcoming Menstrual Summary',
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
                              child: Icon(
                                state.isPeriodLate ? Icons.hourglass_top_rounded : Icons.water_drop,
                                color: AppColors.primaryPink,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                state.isPeriodLate
                                    ? 'Period is ${state.daysLate} ${state.daysLate == 1 ? "day" : "days"} late (expected ${state.nextPeriodStartDate!.day} ${_getMonthName(state.nextPeriodStartDate!.month)})'
                                    : 'Period expected ${state.nextPeriodStartDate!.day}-${(state.nextPeriodEndDate ?? state.nextPeriodStartDate!.add(const Duration(days: 4))).day} ${_getMonthName(state.nextPeriodStartDate!.month)}',
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
                              child: const Icon(Icons.spa_outlined, color: Colors.green, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final now = DateTime.now();
                                  final today = DateTime(now.year, now.month, now.day);
                                  final upcoming = state.fertileDays.where((d) => !d.isBefore(today.subtract(const Duration(days: 5)))).toList();
                                  if (upcoming.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  // Extract only the first continuous fertile window block (6 days)
                                  final firstWindow = <DateTime>[upcoming.first];
                                  for (int i = 1; i < upcoming.length; i++) {
                                    if (upcoming[i].difference(firstWindow.last).inDays == 1) {
                                      firstWindow.add(upcoming[i]);
                                    } else {
                                      break; // Belongs to next cycle
                                    }
                                  }

                                  final fStart = firstWindow.first;
                                  final fEnd = firstWindow.last;
                                  final label = fStart.month == fEnd.month
                                      ? 'Fertile window ${fStart.day}-${fEnd.day} ${_getMonthName(fStart.month)}'
                                      : 'Fertile window ${fStart.day} ${_getMonthName(fStart.month)} - ${fEnd.day} ${_getMonthName(fEnd.month)}';

                                  return Text(
                                    label,
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

  Future<void> _handleLogPeriodForDay(BuildContext context, WidgetRef ref, DateTime date, int? cycleDay) async {
    final cleanDate = DateTime(date.year, date.month, date.day);
    await showPeriodFlowPainSheet(
      context: context,
      ref: ref,
      date: cleanDate,
      cycleDay: cycleDay,
      showDisclaimer: false,
    );
  }

  Future<void> _handleChangePeriodDate(BuildContext context, WidgetRef ref, DateTime oldDate) async {
    final cleanOld = DateTime(oldDate.year, oldDate.month, oldDate.day);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: cleanOld,
      firstDate: now.subtract(const Duration(days: 90)),
      lastDate: now.add(const Duration(days: 1)),
      helpText: 'Select correct period date',
      confirmText: 'Move to this date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPink,
              onPrimary: Colors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final cleanNew = DateTime(picked.year, picked.month, picked.day);
      final cycleRepo = ref.read(cycleRepositoryProvider);
      final dailyLogRepo = ref.read(dailyLogRepositoryProvider);
      final currentCycle = ref.read(currentCycleStreamProvider).value;

      await dailyLogRepo.movePeriodLog(cleanOld, cleanNew);

      if (currentCycle != null) {
        await cycleRepo.updateCycleStartDate(currentCycle.id, cleanNew);
      }

      ref.read(calendarProvider.notifier).onDaySelected(cleanNew, cleanNew);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Period date moved from ${DateFormat('MMM d').format(cleanOld)} to ${DateFormat('MMM d').format(cleanNew)}'),
            backgroundColor: AppColors.primaryPink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _handleRemovePeriod(BuildContext context, WidgetRef ref, DateTime date) async {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Period Log?'),
        content: Text('Do you want to remove the period log for ${DateFormat('EEEE, MMM d').format(cleanDate)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final dailyLogRepo = ref.read(dailyLogRepositoryProvider);
      final cycleRepo = ref.read(cycleRepositoryProvider);

      // 1. Remove flow from daily_logs for that date
      await dailyLogRepo.removePeriodFlowForDate(cleanDate);

      // 2. Fetch remaining period logs
      final allDailyLogs = await dailyLogRepo.getAllDailyLogs();
      final remainingPeriodLogs = allDailyLogs.where((l) {
        final d = DateTime(l.date.year, l.date.month, l.date.day);
        return !DateUtils.isSameDay(d, cleanDate) &&
            l.flowIntensity != null &&
            l.flowIntensity != 'None' &&
            l.flowIntensity!.isNotEmpty;
      }).toList();

      // 3. Check current cycle
      final currentCycle = await cycleRepo.getCurrentCycle();
      if (currentCycle != null) {
        final cleanCycleStart = DateTime(
          currentCycle.startDate.year,
          currentCycle.startDate.month,
          currentCycle.startDate.day,
        );

        // If the date being removed was the start of the current cycle:
        if (DateUtils.isSameDay(cleanDate, cleanCycleStart)) {
          // Check if there are other period logs in this cycle (within 14 days after start)
          final otherLogsInCycle = remainingPeriodLogs.where((l) {
            final d = DateTime(l.date.year, l.date.month, l.date.day);
            final diff = d.difference(cleanCycleStart).inDays;
            return diff > 0 && diff < 15;
          }).toList()
            ..sort((a, b) => a.date.compareTo(b.date));

          if (otherLogsInCycle.isNotEmpty) {
            // Move cycle start to the next earliest period date in this cycle
            await cycleRepo.updateCycleStartDate(currentCycle.id, otherLogsInCycle.first.date);
          } else {
            // No other period logs in this cycle! The cycle was started solely by this removed log.
            // Delete this cycle and reopen the previous completed cycle if one exists.
            final prevCycle = await cycleRepo.getPreviousCompletedCycle();
            await cycleRepo.deleteCycle(currentCycle.id);
            if (prevCycle != null) {
              await cycleRepo.reopenCycle(prevCycle.id);
            }
          }
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Period removed for ${DateFormat('MMM d').format(cleanDate)}'),
            backgroundColor: AppColors.text,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _handleCheckinForDay(BuildContext context, WidgetRef ref, DateTime date) async {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final dailyLogRepo = ref.read(dailyLogRepositoryProvider);
    final symptomRepo = ref.read(symptomRepositoryProvider);

    // Clear previous check-in state and set target date with fromCalendar = true
    ref.read(dailyCheckinProvider.notifier).clear();
    ref.read(dailyCheckinProvider.notifier).setTargetDate(cleanDate, fromCalendar: true);

    // Pre-populate if a log already exists
    final existingLog = await dailyLogRepo.getLogForDate(cleanDate);
    if (existingLog != null) {
      final symptoms = await symptomRepo.getSymptomsForLog(existingLog.id);
      ref.read(dailyCheckinProvider.notifier).loadFromLog(existingLog, symptoms);
    }

    if (context.mounted) {
      context.push('/checkin/mood', extra: {'date': cleanDate});
    }
  }
}

