import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_option_card.dart';
import '../providers/onboarding_provider.dart';

class CycleDurationPage extends ConsumerWidget {
  const CycleDurationPage({super.key});

  final List<String> options = const [
    '21 - 24 days',
    '25 - 28 days',
    '29 - 32 days',
    '33 - 35 days',
    'Irregular',
    "I don't know",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final selectedDuration = state.cycleDuration;

    return Scaffold(
      appBar: const BloomAppBar(progress: 0.6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How long is your cycle\nusually?',
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
                        ref.read(onboardingProvider.notifier).setCycleDuration(option);
                      },
                    );
                  },
                ),
              ),
              BloomButton(
                text: 'Next',
                onPressed: () {
                  if (selectedDuration != null) {
                    context.push('/onboarding/symptoms');
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
