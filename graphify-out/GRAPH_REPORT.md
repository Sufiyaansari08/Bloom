# Graph Report - bloom  (2026-10-16)

## Corpus Check
- 181 files · ~497,208 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 16 file(s) not represented in the graph (top: .xml 10, (none) 3, .properties 2)

## Summary
- 1677 nodes · 2713 edges · 116 communities (103 shown, 13 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 1 edges (avg confidence: 0.95)
- Token cost: 1,200 input · 650 output

## Community Hubs (Navigation)
- Drift Database & Tables Schema
- AI Insight Engine
- Notification & Reminder Scheduling
- Home Dashboard & Cycle State
- Period Flow Pain Bottom Sheet Module
- Privacy & App Lock Security
- Daily Check-in & Symptoms Logging
- Privacy & App Lock Security
- Clinical PDF Report Generation
- Cycle Comparison & Patterns
- Privacy & App Lock Security
- Custom Reminders Management
- Notification & Reminder Scheduling
- Privacy & App Lock Security
- Daily Summary Card Module
- Daily Check-in & Symptoms Logging
- Privacy & App Lock Security
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
- Notification & Reminder Scheduling
- Calendar & Period Timeline
- Authentication & User Session
- Edit Profile Page Module
- Bloom Pro Banner Module
- Calendar & Period Timeline
- User Onboarding & Goals Setup
- Theme Tokens & Styling
- Drift Database & Tables Schema
- Home Dashboard & Cycle State
- Bloom Emoticon Picker Module
- AI Insight Engine
- Custom Reminders Management
- Cycles Table Module
- Calendar & Period Timeline
- Daily Log Repository Module
- Clinical PDF Report Generation
- Summary Metrics Row Module
- User Onboarding & Goals Setup
- Report Problem Page Module
- Authentication & User Session
- Cycle Comparison & Patterns
- Quick Actions Grid Module
- AI Insight Engine
- Custom Reminders Management
- Authentication & User Session
- AI Insight Engine
- Theme Tokens & Styling
- Home Dashboard & Cycle State
- AI Insight Engine
- In App Lock Runtime Provider Module
- Daily Symptoms Table Module
- Last Period Page Module
- Daily Check-in & Symptoms Logging
- Period Logging Provider Module
- Contact Support Page Module
- Drift Database & Tables Schema
- AI Insight Engine
- AI Insight Engine
- Authentication & User Session
- Doctor Report Setup Page Module
- App Shell Module
- Cycle Status Card Module
- Mood Trends Page Module
- Privacy & App Lock Security
- App Settings Page Module
- Calendar & Period Timeline
- Bloom App Bar Module
- Bloom Lifestyle Card Module
- AI Insight Engine
- AI Insight Engine
- Symptom Repository Module
- AI Insight Engine
- AI Insight Engine
- Bloom Button Module
- Bloom Slider Module
- Privacy & App Lock Security
- User Repository Module
- AI Insight Engine
- AI Insight Engine
- Give Feedback Page Module
- Profile Page Module
- Bloom Checkbox Tile Module
- Bloom Flow Option Module
- Bloom Grid Item Module
- Bloom Option Card Module
- AI Insight Engine
- Custom Reminders Management
- AI Insight Engine
- AI Insight Engine
- Cycle Comparison & Patterns
- AI Insight Engine
- AI Insight Engine
- AI Insight Engine
- Generate Icon Test Module
- Authentication & User Session
- Cycle Length Chart Module
- Faq Page Module
- Suggest Feature Page Module
- Daily Check-in & Symptoms Logging
- Notification & Reminder Scheduling
- Mainactivity.Kt Module
- Daily Check-in & Symptoms Logging

## God Nodes (most connected - your core abstractions)
1. `userProfileStreamProvider` - 25 edges
2. `privacySecurityProvider` - 25 edges
3. `allCyclesStreamProvider` - 21 edges
4. `allDailyLogsStreamProvider` - 17 edges
5. `onboardingProvider` - 16 edges
6. `dailyCheckinProvider` - 14 edges
7. `AppDatabase` - 12 edges
8. `CalendarPage` - 12 edges
9. `inAppLockRuntimeProvider` - 11 edges
10. `userRepositoryProvider` - 10 edges

## Surprising Connections (you probably didn't know these)
- `MockCalendarNotifier` --references--> `CalendarState`  [EXTRACTED]
  test/reminders_due_badge_test.dart → lib/features/calendar/presentation/providers/calendar_provider.dart
- `MockCalendarNotifier` --implements--> `CalendarNotifier`  [EXTRACTED]
  test/reminders_due_badge_test.dart → lib/features/calendar/presentation/providers/calendar_provider.dart
- `_showSetPinDialog` --references--> `privacySecurityProvider`  [EXTRACTED]
  lib/features/profile/presentation/pages/app_lock_choice_page.dart → lib/features/profile/presentation/providers/privacy_security_provider.dart
- `build` --references--> `privacySecurityProvider`  [EXTRACTED]
  lib/features/profile/presentation/widgets/in_app_lock_screen.dart → lib/features/profile/presentation/providers/privacy_security_provider.dart
- `_confirmDeleteTrackingData` --references--> `databaseProvider`  [EXTRACTED]
  lib/features/profile/presentation/pages/privacy_security_page.dart → lib/core/database/database_providers.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Offline-First Sync Entities** — unified_schema_sync_engine, unified_schema_user_profiles, unified_schema_cycles, unified_schema_daily_logs [INFERRED 0.85]

## Communities (116 total, 13 thin omitted)

### Community 0 - "Drift Database & Tables Schema"
Cohesion: 0.03
Nodes (120): _, activityLevel, _activityLevelMeta, actualTableName, _alias, aliasedName, allSchemaEntities, allTables (+112 more)

### Community 1 - "AI Insight Engine"
Cohesion: 0.04
Nodes (6): appRouter, createAppRouter, initialLocation, rootNavigatorKey, shellNavigatorKey, state

### Community 2 - "Notification & Reminder Scheduling"
Cohesion: 0.04
Nodes (39): areNotificationsEnabled, cancel, cancelAll, channelDescription, channelId, channelName, getAppLaunchPayload, hasNotifiedCycle (+31 more)

### Community 3 - "Home Dashboard & Cycle State"
Cohesion: 0.05
Nodes (37): allCyclesAsync, avgCycleLen, avgPeriodLen, currentCycle, currentCycleAsync, cycleDay, daysUntil, daysUntilPeriod (+29 more)

### Community 4 - "Period Flow Pain Bottom Sheet Module"
Cohesion: 0.06
Nodes (28): build, _buildPainStep, cleanDate, createState, _currentStep, cycleDay, cycleId, cycleRepo (+20 more)

### Community 5 - "Privacy & App Lock Security"
Cohesion: 0.07
Nodes (27): autoLockTime, copyWith, fromJson, isAiDataUsageEnabled, isAnalyticsEnabled, isDiscreteNotificationsEnabled, isLockActive, isPersonalizedRecommendationsEnabled (+19 more)

### Community 6 - "Daily Check-in & Symptoms Logging"
Cohesion: 0.07
Nodes (27): activity, clear, copyWith, fromCalendar, loadFromLog, mood, notes, painAfter1Hour (+19 more)

### Community 7 - "Privacy & App Lock Security"
Cohesion: 0.09
Nodes (17): build, _buildSymptomList, EmergencyInformationPage, _buildSectionGroup, _buildTileItem, HelpSupportPage, build, _buildSection (+9 more)

### Community 8 - "Clinical PDF Report Generation"
Cohesion: 0.08
Nodes (21): bgPink, borderCol, _buildCycleSummaryChart, _buildHeader, _buildInfoCol, _buildLifestyleInsights, _buildMetricBox, _buildObservations (+13 more)

### Community 9 - "Cycle Comparison & Patterns"
Cohesion: 0.08
Nodes (24): averagePain, averageSleep, bloating, _buildTableRow, _calculateMetrics, createState, _customCycle1Id, _customCycle2Id (+16 more)

### Community 10 - "Privacy & App Lock Security"
Cohesion: 0.08
Nodes (21): activeColor, build, clearPattern, color, createState, currentTouchPos, _currentTouchPosition, _dotCenter (+13 more)

### Community 11 - "Custom Reminders Management"
Cohesion: 0.09
Nodes (23): actionLabel, _buildQuietHoursBanner, color, createState, date, description, _formatNotificationDate, _formatNotificationTime (+15 more)

### Community 12 - "Notification & Reminder Scheduling"
Cohesion: 0.09
Nodes (21): calendarState, cycleSummaryReminder, dailyLogsAsync, dailyReminder, fertileReminder, _findFertileStart, hasFlowToday, hasRecentFlow (+13 more)

### Community 13 - "Privacy & App Lock Security"
Cohesion: 0.10
Nodes (13): AuthStorageService, _fileName, _getFile, instance, isLoggedIn, logout, setLoggedIn, _fileName (+5 more)

### Community 14 - "Daily Summary Card Module"
Cohesion: 0.09
Nodes (20): build, checkinData, cycleDay, DailySummaryCard, date, daysLate, expectedPeriodDate, isCycleStart (+12 more)

### Community 15 - "Daily Check-in & Symptoms Logging"
Cohesion: 0.16
Nodes (5): symptoms, remedies, _buildStatColumn, flowOptions, symptoms

### Community 16 - "Privacy & App Lock Security"
Cohesion: 0.15
Nodes (16): build, build, inAppLockRuntimeProvider, privacySecurityProvider, _InAppLockScreenState, _onPatternComplete, _verifyPassword, _verifyPin (+8 more)

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
Cohesion: 0.22
Nodes (19): allCyclesStreamProvider, allDailyLogsStreamProvider, allSymptomsStreamProvider, currentCycleStreamProvider, CalendarNotifier, CalendarState, _recomputeCyclePredictions, build (+11 more)

### Community 21 - "Notification & Reminder Scheduling"
Cohesion: 0.11
Nodes (11): cancel, cancelAll, cancelled, FakeFlutterLocalNotificationsPlatform, fakePlatform, FlutterLocalNotificationsPlatform, instant, main (+3 more)

### Community 22 - "In App Lock Screen Module"
Cohesion: 0.11
Nodes (15): build, _buildKeypadButton, _buildPasswordView, _buildPatternView, _buildPinView, createState, dispose, _enteredPin (+7 more)

### Community 23 - "Privacy & App Lock Security"
Cohesion: 0.13
Nodes (15): databaseProvider, autoLockOptions, build, _buildActionTile, _buildExportRow, _buildSwitchTile, _confirmDeleteAccount, _confirmDeleteTrackingData (+7 more)

### Community 24 - "Custom Reminders Management"
Cohesion: 0.12
Nodes (14): DatabaseSeeder, purgeMockCycles, seedInitialData, _uuid, _db, ensureStandardReminders, getAllReminders, ReminderRepository (+6 more)

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
Nodes (12): build, CheckinLifestylePage, build, CheckinMoodPage, _showMoreSymptoms, CheckinNotesPage, build, CheckinRatingsPage (+4 more)

### Community 29 - "Notification & Reminder Scheduling"
Cohesion: 0.12
Nodes (10): notificationSyncProvider, BloomApp, build, db, initialRoute, initialSecurityState, isLoggedIn, main (+2 more)

### Community 30 - "Calendar & Period Timeline"
Cohesion: 0.18
Nodes (16): cycleRepositoryProvider, dailyLogRepositoryProvider, userRepositoryProvider, build, _handleChangePeriodDate, _handleRemovePeriod, build, GoalsPage (+8 more)

### Community 31 - "Authentication & User Session"
Cohesion: 0.19
Nodes (4): options, goals, options, symptoms

### Community 32 - "Edit Profile Page Module"
Cohesion: 0.12
Nodes (14): _availableAvatars, _buildDobPicker, _buildTextField, createState, _currentAvatar, dispose, _emailController, _formKey (+6 more)

### Community 33 - "Bloom Pro Banner Module"
Cohesion: 0.12
Nodes (9): showPageInfoDialog, build, BodyTodayCard, build, message, BloomProBanner, build, build (+1 more)

### Community 34 - "Calendar & Period Timeline"
Cohesion: 0.12
Nodes (15): BloomCalendar, build, expectedPeriodDays, fertileDays, focusedDay, _isAnyPeriodDay, _isExpectedPeriodDay, _isFertileDay (+7 more)

### Community 35 - "User Onboarding & Goals Setup"
Cohesion: 0.12
Nodes (15): copyWith, cycleDuration, goals, lastPeriodDate, periodDuration, setCycleDuration, setLastPeriodDate, setPeriodDuration (+7 more)

### Community 36 - "Theme Tokens & Styling"
Cohesion: 0.14
Nodes (9): AppTheme, AppLockChoicePage, _AppLockChoicePageState, _buildDialogKeypadBtn, _buildMethodTile, createState, _showSetPasswordDialog, _showSetPatternDialog (+1 more)

### Community 37 - "Drift Database & Tables Schema"
Cohesion: 0.23
Nodes (12): AiInsight, AiInsightsCompanion, Cycle, CyclesCompanion, DailyLog, DailyLogsCompanion, DailySymptom, DailySymptomsCompanion (+4 more)

### Community 38 - "Home Dashboard & Cycle State"
Cohesion: 0.13
Nodes (14): completeCycle, _db, deleteCycle, getAllCycles, getCurrentCycle, getCycleForDate, getOrCreateCycleForPeriodDate, getPreviousCompletedCycle (+6 more)

### Community 39 - "Bloom Emoticon Picker Module"
Cohesion: 0.13
Nodes (12): icon, onTap, ProfilePage, _SettingsTile, showDivider, title, trailingText, BloomEmoticonPicker (+4 more)

### Community 40 - "AI Insight Engine"
Cohesion: 0.16
Nodes (5): _buildBarData, _buildSmallStatBox, createState, CyclePatternsPage, _selectedCycles

### Community 41 - "Custom Reminders Management"
Cohesion: 0.14
Nodes (12): _buildDailyLogReminderTile, _buildDialogStep, _buildPeriodReminderTile, _buildReminderTile, createState, _editQuietHours, _editSingleReminderTime, _formatQuietHours (+4 more)

### Community 42 - "Cycles Table Module"
Cohesion: 0.14
Nodes (12): createdAt, cycleLength, endDate, id, isDeleted, isPredicted, isSynced, periodLength (+4 more)

### Community 43 - "Calendar & Period Timeline"
Cohesion: 0.26
Nodes (14): allRemindersStreamProvider, reminderRepositoryProvider, userProfileStreamProvider, build, CalendarPage, calendarProvider, dailyCheckinForSelectedDayProvider, build (+6 more)

### Community 44 - "Daily Log Repository Module"
Cohesion: 0.14
Nodes (13): _db, getAllDailyLogs, getLogForDate, getLogsForCycle, getLogsForDateRange, movePeriodLog, removePeriodFlowForDate, _stripTime (+5 more)

### Community 45 - "Clinical PDF Report Generation"
Cohesion: 0.14
Nodes (11): build, _buildAverageRow, _buildBarData, _buildChecklistItem, _buildInfoCol, _buildMetricBox, _buildPeriodBarData, _buildSectionTitle (+3 more)

### Community 46 - "Summary Metrics Row Module"
Cohesion: 0.14
Nodes (13): build, _getMoodEmoji, _getMoodSubtext, _getPainSubtext, label, _MetricItem, mood, painLevel (+5 more)

### Community 47 - "User Onboarding & Goals Setup"
Cohesion: 0.14
Nodes (9): build, build, initState, build, build, PeriodDurationPage, build, SymptomsPage (+1 more)

### Community 48 - "Report Problem Page Module"
Cohesion: 0.14
Nodes (11): _appVersion, _attachedFileNames, build, _buildTextField, createState, _deviceModel, initState, _loadDeviceInfo (+3 more)

### Community 49 - "Authentication & User Session"
Cohesion: 0.17
Nodes (5): Fake, FakePathProviderPlatform, getApplicationDocumentsPath, main, tempDir

### Community 50 - "Cycle Comparison & Patterns"
Cohesion: 0.15
Nodes (12): CompareCyclesPage, LifestyleInsightsPage, PainInsightsPage, SymptomsPatternsPage, LastPeriodPage, _LastPeriodPageState, NamePage, _NamePageState (+4 more)

### Community 51 - "Quick Actions Grid Module"
Cohesion: 0.15
Nodes (9): icon, label, onTap, _QuickAction, build, icon, prediction, symptom (+1 more)

### Community 52 - "AI Insight Engine"
Cohesion: 0.15
Nodes (11): category, createdAt, cyclePhase, generatedDate, headline, id, insightText, isDeleted (+3 more)

### Community 53 - "Custom Reminders Management"
Cohesion: 0.15
Nodes (11): createdAt, daysBefore, id, isDeleted, isEnabled, isSynced, primaryKey, timeOfDay (+3 more)

### Community 54 - "Authentication & User Session"
Cohesion: 0.18
Nodes (8): createState, dispose, _emailController, SignUpPage, _SignUpPageState, createState, dispose, _nameController

### Community 55 - "AI Insight Engine"
Cohesion: 0.17
Nodes (4): db, insightsRepositoryProvider, symptomsForLogStreamProvider, watch

### Community 56 - "Theme Tokens & Styling"
Cohesion: 0.17
Nodes (10): AppColors, background, border, lightPink, lightPurple, primaryPink, primaryPurple, secondaryText (+2 more)

### Community 57 - "Home Dashboard & Cycle State"
Cohesion: 0.17
Nodes (5): build, HomePage, homeProvider, QuickActionsGrid, build

### Community 58 - "AI Insight Engine"
Cohesion: 0.17
Nodes (11): _buildAverageRow, _buildCorrelationRow, color, _CorrelationItem, createState, icon, _isLogForCycle, _parseWaterLiters (+3 more)

### Community 59 - "In App Lock Runtime Provider Module"
Cohesion: 0.18
Nodes (11): copyWith, InAppLockRuntimeNotifier, InAppLockRuntimeState, isAppHidden, isLocked, lastPausedAt, lock, onAppPaused (+3 more)

### Community 60 - "Daily Symptoms Table Module"
Cohesion: 0.18
Nodes (8): createdAt, dailyLogId, id, isDeleted, isSynced, primaryKey, severity, symptomName

### Community 61 - "Last Period Page Module"
Cohesion: 0.18
Nodes (7): createState, _selectedDate, build, createState, initState, _pickDate, _selectedDate

### Community 62 - "Daily Check-in & Symptoms Logging"
Cohesion: 0.24
Nodes (6): build, build, build, build, _buildFlowStep, _getReminderItem

### Community 63 - "Period Logging Provider Module"
Cohesion: 0.20
Nodes (10): clear, copyWith, flowLevel, painLevel, PeriodLoggingNotifier, PeriodLoggingState, setFlowLevel, setPainLevel (+2 more)

### Community 64 - "Contact Support Page Module"
Cohesion: 0.20
Nodes (9): _attachedFileNames, build, categories, ContactSupportPage, _ContactSupportPageState, createState, _pickFile, selectedCategory (+1 more)

### Community 65 - "Drift Database & Tables Schema"
Cohesion: 0.20
Nodes (7): AppDatabase, _db, getInsightsForCategory, getLatestInsight, InsightsRepository, saveInsight, watchInsightsForCategory

### Community 66 - "AI Insight Engine"
Cohesion: 0.20
Nodes (8): _buildLegendItem, _buildPhasePainRow, _buildSmallStatBox, createState, _getPainCategoryColor, _getPainCategoryText, _isLogForCycle, _selectedCycles

### Community 67 - "AI Insight Engine"
Cohesion: 0.20
Nodes (7): AiInsightService, getBodyTodayInsight, getCompareCyclesInsight, getCyclePatternInsight, getLifestyleCorrelationInsight, getMoodTrendInsight, instance

### Community 68 - "Authentication & User Session"
Cohesion: 0.20
Nodes (8): LoginPage, DoctorReportBanner, HistoryPage, build, ProfilePage, TroubleshootingPage, WhenToSeekHelpPage, WelcomePage

### Community 69 - "Doctor Report Setup Page Module"
Cohesion: 0.22
Nodes (8): build, _buildCheckListItem, createState, _cycleOptions, DoctorReportSetupPage, _DoctorReportSetupPageState, initState, _selectedRange

### Community 70 - "App Shell Module"
Cohesion: 0.20
Nodes (7): AppShell, child, icon, isSelected, label, _NavItem, onTap

### Community 71 - "Cycle Status Card Module"
Cohesion: 0.20
Nodes (9): build, cycleDay, CycleStatusCard, daysUntilPeriod, fertileWindowRange, isPeriodLate, isPeriodOngoing, periodDateRange (+1 more)

### Community 72 - "Mood Trends Page Module"
Cohesion: 0.20
Nodes (9): _buildLegendRow, _buildTimelineMoodRow, createState, _getMoodDisplay, _getPredominantMood, _isLogForCycle, MoodTrendsPage, _normalizeMood (+1 more)

### Community 73 - "Privacy & App Lock Security"
Cohesion: 0.27
Nodes (8): PeriodStartPage, _PeriodStartPageState, ReportProblemPage, _ReportProblemPageState, SuggestFeaturePage, _SuggestFeaturePageState, PatternLockWidget, PatternLockWidgetState

### Community 74 - "App Settings Page Module"
Cohesion: 0.22
Nodes (7): _buildActionTile, _buildDropdownTile, _buildInfoTile, _buildSwitchTile, cycleOptions, goalOptions, periodOptions

### Community 75 - "Calendar & Period Timeline"
Cohesion: 0.22
Nodes (4): symptomRepositoryProvider, _getMonthName, _handleCheckinForDay, _handleLogPeriodForDay

### Community 76 - "Bloom App Bar Module"
Cohesion: 0.22
Nodes (6): BloomAppBar, build, onSkip, preferredSize, progress, showSkip

### Community 77 - "Bloom Lifestyle Card Module"
Cohesion: 0.22
Nodes (8): BloomLifestyleCard, bottomWidget, build, icon, onTap, title, trailing, valueText

### Community 78 - "AI Insight Engine"
Cohesion: 0.22
Nodes (9): Bloom Flutter Dependencies & Packages, Bloom Menstrual Tracker Architecture, Bloom Design System & AppColors, Insights & Cycle Comparison Suite, Schema AI Insights Entity, Schema Cycles Entity, Schema DailyLogs Entity, Unified Drift & PostgreSQL Sync Engine (+1 more)

### Community 79 - "AI Insight Engine"
Cohesion: 0.25
Nodes (6): build, icon, iconColor, InsightsGridButton, label, onTap

### Community 80 - "Symptom Repository Module"
Cohesion: 0.25
Nodes (7): _db, getAllSymptoms, getSymptomsForLog, setSymptomsForLog, SymptomRepository, watchAllSymptoms, watchSymptomsForLog

### Community 81 - "AI Insight Engine"
Cohesion: 0.29
Nodes (6): InsightsNotifier, insightsProvider, InsightTab, setTab, OnboardingNotifier, OnboardingState

### Community 82 - "AI Insight Engine"
Cohesion: 0.25
Nodes (5): build, _buildToggle, currentTab, InsightToggleBar, onTabChanged

### Community 83 - "Bloom Button Module"
Cohesion: 0.25
Nodes (7): backgroundColor, BloomButton, build, isPrimary, onPressed, text, width

### Community 84 - "Bloom Slider Module"
Cohesion: 0.25
Nodes (7): BloomSlider, build, divisions, max, min, onChanged, value

### Community 86 - "User Repository Module"
Cohesion: 0.29
Nodes (5): _db, getUserProfile, saveUserProfile, UserRepository, watchUserProfile

### Community 88 - "AI Insight Engine"
Cohesion: 0.29
Nodes (6): AiInsights, Cycles, DailyLogs, DailySymptoms, Reminders, UserProfiles

### Community 89 - "Give Feedback Page Module"
Cohesion: 0.33
Nodes (6): build, createState, GiveFeedbackPage, _GiveFeedbackPageState, _rating, _submit

### Community 91 - "Bloom Checkbox Tile Module"
Cohesion: 0.29
Nodes (6): BloomCheckboxTile, build, icon, isSelected, onTap, text

### Community 92 - "Bloom Flow Option Module"
Cohesion: 0.29
Nodes (6): BloomFlowOption, build, dropOpacity, isSelected, label, onTap

### Community 93 - "Bloom Grid Item Module"
Cohesion: 0.29
Nodes (6): BloomGridItem, build, icon, isSelected, label, onTap

### Community 94 - "Bloom Option Card Module"
Cohesion: 0.29
Nodes (5): BloomOptionCard, build, isSelected, onTap, text

### Community 95 - "AI Insight Engine"
Cohesion: 0.29
Nodes (4): createCompletedCycle, createTestLog, createTestProfile, main

### Community 97 - "AI Insight Engine"
Cohesion: 0.33
Nodes (3): createCompletedCycle, createTestUser, main

### Community 98 - "AI Insight Engine"
Cohesion: 0.33
Nodes (3): createCompletedCycle, createTestUser, main

### Community 99 - "Cycle Comparison & Patterns"
Cohesion: 0.33
Nodes (4): createTestCycle, createTestLog, createTestSymptom, main

### Community 100 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 101 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestProfile, main

### Community 102 - "AI Insight Engine"
Cohesion: 0.33
Nodes (4): createCompletedCycle, createTestLog, createTestSymptom, main

### Community 105 - "Cycle Length Chart Module"
Cohesion: 0.40
Nodes (3): build, _buildBarGroup, CycleLengthChart

### Community 106 - "Faq Page Module"
Cohesion: 0.40
Nodes (4): build, _buildCategory, _buildFaqItem, FaqPage

### Community 107 - "Suggest Feature Page Module"
Cohesion: 0.40
Nodes (4): build, _buildTextField, createState, _submit

### Community 109 - "Notification & Reminder Scheduling"
Cohesion: 0.50
Nodes (3): resetNotifiedCyclesCache, resetShownTodayCache, setPluginForTesting

## Knowledge Gaps
- **882 isolated node(s):** `schemaVersion`, `_openConnection`, `db`, `insightsRepositoryProvider`, `symptomsForLogStreamProvider` (+877 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1081 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDatabase` connect `Drift Database & Tables Schema` to `Drift Database & Tables Schema`, `Home Dashboard & Cycle State`, `Daily Log Repository Module`, `Symptom Repository Module`, `User Repository Module`, `AI Insight Engine`, `Custom Reminders Management`, `Cycle Repository Module`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `schemaVersion`, `_openConnection`, `db` to the rest of the system?**
  _882 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Drift Database & Tables Schema` be split into smaller, more focused modules?**
  _Cohesion score 0.026975563313233895 - nodes in this community are weakly interconnected._
- **Why does `build` connect `Privacy & App Lock Security` to `Privacy & App Lock Security`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Should `AI Insight Engine` be split into smaller, more focused modules?**
  _Cohesion score 0.03508771929824561 - nodes in this community are weakly interconnected._
- **Should `Notification & Reminder Scheduling` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._
- **Should `Home Dashboard & Cycle State` be split into smaller, more focused modules?**
  _Cohesion score 0.05263157894736842 - nodes in this community are weakly interconnected._