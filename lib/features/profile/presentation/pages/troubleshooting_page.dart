import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_button.dart';

class TroubleshootingPage extends StatelessWidget {
  const TroubleshootingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Troubleshooting',
          style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Common Problems',
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
                    _buildIssueTile(
                      context, 
                      'Notifications not appearing', 
                      'First, ensure you have enabled reminders within Bloom by going to Profile > Reminders. If they are enabled there, check your device\'s system settings. Go to Settings > Apps > Bloom > Notifications and verify that Bloom is permitted to send alerts. Also, ensure your phone is not in "Do Not Disturb" or low-power mode, which can block scheduled notifications.'
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildIssueTile(
                      context, 
                      'Data not syncing', 
                      'If your data isn\'t updating across devices, first check that you have a stable Wi-Fi or cellular connection. Then, go to Profile > App Settings and scroll down to the Data & Sync section. Tap the "Sync Now" button to force a manual refresh. If it still fails, try fully closing and reopening the app.'
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildIssueTile(
                      context, 
                      'Period entry not saving', 
                      'Ensure you are selecting a valid date range on the calendar before tapping save. You cannot log a period for a future date, and a single log cannot overlap with another existing period log. If the issue persists, clear your app cache or restart your device.'
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildIssueTile(
                      context, 
                      'Calendar not updating', 
                      'Sometimes the visual calendar may need a moment to refresh after a complex log. Try navigating to another tab (like Insights) and then coming back to the Calendar. If it still looks incorrect, close the app from your recent apps menu and launch it again.'
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildIssueTile(
                      context, 
                      'AI insight not loading', 
                      'AI Insights require a minimum amount of logged cycle and symptom data to discover meaningful correlations. If you recently started using Bloom, simply continue logging your daily symptoms and moods. Insights will automatically generate once enough data is gathered.'
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildIssueTile(
                      context, 
                      'Login problem', 
                      'Double-check that you are using the correct email address and there are no hidden spaces. If you are using a weak or unstable internet connection, the login request may time out. Switch to a stronger Wi-Fi network or cellular data and try again.'
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildIssueTile(
                      context, 
                      'App crashing', 
                      'First, check your device\'s app store (Google Play Store or Apple App Store) to ensure you are running the latest version of Bloom. If you are fully updated, try clearing the app cache in your phone\'s settings, or uninstalling and reinstalling the app (your cloud data is safe).'
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _buildIssueTile(
                      context, 
                      'Forgot password', 
                      'If you are logged out and cannot remember your password, tap the "Forgot Password" link on the login screen. Enter your registered email address, and we will send you a secure link with step-by-step instructions to reset your password.'
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: BloomButton(
                  text: 'Contact Support \u2192',
                  onPressed: () {
                    context.push('/contact_support');
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueTile(BuildContext context, String title, String solution) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text),
        ),
        iconColor: AppColors.primaryPurple,
        collapsedIconColor: AppColors.secondaryText,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                solution,
                style: const TextStyle(fontSize: 14, color: AppColors.secondaryText, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
