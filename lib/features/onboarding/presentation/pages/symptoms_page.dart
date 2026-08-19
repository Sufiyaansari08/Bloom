import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_grid_item.dart';
import '../providers/onboarding_provider.dart';

class SymptomsPage extends ConsumerWidget {
  const SymptomsPage({super.key});

  final List<Map<String, dynamic>> symptoms = const [
    {'label': 'Cramps', 'icon': Icons.waves},
    {'label': 'Headache', 'icon': Icons.face},
    {'label': 'Bloating', 'icon': Icons.bubble_chart},
    {'label': 'Back pain', 'icon': Icons.accessibility},
    {'label': 'Fatigue', 'icon': Icons.battery_alert},
    {'label': 'Mood changes', 'icon': Icons.mood_bad},
    {'label': 'Acne', 'icon': Icons.face_retouching_natural},
    {'label': 'Breast tenderness', 'icon': Icons.favorite_border},
    {'label': 'Food cravings', 'icon': Icons.fastfood},
    {'label': 'Other', 'icon': Icons.search},
    {'label': 'None', 'icon': Icons.block},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final selectedSymptoms = state.symptoms;

    return Scaffold(
      appBar: const BloomAppBar(progress: 0.8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What do you usually\nexperience around\nyour period?',
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
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    final label = symptom['label'] as String;
                    final isSelected = selectedSymptoms.contains(label);

                    return BloomGridItem(
                      label: label,
                      icon: symptom['icon'] as IconData,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(onboardingProvider.notifier).toggleSymptom(label);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              BloomButton(
                text: 'Next',
                onPressed: () {
                  context.push('/onboarding/goals');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
