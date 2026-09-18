import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import 'package:intl/intl.dart';
import '../providers/daily_checkin_provider.dart';

class CheckinNotesPage extends ConsumerWidget {
  const CheckinNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyCheckinProvider);
    final targetDate = state.targetDate ?? DateTime.now();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cleanTarget = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final isToday = cleanTarget.isAtSameMomentAs(today);
    final isYesterday = cleanTarget.isAtSameMomentAs(today.subtract(const Duration(days: 1)));

    final notesTitle = isToday
        ? 'Any notes for today?'
        : (isYesterday
            ? 'Any notes for yesterday?'
            : 'Any notes for ${DateFormat('MMM d').format(cleanTarget)}?');

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
                      notesTitle,
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
                      controller: TextEditingController(text: state.notes)
                        ..selection = TextSelection.fromPosition(TextPosition(offset: state.notes.length)),
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
                        final effectiveDate = ref.read(dailyCheckinProvider).targetDate ?? DateTime.now();
                        final fromCalendar = ref.read(dailyCheckinProvider).fromCalendar;

                        await ref.read(dailyCheckinProvider.notifier).saveToDatabase(effectiveDate);
                        ref.read(dailyCheckinProvider.notifier).clear();

                        if (context.mounted) {
                          final isTodaySaved = DateUtils.isSameDay(effectiveDate, DateTime.now());
                          final isYesterdaySaved = DateUtils.isSameDay(effectiveDate, DateTime.now().subtract(const Duration(days: 1)));
                          final label = isYesterdaySaved ? 'yesterday' : (isTodaySaved ? 'today' : DateFormat('MMM d').format(effectiveDate));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Daily check-in saved for $label'),
                              backgroundColor: AppColors.primaryPurple,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );

                          if (fromCalendar) {
                            context.go('/calendar');
                          } else {
                            context.go('/home');
                          }
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
