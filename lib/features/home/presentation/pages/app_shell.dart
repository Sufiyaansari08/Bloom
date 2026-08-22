import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter/services.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/calendar')) currentIndex = 1;
    if (location.startsWith('/insights')) currentIndex = 2;
    if (location.startsWith('/profile')) currentIndex = 3;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: child,
        extendBody: true, // Needed for the notch to look transparent
      // Removed floatingActionButton because user wants it strictly inside the navigation bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _NavItem(
                icon: currentIndex == 1 ? Icons.calendar_month : Icons.calendar_month_outlined,
                label: 'Calendar',
                isSelected: currentIndex == 1,
                onTap: () => context.go('/calendar'),
              ),
              
              // The plus icon kept perfectly inline with the other navigation items
              GestureDetector(
                onTap: () => context.push('/checkin/mood'),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),

              _NavItem(
                icon: currentIndex == 2 ? Icons.bar_chart : Icons.bar_chart_outlined,
                label: 'Insights',
                isSelected: currentIndex == 2,
                onTap: () => context.go('/insights'),
              ),
              _NavItem(
                icon: currentIndex == 3 ? Icons.person : Icons.person_outline,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
