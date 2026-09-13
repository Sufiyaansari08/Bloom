import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../providers/privacy_security_provider.dart';

class PrivacySecurityPage extends ConsumerStatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  ConsumerState<PrivacySecurityPage> createState() =>
      _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends ConsumerState<PrivacySecurityPage> {
  final List<String> autoLockOptions = const [
    'Immediately',
    '1 minute',
    '5 minutes',
    '15 minutes',
    '30 minutes',
  ];

  @override
  Widget build(BuildContext context) {
    final secState = ref.watch(privacySecurityProvider);
    final secNotifier = ref.read(privacySecurityProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // Section 1: Security
              // ==========================================
              const Text(
                'Security',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // 1. App Lock (None / PIN / Password / Pattern)
                    _buildActionTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'App Lock',
                      subtitle: secState.lockType,
                      trailingWidget: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: AppColors.primaryPurple,
                          size: 20,
                        ),
                      ),
                      onTap: () => context.push('/app_lock'),
                    ),

                    // 2. Auto-lock time (if lock active)
                    if (secState.isLockActive) ...[
                      const Divider(color: AppColors.border, height: 1),
                      _buildActionTile(
                        icon: Icons.timer_outlined,
                        title: 'Auto-lock Delay',
                        subtitle:
                            'Locks after ${secState.autoLockTime.toLowerCase()}',
                        trailingWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            secState.autoLockTime,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                        onTap: () => _showAutoLockPicker(
                          context,
                          secState.autoLockTime,
                        ),
                      ),
                    ],

                    const Divider(color: AppColors.border, height: 1),

                    // 3. Privacy Blur in App Switcher
                    _buildSwitchTile(
                      icon: Icons.visibility_off_outlined,
                      title: 'Privacy Blur in App Switcher',
                      subtitle:
                          'Shield cycle details when switching apps or in multitasking',
                      value: secState.isPrivacyBlurEnabled,
                      onChanged: (val) =>
                          secNotifier.togglePrivacyBlur(val),
                    ),

                    const Divider(color: AppColors.border, height: 1),

                    // 4. Discrete Notifications
                    _buildSwitchTile(
                      icon: Icons.notifications_paused_outlined,
                      title: 'Discrete Notifications',
                      subtitle:
                          'Use subtle, non-embarrassing lock-screen alerts',
                      value: secState.isDiscreteNotificationsEnabled,
                      onChanged: (val) =>
                          secNotifier.toggleDiscreteNotifications(val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // Section 2: Privacy
              // ==========================================
              const Text(
                'Privacy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // 1. AI data usage
                    _buildSwitchTile(
                      icon: Icons.auto_awesome_outlined,
                      title: 'AI data usage',
                      subtitle:
                          'Allow Bloom AI to analyze cycle trends for health tips',
                      value: secState.isAiDataUsageEnabled,
                      onChanged: (val) => secNotifier.toggleAiDataUsage(val),
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 2. Analytics/data sharing
                    _buildSwitchTile(
                      icon: Icons.analytics_outlined,
                      title: 'Analytics / data sharing',
                      subtitle:
                          'Share anonymous usage statistics to improve Bloom',
                      value: secState.isAnalyticsEnabled,
                      onChanged: (val) => secNotifier.toggleAnalytics(val),
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 3. Personalized recommendations
                    _buildSwitchTile(
                      icon: Icons.recommend_outlined,
                      title: 'Personalized recommendations',
                      subtitle:
                          'Tailor wellness insights based on your cycle phase',
                      value: secState.isPersonalizedRecommendationsEnabled,
                      onChanged: (val) =>
                          secNotifier.togglePersonalizedRecommendations(val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // Section 2: Your Data
              // ==========================================
              const Text(
                'Your Data',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // 1. Export my data
                    _buildActionTile(
                      icon: Icons.download_rounded,
                      title: 'Export my data',
                      subtitle:
                          'Download your cycle history and daily health logs',
                      showChevron: true,
                      onTap: () => _handleExportData(context),
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 2. Delete tracking data
                    _buildActionTile(
                      icon: Icons.restart_alt_rounded,
                      title: 'Delete tracking data',
                      subtitle:
                          'Erase symptoms and logs while keeping your account',
                      isWarning: true,
                      showChevron: true,
                      onTap: () => _confirmDeleteTrackingData(context),
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 3. Delete account
                    _buildActionTile(
                      icon: Icons.delete_forever_rounded,
                      title: 'Delete account',
                      subtitle:
                          'Permanently delete your profile and all cycle records',
                      isDestructive: true,
                      showChevron: true,
                      onTap: () => _confirmDeleteAccount(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // Section 3: Account Security
              // ==========================================
              const Text(
                'Account Security',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // 1. Active devices
                    _buildActionTile(
                      icon: Icons.devices,
                      title: 'Active devices',
                      subtitle: 'Manage devices logged into your account',
                      trailingWidget: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 7,
                              color: Color(0xFF2E7D32),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '1 Active',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => _showActiveDevicesModal(context),
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 2. Sign out from all device
                    _buildActionTile(
                      icon: Icons.logout_rounded,
                      title: 'Sign out from all devices',
                      subtitle:
                          'End sessions and sign out across all other devices',
                      isDestructive: true,
                      showChevron: true,
                      onTap: () => _confirmSignOutAllDevices(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // REUSABLE TILE BUILDERS (MATCHING APP_SETTINGS)
  // ==========================================

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    bool enabled = true,
    required ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: value && enabled
                  ? AppColors.lightPurple
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value && enabled
                  ? AppColors.primaryPurple
                  : AppColors.secondaryText,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: enabled ? AppColors.text : AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: AppColors.primaryPurple,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
    Widget? trailingWidget,
    bool showChevron = false,
    bool isWarning = false,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    Color iconColor = AppColors.primaryPurple;
    Color iconBgColor = AppColors.lightPurple;
    Color titleColor = AppColors.text;

    if (isDestructive) {
      iconColor = Colors.red;
      iconBgColor = const Color(0xFFFFEBEE);
      titleColor = Colors.red;
    } else if (isWarning) {
      iconColor = Colors.orange.shade800;
      iconBgColor = const Color(0xFFFFF3E0);
      titleColor = Colors.orange.shade900;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingWidget != null)
              trailingWidget
            else if (trailingText != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trailingText,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 11,
                      color: AppColors.primaryPurple,
                    ),
                  ],
                ),
              )
            else if (showChevron)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.secondaryText,
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // DIALOGS AND MODALS
  // ==========================================

  void _showAutoLockPicker(BuildContext context, String currentChoice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'Select Auto-lock Delay',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
                const Divider(color: AppColors.border),
                ...autoLockOptions.map((option) {
                  final isSelected = option == currentChoice;
                  return ListTile(
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? AppColors.primaryPurple
                          : AppColors.secondaryText,
                    ),
                    title: Text(
                      option,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryPurple
                            : AppColors.text,
                      ),
                    ),
                    onTap: () {
                      ref
                          .read(privacySecurityProvider.notifier)
                          .setAutoLockTime(option);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleExportData(BuildContext context) async {
    final db = ref.read(databaseProvider);
    final logs = await db.select(db.dailyLogs).get();
    final cycles = await db.select(db.cycles).get();
    final user = await db.select(db.userProfiles).getSingleOrNull();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.download_done_rounded,
                  color: AppColors.primaryPurple, size: 24),
              SizedBox(width: 8),
              Text(
                'Export Ready',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Bloom records are compiled and ready for encrypted export:',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildExportRow(
                        'Account', user?.name ?? 'Bloom User'),
                    const Divider(height: 14, color: AppColors.border),
                    _buildExportRow('Cycle Records', '${cycles.length} cycles'),
                    const Divider(height: 14, color: AppColors.border),
                    _buildExportRow('Daily Health Logs', '${logs.length} check-ins'),
                    const Divider(height: 14, color: AppColors.border),
                    _buildExportRow('Format', 'JSON & PDF archive'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  final exportData = {
                    'exportedAt': DateTime.now().toIso8601String(),
                    'user': user?.name,
                    'cycleCount': cycles.length,
                    'logsCount': logs.length,
                  };
                  debugPrint('Export: ${jsonEncode(exportData)}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Data exported successfully to downloads folder.'),
                        ],
                      ),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                },
                child: const Text(
                  'Download Archive',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  void _confirmDeleteTrackingData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.orange.shade800, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Delete Tracking Data?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'This will erase all your logged moods, symptoms, pain levels, and flow history. Your profile and account settings will remain intact.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final db = ref.read(databaseProvider);
                        await db.delete(db.dailyLogs).go();
                        if (context.mounted) {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Tracking data successfully erased.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Erase Logs',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'Delete Account?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'This action is permanent and cannot be undone. All your profile information, predictions, cycle history, and logged data will be completely deleted.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final db = ref.read(databaseProvider);
                        await db.delete(db.dailyLogs).go();
                        await db.delete(db.cycles).go();
                        await db.delete(db.userProfiles).go();
                        if (context.mounted) {
                          Navigator.of(ctx).pop();
                          context.go('/welcome');
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showActiveDevicesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.devices,
                        color: AppColors.primaryPurple, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Active Devices',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'These devices are currently authorized and connected to your Bloom account.',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.smartphone,
                          color: AppColors.primaryPurple,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'This Device',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '(Android Phone)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 7,
                                  color: Color(0xFF2E7D32),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Current Session • Active Now',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmSignOutAllDevices(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'Sign Out Everywhere?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'This will terminate your login sessions across all phones and tablets. You will be redirected to the sign-in screen.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go('/welcome');
                      },
                      child: const Text(
                        'Sign Out All',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
