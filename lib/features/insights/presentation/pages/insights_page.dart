import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/database/database_providers.dart';
import '../widgets/insights_hero_card.dart';
import '../widgets/insights_grid_button.dart';
import '../../../doctor_report/presentation/widgets/doctor_report_banner.dart';
import '../widgets/bloom_pro_banner.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cyclesAsync = ref.watch(allCyclesStreamProvider);
    final cycles = cyclesAsync.value ?? [];
    final completedCycles = cycles
        .where((c) =>
            !c.isDeleted &&
            c.endDate != null &&
            c.cycleLength != null &&
            c.cycleLength! > 0)
        .toList();

    final String cycleSubtitle;
    if (completedCycles.isEmpty) {
      cycleSubtitle = 'Based on onboarding profile';
    } else if (completedCycles.length == 1) {
      cycleSubtitle = 'Based on your last cycle';
    } else {
      final count = completedCycles.length > 6 ? 6 : completedCycles.length;
      cycleSubtitle = 'Based on your last $count cycles';
    }

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
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: AppColors.text),
                    onPressed: () {
                      context.push('/reminders');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    cycleSubtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      showPageInfoDialog(
                        context,
                        title: 'Insights Overview',
                        description: completedCycles.isEmpty
                            ? 'This dashboard currently displays your baseline health profile. As you log periods and complete cycles, your personal averages and patterns will appear here.'
                            : 'This dashboard provides a comprehensive analysis of your health patterns, cycle regularity, and symptom trends based on your logged history.',
                      );
                    },
                    child: Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.secondaryText.withValues(alpha: 0.8),
                    ),
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
                    onTap: () => context.push('/insights/symptoms'),
                  ),
                  InsightsGridButton(
                    icon: Icons.bolt_outlined,
                    iconColor: Colors.orangeAccent,
                    label: 'Pain\nInsights',
                    onTap: () => context.push('/insights/pain'),
                  ),
                  InsightsGridButton(
                    icon: Icons.sentiment_satisfied_alt,
                    iconColor: Colors.blueAccent,
                    label: 'Mood\nTrends',
                    onTap: () => context.push('/insights/mood'),
                  ),
                  InsightsGridButton(
                    icon: Icons.local_drink_outlined,
                    iconColor: Colors.green,
                    label: 'Lifestyle\nInsights',
                    onTap: () => context.push('/insights/lifestyle'),
                  ),
                  InsightsGridButton(
                    icon: Icons.compare_arrows,
                    iconColor: Colors.teal, // Kept color consistent with previous
                    label: 'Compare\nCycles',
                    onTap: () => context.push('/insights/compare'),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              const DoctorReportBanner(),
              const SizedBox(height: 16),

              // Pro Banner
              const BloomProBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
