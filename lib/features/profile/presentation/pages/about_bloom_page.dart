import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class AboutBloomPage extends StatelessWidget {
  const AboutBloomPage({super.key});

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
          'About Bloom',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Beautiful App Logo Header
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Bloom',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'Bloom is your intelligent, compassionate companion for reproductive health. '
                'We believe in empowering you with deep insights and a complete understanding of your body\'s unique rhythms.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: AppColors.text.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 40),

              // What Bloom Offers Section
              _buildSectionHeader(context, 'What Bloom Offers', Icons.star_rounded),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                icon: Icons.calendar_month_rounded,
                title: 'Smart Cycle Tracking',
                description: 'Accurately predict your periods, fertile windows, and ovulation days using intelligent algorithms.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                icon: Icons.insights_rounded,
                title: 'Deep Health Insights',
                description: 'Discover how your cycle influences your mood, sleep, pain levels, and overall lifestyle.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                icon: Icons.medical_services_outlined,
                title: 'Doctor Reports',
                description: 'Easily generate comprehensive cycle history reports to share with your healthcare provider.',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                icon: Icons.notifications_active_outlined,
                title: 'Personalized Reminders',
                description: 'Never get caught off guard. Receive gentle, customizable alerts for your upcoming period, fertile window, and daily check-ins.',
              ),
              
              const SizedBox(height: 40),

              // How Bloom Works Section
              _buildSectionHeader(context, 'How Bloom Works', Icons.psychology_rounded),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    _buildTimelineStep(
                      context,
                      stepNumber: '1',
                      title: 'Log Daily',
                      description: 'Quickly log your mood, symptoms, and flow each day.',
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      context,
                      stepNumber: '2',
                      title: 'Analyze Patterns',
                      description: 'Bloom finds connections between your lifestyle and your cycle phases.',
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      context,
                      stepNumber: '3',
                      title: 'Stay Prepared',
                      description: 'Get timely reminders and actionable insights tailored to your body.',
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Legal Links
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildListTile('Terms of Use', () {
                      context.push('/terms_of_use');
                    }),
                    const Divider(height: 1, color: AppColors.border, indent: 20, endIndent: 20),
                    _buildListTile('Privacy Policy', () {}),
                    const Divider(height: 1, color: AppColors.border, indent: 20, endIndent: 20),
                    _buildListTile('Medical Disclaimer', () {}),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              Text(
                'Crafted with ♥ for your well-being',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '© 2026 Bloom Inc.',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryPink, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F9), // Very light soft background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryPink, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required String stepNumber,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryPink,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.primaryPink.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              if (!isLast) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}
