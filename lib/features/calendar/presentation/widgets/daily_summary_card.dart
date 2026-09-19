import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../checkin/presentation/providers/daily_checkin_provider.dart';

class DailySummaryCard extends StatelessWidget {
  final DateTime date;
  final bool isPeriodDay;
  final bool isLoggedPeriodDay;
  final String? loggedFlow;
  final bool isFertileDay;
  final bool isOvulationDay;
  final int? cycleDay;
  final int? periodDay;
  final bool isCycleStart;
  final bool isPeriodLate;
  final int daysLate;
  final DateTime? expectedPeriodDate;
  final DailyCheckinState? checkinData;
  final VoidCallback? onSetAsPeriodStart;
  final VoidCallback? onChangePeriodDate;
  final VoidCallback? onRemovePeriod;
  final VoidCallback? onLogPeriodForDay;
  final VoidCallback? onCheckinForDay;

  const DailySummaryCard({
    super.key,
    required this.date,
    required this.isPeriodDay,
    this.isLoggedPeriodDay = false,
    this.loggedFlow,
    required this.isFertileDay,
    this.isOvulationDay = false,
    this.cycleDay,
    this.periodDay,
    this.isCycleStart = false,
    this.isPeriodLate = false,
    this.daysLate = 0,
    this.expectedPeriodDate,
    this.checkinData,
    this.onSetAsPeriodStart,
    this.onChangePeriodDate,
    this.onRemovePeriod,
    this.onLogPeriodForDay,
    this.onCheckinForDay,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [];

    // 1. Cycle Status Card (Period, Ovulation, Fertile, Late, or Cycle Day)
    if (isPeriodDay || isOvulationDay || isFertileDay || isPeriodLate || cycleDay != null) {
      String statusTitle;
      String statusSubtitle;
      Color iconColor;
      IconData icon;

      if (isPeriodLate && !isLoggedPeriodDay) {
        statusTitle =
            'Period is $daysLate ${daysLate == 1 ? "day" : "days"} late';
        statusSubtitle = expectedPeriodDate != null
            ? 'Expected on ${expectedPeriodDate!.day}/${expectedPeriodDate!.month}. Period not arrived yet?'
            : 'Your period is overdue. Has it started?';
        iconColor = AppColors.primaryPink;
        icon = Icons.hourglass_top_rounded;
      } else if (isPeriodDay) {
        final displayPeriodDay = periodDay ?? (isLoggedPeriodDay ? cycleDay : null);
        statusTitle = displayPeriodDay != null ? 'Period Day $displayPeriodDay' : 'Period Day';
        statusSubtitle = isLoggedPeriodDay
            ? 'Flow logged: ${loggedFlow ?? "Period logged"}'
            : 'Predicted period day';
        iconColor = AppColors.primaryPink;
        icon = Icons.water_drop;
      } else if (isOvulationDay) {
        statusTitle = cycleDay != null
            ? 'Ovulation expected today • Day $cycleDay'
            : 'Ovulation expected today';
        statusSubtitle = 'Peak fertility • Highest chance of conception';
        iconColor = Colors.amber.shade700;
        icon = Icons.auto_awesome;
      } else if (isFertileDay) {
        statusTitle = cycleDay != null
            ? 'Fertile Window • Day $cycleDay'
            : 'Fertile Window';
        statusSubtitle = 'High chance of pregnancy';
        iconColor = Colors.green;
        icon = Icons.spa_outlined;
      } else {
        statusTitle = 'Cycle Day $cycleDay';
        statusSubtitle = 'Day $cycleDay of your menstrual cycle';
        iconColor = AppColors.primaryPurple;
        icon = Icons.calendar_month_outlined;
      }

      cards.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: iconColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          statusSubtitle,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isPeriodDay || (isPeriodLate && !isLoggedPeriodDay)) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (isPeriodDay && onChangePeriodDate != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onChangePeriodDate,
                          icon: const Icon(
                            Icons.edit_calendar_outlined,
                            size: 15,
                          ),
                          label: const Text(
                            'Change Date',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryPink,
                            side: BorderSide(
                              color: AppColors.primaryPink.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    if (isPeriodDay &&
                        onChangePeriodDate != null &&
                        (onRemovePeriod != null || !isLoggedPeriodDay))
                      const SizedBox(width: 8),
                    if (isPeriodDay &&
                        onRemovePeriod != null &&
                        isLoggedPeriodDay)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onRemovePeriod,
                          icon: const Icon(Icons.delete_outline, size: 15),
                          label: const Text(
                            'Remove',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade400,
                            side: BorderSide(color: Colors.red.shade200),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    if (!isLoggedPeriodDay &&
                        (onLogPeriodForDay != null ||
                            onSetAsPeriodStart != null))
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onLogPeriodForDay ?? onSetAsPeriodStart,
                          icon: const Icon(Icons.water_drop, size: 15),
                          label: Text(
                            isPeriodLate
                                ? 'Log Period for Today'
                                : (periodDay != null
                                      ? 'Log Day $periodDay'
                                      : 'Log Period'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPink,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 2. Check-in Data Card
    final hasCheckinData =
        checkinData != null &&
        (checkinData!.mood != null ||
            checkinData!.symptoms.isNotEmpty ||
            checkinData!.sleep != null ||
            checkinData!.waterIntake != null ||
            checkinData!.activity != null ||
            checkinData!.notes.isNotEmpty);

    if (hasCheckinData) {
      if (cards.isNotEmpty) cards.add(const SizedBox(height: 12));
      cards.add(
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      checkinData!.mood != null
                          ? Icons.mood
                          : Icons.check_circle_outline,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      checkinData!.mood != null
                          ? 'Feeling ${checkinData!.mood}'
                          : 'Daily Check-in',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  if (onCheckinForDay != null)
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppColors.primaryPurple,
                      ),
                      tooltip: 'Edit check-in',
                      onPressed: onCheckinForDay,
                    ),
                ],
              ),
              if (checkinData!.symptoms.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: checkinData!.symptoms
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightPink,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryPink,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            s,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryPink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (checkinData!.sleep != null ||
                  checkinData!.waterIntake != null ||
                  checkinData!.activity != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.border),
                ),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (checkinData!.sleep != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bedtime,
                            size: 16,
                            color: AppColors.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            checkinData!.sleep!,
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    if (checkinData!.waterIntake != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            checkinData!.waterIntake!,
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    if (checkinData!.activity != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.directions_run,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            checkinData!.activity!,
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
              if (checkinData!.notes.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.border),
                ),
                Text(
                  'Notes',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  checkinData!.notes,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    } else if (onCheckinForDay != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final cleanDate = DateTime(date.year, date.month, date.day);
      final isFuture = cleanDate.isAfter(today);

      if (!isFuture) {
        final isToday = cleanDate.isAtSameMomentAs(today);
        final isYesterday = cleanDate.isAtSameMomentAs(
          today.subtract(const Duration(days: 1)),
        );
        final dateLabel = isYesterday
            ? 'yesterday'
            : DateFormat('MMM d').format(cleanDate);
        final daySubtitle = isToday
            ? 'Log your mood, symptoms, and lifestyle'
            : 'You missed check-in for $dateLabel. Tap to log it now.';

        if (cards.isNotEmpty) cards.add(const SizedBox(height: 12));
        cards.add(
          InkWell(
            onTap: onCheckinForDay,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryPurple.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_box_outlined,
                      color: AppColors.primaryPurple,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isYesterday
                              ? 'Daily Check-in • Yesterday'
                              : (isToday
                                    ? 'Daily Check-in'
                                    : 'Daily Check-in • ${DateFormat('MMM d').format(cleanDate)}'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          daySubtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 3. Fallback (Nothing logged)
    if (cards.isEmpty) {
      cards.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryText.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.secondaryText,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nothing logged yet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tap below to mark period or log check-in',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
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

    // 4. Quick Action to set/move Period Start or log flow
    if (!isPeriodDay &&
        (onLogPeriodForDay != null || onSetAsPeriodStart != null)) {
      final String periodActionTitle = periodDay != null
          ? 'Log Period (Day $periodDay)'
          : 'Log Period';
      final String periodActionSubtitle = periodDay != null
          ? 'Record bleeding/flow for Day $periodDay'
          : 'Record bleeding/flow for this date';

      cards.add(const SizedBox(height: 12));
      cards.add(
        InkWell(
          onTap: onLogPeriodForDay ?? onSetAsPeriodStart,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryPink.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: AppColors.primaryPink,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        periodActionTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        periodActionSubtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primaryPink,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(children: cards);
  }
}
