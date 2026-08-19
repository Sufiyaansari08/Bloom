import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class BloomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double progress; // 0.0 to 1.0
  final bool showSkip;
  final VoidCallback? onSkip;

  const BloomAppBar({
    super.key,
    required this.progress,
    this.showSkip = false,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.text),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
      actions: showSkip
          ? [
              TextButton(
                onPressed: onSkip,
                child: const Text('Skip', style: TextStyle(color: AppColors.secondaryText)),
              )
            ]
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.border,
          color: AppColors.primaryPurple,
          minHeight: 4,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4.0);
}
