import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:bloom/core/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class FakeFlutterLocalNotificationsPlatform
    extends FlutterLocalNotificationsPlatform
    with MockPlatformInterfaceMixin {
  final List<Map<String, dynamic>> scheduled = [];
  final List<Map<String, dynamic>> instant = [];
  final List<int> cancelled = [];

  @override
  Future<void> show({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    instant.add({'id': id, 'title': title, 'body': body, 'payload': payload});
  }

  @override
  Future<void> zonedSchedule({
    required int id,
    String? title,
    String? body,
    required tz.TZDateTime scheduledDate,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    scheduled.add({
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate,
      'payload': payload,
    });
  }

  @override
  Future<void> cancel({required int id}) async {
    cancelled.add(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelled.clear();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.local);

  late FakeFlutterLocalNotificationsPlatform fakePlatform;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    fakePlatform = FakeFlutterLocalNotificationsPlatform();
    FlutterLocalNotificationsPlatform.instance = fakePlatform;
    NotificationService.resetShownTodayCache();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('NotificationService Milestone Alerts and IDs', () {
    test('All required notification IDs are defined and unique', () {
      final ids = [
        NotificationService.idDailyCheckIn,
        NotificationService.idPeriodAlert,
        NotificationService.idFertileAlert,
        NotificationService.idOvulationAlert,
        NotificationService.idCycleSummary,
        NotificationService.idPeriodTodayAlert,
        NotificationService.idFertileTodayAlert,
        NotificationService.idOvulationEveAlert,
      ];

      expect(
        ids.toSet().length,
        ids.length,
        reason: 'Every notification ID must be unique',
      );
      expect(NotificationService.idDailyCheckIn, 101);
      expect(NotificationService.idPeriodAlert, 102);
      expect(NotificationService.idFertileAlert, 103);
      expect(NotificationService.idOvulationAlert, 104);
      expect(NotificationService.idCycleSummary, 105);
      expect(NotificationService.idPeriodTodayAlert, 106);
      expect(NotificationService.idFertileTodayAlert, 107);
      expect(NotificationService.idOvulationEveAlert, 108);
    });

    test(
      'schedulePeriodAlert schedules advance and day-of alerts with correct texts',
      () async {
        final now = DateTime.now();
        final futurePeriod = now.add(const Duration(days: 5));

        final success = await NotificationService.instance.schedulePeriodAlert(
          periodDate: futurePeriod,
          daysBefore: 2,
          isEnabled: true,
          isDiscrete: false,
        );

        expect(success, isTrue);
        final periodAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 102,
        );
        expect(periodAlert['title'], 'Expected Period Alert');
        expect(periodAlert['body'], 'Period expected in 2 days.');

        final todayAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 106,
        );
        expect(todayAlert['title'], 'Expected Period Alert');
        expect(todayAlert['body'], 'Period expected today.');
      },
    );

    test(
      'schedulePeriodAlert handles 1 day before text and discrete mode',
      () async {
        final now = DateTime.now();
        final futurePeriod = now.add(const Duration(days: 4));

        // Discrete mode with 1 day before
        final success = await NotificationService.instance.schedulePeriodAlert(
          periodDate: futurePeriod,
          daysBefore: 1,
          isEnabled: true,
          isDiscrete: true,
        );

        expect(success, isTrue);
        final periodAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 102,
        );
        expect(periodAlert['title'], 'Cycle Reminder 🌸');
        expect(
          periodAlert['body'],
          'You have an upcoming cycle milestone tomorrow.',
        );

        final todayAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 106,
        );
        expect(todayAlert['title'], 'Cycle Reminder 🌸');
        expect(
          todayAlert['body'],
          'You have an expected cycle milestone today. Tap to view.',
        );
      },
    );

    test(
      'scheduleFertileAlert handles eve and start day in standard and discrete modes',
      () async {
        final now = DateTime.now();
        final futureFertile = now.add(const Duration(days: 4));

        // Standard mode
        await NotificationService.instance.scheduleFertileAlert(
          fertileStart: futureFertile,
          isEnabled: true,
          isDiscrete: false,
        );

        final eveAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 103,
        );
        expect(eveAlert['title'], 'Fertile Window Alert');
        expect(
          eveAlert['body'],
          'Fertile window is expected to start tomorrow.',
        );

        final startAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 107,
        );
        expect(startAlert['title'], 'Fertile Window Alert');
        expect(
          startAlert['body'],
          'Fertile window is expected to start today.',
        );

        // Discrete mode
        fakePlatform.scheduled.clear();
        await NotificationService.instance.scheduleFertileAlert(
          fertileStart: futureFertile,
          isEnabled: true,
          isDiscrete: true,
        );

        final discreteEve = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 103,
        );
        expect(discreteEve['title'], 'Wellness Update ✨');
        expect(
          discreteEve['body'],
          'A new cycle phase begins tomorrow. Tap to view in Bloom.',
        );

        final discreteStart = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 107,
        );
        expect(discreteStart['title'], 'Cycle Update 🌸');
        expect(
          discreteStart['body'],
          'An important cycle phase begins today.',
        );
      },
    );

    test(
      'scheduleOvulationAlert handles eve and day-of in standard and discrete modes',
      () async {
        final now = DateTime.now();
        final futureOvulation = now.add(const Duration(days: 6));

        // Standard mode
        await NotificationService.instance.scheduleOvulationAlert(
          ovulationDate: futureOvulation,
          isEnabled: true,
          isDiscrete: false,
        );

        final eveAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 108,
        );
        expect(eveAlert['title'], 'Ovulation Alert');
        expect(eveAlert['body'], 'Ovulation expected tomorrow.');

        final dayAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 104,
        );
        expect(dayAlert['title'], 'Ovulation Day Alert');
        expect(dayAlert['body'], 'Ovulation is expected today.');

        // Discrete mode
        fakePlatform.scheduled.clear();
        await NotificationService.instance.scheduleOvulationAlert(
          ovulationDate: futureOvulation,
          isEnabled: true,
          isDiscrete: true,
        );

        final discreteEve = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 108,
        );
        expect(discreteEve['title'], 'Cycle Milestone 🌸');
        expect(
          discreteEve['body'],
          'An important cycle milestone is predicted for tomorrow.',
        );

        final discreteDay = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 104,
        );
        expect(discreteDay['title'], 'Cycle Milestone 🌸');
        expect(
          discreteDay['body'],
          'An important cycle milestone is predicted for today.',
        );
      },
    );

    test(
      'scheduleDailyCheckIn schedules daily routine at custom time in standard and discrete modes',
      () async {
        await NotificationService.instance.scheduleDailyCheckIn(
          hour: 21,
          minute: 0,
          isEnabled: true,
          isDiscrete: false,
        );

        final checkIn = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 101,
        );
        expect(checkIn['title'], 'Daily Check-in Reminder');
        expect(
          checkIn['body'],
          'Remember to log your mood, flow, and symptoms for today.',
        );

        fakePlatform.scheduled.clear();
        await NotificationService.instance.scheduleDailyCheckIn(
          hour: 20,
          minute: 30,
          isEnabled: true,
          isDiscrete: true,
        );

        final discreteCheckIn = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 101,
        );
        expect(discreteCheckIn['title'], 'Daily Check-in 🌿');
        expect(discreteCheckIn['body'], 'Time for your daily Bloom check-in.');
      },
    );

    test(
      'Same-day milestone does not spam instant alerts on app launch',
      () async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // Today is ovulation day
        await NotificationService.instance.scheduleOvulationAlert(
          ovulationDate: today,
          isEnabled: true,
          isDiscrete: false,
        );

        // It should NEVER fire an instant notification to spam user on app open!
        expect(fakePlatform.instant.any((e) => e['id'] == 104), isFalse);

        // If scheduled before 9 AM, it should be scheduled for 9 AM today
        if (now.hour < 9) {
          final hasScheduled = fakePlatform.scheduled.any((e) => e['id'] == 104);
          expect(hasScheduled, isTrue);
        }
      },
    );

    test('Cancellation clears alerts when isEnabled is false', () async {
      await NotificationService.instance.schedulePeriodAlert(
        periodDate: DateTime.now().add(const Duration(days: 3)),
        daysBefore: 1,
        isEnabled: false,
      );
      expect(fakePlatform.cancelled, contains(102));
      expect(fakePlatform.cancelled, contains(106));

      await NotificationService.instance.scheduleFertileAlert(
        fertileStart: DateTime.now().add(const Duration(days: 3)),
        isEnabled: false,
      );
      expect(fakePlatform.cancelled, contains(103));
      expect(fakePlatform.cancelled, contains(107));

      await NotificationService.instance.scheduleOvulationAlert(
        ovulationDate: DateTime.now().add(const Duration(days: 3)),
        isEnabled: false,
      );
      expect(fakePlatform.cancelled, contains(104));
      expect(fakePlatform.cancelled, contains(108));
    });

    test(
      'showCycleSummaryNotification sends instant alert in standard and discrete modes',
      () async {
        // Standard mode
        await NotificationService.instance.showCycleSummaryNotification(
          isDiscrete: false,
        );
        final alert = fakePlatform.instant.firstWhere((e) => e['id'] == 105);
        expect(alert['title'], 'Monthly Cycle Summary');
        expect(
          alert['body'],
          'Your cycle summary and insights are ready. Tap to view your cycle trends.',
        );
        expect(alert['payload'], '/insights');

        // Discrete mode
        fakePlatform.instant.clear();
        await NotificationService.instance.showCycleSummaryNotification(
          isDiscrete: true,
        );
        final discreteAlert = fakePlatform.instant.firstWhere(
          (e) => e['id'] == 105,
        );
        expect(discreteAlert['title'], 'Wellness Insights 🌿');
        expect(
          discreteAlert['body'],
          'Your latest wellness summary is ready in Bloom.',
        );
        expect(discreteAlert['payload'], '/insights');
      },
    );

    test(
      'scheduleMonthlyCycleSummary schedules recurring monthly alert',
      () async {
        await NotificationService.instance.scheduleMonthlyCycleSummary(
          hour: 10,
          minute: 0,
          isEnabled: true,
          isDiscrete: false,
        );

        final scheduledAlert = fakePlatform.scheduled.firstWhere(
          (e) => e['id'] == 105,
        );
        expect(scheduledAlert['title'], 'Monthly Cycle Summary');
        expect(scheduledAlert['id'], 105);
      },
    );

    test(
      'Cycle notification cache prevents duplicate alerts for the same cycle',
      () {
        NotificationService.resetNotifiedCyclesCache();
        const cycleId = 'test_cycle_123';

        expect(NotificationService.hasNotifiedCycle(cycleId), isFalse);
        NotificationService.markCycleNotified(cycleId);
        expect(NotificationService.hasNotifiedCycle(cycleId), isTrue);
      },
    );
  });
}
