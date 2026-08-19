import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../checkin/presentation/providers/daily_checkin_provider.dart';

class DailySummaryCard extends StatelessWidget {
  final DateTime date;
  final bool isPeriodDay;
  final bool isFertileDay;
  final DailyCheckinState? checkinData;

  const DailySummaryCard({
    super.key,
    required this.date,
    required this.isPeriodDay,
    required this.isFertileDay,
    this.checkinData,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [];

    // 1. Cycle Status Card (Period or Fertile)
    if (isPeriodDay || isFertileDay) {
      String statusTitle = isPeriodDay ? 'Period Day' : 'Fertile Window';
      String statusSubtitle = isPeriodDay ? 'Medium flow logged' : 'High chance of pregnancy';
      Color iconColor = isPeriodDay ? AppColors.primaryPink : Colors.green;
      IconData icon = isPeriodDay ? Icons.water_drop : Icons.favorite_border;

      cards.add(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusSubtitle,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
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

    // 2. Check-in Data Card
    if (checkinData != null) {
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
                    child: const Icon(Icons.mood, color: AppColors.primaryPurple, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Feeling ${checkinData!.mood ?? "Okay"}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
                    ),
                  ),
                ],
              ),
              if (checkinData!.symptoms.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: checkinData!.symptoms.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryPink, width: 0.5),
                    ),
                    child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.primaryPink, fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
              ],
              if (checkinData!.sleep != null || checkinData!.waterIntake != null || checkinData!.activity != null) ...[
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
                          const Icon(Icons.bedtime, size: 16, color: AppColors.secondaryText),
                          const SizedBox(width: 4),
                          Text(checkinData!.sleep!, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                        ],
                      ),
                    if (checkinData!.waterIntake != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.water_drop, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(checkinData!.waterIntake!, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                        ],
                      ),
                    if (checkinData!.activity != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.directions_run, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(checkinData!.activity!, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  checkinData!.notes,
                  style: const TextStyle(color: AppColors.secondaryText, fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 3. Fallback (Nothing logged)
    if (cards.isEmpty) {
      cards.add(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryText.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_today, color: AppColors.secondaryText),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nothing logged yet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap the + button to log symptoms',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
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

    return Column(
      children: cards,
    );
  }
}
