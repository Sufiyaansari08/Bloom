import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

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
          'Terms of Use',
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
                '1. Acceptance of Terms',
                'By downloading, accessing, or using Bloom, you agree to be bound by these Terms of Use. If you do not agree to these terms, please do not use the app.',
              ),
              
              _buildSection(
                context,
                '2. Not Medical Advice',
                'Bloom is designed to help you track and understand your menstrual cycle and health patterns. However, Bloom is NOT a medical device, and the information provided by the app does not constitute medical advice, diagnosis, or treatment. Always consult with a qualified healthcare provider regarding any medical questions or conditions.',
              ),
              
              _buildSection(
                context,
                '3. User Data & Privacy',
                'Your privacy is our priority. Bloom collects and processes your health data strictly to provide you with insights and functionality. Your data is stored securely. For detailed information on how we handle your data, please read our Privacy Policy.',
              ),

              _buildSection(
                context,
                '4. User Responsibilities',
                'You are responsible for maintaining the confidentiality of your account and the accuracy of the data you log. You agree not to use Bloom for any unlawful or prohibited activities.',
              ),

              _buildSection(
                context,
                '5. Modifications to the App & Terms',
                'We reserve the right to modify or discontinue any feature of Bloom at any time. We may also revise these Terms of Use periodically. Your continued use of the app after changes have been made constitutes acceptance of the new terms.',
              ),

              _buildSection(
                context,
                '6. Contact Us',
                'If you have any questions or concerns about these Terms of Use, please contact our support team at support@bloomapp.example.com.',
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
