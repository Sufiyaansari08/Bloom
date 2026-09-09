import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../providers/daily_checkin_provider.dart';

class CheckinNotesPage extends ConsumerWidget {
  const CheckinNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Scaffold(
      appBar: const BloomAppBar(progress: 1.0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Any notes for today?',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '(Optional)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      maxLines: 5,
                      maxLength: 200,
                      onChanged: (val) {
                        ref.read(dailyCheckinProvider.notifier).setNotes(val);
                      },
                      decoration: InputDecoration(
                        hintText: 'Felt very tired in the afternoon...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Column(
                        children: [
                          const Icon(Icons.local_florist, size: 64, color: AppColors.primaryPink), // Placeholder for plant
                          const SizedBox(height: 16),
                          Text(
                            'You\'re doing great!',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Taking care of yourself is important.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    BloomButton(
                      text: 'Done',
                      onPressed: () async {
                        await ref.read(dailyCheckinProvider.notifier).saveToDatabase(DateTime.now());
                        ref.read(dailyCheckinProvider.notifier).clear();
                        if (context.mounted) {
                          context.go('/home'); // Complete flow, back to home
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
