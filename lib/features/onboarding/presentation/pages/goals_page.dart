import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_checkbox_tile.dart';
import '../providers/onboarding_provider.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  final List<Map<String, dynamic>> goals = const [
    {'label': 'Track my period', 'icon': Icons.calendar_month},
    {'label': 'Understand my symptoms', 'icon': Icons.insights},
    {'label': 'Lifestyle & wellness', 'icon': Icons.spa},
    {'label': 'Sleep & energy', 'icon': Icons.nights_stay},
    {'label': 'Understand unusual changes', 'icon': Icons.change_circle},
    {'label': 'Fertility planning', 'icon': Icons.child_care},
    {'label': 'Learning about menstrual health', 'icon': Icons.menu_book},
    {'label': 'Managing periods during college/school', 'icon': Icons.school},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final selectedGoals = state.goals;

    return Scaffold(
      appBar: const BloomAppBar(progress: 1.0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What do you want\nhelp with?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select all that apply',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final label = goal['label'] as String;
                    final isSelected = selectedGoals.contains(label);

                    return BloomCheckboxTile(
                      text: label,
                      icon: goal['icon'] as IconData,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(onboardingProvider.notifier).toggleGoal(label);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              BloomButton(
                text: 'Save',
                onPressed: () {
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
