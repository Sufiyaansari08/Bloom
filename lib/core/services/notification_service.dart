import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  static const String channelId = 'bloom_reminders';
  static const String channelName = 'Bloom Reminders';
  static const String channelDescription =
      'Notifications for period tracking, fertile window, and daily check-ins';

  static const int idDailyCheckIn = 101;
  static const int idPeriodAlert = 102;
  static const int idFertileAlert = 103;
  static const int idOvulationAlert = 104;
  static const int idCycleSummary = 105;
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

    try {
      tz_data.initializeTimeZones();
      final offset = DateTime.now().timeZoneOffset;
      tz.Location? matched;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.zones.any((z) => z.offset == offset)) {
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
      const androidSettings =
          AndroidInitializationSettings('@mipmap/launcher_icon');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const linuxSettings = LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
        linux: linuxSettings,
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
      icon: '@mipmap/launcher_icon',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
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
    );
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

      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _notificationDetails(title: title, body: body),
        payload: payload ?? '/reminders',
      );
      return true;
    } catch (e, stack) {
      debugPrint('Error showing notification: $e\n$stack');
      return false;
    }
  }

  Future<bool> scheduleDailyCheckIn({
    required int hour,
    required int minute,
    required bool isEnabled,
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

      const title = 'Daily Check-in Reminder';
      const body = 'Remember to log your mood, flow, and symptoms for today.';
      await _plugin.zonedSchedule(
        id: idDailyCheckIn,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails(title: title, body: body),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '/reminders',
      );
      debugPrint('Scheduled daily check-in at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      return true;
    } catch (e) {
      debugPrint('Error scheduling daily checkin notification: $e');
      return false;
    }
  }

  Future<bool> schedulePeriodAlert({
    required DateTime periodDate,
    required int daysBefore,
    required bool isEnabled,
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idPeriodAlert);

      if (!isEnabled) return true;

      final targetDate = periodDate.subtract(Duration(days: daysBefore));
      final scheduledDate = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        9,
        0,
      );

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return true;

      const title = 'Expected Period Alert';
      final body = daysBefore == 0
          ? 'You may get your period today.'
          : 'Your period is expected in $daysBefore ${daysBefore == 1 ? "day" : "days"}.';
      await _plugin.zonedSchedule(
        id: idPeriodAlert,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails(title: title, body: body),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '/reminders',
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
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idFertileAlert);

      if (!isEnabled) return true;

      final targetDate = fertileStart.subtract(const Duration(days: 1));
      final scheduledDate = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        9,
        0,
      );

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return true;

      const title = 'Fertile Window Alert';
      const body = 'Your fertile window begins tomorrow.';
      await _plugin.zonedSchedule(
        id: idFertileAlert,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails(title: title, body: body),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '/reminders',
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
  }) async {
    try {
      if (!_isInitialized) {
        final ok = await initialize();
        if (!ok) return false;
      }
      await _plugin.cancel(id: idOvulationAlert);

      if (!isEnabled) return true;

      final scheduledDate = tz.TZDateTime(
        tz.local,
        ovulationDate.year,
        ovulationDate.month,
        ovulationDate.day,
        9,
        0,
      );

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return true;

      const title = 'Ovulation Day Alert';
      const body = 'Today is your predicted ovulation day.';
      await _plugin.zonedSchedule(
        id: idOvulationAlert,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails(title: title, body: body),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '/reminders',
      );
      return true;
    } catch (e) {
      debugPrint('Error scheduling ovulation alert notification: $e');
      return false;
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
