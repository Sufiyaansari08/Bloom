import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/insights_provider.dart';
import '../widgets/insight_toggle_bar.dart';
import '../widgets/cycle_length_chart.dart';
import '../widgets/symptom_prediction_card.dart';
import '../widgets/export_report_card.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(insightsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // padding for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insights',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 24),
              InsightToggleBar(
                currentTab: currentTab,
                onTabChanged: (tab) {
                  ref.read(insightsProvider.notifier).setTab(tab);
                },
              ),
              const SizedBox(height: 32),
              
              if (currentTab == InsightTab.cycle) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your cycle length is normal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Average 28 days',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.info_outline, color: AppColors.secondaryText),
                  ],
                ),
                const SizedBox(height: 24),
                const CycleLengthChart(),
                const SizedBox(height: 32),
                const Text(
                  'Symptom predictions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                const SymptomPredictionCard(
                  symptom: 'Cramps',
                  prediction: 'Expected in 2 days',
                  icon: Icons.waves,
                ),
                const SymptomPredictionCard(
                  symptom: 'Bloating',
                  prediction: 'Expected in 4 days',
                  icon: Icons.bubble_chart,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Generate report',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                const ExportReportCard(),
              ] else ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'More insights coming soon...',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
