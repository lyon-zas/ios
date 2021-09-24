import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

class NotificationsBloc {
  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final BehaviorSubject<ReceivedNotification>
      _didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String> _selectNotificationSubject =
      BehaviorSubject<String>();

  BehaviorSubject<String> get selectNotificationSubject =>
      _selectNotificationSubject;

  BehaviorSubject<ReceivedNotification>
      get didReceiveLocalNotificationSubject =>
          _didReceiveLocalNotificationSubject;

  dispose() {
    _selectNotificationSubject.close();
    _didReceiveLocalNotificationSubject.close();
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleDailyTenAMNotification(
      String title, String body, int hour24, int min) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        _nextInstanceOfTenAM(hour24, min),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily-01',
              'myTritek_daily_channel', 'My Tritek Local Notifications'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour24, int min) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour24, min);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void displayNotification(String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'myTritek',
            'mytritek.co.uk/local_notifications',
            'MyTritek App Local Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final notificationsBloc = NotificationsBloc();

const MethodChannel platform =
    MethodChannel('mytritek.co.uk/local_notifications');
