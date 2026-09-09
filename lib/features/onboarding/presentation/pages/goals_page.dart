import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_checkbox_tile.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

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
                onPressed: () async {
                  final userRepo = ref.read(userRepositoryProvider);
                  final currentUser = await userRepo.getUserProfile();
                  if (currentUser != null && state.userName != null) {
                    int? cycleLen;
                    if (state.cycleDuration != null && state.cycleDuration!.contains(' ')) {
                      cycleLen = int.tryParse(state.cycleDuration!.split(' ')[0]);
                    }
                    int? periodLen;
                    if (state.periodDuration != null && state.periodDuration!.contains(' ')) {
                      periodLen = int.tryParse(state.periodDuration!.split(' ')[0]);
                    }

                    await userRepo.saveUserProfile(
                      currentUser.toCompanion(true).copyWith(
                        name: drift.Value(state.userName!),
                        email: state.userEmail != null ? drift.Value(state.userEmail) : const drift.Value.absent(),
                        avgCycleLength: cycleLen != null ? drift.Value(cycleLen) : const drift.Value.absent(),
                        avgPeriodLength: periodLen != null ? drift.Value(periodLen) : const drift.Value.absent(),
                      ),
                    );

                    // Create an initial cycle based on lastPeriodDate
                    if (state.lastPeriodDate != null) {
                      final cycleRepo = ref.read(cycleRepositoryProvider);
                      // Since we use uuid for IDs, let's use the uuid package or a simple timestamp
                      final newCycle = CyclesCompanion.insert(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        userId: currentUser.id,
                        startDate: state.lastPeriodDate!,
                        cycleLength: drift.Value(cycleLen),
                        periodLength: drift.Value(periodLen),
                      );
                      await cycleRepo.insertCycle(newCycle);
                    }
                  }
                  if (context.mounted) {
                    context.go('/home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
