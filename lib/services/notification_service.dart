import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart'; // Import this

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize Timezone Database
    tz.initializeTimeZones();

    // 2. GET THE DEVICE TIMEZONE (Crucial Fix)
    final String timeZoneName =
        (await FlutterTimezone.getLocalTimezone()) as String;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // 3. Initialize Android Settings
    // Ensure 'ic_launcher' exists in android/app/src/main/res/mipmap-*/
    // If you are unsure, use '@mipmap/ic_launcher' which is default.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Notification Clicked");
      },
    );
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      // For Android 12+, exact alarms need specific permission
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      // Create the TZDateTime object
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

      // FAILSAFE: If time is in the past, schedule it 5 seconds later for testing
      if (scheduledDate.isBefore(now)) {
        print("Time was in the past. Scheduling for tomorrow instead.");
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      print("Attempting to schedule alarm for: $scheduledDate");

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'med_channel_id',
            'Medicine Reminders',
            channelDescription: 'Reminders to take medicine',
            importance: Importance.max,
            priority: Priority.high,
            // Ensure this sound resource exists or remove 'playSound: true' if unsure
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
      );

      print("SUCCESS: Alarm Scheduled for ID $id");
    } catch (e) {
      // THIS WILL TELL US THE ERROR
      print("ERROR SCHEDULING NOTIFICATION: $e");
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
