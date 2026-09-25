import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Onboarding
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/onboarding/presentation/pages/name_page.dart';
import '../../features/onboarding/presentation/pages/last_period_page.dart';
import '../../features/onboarding/presentation/pages/period_duration_page.dart';
import '../../features/onboarding/presentation/pages/cycle_duration_page.dart';
import '../../features/onboarding/presentation/pages/symptoms_page.dart';
import '../../features/onboarding/presentation/pages/goals_page.dart';
// Check-in
import '../../features/checkin/presentation/pages/checkin_mood_page.dart';
import '../../features/checkin/presentation/pages/checkin_ratings_page.dart';
import '../../features/checkin/presentation/pages/checkin_lifestyle_page.dart';
import '../../features/checkin/presentation/pages/checkin_remedies_page.dart';
import '../../features/checkin/presentation/pages/checkin_notes_page.dart';
// Period Logging
import '../../features/period_logging/presentation/pages/period_start_page.dart';
import '../../features/period_logging/presentation/pages/period_log_page.dart';
// Home Dashboard
import '../../features/home/presentation/pages/app_shell.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/app_settings_page.dart';
import '../../features/profile/presentation/pages/privacy_security_page.dart';
import '../../features/profile/presentation/pages/app_lock_choice_page.dart';
import '../../features/profile/presentation/pages/about_bloom_page.dart';
import '../../features/profile/presentation/pages/terms_of_use_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/profile/presentation/pages/medical_disclaimer_page.dart';
// Insights
import '../../features/insights/presentation/pages/insights_page.dart';
import '../../features/insights/presentation/pages/cycle_patterns_page.dart';
import '../../features/insights/presentation/pages/symptoms_patterns_page.dart';
import '../../features/insights/presentation/pages/pain_insights_page.dart';
import '../../features/insights/presentation/pages/mood_trends_page.dart';
import '../../features/insights/presentation/pages/lifestyle_insights_page.dart';
import '../../features/insights/presentation/pages/compare_cycles_page.dart';

// Calendar
import '../../features/calendar/presentation/pages/calendar_page.dart';

// History
// Doctor Report
import '../../features/doctor_report/presentation/pages/doctor_report_setup_page.dart';
import '../../features/doctor_report/presentation/pages/doctor_report_result_page.dart';
import '../../features/reminders/presentation/pages/reminders_page.dart';
import '../../features/reminders/presentation/pages/reminder_settings_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [


    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/onboarding/name',
      builder: (context, state) => const NamePage(),
    ),
    GoRoute(
      path: '/onboarding/last_period',
      builder: (context, state) => const LastPeriodPage(),
    ),
    GoRoute(
      path: '/onboarding/period_duration',
      builder: (context, state) => const PeriodDurationPage(),
    ),
    GoRoute(
      path: '/onboarding/cycle_duration',
      builder: (context, state) => const CycleDurationPage(),
    ),
    GoRoute(
      path: '/onboarding/symptoms',
      builder: (context, state) => const SymptomsPage(),
    ),
    GoRoute(
      path: '/onboarding/goals',
      builder: (context, state) => const GoalsPage(),
    ),
    GoRoute(
      path: '/checkin/mood',
      builder: (context, state) => const CheckinMoodPage(),
    ),
    GoRoute(
      path: '/checkin/ratings',
      builder: (context, state) => const CheckinRatingsPage(),
    ),
    GoRoute(
      path: '/checkin/lifestyle',
      builder: (context, state) => const CheckinLifestylePage(),
    ),
    GoRoute(
      path: '/checkin/remedies',
      builder: (context, state) => const CheckinRemediesPage(),
    ),
    GoRoute(
      path: '/checkin/notes',
      builder: (context, state) => const CheckinNotesPage(),
    ),
    GoRoute(
      path: '/reminders',
      builder: (context, state) => const RemindersPage(),
    ),
    GoRoute(
      path: '/reminder_settings',
      builder: (context, state) => const ReminderSettingsPage(),
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/app_settings',
      builder: (context, state) => const AppSettingsPage(),
    ),
    GoRoute(
      path: '/privacy_security',
      builder: (context, state) => const PrivacySecurityPage(),
    ),
    GoRoute(
      path: '/app_lock',
      builder: (context, state) => const AppLockChoicePage(),
    ),
    GoRoute(
      path: '/about_bloom',
      builder: (context, state) => const AboutBloomPage(),
    ),
    GoRoute(
      path: '/terms_of_use',
      builder: (context, state) => const TermsOfUsePage(),
    ),
    GoRoute(
      path: '/privacy_policy',
      builder: (context, state) => const PrivacyPolicyPage(),
    ),
    GoRoute(
      path: '/medical_disclaimer',
      builder: (context, state) => const MedicalDisclaimerPage(),
    ),
    GoRoute(
      path: '/period_logging/start',
      builder: (context, state) => const PeriodStartPage(),
    ),
    GoRoute(
      path: '/period_logging/log',
      builder: (context, state) => const PeriodLogPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarPage(),
        ),
        GoRoute(
          path: '/insights',
          builder: (context, state) => const InsightsPage(),
        ),
        GoRoute(
          path: '/insights/cycle_patterns',
          builder: (context, state) => const CyclePatternsPage(),
        ),
        GoRoute(
          path: '/insights/symptoms',
          builder: (context, state) => const SymptomsPatternsPage(),
        ),
        GoRoute(
          path: '/insights/pain',
          builder: (context, state) => const PainInsightsPage(),
        ),
        GoRoute(
          path: '/insights/mood',
          builder: (context, state) => const MoodTrendsPage(),
        ),
        GoRoute(
          path: '/insights/lifestyle',
          builder: (context, state) => const LifestyleInsightsPage(),
        ),
        GoRoute(
          path: '/insights/compare',
          builder: (context, state) => const CompareCyclesPage(),
        ),
        GoRoute(
          path: '/doctor_report/setup',
          builder: (context, state) => const DoctorReportSetupPage(),
        ),
        GoRoute(
          path: '/doctor_report/result',
          builder: (context, state) => const DoctorReportResultPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);
