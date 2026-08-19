import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BloomLifestyleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? valueText;
  final Widget? trailing;
  final Widget? bottomWidget;
  final VoidCallback? onTap;

  const BloomLifestyleCard({
    super.key,
    required this.title,
    required this.icon,
    this.valueText,
    this.trailing,
    this.bottomWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryPurple, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      if (valueText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          valueText!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
            if (bottomWidget != null) ...[
              const SizedBox(height: 16),
              bottomWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
