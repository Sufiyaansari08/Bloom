import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MedicalDisclaimerPage extends StatelessWidget {
  const MedicalDisclaimerPage({super.key});

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
          'Medical Disclaimer',
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
                '1. Not a Substitute for Medical Advice',
                'The content, predictions, and insights provided by Bloom are strictly for informational and educational purposes. Bloom is NOT a medical device, nor does it provide medical advice, diagnosis, or treatment. The app is not intended to replace consultation with a qualified healthcare professional.',
              ),
              
              _buildSection(
                context,
                '2. Always Consult Your Doctor',
                'Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition, symptoms, or reproductive health. Never disregard professional medical advice or delay in seeking it because of something you have read or tracked in Bloom.',
              ),
              
              _buildSection(
                context,
                '3. Not for Contraception',
                'Bloom\'s fertile window and ovulation predictions are estimates based on your logged data. They should NOT be relied upon as a method of birth control or contraception to prevent pregnancy.',
              ),

              _buildSection(
                context,
                '4. Medical Emergencies',
                'If you think you may have a medical emergency, call your doctor, go to the emergency department, or call emergency services immediately. Bloom should not be used in emergencies.',
              ),

              _buildSection(
                context,
                '5. Assumption of Risk',
                'Reliance on any information provided by Bloom is solely at your own risk. While we strive to provide accurate algorithms and insights, every body is unique, and predictions may not always align with your actual physical symptoms or cycle events.',
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
