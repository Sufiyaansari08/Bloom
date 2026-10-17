# Graph Report - bloom  (2026-10-17)

## Corpus Check
- 146 files · ~506,419 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 16 file(s) not represented in the graph (top: .xml 10, (none) 3, .properties 2)

## Summary
- 1852 nodes · 3000 edges · 123 communities (108 shown, 15 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 1 edges (avg confidence: 0.95)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d59701a4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Drift Database & Tables Schema
- AI Insight Engine
- Notification & Reminder Scheduling
- Home Dashboard & Cycle State
- Period Flow Pain Bottom Sheet Module
- Privacy & App Lock Security
- Daily Check-in & Symptoms Logging
- package:flutter/material.dart
- Clinical PDF Report Generation
- Cycle Comparison & Patterns
- Privacy & App Lock Security
- reminders_page.dart
- Notification & Reminder Scheduling
- Privacy & App Lock Security
- Daily Summary Card Module
- ../../core/theme/app_colors.dart
- doctor_report_service.dart
- Daily Logs Table Module
- User Profiles Table Module
- About Bloom Page Module
- Cycle Comparison & Patterns
- Notification & Reminder Scheduling
- reminder_settings_page.dart
- Privacy & App Lock Security
- Custom Reminders Management
- Cycle Repository Module
- in_app_lock_screen.dart
- splash_page.dart
- ConsumerWidget
- build
- lifestyle_insights_page.dart
- health_details_page.dart
- Edit Profile Page Module
- ai_insight_service.dart
- Calendar & Period Timeline
- onboarding_provider.dart
- in_app_security_gate.dart
- Drift Database & Tables Schema
- Home Dashboard & Cycle State
- PeriodFlowPainBottomSheetContent
- cycle_patterns_page.dart
- bloom_app_bar.dart
- Cycles Table Module
- insight_toggle_bar.dart
- Daily Log Repository Module
- IconData
- Summary Metrics Row Module
- calendar_provider.dart
- Report Problem Page Module
- Authentication & User Session
- List
- doctor_report_result_page.dart
- AI Insight Engine
- Custom Reminders Management
- signup_page.dart
- database_providers.dart
- Theme Tokens & Styling
- Home Dashboard & Cycle State
- ConsumerStatefulWidget
- symptoms_patterns_page.dart
- Daily Symptoms Table Module
- app_shell.dart
- core/database/database_providers.dart
- bloom_flow_option.dart
- Contact Support Page Module
- Drift Database & Tables Schema
- AI Insight Engine
- last_period_page.dart
- doctor_report_test.dart
- doctor_report_ai_service.dart
- compare_cycles_page_test.dart
- Cycle Status Card Module
- main.dart
- doctor_report_setup_page.dart
- package:flutter_riverpod/flutter_riverpod.dart
- period_start_page.dart
- Bloom Lifestyle Card Module
- AI Insight Engine
- insights_grid_button.dart
- Symptom Repository Module
- app_settings_page.dart
- String?
- period_log_page.dart
- bloom_checkbox_tile.dart
- Privacy & App Lock Security
- User Repository Module
- build
- AI Insight Engine
- Give Feedback Page Module
- AppDatabase
- insights_hero_card_test.dart
- onboardingProvider
- doctor_report_ai_observation_card.dart
- database_providers.dart
- AI Insight Engine
- package:bloom/core/database/app_database.dart
- in_app_lock_runtime_provider.dart
- app_lock_choice_page.dart
- VoidCallback
- profile_page.dart
- DailyCheckinNotifier
- AI Insight Engine
- period_logging_provider.dart
- StateNotifier
- about_bloom_page.dart
- name_page.dart
- database_seeder.dart
- suggest_feature_page.dart
- Notification & Reminder Scheduling
- Mainactivity.Kt Module
- build
- inAppLockRuntimeProvider
- build
- lifestyle_insights_page_test.dart
- package:google_fonts/google_fonts.dart
- CalendarNotifier
- _SplashPageState
- _PatternPainter

## God Nodes (most connected - your core abstractions)
1. `privacySecurityProvider` - 29 edges
2. `userProfileStreamProvider` - 27 edges
3. `allCyclesStreamProvider` - 25 edges
4. `allDailyLogsStreamProvider` - 19 edges
5. `onboardingProvider` - 19 edges
6. `dailyCheckinProvider` - 14 edges
7. `AppDatabase` - 12 edges
8. `CalendarPage` - 12 edges
9. `inAppLockRuntimeProvider` - 11 edges
10. `userRepositoryProvider` - 10 edges

## Surprising Connections (you probably didn't know these)
- `build` --references--> `allCyclesStreamProvider`  [EXTRACTED]
  lib/features/doctor_report/presentation/pages/doctor_report_setup_page.dart → lib/core/database/database_providers.dart
- `MockCalendarNotifier` --references--> `CalendarState`  [EXTRACTED]
  test/reminders_due_badge_test.dart → lib/features/calendar/presentation/providers/calendar_provider.dart
- `MockCalendarNotifier` --implements--> `CalendarNotifier`  [EXTRACTED]
  test/reminders_due_badge_test.dart → lib/features/calendar/presentation/providers/calendar_provider.dart
- `_showSetPinDialog` --references--> `privacySecurityProvider`  [EXTRACTED]
  lib/features/profile/presentation/pages/app_lock_choice_page.dart → lib/features/profile/presentation/providers/privacy_security_provider.dart
- `build` --references--> `privacySecurityProvider`  [EXTRACTED]
  lib/features/profile/presentation/widgets/in_app_lock_screen.dart → lib/features/profile/presentation/providers/privacy_security_provider.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Offline-First Sync Entities** — unified_schema_sync_engine, unified_schema_user_profiles, unified_schema_cycles, unified_schema_daily_logs [INFERRED 0.85]

## Communities (123 total, 15 thin omitted)

### Community 0 - "Drift Database & Tables Schema"
Cohesion: 0.03
Nodes (120): _, activityLevel, _activityLevelMeta, actualTableName, _alias, aliasedName, allSchemaEntities, allTables (+112 more)

### Community 1 - "AI Insight Engine"
Cohesion: 0.04
Nodes (4): appRouter, createAppRouter, rootNavigatorKey, shellNavigatorKey

### Community 2 - "Notification & Reminder Scheduling"
Cohesion: 0.04
Nodes (39): areNotificationsEnabled, cancel, cancelAll, channelDescription, channelId, channelName, getAppLaunchPayload, hasNotifiedCycle (+31 more)

### Community 3 - "Home Dashboard & Cycle State"
Cohesion: 0.05
Nodes (37): allCyclesAsync, avgCycleLen, avgPeriodLen, currentCycle, currentCycleAsync, cycleDay, daysUntil, daysUntilPeriod (+29 more)

### Community 4 - "Period Flow Pain Bottom Sheet Module"
Cohesion: 0.07
Nodes (26): build, _buildPainStep, cleanDate, createState, _currentStep, cycleDay, cycleId, cycleRepo (+18 more)

### Community 5 - "Privacy & App Lock Security"
Cohesion: 0.07
Nodes (27): autoLockTime, copyWith, fromJson, isAiDataUsageEnabled, isAnalyticsEnabled, isDiscreteNotificationsEnabled, isLockActive, isPersonalizedRecommendationsEnabled (+19 more)

### Community 6 - "Daily Check-in & Symptoms Logging"
Cohesion: 0.07
Nodes (27): activity, clear, copyWith, fromCalendar, loadFromLog, mood, notes, painAfter1Hour (+19 more)

### Community 7 - "package:flutter/material.dart"
Cohesion: 0.13
Nodes (8): showPageInfoDialog, build, ProfilePage, build, ExportReportCard, build, _buildSymptomList, EmergencyInformationPage

### Community 8 - "Clinical PDF Report Generation"
Cohesion: 0.07
Nodes (22): bgPink, borderCol, _buildCycleSummaryChart, _buildHeader, _buildInfoCol, _buildLifestyleInsights, _buildMetricBox, _buildObservations (+14 more)

### Community 9 - "Cycle Comparison & Patterns"
Cohesion: 0.08
Nodes (24): averagePain, averageSleep, bloating, _buildTableRow, _calculateMetrics, createState, _customCycle1Id, _customCycle2Id (+16 more)

### Community 10 - "Privacy & App Lock Security"
Cohesion: 0.09
Nodes (22): activeColor, build, clearPattern, color, createState, currentTouchPos, _currentTouchPosition, _dotCenter (+14 more)

### Community 11 - "reminders_page.dart"
Cohesion: 0.09
Nodes (23): actionLabel, _buildQuietHoursBanner, color, createState, date, description, _formatNotificationDate, _formatNotificationTime (+15 more)

### Community 12 - "Notification & Reminder Scheduling"
Cohesion: 0.09
Nodes (21): calendarState, cycleSummaryReminder, dailyLogsAsync, dailyReminder, fertileReminder, _findFertileStart, hasFlowToday, hasRecentFlow (+13 more)

### Community 13 - "Privacy & App Lock Security"
Cohesion: 0.10
Nodes (13): AuthStorageService, _fileName, _getFile, instance, isLoggedIn, logout, setLoggedIn, _fileName (+5 more)

### Community 14 - "Daily Summary Card Module"
Cohesion: 0.10
Nodes (19): build, checkinData, cycleDay, date, daysLate, expectedPeriodDate, isCycleStart, isFertileDay (+11 more)

### Community 15 - "../../core/theme/app_colors.dart"
Cohesion: 0.08
Nodes (21): DailySummaryCard, build, DoctorReportBanner, build, HistoryPage, BodyTodayCard, build, message (+13 more)

### Community 16 - "doctor_report_service.dart"
Cohesion: 0.04
Nodes (49): activityFormatted, avgCycleLength, avgPainLevel, avgPeriodLength, color, computeReportData, copyWith, cycleBarPoints (+41 more)

### Community 17 - "Daily Logs Table Module"
Cohesion: 0.10
Nodes (19): activityLevel, createdAt, cycleId, date, flowIntensity, id, isDeleted, isSynced (+11 more)

### Community 18 - "User Profiles Table Module"
Cohesion: 0.10
Nodes (20): avatarPath, avgCycleLength, avgPeriodLength, bloodGroup, createdAt, dateOfBirth, email, fertileWindowEnabled (+12 more)

### Community 19 - "About Bloom Page Module"
Cohesion: 0.10
Nodes (10): build, _buildSectionGroup, _buildTileItem, HelpSupportPage, build, _buildIssueTile, TroubleshootingPage, build (+2 more)

### Community 20 - "Cycle Comparison & Patterns"
Cohesion: 0.23
Nodes (22): allCyclesStreamProvider, allDailyLogsStreamProvider, allSymptomsStreamProvider, build, DoctorReportResultPage, build, _DoctorReportAiObservationCardState, doctorReportAiProvider (+14 more)

### Community 21 - "Notification & Reminder Scheduling"
Cohesion: 0.11
Nodes (11): cancel, cancelAll, cancelled, FakeFlutterLocalNotificationsPlatform, fakePlatform, FlutterLocalNotificationsPlatform, instant, main (+3 more)

### Community 22 - "reminder_settings_page.dart"
Cohesion: 0.14
Nodes (12): _buildDailyLogReminderTile, _buildDialogStep, _buildPeriodReminderTile, _buildReminderTile, createState, _editQuietHours, _editSingleReminderTime, _formatQuietHours (+4 more)

### Community 23 - "Privacy & App Lock Security"
Cohesion: 0.13
Nodes (16): databaseProvider, autoLockOptions, build, _buildActionTile, _buildExportRow, _buildSwitchTile, _confirmDeleteAccount, _confirmDeleteTrackingData (+8 more)

### Community 24 - "Custom Reminders Management"
Cohesion: 0.18
Nodes (10): _db, ensureStandardReminders, getAllReminders, ReminderRepository, toggleReminder, updateReminderDaysBefore, updateReminderTime, upsertReminder (+2 more)

### Community 25 - "Cycle Repository Module"
Cohesion: 0.12
Nodes (11): CycleRepository, DailyLogRepository, PeriodFlowPainResult, cycleRepo, db, main, cycleRepo, dailyLogRepo (+3 more)

### Community 26 - "in_app_lock_screen.dart"
Cohesion: 0.11
Nodes (15): build, _buildKeypadButton, _buildPasswordView, _buildPatternView, _buildPinView, createState, dispose, _enteredPin (+7 more)

### Community 27 - "splash_page.dart"
Cohesion: 0.07
Nodes (28): angle, baseOpacity, build, _controller, createState, dispose, distance, _dotsFade (+20 more)

### Community 28 - "ConsumerWidget"
Cohesion: 0.10
Nodes (16): build, CheckinLifestylePage, build, CheckinMoodPage, _showMoreSymptoms, symptoms, CheckinNotesPage, build (+8 more)

### Community 29 - "build"
Cohesion: 0.43
Nodes (8): allRemindersStreamProvider, reminderRepositoryProvider, calendarProvider, build, _ReminderSettingsPageState, build, dismissedRemindersProvider, RemindersPage

### Community 30 - "lifestyle_insights_page.dart"
Cohesion: 0.17
Nodes (11): _buildAverageRow, _buildCorrelationRow, color, _CorrelationItem, createState, icon, _isLogForCycle, _parseWaterLiters (+3 more)

### Community 31 - "health_details_page.dart"
Cohesion: 0.17
Nodes (11): bloodGroups, build, createState, dispose, HealthDetailsPage, _HealthDetailsPageState, _heightController, _pickDateOfBirth (+3 more)

### Community 32 - "Edit Profile Page Module"
Cohesion: 0.11
Nodes (16): bloodGroups, _buildDobPicker, _buildTextField, createState, _currentAvatar, dispose, _emailController, _formKey (+8 more)

### Community 33 - "ai_insight_service.dart"
Cohesion: 0.20
Nodes (7): AiInsightService, getBodyTodayInsight, getCompareCyclesInsight, getCyclePatternInsight, getLifestyleCorrelationInsight, getMoodTrendInsight, instance

### Community 34 - "Calendar & Period Timeline"
Cohesion: 0.12
Nodes (15): BloomCalendar, build, expectedPeriodDays, fertileDays, focusedDay, _isAnyPeriodDay, _isExpectedPeriodDay, _isFertileDay (+7 more)

### Community 35 - "onboarding_provider.dart"
Cohesion: 0.09
Nodes (22): bloodGroup, copyWith, cycleDuration, dateOfBirth, goals, heightCm, lastPeriodDate, OnboardingNotifier (+14 more)

### Community 36 - "in_app_security_gate.dart"
Cohesion: 0.20
Nodes (6): child, createState, didChangeAppLifecycleState, dispose, InAppSecurityGate, _InAppSecurityGateState

### Community 37 - "Drift Database & Tables Schema"
Cohesion: 0.23
Nodes (12): AiInsight, AiInsightsCompanion, Cycle, CyclesCompanion, DailyLog, DailyLogsCompanion, DailySymptom, DailySymptomsCompanion (+4 more)

### Community 38 - "Home Dashboard & Cycle State"
Cohesion: 0.13
Nodes (14): completeCycle, _db, deleteCycle, getAllCycles, getCurrentCycle, getCycleForDate, getOrCreateCycleForPeriodDate, getPreviousCompletedCycle (+6 more)

### Community 40 - "cycle_patterns_page.dart"
Cohesion: 0.15
Nodes (5): _buildBarData, _buildSmallStatBox, createState, _selectedCycles, _buildStatColumn

### Community 41 - "bloom_app_bar.dart"
Cohesion: 0.22
Nodes (6): BloomAppBar, build, onSkip, preferredSize, progress, showSkip

### Community 42 - "Cycles Table Module"
Cohesion: 0.14
Nodes (12): createdAt, cycleLength, endDate, id, isDeleted, isPredicted, isSynced, periodLength (+4 more)

### Community 43 - "insight_toggle_bar.dart"
Cohesion: 0.12
Nodes (12): build, _buildToggle, currentTab, InsightToggleBar, onTabChanged, BloomSlider, build, divisions (+4 more)

### Community 44 - "Daily Log Repository Module"
Cohesion: 0.14
Nodes (13): _db, getAllDailyLogs, getLogForDate, getLogsForCycle, getLogsForDateRange, movePeriodLog, removePeriodFlowForDate, _stripTime (+5 more)

### Community 45 - "IconData"
Cohesion: 0.14
Nodes (11): build, icon, prediction, symptom, SymptomPredictionCard, BloomGridItem, build, icon (+3 more)

### Community 46 - "Summary Metrics Row Module"
Cohesion: 0.14
Nodes (13): build, _getMoodEmoji, _getMoodSubtext, _getPainSubtext, label, _MetricItem, mood, painLevel (+5 more)

### Community 47 - "calendar_provider.dart"
Cohesion: 0.11
Nodes (15): copyWith, daysLate, expectedPeriodDays, fertileDays, focusedDay, isPeriodLate, nextPeriodEndDate, nextPeriodStartDate (+7 more)

### Community 48 - "Report Problem Page Module"
Cohesion: 0.13
Nodes (13): _appVersion, _attachedFileNames, build, _buildTextField, createState, _deviceModel, initState, _loadDeviceInfo (+5 more)

### Community 49 - "Authentication & User Session"
Cohesion: 0.17
Nodes (5): Fake, FakePathProviderPlatform, getApplicationDocumentsPath, main, tempDir

### Community 50 - "List"
Cohesion: 0.18
Nodes (6): CycleDurationPage, options, goals, options, symptoms, SymptomsPage

### Community 51 - "doctor_report_result_page.dart"
Cohesion: 0.13
Nodes (10): _buildAverageRow, _buildBarData, _buildChecklistItem, _buildInfoCol, _buildMetricBox, _buildPeriodBarData, _buildSectionTitle, _buildTimelineRow (+2 more)

### Community 52 - "AI Insight Engine"
Cohesion: 0.15
Nodes (11): category, createdAt, cyclePhase, generatedDate, headline, id, insightText, isDeleted (+3 more)

### Community 53 - "Custom Reminders Management"
Cohesion: 0.15
Nodes (11): createdAt, daysBefore, id, isDeleted, isEnabled, isSynced, primaryKey, timeOfDay (+3 more)

### Community 54 - "signup_page.dart"
Cohesion: 0.18
Nodes (7): build, createState, dispose, _emailController, SignUpPage, _SignUpPageState, build

### Community 55 - "database_providers.dart"
Cohesion: 0.13
Nodes (16): currentCycleStreamProvider, cycleRepositoryProvider, dailyLogRepositoryProvider, symptomRepositoryProvider, build, CalendarPage, _getMonthName, _handleChangePeriodDate (+8 more)

### Community 56 - "Theme Tokens & Styling"
Cohesion: 0.17
Nodes (10): AppColors, background, border, lightPink, lightPurple, primaryPink, primaryPurple, secondaryText (+2 more)

### Community 57 - "Home Dashboard & Cycle State"
Cohesion: 0.18
Nodes (15): userProfileStreamProvider, userRepositoryProvider, build, HomePage, homeProvider, QuickActionsGrid, InsightsPage, build (+7 more)

### Community 58 - "ConsumerStatefulWidget"
Cohesion: 0.22
Nodes (8): CompareCyclesPage, CyclePatternsPage, LifestyleInsightsPage, MoodTrendsPage, SymptomsPatternsPage, EditProfilePage, InAppLockScreen, ReminderSettingsPage

### Community 59 - "symptoms_patterns_page.dart"
Cohesion: 0.11
Nodes (17): badgeColor, badgeText, _buildCommonSymptomRow, _buildTimelineSymptomRow, _calculateTimingInfo, createState, _getSymptomIcon, icon (+9 more)

### Community 60 - "Daily Symptoms Table Module"
Cohesion: 0.18
Nodes (8): createdAt, dailyLogId, id, isDeleted, isSynced, primaryKey, severity, symptomName

### Community 61 - "app_shell.dart"
Cohesion: 0.20
Nodes (7): AppShell, child, icon, isSelected, label, _NavItem, onTap

### Community 62 - "core/database/database_providers.dart"
Cohesion: 0.14
Nodes (11): _buildLegendRow, _buildTimelineMoodRow, createState, _getMoodDisplay, _getPredominantMood, _isLogForCycle, _normalizeMood, _selectedCycles (+3 more)

### Community 63 - "bloom_flow_option.dart"
Cohesion: 0.29
Nodes (6): BloomFlowOption, build, dropOpacity, isSelected, label, onTap

### Community 64 - "Contact Support Page Module"
Cohesion: 0.18
Nodes (9): _attachedFileNames, build, categories, ContactSupportPage, _ContactSupportPageState, createState, _pickFile, selectedCategory (+1 more)

### Community 65 - "Drift Database & Tables Schema"
Cohesion: 0.25
Nodes (6): _db, getInsightsForCategory, getLatestInsight, InsightsRepository, saveInsight, watchInsightsForCategory

### Community 66 - "AI Insight Engine"
Cohesion: 0.20
Nodes (9): _buildLegendItem, _buildPhasePainRow, _buildSmallStatBox, createState, _getPainCategoryColor, _getPainCategoryText, _isLogForCycle, PainInsightsPage (+1 more)

### Community 67 - "last_period_page.dart"
Cohesion: 0.40
Nodes (4): createState, LastPeriodPage, _LastPeriodPageState, _selectedDate

### Community 68 - "doctor_report_test.dart"
Cohesion: 0.13
Nodes (8): createTestCycle, createTestLog, createTestUser, main, createTestCycle, createTestLog, createTestUser, main

### Community 69 - "doctor_report_ai_service.dart"
Cohesion: 0.09
Nodes (17): AiSummaryStatus, authToken, backendUrl, buildPayload, copyWith, DoctorReportAiService, errorMessage, generateAiSummary (+9 more)

### Community 70 - "compare_cycles_page_test.dart"
Cohesion: 0.33
Nodes (4): createTestCycle, createTestLog, createTestSymptom, main

### Community 71 - "Cycle Status Card Module"
Cohesion: 0.20
Nodes (9): build, cycleDay, CycleStatusCard, daysUntilPeriod, fertileWindowRange, isPeriodLate, isPeriodOngoing, periodDateRange (+1 more)

### Community 72 - "main.dart"
Cohesion: 0.12
Nodes (10): notificationSyncProvider, BloomApp, build, db, initialSecurityState, isLoggedIn, main, purgeMockCycles (+2 more)

### Community 73 - "doctor_report_setup_page.dart"
Cohesion: 0.29
Nodes (6): build, _buildCheckListItem, createState, DoctorReportSetupPage, _DoctorReportSetupPageState, _selectedCycles

### Community 74 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.15
Nodes (5): main, createTestWidget, main, main, main

### Community 75 - "period_start_page.dart"
Cohesion: 0.22
Nodes (7): build, createState, initState, PeriodStartPage, _PeriodStartPageState, _pickDate, _selectedDate

### Community 77 - "Bloom Lifestyle Card Module"
Cohesion: 0.20
Nodes (9): BloomLifestyleCard, bottomWidget, build, icon, iconColor, onTap, title, trailing (+1 more)

### Community 78 - "AI Insight Engine"
Cohesion: 0.22
Nodes (9): Bloom Flutter Dependencies & Packages, Bloom Menstrual Tracker Architecture, Bloom Design System & AppColors, Insights & Cycle Comparison Suite, Schema AI Insights Entity, Schema Cycles Entity, Schema DailyLogs Entity, Unified Drift & PostgreSQL Sync Engine (+1 more)

### Community 79 - "insights_grid_button.dart"
Cohesion: 0.12
Nodes (13): build, icon, iconColor, InsightsGridButton, label, onTap, backgroundColor, BloomButton (+5 more)

### Community 80 - "Symptom Repository Module"
Cohesion: 0.25
Nodes (7): _db, getAllSymptoms, getSymptomsForLog, setSymptomsForLog, SymptomRepository, watchAllSymptoms, watchSymptomsForLog

### Community 81 - "app_settings_page.dart"
Cohesion: 0.22
Nodes (7): _buildActionTile, _buildDropdownTile, _buildInfoTile, _buildSwitchTile, cycleOptions, goalOptions, periodOptions

### Community 82 - "String?"
Cohesion: 0.29
Nodes (5): BloomEmoticonPicker, build, moods, onMoodSelected, selectedMood

### Community 83 - "period_log_page.dart"
Cohesion: 0.20
Nodes (4): flowOptions, _showMoreSymptoms, symptoms, main

### Community 84 - "bloom_checkbox_tile.dart"
Cohesion: 0.29
Nodes (6): BloomCheckboxTile, build, icon, isSelected, onTap, text

### Community 86 - "User Repository Module"
Cohesion: 0.29
Nodes (5): _db, getUserProfile, saveUserProfile, UserRepository, watchUserProfile

### Community 87 - "build"
Cohesion: 0.19
Nodes (8): build, _handleCheckinForDay, build, build, build, build, _buildFlowStep, _getReminderItem

### Community 88 - "AI Insight Engine"
Cohesion: 0.29
Nodes (6): AiInsights, Cycles, DailyLogs, DailySymptoms, Reminders, UserProfiles

### Community 89 - "Give Feedback Page Module"
Cohesion: 0.33
Nodes (6): build, createState, GiveFeedbackPage, _GiveFeedbackPageState, _rating, _submit

### Community 91 - "insights_hero_card_test.dart"
Cohesion: 0.15
Nodes (5): createCompletedCycle, createTestUser, main, createTestUser, main

### Community 92 - "onboardingProvider"
Cohesion: 0.14
Nodes (9): build, initState, _onContinue, build, initState, build, PeriodDurationPage, build (+1 more)

### Community 93 - "doctor_report_ai_observation_card.dart"
Cohesion: 0.15
Nodes (8): createState, dispose, DoctorReportAiObservationCard, initState, _pulseAnimation, _pulseController, reportData, DoctorReportData

### Community 94 - "database_providers.dart"
Cohesion: 0.17
Nodes (4): db, insightsRepositoryProvider, symptomsForLogStreamProvider, watch

### Community 95 - "AI Insight Engine"
Cohesion: 0.29
Nodes (4): createCompletedCycle, createTestLog, createTestProfile, main

### Community 96 - "package:bloom/core/database/app_database.dart"
Cohesion: 0.12
Nodes (9): createCompletedCycle, createTestUser, main, createCompletedCycle, createTestLog, createTestProfile, main, main (+1 more)

### Community 97 - "in_app_lock_runtime_provider.dart"
Cohesion: 0.18
Nodes (11): copyWith, InAppLockRuntimeNotifier, InAppLockRuntimeState, isAppHidden, isLocked, lastPausedAt, lock, onAppPaused (+3 more)

### Community 98 - "app_lock_choice_page.dart"
Cohesion: 0.20
Nodes (8): AppLockChoicePage, _AppLockChoicePageState, _buildDialogKeypadBtn, _buildMethodTile, createState, _showSetPasswordDialog, _showSetPatternDialog, _showSetPinDialog

### Community 99 - "VoidCallback"
Cohesion: 0.15
Nodes (9): icon, label, onTap, _QuickAction, BloomOptionCard, build, isSelected, onTap (+1 more)

### Community 100 - "profile_page.dart"
Cohesion: 0.20
Nodes (6): LoginPage, icon, onTap, _SettingsTile, showDivider, title

### Community 102 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 103 - "period_logging_provider.dart"
Cohesion: 0.20
Nodes (10): clear, copyWith, flowLevel, painLevel, PeriodLoggingNotifier, PeriodLoggingState, setFlowLevel, setPainLevel (+2 more)

### Community 104 - "StateNotifier"
Cohesion: 0.29
Nodes (6): AiSummaryState, DoctorReportAiNotifier, InsightsNotifier, insightsProvider, InsightTab, setTab

### Community 105 - "about_bloom_page.dart"
Cohesion: 0.20
Nodes (6): AboutBloomPage, build, _buildFeatureCard, _buildListTile, _buildSectionHeader, _buildTimelineStep

### Community 106 - "name_page.dart"
Cohesion: 0.25
Nodes (6): build, createState, dispose, _nameController, NamePage, _NamePageState

### Community 107 - "database_seeder.dart"
Cohesion: 0.29
Nodes (4): DatabaseSeeder, purgeMockCycles, seedInitialData, _uuid

### Community 108 - "suggest_feature_page.dart"
Cohesion: 0.33
Nodes (6): build, _buildTextField, createState, _submit, SuggestFeaturePage, _SuggestFeaturePageState

### Community 109 - "Notification & Reminder Scheduling"
Cohesion: 0.50
Nodes (3): resetNotifiedCyclesCache, resetShownTodayCache, setPluginForTesting

### Community 116 - "inAppLockRuntimeProvider"
Cohesion: 0.29
Nodes (7): build, inAppLockRuntimeProvider, _onPatternComplete, _verifyPassword, _verifyPin, build, initState

### Community 118 - "lifestyle_insights_page_test.dart"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 120 - "CalendarNotifier"
Cohesion: 1.00
Nodes (3): CalendarNotifier, CalendarState, MockCalendarNotifier

## Knowledge Gaps
- **1008 isolated node(s):** `schemaVersion`, `_openConnection`, `db`, `insightsRepositoryProvider`, `symptomsForLogStreamProvider` (+1003 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1218 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDatabase` connect `AppDatabase` to `Drift Database & Tables Schema`, `Drift Database & Tables Schema`, `Home Dashboard & Cycle State`, `Daily Log Repository Module`, `Symptom Repository Module`, `User Repository Module`, `Custom Reminders Management`, `Cycle Repository Module`, `database_providers.dart`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `schemaVersion`, `_openConnection`, `db` to the rest of the system?**
  _1008 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Drift Database & Tables Schema` be split into smaller, more focused modules?**
  _Cohesion score 0.027264920566766854 - nodes in this community are weakly interconnected._
- **Why does `build` connect `About Bloom Page Module` to `about_bloom_page.dart`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **Should `AI Insight Engine` be split into smaller, more focused modules?**
  _Cohesion score 0.03508771929824561 - nodes in this community are weakly interconnected._
- **Why does `build` connect `build` to `Home Dashboard & Cycle State`, `profile_page.dart`, `Privacy & App Lock Security`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Should `Notification & Reminder Scheduling` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._