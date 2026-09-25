import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Privacy Policy',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Updated: September 2026',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              
              _buildSection(
                context,
                '1. Introduction',
                'At Bloom, your privacy is our highest priority. We are committed to protecting the sensitive health information you share with us. This Privacy Policy explains how we collect, use, and protect your data.',
              ),
              
              _buildSection(
                context,
                '2. Information We Collect',
                'We collect the information you voluntarily provide when using Bloom, including but not limited to:\n\n'
                '• Cycle data (period start/end dates, flow intensity)\n'
                '• Daily logs (mood, symptoms, pain levels)\n'
                '• Lifestyle information (sleep, water intake)\n'
                '• Basic profile information (age, average cycle length)',
              ),
              
              _buildSection(
                context,
                '3. How We Use Your Data',
                'Your data is used exclusively to provide and improve Bloom\'s core features. We use it to:\n\n'
                '• Accurately predict your upcoming periods and fertile windows\n'
                '• Generate personalized health insights and pattern analysis\n'
                '• Provide tailored reminders and notifications',
              ),

              _buildSection(
                context,
                '4. Data Security & Storage',
                'We implement industry-standard security measures to protect your data. All sensitive health information is encrypted and stored locally on your device by default to ensure maximum privacy.',
              ),

              _buildSection(
                context,
                '5. Data Sharing',
                'We do NOT sell your personal or health data to third parties. We will only share your data if required by law or with your explicit consent (e.g., generating a Doctor Report).',
              ),

              _buildSection(
                context,
                '6. Your Rights & Choices',
                'You have full control over your data. You can access, edit, export, or permanently delete your health data directly from the app settings at any time.',
              ),

              _buildSection(
                context,
                '7. Contact Us',
                'If you have any questions or concerns about this Privacy Policy, please contact our privacy team at privacy@bloomapp.example.com.',
              ),
              
              const SizedBox(height: 40),
              Center(
                child: Text(
                  '© 2026 Bloom Inc.',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: AppColors.text.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
