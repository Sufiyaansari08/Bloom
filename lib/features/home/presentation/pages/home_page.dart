import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';
import '../widgets/cycle_status_card.dart';
import '../widgets/body_today_card.dart';
import '../widgets/summary_metrics_row.dart';
import '../widgets/quick_actions_grid.dart';
import '../../../doctor_report/presentation/widgets/doctor_report_banner.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // padding for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Good morning, ${state.userName} 🌸',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 24,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: AppColors.text,
                    ),
                    onPressed: () {
                      context.push('/reminders');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CycleStatusCard(
                cycleDay: state.cycleDay,
                daysUntilPeriod: state.daysUntilPeriod,
                periodDateRange: state.periodDateRange,
                fertileWindowRange: state.fertileWindowRange,
              ),
              const SizedBox(height: 32),
              const BodyTodayCard(
                message: 'You usually feel lower energy and get headaches around this point in your cycle.',
              ),
              const SizedBox(height: 24),
              SummaryMetricsRow(
                symptomsLogged: state.symptomsLogged,
                painLevel: state.painLevel,
                mood: state.mood,
              ),
              const SizedBox(height: 32),
              Text(
                'Quick actions',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              const QuickActionsGrid(),
              const SizedBox(height: 32),
              const DoctorReportBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
