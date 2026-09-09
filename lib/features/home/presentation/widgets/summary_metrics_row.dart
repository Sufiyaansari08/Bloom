import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SummaryMetricsRow extends StatelessWidget {
  final int symptomsLogged;
  final int painLevel;
  final String mood;

  const SummaryMetricsRow({
    super.key,
    required this.symptomsLogged,
    required this.painLevel,
    required this.mood,
  });

  String _getPainSubtext() {
    if (painLevel == 0) return 'None';
    if (painLevel <= 3) return 'Mild';
    if (painLevel <= 6) return 'Moderate';
    return 'Severe';
  }

  String _getMoodEmoji() {
    switch (mood.toLowerCase()) {
      case 'great': return '🤩';
      case 'good': return '🙂';
      case 'okay': return '😐';
      case 'not great': return '😔';
      case 'bad': return '😫';
      default: return '-';
    }
  }

  String _getMoodSubtext() {
    if (mood.toLowerCase() == 'not great') return 'Not Great';
    if (mood == 'None' || mood.isEmpty) return 'None';
    return mood[0].toUpperCase() + mood.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MetricItem(label: 'Symptoms', value: '$symptomsLogged', subtext: 'Logged today'),
          _MetricItem(label: 'Pain', value: '$painLevel', valueSuffix: '/10', subtext: _getPainSubtext()),
          _MetricItem(label: 'Mood', value: _getMoodEmoji(), subtext: _getMoodSubtext()),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final String? valueSuffix;
  final String subtext;

  const _MetricItem({
    required this.label,
    required this.value,
    this.valueSuffix,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
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
                if (valueSuffix != null) ...[
                  const SizedBox(width: 2),
                  Text(
                    valueSuffix!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtext,
              style: const TextStyle(fontSize: 10, color: AppColors.secondaryText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
