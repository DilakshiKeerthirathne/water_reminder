import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  static Future<void> showInstant({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'water_channel',
        'Water Reminder',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
    );

    await _plugin.show(0, title, body, details);
  }

  static Future<void> schedule({
    required int id,
    required DateTime time,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'water_channel',
      'Water Reminder',
      channelDescription: 'Reminds user to drink water',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),

      details,

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
