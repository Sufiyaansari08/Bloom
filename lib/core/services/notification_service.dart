import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  static const String channelId = 'bloom_reminders_v2';
  static const String channelName = 'Bloom Reminders';
  static const String channelDescription =
      'Notifications for period tracking, fertile window, and daily check-ins';

  static const int idDailyCheckIn = 101;
  static const int idPeriodAlert = 102;
  static const int idFertileAlert = 103;
  static const int idOvulationAlert = 104;
  static const int idCycleSummary = 105;
  static const int idPeriodTodayAlert = 106;
  static const int idFertileTodayAlert = 107;
  static const int idOvulationEveAlert = 108;
  static const int idTest = 999;

  void Function(String? payload)? onNotificationTapped;

  Future<String?> getAppLaunchPayload() async {
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        return details.notificationResponse?.payload ?? '/reminders';
      }
    } catch (_) {}
    return null;
  }

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    await loadNotifiedCycleIds();

    try {
      tz_data.initializeTimeZones();
      final offset = DateTime.now().timeZoneOffset;
      tz.Location? matched;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.currentTimeZone.offset == offset) {
          matched = loc;
          break;
        }
      }
      if (matched != null) {
        tz.setLocalLocation(matched);
      } else {
        tz.setLocalLocation(tz.local);
      }
    } catch (e) {
      debugPrint('Error setting up timezone: $e');
    }

    try {
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        macOS: DarwinInitializationSettings(),
        linux: LinuxInitializationSettings(
          defaultActionName: 'Open notification',
        ),
      );

      final initialized = await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
          onNotificationTapped?.call(response.payload);
        },
      );

      // Create high-importance Android channel
      const androidChannel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      _isInitialized = initialized ?? true;
      debugPrint('NotificationService initialized successfully: $_isInitialized');
      return _isInitialized;
    } catch (e, stack) {
      debugPrint('Warning: NotificationService initialize failed: $e\n$stack');
      _isInitialized = false;
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      if (!_isInitialized) await initialize();

      bool granted = false;

      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final notifGranted =
            await androidPlugin.requestNotificationsPermission() ?? false;
        await androidPlugin.requestExactAlarmsPermission();
        final areEnabled =
            await androidPlugin.areNotificationsEnabled() ?? false;
        granted = notifGranted || areEnabled;
      }

      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final iosGranted = await iosPlugin.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
        granted = granted || iosGranted;
      }

      return granted;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      if (!_isInitialized) await initialize();

      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        return await androidPlugin.areNotificationsEnabled() ?? false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  NotificationDetails _notificationDetails({
    required String title,
    required String body,
  }) {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: 'ic_notification',
      visibility: NotificationVisibility.public,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'Bloom',
        htmlFormatContentTitle: false,
        htmlFormatBigText: false,
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
      windows: const WindowsNotificationDetails(),
      linux: const LinuxNotificationDetails(),
    );
  }

  @visibleForTesting
  void setPluginForTesting(FlutterLocalNotificationsPlugin plugin) {
    _plugin = plugin;
    _isInitialized = true;
  }

  Future<bool> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }

      try {
        await _plugin.show(
          id: id,
          title: title,
          body: body,
          notificationDetails: _notificationDetails(title: title, body: body),
          payload: payload ?? '/reminders',
        );
        return true;
      } catch (innerErr) {
        debugPrint('showInstantNotification first attempt failed ($innerErr), attempting fallback details...');
        final fallbackAndroid = AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: title,
            summaryText: 'Bloom',
          ),
        );
        await _plugin.show(
          id: id,
          title: title,
          body: body,
          notificationDetails: NotificationDetails(
            android: fallbackAndroid,
            iOS: const DarwinNotificationDetails(),
          ),
          payload: payload ?? '/reminders',
        );
        return true;
      }
    } catch (e, stack) {
      debugPrint('Error showing notification: $e\n$stack');
      return false;
    }
  }

  Future<bool> scheduleDailyCheckIn({
    required int hour,
    required int minute,
    required bool isEnabled,
    bool isDiscrete = false,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idDailyCheckIn);

      if (!isEnabled) return true;

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final title = isDiscrete ? 'Daily Check-in 🌿' : 'Daily Check-in Reminder';
      final body = isDiscrete
          ? 'Time for your daily Bloom check-in.'
          : 'Remember to log your mood, flow, and symptoms for today.';
      await _safeZonedSchedule(
        id: idDailyCheckIn,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '/reminders',
      );
      debugPrint('Scheduled daily check-in (isDiscrete: $isDiscrete) at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      return true;
    } catch (e) {
      debugPrint('Error scheduling daily checkin notification: $e');
      return false;
    }
  }

  static final Set<String> _shownTodayKeys = {};

  @visibleForTesting
  static void resetShownTodayCache() {
    _shownTodayKeys.clear();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _showMilestoneIfDueToday({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final now = DateTime.now();
    final key = '${now.year}-${now.month}-${now.day}_$id';
    if (_shownTodayKeys.contains(key)) return;
    _shownTodayKeys.add(key);

    await showInstantNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  Future<void> _scheduleOrShowMilestone({
    required int id,
    required String title,
    required String body,
    required DateTime targetDate,
    String? payload,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(targetDate.year, targetDate.month, targetDate.day);

    if (_isSameDay(targetDay, today)) {
      if (now.hour >= 9) {
        await _showMilestoneIfDueToday(
          id: id,
          title: title,
          body: body,
          payload: payload,
        );
      } else {
        final scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          9,
          0,
        );
        await _safeZonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          payload: payload,
        );
      }
    } else if (targetDay.isAfter(today)) {
      final scheduledDate = tz.TZDateTime(
        tz.local,
        targetDay.year,
        targetDay.month,
        targetDay.day,
        9,
        0,
      );
      await _safeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: payload,
      );
    }
  }

  Future<bool> schedulePeriodAlert({
    required DateTime periodDate,
    required int daysBefore,
    required bool isEnabled,
    bool isDiscrete = false,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idPeriodAlert);
      await _plugin.cancel(id: idPeriodTodayAlert);

      if (!isEnabled) return true;

      // 1. Advance reminder (e.g. 1, 2, or 3 days before)
      if (daysBefore > 0) {
        final advanceDate = periodDate.subtract(Duration(days: daysBefore));
        final advanceTitle =
            isDiscrete ? 'Cycle Reminder 🌸' : 'Expected Period Alert';
        final advanceBody = isDiscrete
            ? (daysBefore == 1
                ? 'You have an upcoming cycle milestone tomorrow.'
                : 'You have an upcoming cycle milestone in $daysBefore days.')
            : (daysBefore == 1
                ? 'Period expected tomorrow.'
                : 'Period expected in $daysBefore days.');

        await _scheduleOrShowMilestone(
          id: idPeriodAlert,
          title: advanceTitle,
          body: advanceBody,
          targetDate: advanceDate,
          payload: '/calendar',
        );
      }

      // 2. Day-of period reminder (on expected period start date)
      final todayTitle =
          isDiscrete ? 'Cycle Reminder 🌸' : 'Expected Period Alert';
      final todayBody = isDiscrete
          ? 'You have an expected cycle milestone today. Tap to view.'
          : 'Period expected today.';

      await _scheduleOrShowMilestone(
        id: idPeriodTodayAlert,
        title: todayTitle,
        body: todayBody,
        targetDate: periodDate,
        payload: '/calendar',
      );

      return true;
    } catch (e) {
      debugPrint('Error scheduling period alert notification: $e');
      return false;
    }
  }

  Future<bool> scheduleFertileAlert({
    required DateTime fertileStart,
    required bool isEnabled,
    bool isDiscrete = false,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idFertileAlert);
      await _plugin.cancel(id: idFertileTodayAlert);

      if (!isEnabled) return true;

      // 1. Eve reminder: 1 day before fertile window starts
      final eveDate = fertileStart.subtract(const Duration(days: 1));
      final eveTitle =
          isDiscrete ? 'Wellness Update ✨' : 'Fertile Window Alert';
      final eveBody = isDiscrete
          ? 'A new cycle phase begins tomorrow. Tap to view in Bloom.'
          : 'Fertile window is expected to start tomorrow.';

      await _scheduleOrShowMilestone(
        id: idFertileAlert,
        title: eveTitle,
        body: eveBody,
        targetDate: eveDate,
        payload: '/calendar',
      );

      // 2. Day-of reminder: on fertile window start day
      final todayTitle =
          isDiscrete ? 'Wellness Update ✨' : 'Fertile Window Alert';
      final todayBody = isDiscrete
          ? 'A new phase update is ready in Bloom. Tap to check your insights.'
          : 'Fertile window is expected to start today.';

      await _scheduleOrShowMilestone(
        id: idFertileTodayAlert,
        title: todayTitle,
        body: todayBody,
        targetDate: fertileStart,
        payload: '/calendar',
      );

      return true;
    } catch (e) {
      debugPrint('Error scheduling fertile alert notification: $e');
      return false;
    }
  }

  Future<bool> scheduleOvulationAlert({
    required DateTime ovulationDate,
    required bool isEnabled,
    bool isDiscrete = false,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idOvulationAlert);
      await _plugin.cancel(id: idOvulationEveAlert);

      if (!isEnabled) return true;

      // 1. Eve reminder: 1 day before ovulation
      final eveDate = ovulationDate.subtract(const Duration(days: 1));
      final eveTitle =
          isDiscrete ? 'Health & Cycle Tip 🌸' : 'Ovulation Alert';
      final eveBody = isDiscrete
          ? 'An important cycle milestone is predicted for tomorrow.'
          : 'Ovulation expected tomorrow.';

      await _scheduleOrShowMilestone(
        id: idOvulationEveAlert,
        title: eveTitle,
        body: eveBody,
        targetDate: eveDate,
        payload: '/calendar',
      );

      // 2. Day-of reminder: on ovulation day
      final todayTitle =
          isDiscrete ? 'Health & Cycle Tip 🌸' : 'Ovulation Day Alert';
      final todayBody = isDiscrete
          ? 'New daily insight ready for you in Bloom.'
          : 'Ovulation is expected today.';

      await _scheduleOrShowMilestone(
        id: idOvulationAlert,
        title: todayTitle,
        body: todayBody,
        targetDate: ovulationDate,
        payload: '/calendar',
      );

      return true;
    } catch (e) {
      debugPrint('Error scheduling ovulation alert notification: $e');
      return false;
    }
  }

  static final Set<String> _notifiedCycleIds = {};
  static bool _prefsLoaded = false;

  static bool hasNotifiedCycle(String cycleId) {
    return _notifiedCycleIds.contains(cycleId);
  }

  static void markCycleNotified(String cycleId) {
    _notifiedCycleIds.add(cycleId);
    _persistNotifiedCycleIds();
  }

  static Future<void> loadNotifiedCycleIds() async {
    if (_prefsLoaded) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/cycle_notif_cache.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> list = jsonDecode(content);
        _notifiedCycleIds.addAll(list.map((e) => e.toString()));
      }
      _prefsLoaded = true;
    } catch (_) {}
  }

  static Future<void> _persistNotifiedCycleIds() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/cycle_notif_cache.json');
      await file.writeAsString(jsonEncode(_notifiedCycleIds.toList()), flush: true);
    } catch (_) {}
  }

  @visibleForTesting
  static void resetNotifiedCyclesCache() {
    _notifiedCycleIds.clear();
    _prefsLoaded = true;
  }

  Future<bool> showCycleSummaryNotification({
    bool isDiscrete = false,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      final title =
          isDiscrete ? 'Wellness Insights 🌿' : 'Monthly Cycle Summary';
      final body = isDiscrete
          ? 'Your latest wellness summary is ready in Bloom.'
          : 'Your cycle summary and insights are ready. Tap to view your cycle trends.';

      return await showInstantNotification(
        id: idCycleSummary,
        title: title,
        body: body,
        payload: '/insights',
      );
    } catch (e) {
      debugPrint('Error showing cycle summary notification: $e');
      return false;
    }
  }

  Future<bool> scheduleMonthlyCycleSummary({
    required int hour,
    required int minute,
    required bool isEnabled,
    bool isDiscrete = false,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idCycleSummary);

      if (!isEnabled) return true;

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        1,
        hour,
        minute,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month + 1,
          1,
          hour,
          minute,
        );
      }

      final title =
          isDiscrete ? 'Wellness Insights 🌿' : 'Monthly Cycle Summary';
      final body = isDiscrete
          ? 'Your latest wellness summary is ready in Bloom.'
          : 'Your cycle summary and insights are ready. Tap to view your cycle trends.';

      await _safeZonedSchedule(
        id: idCycleSummary,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        payload: '/insights',
      );
      return true;
    } catch (e) {
      debugPrint('Error scheduling monthly cycle summary notification: $e');
      return false;
    }
  }

  Future<void> _safeZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    final details = _notificationDetails(title: title, body: body);
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: matchDateTimeComponents,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Exact alarm not permitted ($e), falling back to inexact: $id');
      try {
        await _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: matchDateTimeComponents,
          payload: payload,
        );
      } catch (fallbackErr) {
        debugPrint('Fallback scheduling also failed: $fallbackErr');
      }
    }
  }

  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (_) {}
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }
}
