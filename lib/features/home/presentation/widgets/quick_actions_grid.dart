import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickAction(
          icon: Icons.water_drop_outlined,
          label: 'Log Period',
          onTap: () => context.push('/period_logging/start'),
        ),
        _QuickAction(
          icon: Icons.add_box_outlined,
          label: 'Check-in',
          onTap: () => context.push('/checkin/mood'),
        ),
        _QuickAction(
          icon: Icons.calendar_month_outlined,
          label: 'Calendar',
          onTap: () => context.go('/calendar'),
        ),
        _QuickAction(
          icon: Icons.assignment_outlined,
          label: 'Report',
          onTap: () => context.push('/doctor_report/setup'),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightPurple,
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
