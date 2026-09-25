import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

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
          'Frequently Asked Questions',
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
              _buildCategory('Period & Cycle', [
                _buildFaqItem(context, 'How do I log my period?', 'To log a new period, navigate to the Home or Calendar tab. Tap on the "Log Period" button. You can then select the flow intensity and any associated symptoms for that specific day.'),
                _buildFaqItem(context, 'How do I edit a period?', 'If you need to change a past log, simply go to the Calendar tab and tap on the date you want to edit. A menu will appear allowing you to modify your flow, symptoms, or delete the entry entirely.'),
                _buildFaqItem(context, 'How does Bloom calculate cycle length?', 'Bloom uses your historical data to determine your cycle length. It takes the average number of days between the start of your previous periods over your last several logged cycles to provide a personalized baseline.'),
                _buildFaqItem(context, 'How are period predictions calculated?', 'Your upcoming period dates are predicted by adding your average cycle length to the start date of your most recent period. As you log more cycles, the algorithm becomes increasingly accurate.'),
                _buildFaqItem(context, 'What happens if I forget to log my period?', 'Don\'t worry! You can always retroactively log past periods. Just open the Calendar tab, select the dates your period actually occurred, and log them normally. Your insights and predictions will automatically recalculate.'),
              ]),
              const SizedBox(height: 24),
              _buildCategory('Insights', [
                _buildFaqItem(context, 'What are Insights & Patterns?', 'Insights provide a deeper look into your menstrual health by analyzing the symptoms, moods, and period dates you log. Over time, Bloom highlights recurring patterns to help you better understand your body.'),
                _buildFaqItem(context, 'How does Bloom identify patterns?', 'Bloom\'s algorithm looks for statistical correlations in your data across multiple consecutive cycles. For example, if you consistently log headaches two days before your period, Bloom will identify this as a recurring pattern.'),
                _buildFaqItem(context, 'What does "average cycle length" mean?', 'This is the typical duration of your menstrual cycle, counted from the first day of bleeding in one period to the day before the first day of bleeding in your next period.'),
                _buildFaqItem(context, 'What does "cycle length over time" mean?', 'This refers to a graphical trend showing how the total duration of your cycles changes from month to month. Tracking this can help you spot irregularities or confirm that your cycle is highly regular.'),
                _buildFaqItem(context, 'Why did my prediction change?', 'Predictions are dynamic and recalculate whenever you log new data. If your current period arrives earlier or later than expected, Bloom will instantly adjust future predictions to reflect this new baseline.'),
              ]),
              const SizedBox(height: 24),
              _buildCategory('AI Insights', [
                _buildFaqItem(context, 'What are AI Insights?', 'AI Insights use on-device machine learning to discover hidden, highly personalized correlations in your health data—such as how your sleep quality might be affecting your cycle length.'),
                _buildFaqItem(context, 'How does Bloom use my data for AI?', 'Your data is processed entirely securely on your device. Bloom\'s AI analyzes your logs to find unique patterns without ever sending your sensitive health information to external servers.'),
                _buildFaqItem(context, 'Can I turn AI Insights off?', 'Yes. If you prefer not to receive AI-generated insights, you can easily disable them by navigating to Profile > App Settings and toggling off the AI Insights feature.'),
                _buildFaqItem(context, 'Are AI Insights medical advice?', 'No. AI Insights are strictly for informational and educational purposes. They are designed to help you understand your body better, but they are not a substitute for professional medical advice or diagnosis.'),
              ]),
              const SizedBox(height: 24),
              _buildCategory('Reminders', [
                _buildFaqItem(context, 'How do I set a reminder?', 'You can configure your notifications by navigating to Profile > Reminders. From there, you can enable alerts for upcoming periods, fertile windows, and daily check-ins.'),
                _buildFaqItem(context, 'Why didn\'t I receive my reminder?', 'Please ensure that Bloom has permission to send notifications in your device\'s system settings. Also, check that you don\'t have "Do Not Disturb" or battery-saver modes blocking alerts.'),
                _buildFaqItem(context, 'How do I change reminder time?', 'You can easily adjust the exact time you receive notifications. Simply go to the Reminders settings page, tap on the specific reminder you want to change, and select a new time.'),
                _buildFaqItem(context, 'How do I turn reminders off?', 'If you no longer wish to receive notifications, you can toggle them off individually in the Reminders page, or disable notifications entirely via your device\'s system settings.'),
              ]),
              const SizedBox(height: 24),
              _buildCategory('Account', [
                _buildFaqItem(context, 'How do I edit my profile?', 'To update your personal information, name, or avatar, navigate to the Profile tab and select "My Profile" (or "Edit Profile"). Make your changes and tap save.'),
                _buildFaqItem(context, 'How do I change my password?', 'For security reasons, password changes are handled in the Privacy & Security section. Navigate to Profile > Privacy & Security and select "Change Password" to update your credentials.'),
                _buildFaqItem(context, 'How do I delete my account?', 'You can permanently delete your account and all associated data from the Privacy & Security settings. Please note that this action is irreversible and all your health logs will be permanently erased.'),
                _buildFaqItem(context, 'How do I change my email?', 'You can update the email address associated with your account by going to the Edit Profile section. You may be asked to verify your new email address for security purposes.'),
              ]),
              const SizedBox(height: 24),
              _buildCategory('Data & Sync', [
                _buildFaqItem(context, 'Does Bloom work offline?', 'Yes, Bloom is designed to function fully offline. All your data is stored locally on your device, meaning you can log your period and view insights even without an internet connection.'),
                _buildFaqItem(context, 'What happens when I reconnect to the internet?', 'Once your device regains internet access, Bloom will automatically sync your local data with your secure cloud backup, ensuring your records are up to date across devices.'),
                _buildFaqItem(context, 'How do I sync my data?', 'While syncing usually happens automatically in the background, you can force a manual sync at any time by going to Profile > App Settings and tapping the "Sync Now" button.'),
                _buildFaqItem(context, 'How do I export my data?', 'Bloom makes it easy to share your data with healthcare providers. Go to the Insights tab and select the "Generate Doctor Report" feature to create a comprehensive PDF of your cycle history.'),
                _buildFaqItem(context, 'What happens to my data if I delete my account?', 'If you choose to delete your account, all of your cloud backups and personal data will be permanently wiped from our servers in compliance with our Privacy Policy.'),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
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
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
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
                answer,
                style: const TextStyle(fontSize: 14, color: AppColors.secondaryText, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
