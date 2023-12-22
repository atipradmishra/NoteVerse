import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsServices {
  final FlutterLocalNotificationsPlugin _flutterlocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings(
    'note'
  );
  void initialiseNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
        android: _androidInitializationSettings
    );
    await _flutterlocalNotificationsPlugin.initialize(initializationSettings);
  }
  void scheduleNotifications(List<DateTime> scheduledDates, String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    for (DateTime scheduledDateTime in scheduledDates) {
      // Calculate the time difference between the scheduled date/time and the current time
      final timeDifference = scheduledDateTime.difference(DateTime.now());

      // Check if the scheduled date/time is in the future
      if (timeDifference > Duration(seconds: 0)) {
        // Convert the DateTime to TZDateTime
        tz.TZDateTime scheduledTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

        // Schedule the notification with the calculated delay
        await _flutterlocalNotificationsPlugin.zonedSchedule(
          scheduledDates.indexOf(scheduledDateTime), // Notification ID (use a unique ID)
          title, // Title of the notification
          body, // Body of the notification
          scheduledTime,
          notificationDetails,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }
}