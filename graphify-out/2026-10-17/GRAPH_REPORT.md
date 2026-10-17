# Graph Report - bloom  (2026-10-17)

## Corpus Check
- 140 files · ~501,888 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 16 file(s) not represented in the graph (top: .xml 10, (none) 3, .properties 2)

## Summary
- 1759 nodes · 2844 edges · 107 communities (95 shown, 12 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 1 edges (avg confidence: 0.95)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c301c566`
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
- calendar_page.dart
- doctor_report_service.dart
- Daily Logs Table Module
- User Profiles Table Module
- About Bloom Page Module
- Cycle Comparison & Patterns
- Notification & Reminder Scheduling
- In App Lock Screen Module
- Privacy & App Lock Security
- Custom Reminders Management
- Cycle Repository Module
- Calendar & Period Timeline
- Symptoms Patterns Page Module
- Daily Check-in & Symptoms Logging
- in_app_lock_runtime_provider.dart
- CalendarPage
- health_details_page.dart
- Edit Profile Page Module
- period_logging_provider.dart
- Calendar & Period Timeline
- onboarding_provider.dart
- in_app_security_gate.dart
- Drift Database & Tables Schema
- Home Dashboard & Cycle State
- profile_page.dart
- core/database/database_providers.dart
- userProfileStreamProvider
- Cycles Table Module
- reminder_settings_page.dart
- Daily Log Repository Module
- Clinical PDF Report Generation
- Summary Metrics Row Module
- package:flutter_riverpod/flutter_riverpod.dart
- Report Problem Page Module
- Authentication & User Session
- onboardingProvider
- quick_actions_grid.dart
- AI Insight Engine
- Custom Reminders Management
- signup_page.dart
- AI Insight Engine
- Theme Tokens & Styling
- Home Dashboard & Cycle State
- app_lock_choice_page.dart
- main.dart
- Daily Symptoms Table Module
- Last Period Page Module
- privacySecurityProvider
- app_settings_page.dart
- Contact Support Page Module
- Drift Database & Tables Schema
- AI Insight Engine
- build
- doctor_report_test.dart
- build
- StatelessWidget
- Cycle Status Card Module
- bloom_grid_item.dart
- doctor_report_setup_page.dart
- package:flutter_test/flutter_test.dart
- State
- Bloom App Bar Module
- Bloom Lifestyle Card Module
- AI Insight Engine
- VoidCallback
- Symptom Repository Module
- bloom_checkbox_tile.dart
- insight_toggle_bar.dart
- package:drift/drift.dart
- package:google_fonts/google_fonts.dart
- Privacy & App Lock Security
- User Repository Module
- build
- AI Insight Engine
- Give Feedback Page Module
- AppDatabase
- CalendarNotifier
- VoidCallback
- StateNotifier
- AI Insight Engine
- package:bloom/core/database/app_database.dart
- AI Insight Engine
- Cycle Comparison & Patterns
- AI Insight Engine
- AI Insight Engine
- Suggest Feature Page Module
- Notification & Reminder Scheduling
- Mainactivity.Kt Module

## God Nodes (most connected - your core abstractions)
1. `userProfileStreamProvider` - 27 edges
2. `allCyclesStreamProvider` - 25 edges
3. `privacySecurityProvider` - 25 edges
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
- `initState` --references--> `onboardingProvider`  [EXTRACTED]
  lib/features/onboarding/presentation/pages/last_period_page.dart → lib/features/onboarding/presentation/providers/onboarding_provider.dart
- `_showSetPinDialog` --references--> `privacySecurityProvider`  [EXTRACTED]
  lib/features/profile/presentation/pages/app_lock_choice_page.dart → lib/features/profile/presentation/providers/privacy_security_provider.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Offline-First Sync Entities** — unified_schema_sync_engine, unified_schema_user_profiles, unified_schema_cycles, unified_schema_daily_logs [INFERRED 0.85]

## Communities (107 total, 12 thin omitted)

### Community 0 - "Drift Database & Tables Schema"
Cohesion: 0.03
Nodes (120): _, activityLevel, _activityLevelMeta, actualTableName, _alias, aliasedName, allSchemaEntities, allTables (+112 more)

### Community 1 - "AI Insight Engine"
Cohesion: 0.03
Nodes (6): appRouter, createAppRouter, initialLocation, rootNavigatorKey, shellNavigatorKey, state

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
Nodes (29): activity, clear, copyWith, DailyCheckinNotifier, DailyCheckinState, fromCalendar, loadFromLog, mood (+21 more)

### Community 7 - "package:flutter/material.dart"
Cohesion: 0.05
Nodes (33): showPageInfoDialog, DoctorReportBanner, build, BodyTodayCard, build, message, BloomProBanner, build (+25 more)

### Community 8 - "Clinical PDF Report Generation"
Cohesion: 0.05
Nodes (29): AiInsightService, getBodyTodayInsight, getCompareCyclesInsight, getCyclePatternInsight, getLifestyleCorrelationInsight, getMoodTrendInsight, instance, bgPink (+21 more)

### Community 9 - "Cycle Comparison & Patterns"
Cohesion: 0.08
Nodes (24): averagePain, averageSleep, bloating, _buildTableRow, _calculateMetrics, createState, _customCycle1Id, _customCycle2Id (+16 more)

### Community 10 - "Privacy & App Lock Security"
Cohesion: 0.08
Nodes (21): activeColor, build, clearPattern, color, createState, currentTouchPos, _currentTouchPosition, _dotCenter (+13 more)

### Community 11 - "reminders_page.dart"
Cohesion: 0.06
Nodes (29): build, build, build, build, _buildFlowStep, actionLabel, _buildQuietHoursBanner, color (+21 more)

### Community 12 - "Notification & Reminder Scheduling"
Cohesion: 0.09
Nodes (21): calendarState, cycleSummaryReminder, dailyLogsAsync, dailyReminder, fertileReminder, _findFertileStart, hasFlowToday, hasRecentFlow (+13 more)

### Community 13 - "Privacy & App Lock Security"
Cohesion: 0.10
Nodes (13): AuthStorageService, _fileName, _getFile, instance, isLoggedIn, logout, setLoggedIn, _fileName (+5 more)

### Community 14 - "Daily Summary Card Module"
Cohesion: 0.10
Nodes (20): build, checkinData, cycleDay, DailySummaryCard, date, daysLate, expectedPeriodDate, isCycleStart (+12 more)

### Community 15 - "calendar_page.dart"
Cohesion: 0.17
Nodes (3): _getMonthName, _handleLogPeriodForDay, main

### Community 16 - "doctor_report_service.dart"
Cohesion: 0.04
Nodes (47): activityFormatted, avgCycleLength, avgPainLevel, avgPeriodLength, color, computeReportData, cycleBarPoints, CycleChartPoint (+39 more)

### Community 17 - "Daily Logs Table Module"
Cohesion: 0.10
Nodes (19): activityLevel, createdAt, cycleId, date, flowIntensity, id, isDeleted, isSynced (+11 more)

### Community 18 - "User Profiles Table Module"
Cohesion: 0.10
Nodes (20): avatarPath, avgCycleLength, avgPeriodLength, bloodGroup, createdAt, dateOfBirth, email, fertileWindowEnabled (+12 more)

### Community 19 - "About Bloom Page Module"
Cohesion: 0.10
Nodes (9): AboutBloomPage, build, _buildFeatureCard, _buildListTile, _buildSectionHeader, _buildTimelineStep, build, build (+1 more)

### Community 20 - "Cycle Comparison & Patterns"
Cohesion: 0.27
Nodes (17): allCyclesStreamProvider, allDailyLogsStreamProvider, allSymptomsStreamProvider, _recomputeCyclePredictions, build, DoctorReportResultPage, build, _CompareCyclesPageState (+9 more)

### Community 21 - "Notification & Reminder Scheduling"
Cohesion: 0.11
Nodes (11): cancel, cancelAll, cancelled, FakeFlutterLocalNotificationsPlatform, fakePlatform, FlutterLocalNotificationsPlatform, instant, main (+3 more)

### Community 22 - "In App Lock Screen Module"
Cohesion: 0.11
Nodes (15): build, _buildKeypadButton, _buildPasswordView, _buildPatternView, _buildPinView, createState, dispose, _enteredPin (+7 more)

### Community 23 - "Privacy & App Lock Security"
Cohesion: 0.14
Nodes (15): databaseProvider, autoLockOptions, build, _buildActionTile, _buildExportRow, _buildSwitchTile, _confirmDeleteAccount, _confirmDeleteTrackingData (+7 more)

### Community 24 - "Custom Reminders Management"
Cohesion: 0.15
Nodes (10): _db, ensureStandardReminders, getAllReminders, ReminderRepository, toggleReminder, updateReminderDaysBefore, updateReminderTime, upsertReminder (+2 more)

### Community 25 - "Cycle Repository Module"
Cohesion: 0.13
Nodes (11): CycleRepository, DailyLogRepository, PeriodFlowPainResult, cycleRepo, db, main, cycleRepo, dailyLogRepo (+3 more)

### Community 26 - "Calendar & Period Timeline"
Cohesion: 0.11
Nodes (15): copyWith, daysLate, expectedPeriodDays, fertileDays, focusedDay, isPeriodLate, nextPeriodEndDate, nextPeriodStartDate (+7 more)

### Community 27 - "Symptoms Patterns Page Module"
Cohesion: 0.11
Nodes (17): badgeColor, badgeText, _buildCommonSymptomRow, _buildTimelineSymptomRow, _calculateTimingInfo, createState, _getSymptomIcon, icon (+9 more)

### Community 28 - "Daily Check-in & Symptoms Logging"
Cohesion: 0.15
Nodes (10): build, CheckinLifestylePage, build, CheckinMoodPage, _showMoreSymptoms, symptoms, CheckinNotesPage, build (+2 more)

### Community 29 - "in_app_lock_runtime_provider.dart"
Cohesion: 0.18
Nodes (11): copyWith, InAppLockRuntimeNotifier, InAppLockRuntimeState, isAppHidden, isLocked, lastPausedAt, lock, onAppPaused (+3 more)

### Community 30 - "CalendarPage"
Cohesion: 0.18
Nodes (17): currentCycleStreamProvider, cycleRepositoryProvider, dailyLogRepositoryProvider, symptomRepositoryProvider, build, build, CalendarPage, _handleChangePeriodDate (+9 more)

### Community 31 - "health_details_page.dart"
Cohesion: 0.18
Nodes (9): bloodGroups, build, createState, dispose, _heightController, _pickDateOfBirth, _selectedBloodGroup, _selectedDob (+1 more)

### Community 32 - "Edit Profile Page Module"
Cohesion: 0.14
Nodes (12): _buildDobPicker, _buildTextField, createState, _currentAvatar, dispose, _emailController, _formKey, _initialized (+4 more)

### Community 33 - "period_logging_provider.dart"
Cohesion: 0.20
Nodes (10): clear, copyWith, flowLevel, painLevel, PeriodLoggingNotifier, PeriodLoggingState, setFlowLevel, setPainLevel (+2 more)

### Community 34 - "Calendar & Period Timeline"
Cohesion: 0.12
Nodes (15): BloomCalendar, build, expectedPeriodDays, fertileDays, focusedDay, _isAnyPeriodDay, _isExpectedPeriodDay, _isFertileDay (+7 more)

### Community 35 - "onboarding_provider.dart"
Cohesion: 0.09
Nodes (20): bloodGroup, copyWith, cycleDuration, dateOfBirth, goals, heightCm, lastPeriodDate, periodDuration (+12 more)

### Community 36 - "in_app_security_gate.dart"
Cohesion: 0.20
Nodes (5): child, createState, dispose, InAppSecurityGate, _InAppSecurityGateState

### Community 37 - "Drift Database & Tables Schema"
Cohesion: 0.23
Nodes (12): AiInsight, AiInsightsCompanion, Cycle, CyclesCompanion, DailyLog, DailyLogsCompanion, DailySymptom, DailySymptomsCompanion (+4 more)

### Community 38 - "Home Dashboard & Cycle State"
Cohesion: 0.13
Nodes (14): completeCycle, _db, deleteCycle, getAllCycles, getCurrentCycle, getCycleForDate, getOrCreateCycleForPeriodDate, getPreviousCompletedCycle (+6 more)

### Community 39 - "profile_page.dart"
Cohesion: 0.14
Nodes (11): icon, onTap, _SettingsTile, showDivider, title, trailingText, BloomEmoticonPicker, build (+3 more)

### Community 40 - "core/database/database_providers.dart"
Cohesion: 0.06
Nodes (23): _buildBarData, _buildSmallStatBox, createState, _selectedCycles, _buildAverageRow, _buildCorrelationRow, color, _CorrelationItem (+15 more)

### Community 41 - "userProfileStreamProvider"
Cohesion: 0.15
Nodes (17): userProfileStreamProvider, userRepositoryProvider, HomePage, homeProvider, QuickActionsGrid, build, InsightsPage, build (+9 more)

### Community 42 - "Cycles Table Module"
Cohesion: 0.14
Nodes (12): createdAt, cycleLength, endDate, id, isDeleted, isPredicted, isSynced, periodLength (+4 more)

### Community 43 - "reminder_settings_page.dart"
Cohesion: 0.13
Nodes (13): _buildDailyLogReminderTile, _buildDialogStep, _buildPeriodReminderTile, _buildReminderTile, createState, _editQuietHours, _editSingleReminderTime, _formatQuietHours (+5 more)

### Community 44 - "Daily Log Repository Module"
Cohesion: 0.14
Nodes (13): _db, getAllDailyLogs, getLogForDate, getLogsForCycle, getLogsForDateRange, movePeriodLog, removePeriodFlowForDate, _stripTime (+5 more)

### Community 45 - "Clinical PDF Report Generation"
Cohesion: 0.14
Nodes (10): _buildAverageRow, _buildBarData, _buildChecklistItem, _buildInfoCol, _buildMetricBox, _buildPeriodBarData, _buildSectionTitle, _buildTimelineRow (+2 more)

### Community 46 - "Summary Metrics Row Module"
Cohesion: 0.17
Nodes (11): build, _getMoodEmoji, _getMoodSubtext, _getPainSubtext, label, mood, painLevel, subtext (+3 more)

### Community 47 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.10
Nodes (15): CheckinRatingsPage, CheckinRemediesPage, remedies, options, goals, createState, initState, _selectedDate (+7 more)

### Community 48 - "Report Problem Page Module"
Cohesion: 0.13
Nodes (13): _appVersion, _attachedFileNames, build, _buildTextField, createState, _deviceModel, initState, _loadDeviceInfo (+5 more)

### Community 49 - "Authentication & User Session"
Cohesion: 0.17
Nodes (5): Fake, FakePathProviderPlatform, getApplicationDocumentsPath, main, tempDir

### Community 50 - "onboardingProvider"
Cohesion: 0.07
Nodes (22): CompareCyclesPage, CyclePatternsPage, LifestyleInsightsPage, MoodTrendsPage, SymptomsPatternsPage, build, CycleDurationPage, HealthDetailsPage (+14 more)

### Community 51 - "quick_actions_grid.dart"
Cohesion: 0.15
Nodes (9): icon, label, onTap, _QuickAction, build, icon, prediction, symptom (+1 more)

### Community 52 - "AI Insight Engine"
Cohesion: 0.15
Nodes (11): category, createdAt, cyclePhase, generatedDate, headline, id, insightText, isDeleted (+3 more)

### Community 53 - "Custom Reminders Management"
Cohesion: 0.15
Nodes (11): createdAt, daysBefore, id, isDeleted, isEnabled, isSynced, primaryKey, timeOfDay (+3 more)

### Community 54 - "signup_page.dart"
Cohesion: 0.18
Nodes (8): createState, dispose, _emailController, SignUpPage, _SignUpPageState, createState, dispose, _nameController

### Community 55 - "AI Insight Engine"
Cohesion: 0.17
Nodes (4): db, insightsRepositoryProvider, symptomsForLogStreamProvider, watch

### Community 56 - "Theme Tokens & Styling"
Cohesion: 0.17
Nodes (10): AppColors, background, border, lightPink, lightPurple, primaryPink, primaryPurple, secondaryText (+2 more)

### Community 58 - "app_lock_choice_page.dart"
Cohesion: 0.22
Nodes (8): AppLockChoicePage, _AppLockChoicePageState, _buildDialogKeypadBtn, _buildMethodTile, createState, _showSetPasswordDialog, _showSetPatternDialog, _showSetPinDialog

### Community 59 - "main.dart"
Cohesion: 0.12
Nodes (10): notificationSyncProvider, BloomApp, build, db, initialRoute, initialSecurityState, isLoggedIn, main (+2 more)

### Community 60 - "Daily Symptoms Table Module"
Cohesion: 0.18
Nodes (8): createdAt, dailyLogId, id, isDeleted, isSynced, primaryKey, severity, symptomName

### Community 61 - "Last Period Page Module"
Cohesion: 0.22
Nodes (7): build, createState, initState, PeriodStartPage, _PeriodStartPageState, _pickDate, _selectedDate

### Community 62 - "privacySecurityProvider"
Cohesion: 0.36
Nodes (10): build, inAppLockRuntimeProvider, privacySecurityProvider, _InAppLockScreenState, _onPatternComplete, _verifyPassword, _verifyPin, build (+2 more)

### Community 63 - "app_settings_page.dart"
Cohesion: 0.22
Nodes (7): _buildActionTile, _buildDropdownTile, _buildInfoTile, _buildSwitchTile, cycleOptions, goalOptions, periodOptions

### Community 64 - "Contact Support Page Module"
Cohesion: 0.22
Nodes (7): _attachedFileNames, build, categories, createState, _pickFile, selectedCategory, _submit

### Community 65 - "Drift Database & Tables Schema"
Cohesion: 0.29
Nodes (6): _db, getInsightsForCategory, getLatestInsight, InsightsRepository, saveInsight, watchInsightsForCategory

### Community 66 - "AI Insight Engine"
Cohesion: 0.13
Nodes (12): _buildLegendItem, _buildPhasePainRow, _buildSmallStatBox, createState, _getPainCategoryColor, _getPainCategoryText, _isLogForCycle, PainInsightsPage (+4 more)

### Community 67 - "build"
Cohesion: 0.48
Nodes (7): allRemindersStreamProvider, reminderRepositoryProvider, build, _ReminderSettingsPageState, build, dismissedRemindersProvider, RemindersPage

### Community 68 - "doctor_report_test.dart"
Cohesion: 0.22
Nodes (4): createTestCycle, createTestLog, createTestUser, main

### Community 70 - "StatelessWidget"
Cohesion: 0.11
Nodes (13): LoginPage, HistoryPage, AppShell, child, icon, isSelected, label, _NavItem (+5 more)

### Community 71 - "Cycle Status Card Module"
Cohesion: 0.20
Nodes (9): build, cycleDay, CycleStatusCard, daysUntilPeriod, fertileWindowRange, isPeriodLate, isPeriodOngoing, periodDateRange (+1 more)

### Community 72 - "bloom_grid_item.dart"
Cohesion: 0.29
Nodes (6): BloomGridItem, build, icon, isSelected, label, onTap

### Community 73 - "doctor_report_setup_page.dart"
Cohesion: 0.29
Nodes (6): build, _buildCheckListItem, createState, DoctorReportSetupPage, _DoctorReportSetupPageState, _selectedCycles

### Community 74 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.18
Nodes (4): main, createTestWidget, main, main

### Community 75 - "State"
Cohesion: 0.32
Nodes (6): PeriodFlowPainBottomSheetContent, _PeriodFlowPainBottomSheetContentState, ContactSupportPage, _ContactSupportPageState, PatternLockWidget, PatternLockWidgetState

### Community 76 - "Bloom App Bar Module"
Cohesion: 0.22
Nodes (6): BloomAppBar, build, onSkip, preferredSize, progress, showSkip

### Community 77 - "Bloom Lifestyle Card Module"
Cohesion: 0.20
Nodes (8): BloomLifestyleCard, bottomWidget, build, icon, onTap, title, trailing, valueText

### Community 78 - "AI Insight Engine"
Cohesion: 0.22
Nodes (9): Bloom Flutter Dependencies & Packages, Bloom Menstrual Tracker Architecture, Bloom Design System & AppColors, Insights & Cycle Comparison Suite, Schema AI Insights Entity, Schema Cycles Entity, Schema DailyLogs Entity, Unified Drift & PostgreSQL Sync Engine (+1 more)

### Community 79 - "VoidCallback"
Cohesion: 0.12
Nodes (13): build, icon, iconColor, InsightsGridButton, label, onTap, backgroundColor, BloomButton (+5 more)

### Community 80 - "Symptom Repository Module"
Cohesion: 0.25
Nodes (7): _db, getAllSymptoms, getSymptomsForLog, setSymptomsForLog, SymptomRepository, watchAllSymptoms, watchSymptomsForLog

### Community 81 - "bloom_checkbox_tile.dart"
Cohesion: 0.29
Nodes (6): BloomCheckboxTile, build, icon, isSelected, onTap, text

### Community 82 - "insight_toggle_bar.dart"
Cohesion: 0.10
Nodes (16): InsightsNotifier, insightsProvider, InsightTab, setTab, build, _buildToggle, currentTab, InsightToggleBar (+8 more)

### Community 83 - "package:drift/drift.dart"
Cohesion: 0.33
Nodes (4): DatabaseSeeder, purgeMockCycles, seedInitialData, _uuid

### Community 86 - "User Repository Module"
Cohesion: 0.29
Nodes (5): _db, getUserProfile, saveUserProfile, UserRepository, watchUserProfile

### Community 88 - "AI Insight Engine"
Cohesion: 0.29
Nodes (6): AiInsights, Cycles, DailyLogs, DailySymptoms, Reminders, UserProfiles

### Community 89 - "Give Feedback Page Module"
Cohesion: 0.33
Nodes (6): build, createState, GiveFeedbackPage, _GiveFeedbackPageState, _rating, _submit

### Community 91 - "CalendarNotifier"
Cohesion: 1.00
Nodes (3): CalendarNotifier, CalendarState, MockCalendarNotifier

### Community 92 - "VoidCallback"
Cohesion: 0.14
Nodes (11): BloomFlowOption, build, dropOpacity, isSelected, label, onTap, BloomOptionCard, build (+3 more)

### Community 95 - "AI Insight Engine"
Cohesion: 0.29
Nodes (4): createCompletedCycle, createTestLog, createTestProfile, main

### Community 96 - "package:bloom/core/database/app_database.dart"
Cohesion: 0.12
Nodes (9): createCompletedCycle, createTestUser, main, createCompletedCycle, createTestLog, createTestProfile, main, main (+1 more)

### Community 98 - "AI Insight Engine"
Cohesion: 0.33
Nodes (3): createCompletedCycle, createTestUser, main

### Community 99 - "Cycle Comparison & Patterns"
Cohesion: 0.33
Nodes (4): createTestCycle, createTestLog, createTestSymptom, main

### Community 100 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 102 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 107 - "Suggest Feature Page Module"
Cohesion: 0.33
Nodes (6): build, _buildTextField, createState, _submit, SuggestFeaturePage, _SuggestFeaturePageState

### Community 109 - "Notification & Reminder Scheduling"
Cohesion: 0.50
Nodes (3): resetNotifiedCyclesCache, resetShownTodayCache, setPluginForTesting

## Knowledge Gaps
- **946 isolated node(s):** `schemaVersion`, `_openConnection`, `db`, `insightsRepositoryProvider`, `symptomsForLogStreamProvider` (+941 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1152 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDatabase` connect `AppDatabase` to `Drift Database & Tables Schema`, `Drift Database & Tables Schema`, `Home Dashboard & Cycle State`, `Daily Log Repository Module`, `Symptom Repository Module`, `User Repository Module`, `AI Insight Engine`, `Custom Reminders Management`, `Cycle Repository Module`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **What connects `schemaVersion`, `_openConnection`, `db` to the rest of the system?**
  _946 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Drift Database & Tables Schema` be split into smaller, more focused modules?**
  _Cohesion score 0.026975563313233895 - nodes in this community are weakly interconnected._
- **Why does `_InAppSecurityGateState` connect `in_app_security_gate.dart` to `Cycle Comparison & Patterns`, `privacySecurityProvider`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Should `AI Insight Engine` be split into smaller, more focused modules?**
  _Cohesion score 0.034482758620689655 - nodes in this community are weakly interconnected._
- **Should `Notification & Reminder Scheduling` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._
- **Should `Home Dashboard & Cycle State` be split into smaller, more focused modules?**
  _Cohesion score 0.05263157894736842 - nodes in this community are weakly interconnected._