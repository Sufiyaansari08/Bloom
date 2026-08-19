import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../providers/onboarding_provider.dart';

class LastPeriodPage extends ConsumerStatefulWidget {
  const LastPeriodPage({super.key});

  @override
  ConsumerState<LastPeriodPage> createState() => _LastPeriodPageState();
}

class _LastPeriodPageState extends ConsumerState<LastPeriodPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final stateDate = ref.read(onboardingProvider).lastPeriodDate;
    if (stateDate != null) {
      _selectedDate = stateDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BloomAppBar(progress: 0.2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'When was the first day\nof your last period?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.primaryPink,
                        onPrimary: Colors.white,
                        onSurface: AppColors.text,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: CalendarDatePicker(
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                        onDateChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              BloomButton(
                text: 'Next',
                onPressed: () {
                  ref.read(onboardingProvider.notifier).setLastPeriodDate(_selectedDate);
                  context.push('/onboarding/period_duration');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
