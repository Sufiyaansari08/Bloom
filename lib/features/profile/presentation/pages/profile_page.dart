import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);
    final userName = userAsync.value?.name ?? 'Guest';
    final userEmail = userAsync.value?.email ?? 'guest@example.com';

    final userAvatar = userAsync.value?.avatarPath ?? 'assets/images/Setting_avatar.png';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 80), // slightly tighter padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. User Info Header
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryPink, width: 2),
                      image: DecorationImage(
                        image: AssetImage(userAvatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 2. Settings List
              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline,
                      title: 'My Profile',
                      onTap: () {
                        context.push('/edit_profile');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.settings_outlined,
                      title: 'App Settings',
                      onTap: () {
                        context.push('/app_settings');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Privacy & Security',
                      onTap: () {
                        context.push('/privacy_security');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_none,
                      title: 'Reminders',
                      onTap: () {
                        context.push('/reminder_settings');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      trailingText: 'English',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'About Bloom',
                      showDivider: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 3. Log out button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to welcome page
                    context.go('/welcome');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryPink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      color: AppColors.primaryPink,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.secondaryText, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailingText != null) ...[
                  Text(
                    trailingText!,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Icon(Icons.chevron_right, color: AppColors.border, size: 20),
              ],
            ),
          ),
          if (showDivider)
            const Padding(
              padding: EdgeInsets.only(left: 60, right: 20),
              child: Divider(color: AppColors.border, height: 1),
            ),
        ],
      ),
    );
  }
}
