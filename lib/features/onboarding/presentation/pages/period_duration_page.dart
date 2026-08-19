import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_option_card.dart';
import '../providers/onboarding_provider.dart';

class PeriodDurationPage extends ConsumerWidget {
  const PeriodDurationPage({super.key});

  final List<String> options = const [
    '2 - 3 days',
    '4 - 5 days',
    '6 - 7 days',
    '8+ days',
    'Not sure',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final selectedDuration = state.periodDuration;

    return Scaffold(
      appBar: const BloomAppBar(progress: 0.4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How long does your\nperiod usually last?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return BloomOptionCard(
                      text: option,
                      isSelected: selectedDuration == option,
                      onTap: () {
                        ref.read(onboardingProvider.notifier).setPeriodDuration(option);
                      },
                    );
                  },
                ),
              ),
              BloomButton(
                text: 'Next',
                onPressed: () {
                  if (selectedDuration != null) {
                    context.push('/onboarding/cycle_duration');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an option')),
                    );
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
