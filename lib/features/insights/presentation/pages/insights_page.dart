import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/insights_hero_card.dart';
import '../widgets/insights_grid_button.dart';
import '../widgets/bloom_pro_banner.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Insights',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: AppColors.text),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    'Based on your last 6 cycles',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.secondaryText.withValues(alpha: 0.8),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Hero Card
              const InsightsHeroCard(),
              const SizedBox(height: 32),

              // Overview Section Title
              const Text(
                'Insights Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),

              // 2-Column Grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InsightsGridButton(
                    icon: Icons.calendar_month_outlined,
                    iconColor: AppColors.primaryPink,
                    label: 'Cycle\nPatterns',
                    onTap: () => context.push('/insights/cycle_patterns'),
                  ),
                  InsightsGridButton(
                    icon: Icons.face_retouching_natural,
                    iconColor: AppColors.primaryPurple,
                    label: 'Symptoms\nPatterns',
                    onTap: () {},
                  ),
                  InsightsGridButton(
                    icon: Icons.bolt_outlined,
                    iconColor: Colors.orangeAccent,
                    label: 'Pain\nInsights',
                    onTap: () {},
                  ),
                  InsightsGridButton(
                    icon: Icons.sentiment_satisfied_alt,
                    iconColor: Colors.blueAccent,
                    label: 'Mood\nTrends',
                    onTap: () {},
                  ),
                  InsightsGridButton(
                    icon: Icons.local_drink_outlined,
                    iconColor: Colors.green,
                    label: 'Lifestyle\nInsights',
                    onTap: () {},
                  ),
                  InsightsGridButton(
                    icon: Icons.compare_arrows,
                    iconColor: Colors.teal,
                    label: 'Compare\nCycles',
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // Pro Banner
              const BloomProBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
