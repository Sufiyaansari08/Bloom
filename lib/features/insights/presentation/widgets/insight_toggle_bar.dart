import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/insights_provider.dart';

class InsightToggleBar extends StatelessWidget {
  final InsightTab currentTab;
  final ValueChanged<InsightTab> onTabChanged;

  const InsightToggleBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildToggle(context, 'Cycle', InsightTab.cycle),
          _buildToggle(context, 'Symptoms', InsightTab.symptoms),
          _buildToggle(context, 'Mood', InsightTab.mood),
        ],
      ),
    );
  }

  Widget _buildToggle(BuildContext context, String label, InsightTab tab) {
    final isSelected = currentTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.secondaryText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
