import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_grid_item.dart';
import '../../../../shared/widgets/bloom_slider.dart';
import '../providers/daily_checkin_provider.dart';

class CheckinRemediesPage extends ConsumerWidget {
  const CheckinRemediesPage({super.key});

  final List<Map<String, dynamic>> remedies = const [
    {'label': 'Rest', 'icon': Icons.bed},
    {'label': 'Heating pad', 'icon': Icons.whatshot},
    {'label': 'Stretching', 'icon': Icons.accessibility_new},
    {'label': 'Walking', 'icon': Icons.directions_walk},
    {'label': 'Medicine', 'icon': Icons.medication},
    {'label': 'Nothing', 'icon': Icons.block},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyCheckinProvider);
    final selectedRemedies = state.remedies;
    final painAfter = state.painAfter1Hour;

    return Scaffold(
      appBar: const BloomAppBar(progress: 0.8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Did you take anything\nfor pain or symptoms?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select all that apply',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: remedies.length,
                      itemBuilder: (context, index) {
                        final remedy = remedies[index];
                        final label = remedy['label'] as String;
                        final isSelected = selectedRemedies.contains(label);

                        return BloomGridItem(
                          label: label,
                          icon: remedy['icon'] as IconData,
                          isSelected: isSelected,
                          onTap: () {
                            ref.read(dailyCheckinProvider.notifier).toggleRemedy(label);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pain after 1 hour',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '$painAfter / 10',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BloomSlider(
                      value: painAfter.toDouble(),
                      onChanged: (val) {
                        ref.read(dailyCheckinProvider.notifier).setPainAfter1Hour(val.toInt());
                      },
                    ),
                  ],
                ),
              ),
              BloomButton(
                text: 'Done',
                onPressed: () {
                  context.push('/checkin/notes');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
