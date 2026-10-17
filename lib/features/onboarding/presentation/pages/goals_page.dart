import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_checkbox_tile.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/auth_storage_service.dart';
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
                  var currentUser = await userRepo.getUserProfile();
                  int? cycleLen;
                  if (state.cycleDuration != null && state.cycleDuration!.contains(' ')) {
                    cycleLen = int.tryParse(state.cycleDuration!.split(' ')[0]);
                  }
                  int? periodLen;
                  if (state.periodDuration != null && state.periodDuration!.contains(' ')) {
                    periodLen = int.tryParse(state.periodDuration!.split(' ')[0]);
                  }

                  if (currentUser != null) {
                    await userRepo.saveUserProfile(
                      currentUser.toCompanion(true).copyWith(
                        name: drift.Value(state.userName ?? currentUser.name),
                        email: state.userEmail != null ? drift.Value(state.userEmail) : const drift.Value.absent(),
                        dateOfBirth: drift.Value(state.dateOfBirth),
                        heightCm: drift.Value(state.heightCm),
                        weightKg: drift.Value(state.weightKg),
                        bloodGroup: drift.Value(state.bloodGroup),
                        avgCycleLength: cycleLen != null ? drift.Value(cycleLen) : const drift.Value.absent(),
                        avgPeriodLength: periodLen != null ? drift.Value(periodLen) : const drift.Value.absent(),
                        primaryGoal: state.goals.isNotEmpty ? drift.Value(state.goals.join(', ')) : const drift.Value.absent(),
                      ),
                    );
                  } else {
                    final userId = DateTime.now().millisecondsSinceEpoch.toString();
                    await userRepo.saveUserProfile(
                      UserProfilesCompanion.insert(
                        id: userId,
                        name: state.userName ?? 'User',
                        email: drift.Value(state.userEmail),
                        dateOfBirth: drift.Value(state.dateOfBirth),
                        heightCm: drift.Value(state.heightCm),
                        weightKg: drift.Value(state.weightKg),
                        bloodGroup: drift.Value(state.bloodGroup),
                        avgCycleLength: drift.Value(cycleLen ?? 28),
                        avgPeriodLength: drift.Value(periodLen ?? 5),
                        primaryGoal: drift.Value(state.goals.isNotEmpty ? state.goals.join(', ') : null),
                      ),
                    );
                    currentUser = await userRepo.getUserProfile();
                  }

                  // Create an initial cycle based on lastPeriodDate
                  if (currentUser != null && state.lastPeriodDate != null) {
                    final cycleRepo = ref.read(cycleRepositoryProvider);
                    final newCycle = CyclesCompanion.insert(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: currentUser.id,
                      startDate: state.lastPeriodDate!,
                      cycleLength: drift.Value(cycleLen),
                      periodLength: drift.Value(periodLen),
                    );
                    await cycleRepo.insertCycle(newCycle);
                  }
                  await AuthStorageService.instance.setLoggedIn(true);
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
