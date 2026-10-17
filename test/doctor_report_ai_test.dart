import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/features/profile/presentation/providers/privacy_security_provider.dart';
import 'package:bloom/features/doctor_report/services/doctor_report_service.dart';
import 'package:bloom/features/doctor_report/services/doctor_report_ai_service.dart';
import 'package:bloom/features/doctor_report/presentation/widgets/doctor_report_ai_observation_card.dart';
import 'package:bloom/features/doctor_report/services/pdf_generator_service.dart';

void main() {
  setUp(() {
    DoctorReportAiService.backendUrl = null;
    DoctorReportAiService.authToken = null;
    DoctorReportAiService.mockDelay = Duration.zero;
  });

  UserProfile createTestUser({
    String name = 'Zoya Patel',
    int avgCycle = 29,
    int avgPeriod = 5,
  }) {
    return UserProfile(
      id: 'test_user_id',
      name: name,
      email: 'zoya@example.com',
      dateOfBirth: DateTime(2000, 5, 15),
      heightCm: 165.0,
      weightKg: 58.0,
      bloodGroup: 'B+',
      avgCycleLength: avgCycle,
      avgPeriodLength: avgPeriod,
      periodPredictionEnabled: true,
      ovulationPredictionEnabled: true,
      fertileWindowEnabled: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  Cycle createTestCycle({
    required String id,
    required DateTime start,
    required DateTime end,
    required int length,
    required int period,
  }) {
    return Cycle(
      id: id,
      userId: 'test_user_id',
      startDate: start,
      endDate: end,
      cycleLength: length,
      periodLength: period,
      isPredicted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  DailyLog createTestLog({
    required String id,
    required String cycleId,
    required DateTime date,
    double? sleepHours,
    String? waterIntake,
    String? activityLevel,
    int? stressLevel,
    int? painLevel,
    String? mood,
  }) {
    return DailyLog(
      id: id,
      userId: 'test_user_id',
      cycleId: cycleId,
      date: date,
      sleepHours: sleepHours,
      waterIntake: waterIntake,
      activityLevel: activityLevel,
      stressLevel: stressLevel,
      painLevel: painLevel,
      mood: mood,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  group('DoctorReportAiService Unit Tests', () {
    test('buildPayload constructs structured JSON conforming to backend contract', () {
      final user = createTestUser();
      final cycle = createTestCycle(
        id: 'c1',
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 30),
        length: 29,
        period: 5,
      );
      final log = createTestLog(
        id: 'l1',
        cycleId: 'c1',
        date: DateTime(2026, 1, 2),
        painLevel: 4,
        sleepHours: 7.5,
        waterIntake: '2.0 L',
        stressLevel: 3,
        mood: 'Calm',
      );
      final symptom = DailySymptom(
        id: 's1',
        dailyLogId: 'l1',
        symptomName: 'Bloating',
        severity: 2,
        createdAt: DateTime.now(),
        isSynced: false,
        isDeleted: false,
      );

      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [cycle],
        allLogs: [log],
        allSymptoms: [symptom],
        requestedCycleCount: 1,
      );

      final payload = DoctorReportAiService.buildPayload(reportData);

      expect(payload['patient']['age'], isNotEmpty);
      expect(payload['patient']['bloodGroup'], 'B+');
      expect(payload['cycleMetrics']['cycleCount'], 1);
      expect(payload['cycleMetrics']['avgCycleLength'], 29);
      expect(payload['periodMetrics']['avgPeriodLength'], 5);
      expect(payload['symptomsAndPain']['painLabel'], isNotEmpty);
      expect(payload['symptomsAndPain']['topSymptoms'], isNotEmpty);
      expect(payload['lifestyle']['sleep'], '7.5 hrs');
      expect(payload['lifestyle']['water'], '2.0 L');
    });

    test('generateClinicalSummary generates rich clinical narrative in mock mode', () async {
      final user = createTestUser();
      final cycle = createTestCycle(
        id: 'c1',
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 30),
        length: 29,
        period: 5,
      );
      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [cycle],
        allLogs: [],
        allSymptoms: [],
      );

      final summary = await DoctorReportAiService.generateClinicalSummary(reportData);

      expect(summary, isNotEmpty);
      expect(summary.contains('cycle length of 29 days'), isTrue);
    });

    test('DoctorReportAiNotifier updates state to success with AI summary when enabled', () async {
      final user = createTestUser();
      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final subscription = container.listen(
        doctorReportAiProvider(reportData),
        (previous, next) {},
        fireImmediately: true,
      );

      await Future.delayed(Duration.zero);

      final state = subscription.read();
      expect(state.status, AiSummaryStatus.success);
      expect(state.isAiGenerated, isTrue);
      expect(state.summary, isNotEmpty);
    });

    test('DoctorReportAiNotifier only returns base summary when isAiDataUsageEnabled is false', () async {
      final user = createTestUser();
      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      final container = ProviderContainer(
        overrides: [
          privacySecurityProvider.overrideWith(
            (ref) => PrivacySecurityNotifier()
              ..toggleAiDataUsage(false),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        doctorReportAiProvider(reportData),
        (previous, next) {},
        fireImmediately: true,
      );

      await Future.delayed(Duration.zero);

      final state = subscription.read();
      expect(state.isAiGenerated, isFalse);
      expect(state.summary, reportData.observationsSummary);
    });

    test('PdfGeneratorService embeds AI summary into generated PDF bytes', () async {
      final user = createTestUser();
      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      const aiSummary = 'This is an AI generated clinical observation summary for testing.';
      final reportWithAi = reportData.copyWith(observationsSummary: aiSummary);

      final bytes = await PdfGeneratorService.generateDoctorReport(reportWithAi);
      expect(bytes, isNotNull);
      expect(bytes.length, greaterThan(1000));
    });
  });

  group('DoctorReportAiObservationCard Widget Tests', () {
    testWidgets('renders observation summary and refresh button when enabled', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final user = createTestUser();
      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DoctorReportAiObservationCard(reportData: reportData),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your body summary'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      expect(find.textContaining('AI synthesis ready for doctor review'), findsOneWidget);
    });

    testWidgets('renders only base summary and hides refresh when disabled in privacy', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final user = createTestUser();
      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            privacySecurityProvider.overrideWith(
              (ref) => PrivacySecurityNotifier()
                ..toggleAiDataUsage(false),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: DoctorReportAiObservationCard(reportData: reportData),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your body summary'), findsOneWidget);
      // Refresh button should NOT be shown
      expect(find.byIcon(Icons.refresh_rounded), findsNothing);
      // Should show base summary text
      expect(find.text(reportData.observationsSummary), findsOneWidget);
      // Should show privacy notice in footer
      expect(
        find.textContaining('AI data usage disabled in Privacy & Security'),
        findsOneWidget,
      );
    });

    testWidgets('tapping refresh button triggers regeneration when AI enabled', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final user = createTestUser();
      final reportData = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DoctorReportAiObservationCard(reportData: reportData),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final refreshBtn = find.byIcon(Icons.refresh_rounded);
      expect(refreshBtn, findsOneWidget);
      await tester.tap(refreshBtn);
      await tester.pumpAndSettle();

      expect(find.text('Your body summary'), findsOneWidget);
    });
  });
}
