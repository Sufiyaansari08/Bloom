import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BloomEmoticonPicker extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const BloomEmoticonPicker({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  final List<Map<String, dynamic>> moods = const [
    {'label': 'Great', 'icon': Icons.sentiment_very_satisfied},
    {'label': 'Good', 'icon': Icons.sentiment_satisfied_alt},
    {'label': 'Okay', 'icon': Icons.sentiment_neutral},
    {'label': 'Not great', 'icon': Icons.sentiment_dissatisfied},
    {'label': 'Bad', 'icon': Icons.sentiment_very_dissatisfied},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: moods.map((mood) {
        final label = mood['label'] as String;
        final icon = mood['icon'] as IconData;
        final isSelected = selectedMood == label;

        return GestureDetector(
          onTap: () => onMoodSelected(label),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primaryPink : AppColors.lightPink,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected ? Colors.white : AppColors.primaryPink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.text : AppColors.secondaryText,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
