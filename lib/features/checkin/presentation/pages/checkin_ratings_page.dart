import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_slider.dart';
import '../providers/daily_checkin_provider.dart';

class CheckinRatingsPage extends ConsumerWidget {
  const CheckinRatingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyCheckinProvider);
    final symptoms = state.symptoms;
    final ratings = state.symptomRatings;

    return Scaffold(
      appBar: const BloomAppBar(progress: 0.4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How would you rate these?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '(0 = None        10 = Severe)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    final currentRating = ratings[symptom] ?? 5; // Default 5

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                symptom,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                '$currentRating',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          BloomSlider(
                            value: currentRating.toDouble(),
                            onChanged: (val) {
                              ref.read(dailyCheckinProvider.notifier).setSymptomRating(symptom, val.toInt());
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              BloomButton(
                text: 'Next',
                onPressed: () {
                  context.push('/checkin/lifestyle');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
