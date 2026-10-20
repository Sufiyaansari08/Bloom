import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/features/doctor_report/presentation/pages/doctor_report_setup_page.dart';
import 'package:bloom/features/doctor_report/presentation/pages/doctor_report_result_page.dart';
import 'package:bloom/features/doctor_report/services/doctor_report_service.dart';
import 'package:bloom/features/doctor_report/services/pdf_generator_service.dart';

void main() {
  UserProfile createTestUser({
    String name = 'Test User',
    DateTime? dob,
    bool includeDob = true,
    double? height = 168.0,
    double? weight = 58.0,
    String? bloodGroup = 'B+',
    int avgCycle = 28,
    int avgPeriod = 5,
  }) {
    return UserProfile(
      id: 'test_user_id',
      name: name,
      email: 'test@example.com',
      dateOfBirth: includeDob ? (dob ?? DateTime(2000, 5, 15)) : null,
      heightCm: height,
      weightKg: weight,
      bloodGroup: bloodGroup,
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

  group('DoctorReportService Unit Tests', () {
    test('computes accurate metrics from completed cycles and daily logs', () {
      final user = createTestUser(
        name: 'Zoya Patel',
        height: 162.0,
        weight: 55.0,
        bloodGroup: 'A+',
      );

      final cycle1 = createTestCycle(
        id: 'c1',
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 28),
        length: 28,
        period: 5,
      );
      final cycle2 = createTestCycle(
        id: 'c2',
        start: DateTime(2026, 1, 29),
        end: DateTime(2026, 2, 28),
        length: 31,
        period: 5,
      );
      final cycle3 = createTestCycle(
        id: 'c3',
        start: DateTime(2026, 3, 1),
        end: DateTime(2026, 3, 29),
        length: 29,
        period: 4,
      );

      final logs = [
        createTestLog(
          id: 'l1',
          cycleId: 'c1',
          date: DateTime(2026, 1, 2),
          painLevel: 6,
          sleepHours: 7.0,
          waterIntake: '2.0 L',
          stressLevel: 4,
          mood: 'Not great',
        ),
        createTestLog(
          id: 'l2',
          cycleId: 'c2',
          date: DateTime(2026, 1, 30),
          painLevel: 4,
          sleepHours: 6.5,
          waterIntake: '1.5 L',
          stressLevel: 3,
          mood: 'Good',
        ),
      ];

      final symptoms = [
        DailySymptom(
          id: 's1',
          dailyLogId: 'l1',
          symptomName: 'Cramps',
          severity: 2,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: false,
          isDeleted: false,
        ),
      ];

      final report = DoctorReportService.computeReportData(
        user: user,
        allCycles: [cycle1, cycle2, cycle3],
        allLogs: logs,
        allSymptoms: symptoms,
        requestedCycleCount: 3,
      );

      expect(report.userName, 'Zoya Patel');
      expect(report.userHeight, '162 cm');
      expect(report.userWeight, '55 kg');
      expect(report.userBloodGroup, 'A+');
      expect(report.cycleCount, 3);
      // Avg: (28 + 31 + 29) / 3 = 29.33 -> 29
      expect(report.avgCycleLength, 29);
      expect(report.shortestCycle, 28);
      expect(report.longestCycle, 31);
      expect(report.cycleRange, '28-31');
      // Period avg: (5 + 5 + 4) / 3 = 4.67 -> 5
      expect(report.avgPeriodLength, 5);
      expect(report.shortestPeriod, 4);
      expect(report.longestPeriod, 5);
      // Pain avg: (6 + 4) / 2 = 5 -> Moderate pain
      expect(report.avgPainLevel, 5.0);
      expect(report.painLabel, 'Moderate pain');
      // Sleep avg: (7.0 + 6.5) / 2 = 6.75 -> 6.8 hrs
      expect(report.sleepFormatted, '6.8 hrs');
      // Symptoms
      expect(report.symptomPatterns.length, 1);
      expect(report.symptomPatterns.first.name, 'Cramps');
      // Moods
      expect(report.moodTrends.any((m) => m.mood == 'Not Great'), isTrue);
    });

    test('gracefully handles empty cycles and baseline profile', () {
      final user = createTestUser(
        name: 'Guest',
        avgCycle: 30,
        avgPeriod: 6,
      );

      final report = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      expect(report.userName, 'Guest');
      expect(report.avgCycleLength, 30);
      expect(report.avgPeriodLength, 6);
      expect(report.shortestCycle, 30);
      expect(report.longestCycle, 30);
      expect(report.cycleRange, '30');
      expect(report.painLabel, 'No pain logged');
      expect(report.sleepFormatted, 'No data');
      expect(report.waterFormatted, 'No data');
      expect(report.symptomPatterns.isEmpty, isTrue);
      expect(report.moodTrends.isEmpty, isTrue);
    });

    test('maps "Don\'t know", empty or null blood group to "-"', () {
      final userDontKnow = createTestUser(
        name: 'Sara',
        bloodGroup: "Don't know",
      );
      final report1 = DoctorReportService.computeReportData(
        user: userDontKnow,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );
      expect(report1.userBloodGroup, '-');

      final userEmpty = createTestUser(
        name: 'Sara',
        bloodGroup: '',
      );
      final report2 = DoctorReportService.computeReportData(
        user: userEmpty,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );
      expect(report2.userBloodGroup, '-');

      // Test with null DOB, height, weight
      final userWithoutDetails = createTestUser(
        name: 'Priya',
        includeDob: false,
        height: null,
        weight: null,
        bloodGroup: null,
      );
      final report3 = DoctorReportService.computeReportData(
        user: userWithoutDetails,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );
      expect(report3.userBloodGroup, '-');
      expect(report3.userHeight, '-');
      expect(report3.userWeight, '-');
      expect(report3.userDob, '-');
      expect(report3.userAge, '-');
    });

    test('generates PDF bytes successfully with real DoctorReportData', () async {
      final user = createTestUser(name: 'Ananya', bloodGroup: "Don't know");
      final report = DoctorReportService.computeReportData(
        user: user,
        allCycles: [],
        allLogs: [],
        allSymptoms: [],
      );

      final pdfBytes = await PdfGeneratorService.generateDoctorReport(report);
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(1000));
    });
  });

  group('Doctor Report Widgets Test', () {
    testWidgets('DoctorReportResultPage displays real user information from database', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final user = createTestUser(
        name: 'Priya Sharma',
        height: 165.0,
        weight: 60.0,
        bloodGroup: 'O+',
      );

      final cycle = createTestCycle(
        id: 'c1',
        start: DateTime(2026, 5, 1),
        end: DateTime(2026, 5, 29),
        length: 29,
        period: 5,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(user)),
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([cycle])),
            allDailyLogsStreamProvider.overrideWith((ref) => Stream.value([])),
            allSymptomsStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: const MaterialApp(
            home: DoctorReportResultPage(cycleCount: 1),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Priya Sharma'), findsOneWidget);
      expect(find.text('165 cm'), findsOneWidget);
      expect(find.text('60 kg'), findsOneWidget);
      expect(find.text('O+'), findsOneWidget);
      expect(find.text('Doctor Report'), findsWidgets);
      expect(find.text('Patient Information'), findsOneWidget);
      expect(find.text('Report Overview'), findsOneWidget);
      expect(find.text('Cycle Summary'), findsOneWidget);
      expect(find.text('Period Details'), findsOneWidget);
      expect(find.text('Lifestyle Insights'), findsOneWidget);
    });

    testWidgets('DoctorReportSetupPage loads and renders correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final cycle = createTestCycle(
        id: 'c1',
        start: DateTime(2026, 5, 1),
        end: DateTime(2026, 5, 29),
        length: 29,
        period: 5,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allCyclesStreamProvider.overrideWith((ref) => Stream.value([cycle])),
          ],
          child: const MaterialApp(
            home: DoctorReportSetupPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Doctor Report'), findsOneWidget);
      expect(find.text('Select time range'), findsOneWidget);
      expect(find.text('Generate Report'), findsOneWidget);
      expect(find.text('Report includes'), findsOneWidget);
    });
  });
}
