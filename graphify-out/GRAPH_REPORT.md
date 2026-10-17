# Graph Report - bloom  (2026-10-17)

## Corpus Check
- 141 files · ~502,506 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 16 file(s) not represented in the graph (top: .xml 10, (none) 3, .properties 2)

## Summary
- 1769 nodes · 2862 edges · 104 communities (96 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 1 edges (avg confidence: 0.95)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `44a35e77`
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
- bloom_app_bar.dart
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
- in_app_lock_screen.dart
- Symptoms Patterns Page Module
- ConsumerWidget
- calendar_page.dart
- lifestyle_insights_page.dart
- health_details_page.dart
- Edit Profile Page Module
- ai_insight_service.dart
- Calendar & Period Timeline
- onboarding_provider.dart
- privacySecurityProvider
- Drift Database & Tables Schema
- Home Dashboard & Cycle State
- profile_page.dart
- cycle_patterns_page.dart
- emergency_information_page.dart
- Cycles Table Module
- ConsumerWidget
- Daily Log Repository Module
- Clinical PDF Report Generation
- Summary Metrics Row Module
- List
- Report Problem Page Module
- Authentication & User Session
- onboardingProvider
- IconData
- AI Insight Engine
- Custom Reminders Management
- ConsumerStatefulWidget
- database_providers.dart
- Theme Tokens & Styling
- Home Dashboard & Cycle State
- ConsumerStatefulWidget
- build
- Daily Symptoms Table Module
- Last Period Page Module
- core/database/database_providers.dart
- bloom_flow_option.dart
- Contact Support Page Module
- Drift Database & Tables Schema
- AI Insight Engine
- period_log_page.dart
- doctor_report_test.dart
- profile_edit_test.dart
- app_shell.dart
- Cycle Status Card Module
- bloom_grid_item.dart
- doctor_report_setup_page.dart
- package:flutter_test/flutter_test.dart
- State
- Bloom Lifestyle Card Module
- AI Insight Engine
- VoidCallback
- Symptom Repository Module
- faq_page.dart
- insight_toggle_bar.dart
- package:flutter/material.dart
- Privacy & App Lock Security
- User Repository Module
- name_page.dart
- AI Insight Engine
- Give Feedback Page Module
- package:drift/drift.dart
- quick_actions_grid.dart
- about_bloom_page.dart
- AI Insight Engine
- package:bloom/core/database/app_database.dart
- mood_trends_page_test.dart
- Cycle Comparison & Patterns
- AI Insight Engine
- AI Insight Engine
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
  lib/features/onboarding/presentation/pages/health_details_page.dart → lib/features/onboarding/presentation/providers/onboarding_provider.dart
- `build` --references--> `privacySecurityProvider`  [EXTRACTED]
  lib/features/profile/presentation/widgets/in_app_lock_screen.dart → lib/features/profile/presentation/providers/privacy_security_provider.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Offline-First Sync Entities** — unified_schema_sync_engine, unified_schema_user_profiles, unified_schema_cycles, unified_schema_daily_logs [INFERRED 0.85]

## Communities (104 total, 8 thin omitted)

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
Cohesion: 0.08
Nodes (20): build, HistoryPage, ProfilePage, BodyTodayCard, build, message, BloomProBanner, build (+12 more)

### Community 8 - "Clinical PDF Report Generation"
Cohesion: 0.07
Nodes (22): bgPink, borderCol, _buildCycleSummaryChart, _buildHeader, _buildInfoCol, _buildLifestyleInsights, _buildMetricBox, _buildObservations (+14 more)

### Community 9 - "Cycle Comparison & Patterns"
Cohesion: 0.08
Nodes (24): averagePain, averageSleep, bloating, _buildTableRow, _calculateMetrics, createState, _customCycle1Id, _customCycle2Id (+16 more)

### Community 10 - "Privacy & App Lock Security"
Cohesion: 0.08
Nodes (21): activeColor, build, clearPattern, color, createState, currentTouchPos, _currentTouchPosition, _dotCenter (+13 more)

### Community 11 - "reminders_page.dart"
Cohesion: 0.06
Nodes (31): build, build, build, build, build, build, _buildFlowStep, actionLabel (+23 more)

### Community 12 - "Notification & Reminder Scheduling"
Cohesion: 0.05
Nodes (31): calendarState, cycleSummaryReminder, dailyLogsAsync, dailyReminder, fertileReminder, _findFertileStart, hasFlowToday, hasRecentFlow (+23 more)

### Community 13 - "Privacy & App Lock Security"
Cohesion: 0.10
Nodes (13): AuthStorageService, _fileName, _getFile, instance, isLoggedIn, logout, setLoggedIn, _fileName (+5 more)

### Community 14 - "Daily Summary Card Module"
Cohesion: 0.05
Nodes (35): copyWith, daysLate, expectedPeriodDays, fertileDays, focusedDay, isPeriodLate, nextPeriodEndDate, nextPeriodStartDate (+27 more)

### Community 15 - "bloom_app_bar.dart"
Cohesion: 0.22
Nodes (6): BloomAppBar, build, onSkip, preferredSize, progress, showSkip

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
Cohesion: 0.13
Nodes (4): build, build, build, build

### Community 20 - "Cycle Comparison & Patterns"
Cohesion: 0.20
Nodes (24): allCyclesStreamProvider, allDailyLogsStreamProvider, allSymptomsStreamProvider, userProfileStreamProvider, CalendarNotifier, CalendarState, _recomputeCyclePredictions, build (+16 more)

### Community 21 - "Notification & Reminder Scheduling"
Cohesion: 0.11
Nodes (11): cancel, cancelAll, cancelled, FakeFlutterLocalNotificationsPlatform, fakePlatform, FlutterLocalNotificationsPlatform, instant, main (+3 more)

### Community 22 - "In App Lock Screen Module"
Cohesion: 0.08
Nodes (20): AppTheme, _buildActionTile, _buildDropdownTile, _buildInfoTile, _buildSwitchTile, cycleOptions, goalOptions, periodOptions (+12 more)

### Community 23 - "Privacy & App Lock Security"
Cohesion: 0.10
Nodes (16): databaseProvider, autoLockOptions, build, _buildActionTile, _buildExportRow, _buildSwitchTile, _confirmDeleteAccount, _confirmDeleteTrackingData (+8 more)

### Community 24 - "Custom Reminders Management"
Cohesion: 0.12
Nodes (14): DatabaseSeeder, purgeMockCycles, seedInitialData, _uuid, _db, ensureStandardReminders, getAllReminders, ReminderRepository (+6 more)

### Community 25 - "Cycle Repository Module"
Cohesion: 0.14
Nodes (11): CycleRepository, DailyLogRepository, PeriodFlowPainResult, cycleRepo, db, main, cycleRepo, dailyLogRepo (+3 more)

### Community 26 - "in_app_lock_screen.dart"
Cohesion: 0.11
Nodes (15): build, _buildKeypadButton, _buildPasswordView, _buildPatternView, _buildPinView, createState, dispose, _enteredPin (+7 more)

### Community 27 - "Symptoms Patterns Page Module"
Cohesion: 0.11
Nodes (17): badgeColor, badgeText, _buildCommonSymptomRow, _buildTimelineSymptomRow, _calculateTimingInfo, createState, _getSymptomIcon, icon (+9 more)

### Community 28 - "ConsumerWidget"
Cohesion: 0.19
Nodes (6): CheckinLifestylePage, CheckinRatingsPage, CheckinRemediesPage, remedies, DoctorReportBanner, WelcomePage

### Community 29 - "calendar_page.dart"
Cohesion: 0.15
Nodes (3): _getMonthName, _handleLogPeriodForDay, main

### Community 30 - "lifestyle_insights_page.dart"
Cohesion: 0.17
Nodes (11): _buildAverageRow, _buildCorrelationRow, color, _CorrelationItem, createState, icon, _isLogForCycle, _parseWaterLiters (+3 more)

### Community 31 - "health_details_page.dart"
Cohesion: 0.13
Nodes (13): bloodGroups, build, createState, dispose, HealthDetailsPage, _HealthDetailsPageState, _heightController, initState (+5 more)

### Community 32 - "Edit Profile Page Module"
Cohesion: 0.11
Nodes (16): bloodGroups, _buildDobPicker, _buildTextField, createState, _currentAvatar, dispose, _emailController, _formKey (+8 more)

### Community 33 - "ai_insight_service.dart"
Cohesion: 0.22
Nodes (7): AiInsightService, getBodyTodayInsight, getCompareCyclesInsight, getCyclePatternInsight, getLifestyleCorrelationInsight, getMoodTrendInsight, instance

### Community 34 - "Calendar & Period Timeline"
Cohesion: 0.12
Nodes (15): BloomCalendar, build, expectedPeriodDays, fertileDays, focusedDay, _isAnyPeriodDay, _isExpectedPeriodDay, _isFertileDay (+7 more)

### Community 35 - "onboarding_provider.dart"
Cohesion: 0.04
Nodes (43): bloodGroup, copyWith, cycleDuration, dateOfBirth, goals, heightCm, lastPeriodDate, OnboardingNotifier (+35 more)

### Community 36 - "privacySecurityProvider"
Cohesion: 0.11
Nodes (22): _AppLockChoicePageState, build, _buildDialogKeypadBtn, _buildMethodTile, createState, _showSetPasswordDialog, _showSetPatternDialog, _showSetPinDialog (+14 more)

### Community 37 - "Drift Database & Tables Schema"
Cohesion: 0.23
Nodes (12): AiInsight, AiInsightsCompanion, Cycle, CyclesCompanion, DailyLog, DailyLogsCompanion, DailySymptom, DailySymptomsCompanion (+4 more)

### Community 38 - "Home Dashboard & Cycle State"
Cohesion: 0.13
Nodes (14): completeCycle, _db, deleteCycle, getAllCycles, getCurrentCycle, getCycleForDate, getOrCreateCycleForPeriodDate, getPreviousCompletedCycle (+6 more)

### Community 39 - "profile_page.dart"
Cohesion: 0.20
Nodes (6): LoginPage, icon, onTap, _SettingsTile, showDivider, title

### Community 40 - "cycle_patterns_page.dart"
Cohesion: 0.15
Nodes (5): _buildBarData, _buildSmallStatBox, createState, CyclePatternsPage, _selectedCycles

### Community 41 - "emergency_information_page.dart"
Cohesion: 0.40
Nodes (3): build, _buildSymptomList, EmergencyInformationPage

### Community 42 - "Cycles Table Module"
Cohesion: 0.14
Nodes (12): createdAt, cycleLength, endDate, id, isDeleted, isPredicted, isSynced, periodLength (+4 more)

### Community 43 - "ConsumerWidget"
Cohesion: 0.18
Nodes (12): userRepositoryProvider, HomePage, homeProvider, QuickActionsGrid, InsightsPage, InsightsHeroCard, GoalsPage, AppSettingsPage (+4 more)

### Community 44 - "Daily Log Repository Module"
Cohesion: 0.14
Nodes (13): _db, getAllDailyLogs, getLogForDate, getLogsForCycle, getLogsForDateRange, movePeriodLog, removePeriodFlowForDate, _stripTime (+5 more)

### Community 45 - "Clinical PDF Report Generation"
Cohesion: 0.14
Nodes (10): _buildAverageRow, _buildBarData, _buildChecklistItem, _buildInfoCol, _buildMetricBox, _buildPeriodBarData, _buildSectionTitle, _buildTimelineRow (+2 more)

### Community 46 - "Summary Metrics Row Module"
Cohesion: 0.14
Nodes (13): build, _getMoodEmoji, _getMoodSubtext, _getPainSubtext, label, _MetricItem, mood, painLevel (+5 more)

### Community 47 - "List"
Cohesion: 0.15
Nodes (9): build, build, CheckinMoodPage, _showMoreSymptoms, symptoms, CheckinNotesPage, build, build (+1 more)

### Community 48 - "Report Problem Page Module"
Cohesion: 0.13
Nodes (13): _appVersion, _attachedFileNames, build, _buildTextField, createState, _deviceModel, initState, _loadDeviceInfo (+5 more)

### Community 49 - "Authentication & User Session"
Cohesion: 0.17
Nodes (5): Fake, FakePathProviderPlatform, getApplicationDocumentsPath, main, tempDir

### Community 50 - "onboardingProvider"
Cohesion: 0.13
Nodes (13): build, CycleDurationPage, options, build, createState, initState, LastPeriodPage, _LastPeriodPageState (+5 more)

### Community 51 - "IconData"
Cohesion: 0.14
Nodes (11): build, icon, prediction, symptom, SymptomPredictionCard, BloomCheckboxTile, build, icon (+3 more)

### Community 52 - "AI Insight Engine"
Cohesion: 0.15
Nodes (11): category, createdAt, cyclePhase, generatedDate, headline, id, insightText, isDeleted (+3 more)

### Community 53 - "Custom Reminders Management"
Cohesion: 0.15
Nodes (11): createdAt, daysBefore, id, isDeleted, isEnabled, isSynced, primaryKey, timeOfDay (+3 more)

### Community 54 - "ConsumerStatefulWidget"
Cohesion: 0.18
Nodes (7): build, createState, dispose, _emailController, SignUpPage, _SignUpPageState, build

### Community 55 - "database_providers.dart"
Cohesion: 0.13
Nodes (15): currentCycleStreamProvider, cycleRepositoryProvider, dailyLogRepositoryProvider, db, insightsRepositoryProvider, symptomRepositoryProvider, symptomsForLogStreamProvider, watch (+7 more)

### Community 56 - "Theme Tokens & Styling"
Cohesion: 0.17
Nodes (10): AppColors, background, border, lightPink, lightPurple, primaryPink, primaryPurple, secondaryText (+2 more)

### Community 57 - "Home Dashboard & Cycle State"
Cohesion: 0.18
Nodes (4): build, dailyCheckinForSelectedDayProvider, build, build

### Community 58 - "ConsumerStatefulWidget"
Cohesion: 0.25
Nodes (7): CompareCyclesPage, LifestyleInsightsPage, SymptomsPatternsPage, AppLockChoicePage, EditProfilePage, InAppLockScreen, ReminderSettingsPage

### Community 59 - "build"
Cohesion: 0.43
Nodes (8): allRemindersStreamProvider, reminderRepositoryProvider, calendarProvider, build, _ReminderSettingsPageState, build, dismissedRemindersProvider, RemindersPage

### Community 60 - "Daily Symptoms Table Module"
Cohesion: 0.18
Nodes (8): createdAt, dailyLogId, id, isDeleted, isSynced, primaryKey, severity, symptomName

### Community 61 - "Last Period Page Module"
Cohesion: 0.25
Nodes (5): build, createState, initState, _pickDate, _selectedDate

### Community 62 - "core/database/database_providers.dart"
Cohesion: 0.12
Nodes (11): _buildLegendRow, _buildTimelineMoodRow, createState, _getMoodDisplay, _getPredominantMood, _isLogForCycle, MoodTrendsPage, _normalizeMood (+3 more)

### Community 63 - "bloom_flow_option.dart"
Cohesion: 0.29
Nodes (6): BloomFlowOption, build, dropOpacity, isSelected, label, onTap

### Community 64 - "Contact Support Page Module"
Cohesion: 0.20
Nodes (9): _attachedFileNames, build, categories, ContactSupportPage, _ContactSupportPageState, createState, _pickFile, selectedCategory (+1 more)

### Community 65 - "Drift Database & Tables Schema"
Cohesion: 0.25
Nodes (6): _db, getInsightsForCategory, getLatestInsight, InsightsRepository, saveInsight, watchInsightsForCategory

### Community 66 - "AI Insight Engine"
Cohesion: 0.13
Nodes (12): _buildLegendItem, _buildPhasePainRow, _buildSmallStatBox, createState, _getPainCategoryColor, _getPainCategoryText, _isLogForCycle, PainInsightsPage (+4 more)

### Community 67 - "period_log_page.dart"
Cohesion: 0.17
Nodes (6): build, symptoms, SymptomsPage, flowOptions, _showMoreSymptoms, symptoms

### Community 68 - "doctor_report_test.dart"
Cohesion: 0.22
Nodes (4): createTestCycle, createTestLog, createTestUser, main

### Community 70 - "app_shell.dart"
Cohesion: 0.20
Nodes (7): AppShell, child, icon, isSelected, label, _NavItem, onTap

### Community 71 - "Cycle Status Card Module"
Cohesion: 0.20
Nodes (9): build, cycleDay, CycleStatusCard, daysUntilPeriod, fertileWindowRange, isPeriodLate, isPeriodOngoing, periodDateRange (+1 more)

### Community 72 - "bloom_grid_item.dart"
Cohesion: 0.29
Nodes (6): BloomGridItem, build, icon, isSelected, label, onTap

### Community 73 - "doctor_report_setup_page.dart"
Cohesion: 0.25
Nodes (6): build, _buildCheckListItem, createState, DoctorReportSetupPage, _DoctorReportSetupPageState, _selectedCycles

### Community 74 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.25
Nodes (3): main, createTestWidget, main

### Community 75 - "State"
Cohesion: 0.17
Nodes (12): PeriodStartPage, _PeriodStartPageState, PeriodFlowPainBottomSheetContent, _PeriodFlowPainBottomSheetContentState, build, _buildTextField, createState, _submit (+4 more)

### Community 77 - "Bloom Lifestyle Card Module"
Cohesion: 0.12
Nodes (14): BloomEmoticonPicker, build, moods, onMoodSelected, selectedMood, BloomLifestyleCard, bottomWidget, build (+6 more)

### Community 78 - "AI Insight Engine"
Cohesion: 0.22
Nodes (9): Bloom Flutter Dependencies & Packages, Bloom Menstrual Tracker Architecture, Bloom Design System & AppColors, Insights & Cycle Comparison Suite, Schema AI Insights Entity, Schema Cycles Entity, Schema DailyLogs Entity, Unified Drift & PostgreSQL Sync Engine (+1 more)

### Community 79 - "VoidCallback"
Cohesion: 0.12
Nodes (13): build, icon, iconColor, InsightsGridButton, label, onTap, backgroundColor, BloomButton (+5 more)

### Community 80 - "Symptom Repository Module"
Cohesion: 0.18
Nodes (8): AppDatabase, _db, getAllSymptoms, getSymptomsForLog, setSymptomsForLog, SymptomRepository, watchAllSymptoms, watchSymptomsForLog

### Community 81 - "faq_page.dart"
Cohesion: 0.40
Nodes (4): build, _buildCategory, _buildFaqItem, FaqPage

### Community 82 - "insight_toggle_bar.dart"
Cohesion: 0.10
Nodes (16): InsightsNotifier, insightsProvider, InsightTab, setTab, build, _buildToggle, currentTab, InsightToggleBar (+8 more)

### Community 83 - "package:flutter/material.dart"
Cohesion: 0.14
Nodes (8): showPageInfoDialog, build, _buildSectionGroup, _buildTileItem, HelpSupportPage, build, _buildSection, MedicalDisclaimerPage

### Community 86 - "User Repository Module"
Cohesion: 0.29
Nodes (5): _db, getUserProfile, saveUserProfile, UserRepository, watchUserProfile

### Community 87 - "name_page.dart"
Cohesion: 0.25
Nodes (6): build, createState, dispose, _nameController, NamePage, _NamePageState

### Community 88 - "AI Insight Engine"
Cohesion: 0.29
Nodes (6): AiInsights, Cycles, DailyLogs, DailySymptoms, Reminders, UserProfiles

### Community 89 - "Give Feedback Page Module"
Cohesion: 0.33
Nodes (6): build, createState, GiveFeedbackPage, _GiveFeedbackPageState, _rating, _submit

### Community 91 - "package:drift/drift.dart"
Cohesion: 0.33
Nodes (3): createCompletedCycle, createTestUser, main

### Community 92 - "quick_actions_grid.dart"
Cohesion: 0.15
Nodes (9): icon, label, onTap, _QuickAction, BloomOptionCard, build, isSelected, onTap (+1 more)

### Community 94 - "about_bloom_page.dart"
Cohesion: 0.33
Nodes (5): AboutBloomPage, _buildFeatureCard, _buildListTile, _buildSectionHeader, _buildTimelineStep

### Community 95 - "AI Insight Engine"
Cohesion: 0.29
Nodes (4): createCompletedCycle, createTestLog, createTestProfile, main

### Community 96 - "package:bloom/core/database/app_database.dart"
Cohesion: 0.18
Nodes (5): createCompletedCycle, createTestUser, main, main, noSuchMethod

### Community 98 - "mood_trends_page_test.dart"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestProfile, main

### Community 99 - "Cycle Comparison & Patterns"
Cohesion: 0.20
Nodes (5): createTestCycle, createTestLog, createTestSymptom, main, main

### Community 100 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 102 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 109 - "Notification & Reminder Scheduling"
Cohesion: 0.50
Nodes (3): resetNotifiedCyclesCache, resetShownTodayCache, setPluginForTesting

## Knowledge Gaps
- **952 isolated node(s):** `schemaVersion`, `_openConnection`, `db`, `insightsRepositoryProvider`, `symptomsForLogStreamProvider` (+947 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1161 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDatabase` connect `Symptom Repository Module` to `Drift Database & Tables Schema`, `Drift Database & Tables Schema`, `Home Dashboard & Cycle State`, `Daily Log Repository Module`, `User Repository Module`, `database_providers.dart`, `Custom Reminders Management`, `Cycle Repository Module`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **What connects `schemaVersion`, `_openConnection`, `db` to the rest of the system?**
  _952 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Drift Database & Tables Schema` be split into smaller, more focused modules?**
  _Cohesion score 0.026975563313233895 - nodes in this community are weakly interconnected._
- **Why does `build` connect `Privacy & App Lock Security` to `Cycle Comparison & Patterns`, `profile_page.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Should `AI Insight Engine` be split into smaller, more focused modules?**
  _Cohesion score 0.034482758620689655 - nodes in this community are weakly interconnected._
- **Why does `build` connect `About Bloom Page Module` to `package:flutter/material.dart`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **Should `Notification & Reminder Scheduling` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._