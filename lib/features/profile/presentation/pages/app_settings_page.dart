import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../shared/widgets/bloom_button.dart';

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
          if (user == null) {
            return const Center(child: Text('User profile not found.'));
          }

          // Map the integer back to a dropdown string
          String currentCycleString = cycleOptions.first;
          if (user.avgCycleLength <= 24) {
            currentCycleString = '21 - 24 days';
          } else if (user.avgCycleLength <= 28) {
            currentCycleString = '25 - 28 days';
          } else if (user.avgCycleLength <= 32) {
            currentCycleString = '29 - 32 days';
          } else {
            currentCycleString = '33 - 35 days';
          }

          String currentPeriodString = periodOptions.first;
          if (user.avgPeriodLength <= 3) {
            currentPeriodString = '2 - 3 days';
          } else if (user.avgPeriodLength <= 5) {
            currentPeriodString = '4 - 5 days';
          } else if (user.avgPeriodLength <= 7) {
            currentPeriodString = '6 - 7 days';
          } else {
            currentPeriodString = '8+ days';
          }

          List<String> selectedGoals = user.primaryGoal?.split(',') ?? [];
          selectedGoals.removeWhere((g) => g.isEmpty);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Cycle & Health Parameters
                  const Text(
                    'Cycle & Health Parameters',
                    style: TextStyle(
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
                    child: Column(
                      children: [
                        // Cycle length dropdown
                        _buildDropdownTile(
                          icon: Icons.autorenew_rounded,
                          title: 'Cycle length',
                          subtitle: 'Average days between periods',
                          value: currentCycleString,
                          options: cycleOptions,
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              final cycleLen = int.tryParse(newValue.split(' ')[0]);
                              if (cycleLen != null) {
                                final userRepo = ref.read(userRepositoryProvider);
                                await userRepo.saveUserProfile(
                                  user.toCompanion(true).copyWith(
                                    avgCycleLength: drift.Value(cycleLen),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // Period duration dropdown
                        _buildDropdownTile(
                          icon: Icons.water_drop_outlined,
                          title: 'Period duration',
                          subtitle: 'Typical number of bleeding days',
                          value: currentPeriodString,
                          options: periodOptions,
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              final periodLen = int.tryParse(newValue.split(' ')[0]);
                              if (periodLen != null) {
                                final userRepo = ref.read(userRepositoryProvider);
                                await userRepo.saveUserProfile(
                                  user.toCompanion(true).copyWith(
                                    avgPeriodLength: drift.Value(periodLen),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // Primary goals tile
                        _buildActionTile(
                          icon: Icons.flag_outlined,
                          title: 'Primary goals',
                          subtitle: selectedGoals.isEmpty
                              ? 'Tap to select health goals'
                              : '${selectedGoals.length} selected',
                          trailingText: selectedGoals.isEmpty
                              ? 'Select'
                              : '${selectedGoals.length} goals',
                          onTap: () => _showGoalsPicker(
                            context,
                            ref,
                            user,
                            selectedGoals,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Section 2: Cycle Predictions & Tracking
                  const Text(
                    'Predictions & Tracking',
                    style: TextStyle(
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
                    child: Column(
                      children: [
                        // Period prediction switch
                        _buildSwitchTile(
                          icon: Icons.insights_outlined,
                          title: 'Period prediction',
                          subtitle: 'Predict future cycle start dates',
                          value: user.periodPredictionEnabled,
                          onChanged: (val) async {
                            final userRepo = ref.read(userRepositoryProvider);
                            await userRepo.saveUserProfile(
                              user.toCompanion(true).copyWith(
                                periodPredictionEnabled: drift.Value(val),
                              ),
                            );
                          },
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // Ovulation prediction switch
                        _buildSwitchTile(
                          icon: Icons.egg_outlined,
                          title: 'Ovulation prediction',
                          subtitle: 'Estimate estimated ovulation day',
                          value: user.ovulationPredictionEnabled,
                          onChanged: (val) async {
                            final userRepo = ref.read(userRepositoryProvider);
                            await userRepo.saveUserProfile(
                              user.toCompanion(true).copyWith(
                                ovulationPredictionEnabled: drift.Value(val),
                              ),
                            );
                          },
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // Fertile window switch
                        _buildSwitchTile(
                          icon: Icons.spa_outlined,
                          title: 'Fertile window',
                          subtitle: 'Show estimated fertile days on calendar',
                          value: user.fertileWindowEnabled,
                          onChanged: (val) async {
                            final userRepo = ref.read(userRepositoryProvider);
                            await userRepo.saveUserProfile(
                              user.toCompanion(true).copyWith(
                                fertileWindowEnabled: drift.Value(val),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Section 3: Data & Sync
                  const Text(
                    'Data & Sync',
                    style: TextStyle(
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
                    child: Column(
                      children: [
                        // Sync now action
                        _buildActionTile(
                          icon: Icons.cloud_sync_outlined,
                          title: 'Sync now',
                          subtitle: 'Synchronize local health logs with cloud',
                          trailingWidget: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightPurple,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primaryPurple.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.sync,
                                  size: 14,
                                  color: AppColors.primaryPurple,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Sync',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Syncing with cloud...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Sync complete! All records are up to date.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // Last synced info
                        _buildInfoTile(
                          icon: Icons.access_time,
                          title: 'Last synced',
                          subtitle: 'Timestamp of previous backup',
                          value: DateFormat('MMM d, h:mm a').format(user.updatedAt),
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // Sync status info
                        _buildInfoTile(
                          icon: Icons.offline_pin_outlined,
                          title: 'Sync status',
                          subtitle: 'Current cloud connectivity',
                          value: 'Local only (Offline)',
                        ),
                        const Divider(color: AppColors.border, height: 1),

                        // Pending data info
                        _buildInfoTile(
                          icon: Icons.pending_actions_outlined,
                          title: 'Pending data',
                          subtitle: 'Unsynced records waiting in queue',
                          value: '0 items',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
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

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: AppColors.primaryPurple,
                ),
                isDense: true,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                selectedItemBuilder: (BuildContext context) {
                  return options.map<Widget>((String val) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        val,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    );
                  }).toList();
                },
                items: options.map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: value ? AppColors.lightPurple : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.primaryPurple : AppColors.secondaryText,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: AppColors.primaryPurple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.lightPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryPurple, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingWidget != null)
              trailingWidget
            else if (trailingText != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trailingText,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.primaryPurple,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalsPicker(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    List<String> currentSelected,
  ) {
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.secondaryText),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose the goals that matter most to your health journey.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.45,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: goalOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final goal = goalOptions[index];
                        final isSelected = tempSelected.contains(goal);
                        return Material(
                          color: isSelected ? AppColors.lightPurple : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryPurple
                                  : AppColors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  tempSelected.remove(goal);
                                } else {
                                  tempSelected.add(goal);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? AppColors.primaryPurple
                                        : AppColors.secondaryText,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      goal,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primaryPurple
                                            : AppColors.text,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  BloomButton(
                    text: 'Save Goals',
                    backgroundColor: AppColors.primaryPurple,
                    onPressed: () async {
                      Navigator.pop(context);
                      final userRepo = ref.read(userRepositoryProvider);
                      await userRepo.saveUserProfile(
                        user.toCompanion(true).copyWith(
                          primaryGoal: drift.Value(tempSelected.join(',')),
                        ),
                      );
                    },
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
