import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class NotificationController {
  final FlutterLocalNotificationsPlugin _instance;

  NotificationController() : _instance = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('app_icon'));
    await _instance.initialize(initializationSettings);
  }

  Future<bool> canNotifiy() async {
    return await _instance
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        true;
  }

  Future<bool> requestPermission() async {
    return await _instance
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestPermission() ??
        true;
  }

  Future<void> notifyNewGrade(List<String> notificationBody) async {
    return _instance.show(
      10000,
      'Nouvelle(s) note(s) disponibles !',
      notificationBody.join(' \n- '),
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'grade_channel',
        'Grade',
        channelDescription: 'Notification channel for Grades',
        enableLights: true,
        ledColor: Colors.white,
        color: Colors.red,
        importance: Importance.high,
      )),
    );
  }

  Future<void> cancelSchedule(int id) async {
    return _instance.cancel(id);
  }

  Future<void> cancelAllSchedule() async {
    return _instance.cancelAll();
  }

  Future<void> cancelAllScheduleFromChannel(String channelId) async {
    final activeNotifs = await _instance.getActiveNotifications();
    await Future.wait(activeNotifs
        .where((notif) => notif.channelId == channelId)
        .map((notif) => _instance.cancel(notif.id)));
  }

  Future<void> schedule(
    int id,
    String? title,
    String? body,
    TZDateTime scheduledDate,
    NotificationDetails notificationDetails,
  ) async {
    _instance.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
