import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_lifestyle_card.dart';
import '../../../../shared/widgets/bloom_slider.dart';
import '../providers/daily_checkin_provider.dart';

class CheckinLifestylePage extends ConsumerWidget {
  const CheckinLifestylePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyCheckinProvider);
    final stressLevel = state.stressLevel;

    return Scaffold(
      appBar: const BloomAppBar(progress: 0.6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s lifestyle',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    BloomLifestyleCard(
                      title: 'Sleep last night',
                      icon: Icons.nightlight_round,
                      trailing: PopupMenuButton<String>(
                        initialValue: state.sleep ?? 'Select',
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.white,
                        elevation: 4,
                        onSelected: (val) {
                          ref.read(dailyCheckinProvider.notifier).setLifestyle(sleep: val == 'Select' ? null : val);
                        },
                        itemBuilder: (context) => ['Select', '< 5 h', '5 - 6 h', '6 h 30 m', '7 - 8 h', '8 h 00 m', '> 8 h']
                            .map((e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: e == 'Select' ? AppColors.secondaryText : AppColors.text,
                                  )),
                                ))
                            .toList(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.sleep ?? 'Select',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: state.sleep == null ? AppColors.secondaryText : AppColors.text,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryText),
                          ],
                        ),
                      ),
                    ),
                    BloomLifestyleCard(
                      title: 'Water intake',
                      icon: Icons.local_drink,
                      trailing: PopupMenuButton<String>(
                        initialValue: state.waterIntake ?? 'Select',
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.white,
                        elevation: 4,
                        onSelected: (val) {
                          ref.read(dailyCheckinProvider.notifier).setLifestyle(waterIntake: val == 'Select' ? null : val);
                        },
                        itemBuilder: (context) => ['Select', '< 1.0 L', '1.5 L', '2.0 L', '2.5 L', '> 3.0 L']
                            .map((e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: e == 'Select' ? AppColors.secondaryText : AppColors.text,
                                  )),
                                ))
                            .toList(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.waterIntake ?? 'Select',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: state.waterIntake == null ? AppColors.secondaryText : AppColors.text,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryText),
                          ],
                        ),
                      ),
                    ),
                    BloomLifestyleCard(
                      title: 'Activity',
                      icon: Icons.directions_walk,
                      trailing: PopupMenuButton<String>(
                        initialValue: state.activity ?? 'Select',
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.white,
                        elevation: 4,
                        onSelected: (val) {
                          ref.read(dailyCheckinProvider.notifier).setLifestyle(activity: val == 'Select' ? null : val);
                        },
                        itemBuilder: (context) => ['Select', 'Low', 'Moderate', 'High', 'Rest day']
                            .map((e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: e == 'Select' ? AppColors.secondaryText : AppColors.text,
                                  )),
                                ))
                            .toList(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.activity ?? 'Select',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: state.activity == null ? AppColors.secondaryText : AppColors.text,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryText),
                          ],
                        ),
                      ),
                    ),
                    BloomLifestyleCard(
                      title: 'Stress level',
                      icon: Icons.speed,
                      valueText: '$stressLevel / 10',
                      bottomWidget: BloomSlider(
                        value: stressLevel.toDouble(),
                        onChanged: (val) {
                          ref.read(dailyCheckinProvider.notifier).setLifestyle(stressLevel: val.toInt());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              BloomButton(
                text: 'Next',
                onPressed: () {
                  context.push('/checkin/remedies');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
