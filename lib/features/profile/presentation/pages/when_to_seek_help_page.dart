import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class WhenToSeekHelpPage extends StatelessWidget {
  const WhenToSeekHelpPage({super.key});

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
        title: const Text('When to Seek Medical Help', style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Important Notice',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bloom is designed for tracking and educational purposes. It cannot diagnose or treat medical conditions.',
                style: TextStyle(color: AppColors.secondaryText, height: 1.5),
              ),
              const SizedBox(height: 32),

              _buildSection(
                title: 'Contact a doctor if you experience:',
                items: [
                  'Periods that suddenly stop for more than 90 days.',
                  'Periods that become highly irregular after having been regular.',
                  'Bleeding for more than 7 days.',
                  'Bleeding that is significantly heavier than usual (soaking through a pad/tampon every 1-2 hours).',
                  'Bleeding between periods.',
                  'Severe pain during your period that disrupts your daily life.',
                  'Sudden fever or feeling sick after using tampons (Toxic Shock Syndrome risk).',
                ],
              ),

              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Emergency Information\n\nIf you believe you are experiencing a medical emergency, call your local emergency services (e.g., 911, 999, 112) or go to the nearest emergency room immediately.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, height: 1.5),
                      ),
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

  Widget _buildSection({required String title, required List<String> items}) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•', style: TextStyle(fontSize: 20, color: AppColors.primaryPurple, height: 1)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item, style: const TextStyle(color: AppColors.text, height: 1.5, fontSize: 15)),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
