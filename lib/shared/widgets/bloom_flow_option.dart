import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BloomFlowOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double dropOpacity; // To visually distinguish Spotting vs Heavy

  const BloomFlowOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.dropOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightPink : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.water_drop,
              color: AppColors.primaryPink.withValues(alpha: dropOpacity),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
