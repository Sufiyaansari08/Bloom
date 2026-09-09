import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';

class AppSettingsPage extends ConsumerWidget {
  const AppSettingsPage({super.key});

  final List<String> cycleOptions = const [
    '21 - 24 days',
    '25 - 28 days',
    '29 - 32 days',
    '33 - 35 days',
  ];

  final List<String> periodOptions = const [
    '2 - 3 days',
    '4 - 5 days',
    '6 - 7 days',
    '8+ days',
  ];

  final List<String> goalOptions = const [
    'Track my period',
    'Understand my symptoms',
    'Lifestyle & wellness',
    'Sleep & energy',
    'Understand unusual changes',
    'Fertility planning',
    'Learning about menstrual health',
    'Managing periods during college/school',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'App Settings',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User profile not found.'));

          // Map the integer back to a dropdown string
          String currentCycleString = cycleOptions.first;
          if (user.avgCycleLength <= 24) currentCycleString = '21 - 24 days';
          else if (user.avgCycleLength <= 28) currentCycleString = '25 - 28 days';
          else if (user.avgCycleLength <= 32) currentCycleString = '29 - 32 days';
          else currentCycleString = '33 - 35 days';

          String currentPeriodString = periodOptions.first;
          if (user.avgPeriodLength <= 3) currentPeriodString = '2 - 3 days';
          else if (user.avgPeriodLength <= 5) currentPeriodString = '4 - 5 days';
          else if (user.avgPeriodLength <= 7) currentPeriodString = '6 - 7 days';
          else currentPeriodString = '8+ days';

          List<String> selectedGoals = user.primaryGoal?.split(',') ?? [];
          selectedGoals.removeWhere((g) => g.isEmpty);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCollapsibleSection(
                    context: context,
                    title: 'Cycle & Tracking',
                    icon: Icons.calendar_today_outlined,
                    initiallyExpanded: true,
                    children: [
                      _SettingsDropdown(
                        title: 'Cycle length',
                        value: currentCycleString,
                        options: cycleOptions,
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            final cycleLen = int.tryParse(newValue.split(' ')[0]);
                            if (cycleLen != null) {
                              final userRepo = ref.read(userRepositoryProvider);
                              await userRepo.saveUserProfile(user.toCompanion(true).copyWith(
                                avgCycleLength: drift.Value(cycleLen),
                              ));
                            }
                          }
                        },
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _SettingsDropdown(
                        title: 'Period duration',
                        value: currentPeriodString,
                        options: periodOptions,
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            final periodLen = int.tryParse(newValue.split(' ')[0]);
                            if (periodLen != null) {
                              final userRepo = ref.read(userRepositoryProvider);
                              await userRepo.saveUserProfile(user.toCompanion(true).copyWith(
                                avgPeriodLength: drift.Value(periodLen),
                              ));
                            }
                          }
                        },
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      ListTile(
                        title: const Text('Primary goals', style: TextStyle(color: AppColors.text, fontSize: 16)),
                        subtitle: Text(
                          selectedGoals.isEmpty ? 'None selected' : '${selectedGoals.length} selected',
                          style: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.secondaryText),
                        onTap: () => _showGoalsPicker(context, ref, user, selectedGoals),
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _SettingsSwitch(
                        title: 'Period prediction',
                        value: user.periodPredictionEnabled,
                        onChanged: (val) async {
                          final userRepo = ref.read(userRepositoryProvider);
                          await userRepo.saveUserProfile(user.toCompanion(true).copyWith(
                            periodPredictionEnabled: drift.Value(val),
                          ));
                        },
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _SettingsSwitch(
                        title: 'Ovulation prediction',
                        value: user.ovulationPredictionEnabled,
                        onChanged: (val) async {
                          final userRepo = ref.read(userRepositoryProvider);
                          await userRepo.saveUserProfile(user.toCompanion(true).copyWith(
                            ovulationPredictionEnabled: drift.Value(val),
                          ));
                        },
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _SettingsSwitch(
                        title: 'Fertile window',
                        value: user.fertileWindowEnabled,
                        onChanged: (val) async {
                          final userRepo = ref.read(userRepositoryProvider);
                          await userRepo.saveUserProfile(user.toCompanion(true).copyWith(
                            fertileWindowEnabled: drift.Value(val),
                          ));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildCollapsibleSection(
                    context: context,
                    title: 'Data & Sync',
                    icon: Icons.cloud_sync_outlined,
                    initiallyExpanded: false,
                    children: [
                      ListTile(
                        title: const Text('Sync now', style: TextStyle(color: AppColors.primaryPurple, fontSize: 16, fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.sync, color: AppColors.primaryPurple),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Syncing...')));
                          Future.delayed(const Duration(seconds: 2), () {
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync complete!')));
                          });
                        },
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      _SettingsInfoRow(title: 'Last synced', value: DateFormat('MMM d, h:mm a').format(user.updatedAt)),
                      const Divider(color: AppColors.border, height: 1),
                      const _SettingsInfoRow(title: 'Sync status', value: 'Local only (Offline)'),
                      const Divider(color: AppColors.border, height: 1),
                      const _SettingsInfoRow(title: 'Pending data', value: '0 items'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Icon(icon, color: AppColors.primaryPurple),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          iconColor: AppColors.primaryPurple,
          collapsedIconColor: AppColors.secondaryText,
          children: children,
        ),
      ),
    );
  }

  void _showGoalsPicker(BuildContext context, WidgetRef ref, dynamic user, List<String> currentSelected) {
    List<String> tempSelected = List.from(currentSelected);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Primary Goals',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final userRepo = ref.read(userRepositoryProvider);
                          await userRepo.saveUserProfile(user.toCompanion(true).copyWith(
                            primaryGoal: drift.Value(tempSelected.join(',')),
                          ));
                        },
                        child: const Text('Done', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: goalOptions.length,
                      itemBuilder: (context, index) {
                        final goal = goalOptions[index];
                        final isSelected = tempSelected.contains(goal);
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(goal, style: const TextStyle(color: AppColors.text)),
                          value: isSelected,
                          activeColor: AppColors.primaryPurple,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                tempSelected.add(goal);
                              } else {
                                tempSelected.remove(goal);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _SettingsDropdown({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.text, fontSize: 16)),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryPurple),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            items: options.map<DropdownMenuItem<String>>((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.text, fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }
}

class _SettingsInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _SettingsInfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.text, fontSize: 16)),
          Text(value, style: const TextStyle(color: AppColors.secondaryText, fontSize: 16)),
        ],
      ),
    );
  }
}
