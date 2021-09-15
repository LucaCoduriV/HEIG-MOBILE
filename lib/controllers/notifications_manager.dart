import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationsManager {
  int _notificationsId = 0;
  var box = Hive.box('heig');

  NotificationsManager() {
    _notificationsId = box.get('notification_id', defaultValue: 0);
  }

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'todos_channel',
          channelName: 'Todo',
          channelDescription: 'Notification channel for todos',
          defaultColor: Colors.red,
          ledColor: Colors.white,
        ),
        NotificationChannel(
          channelKey: 'horaires_channel',
          channelName: 'Horaire',
          channelDescription: 'Notification channel for schedules',
          defaultColor: Colors.red,
          ledColor: Colors.white,
        ),
      ],
    );
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<int> registerNotificationHoraire(
      String title, String body, DateTime date) async {
    AwesomeNotifications().createNotification(
        schedule: NotificationCalendar.fromDate(date: date),
        content: NotificationContent(
          id: _notificationsId,
          channelKey: 'horaires_channel',
          title: 'Cours: $title',
          body: body,
        ));
    box.put('notification_id', _notificationsId);

    return _notificationsId;
  }

  Future<void> listenNotification() async {
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      switch (receivedNotification.payload?['page']) {
        case 'todo':
          debugPrint("GO TO TODO");
          break;
        default:
          debugPrint("DEFAULT");
          break;
      }
    });
  }

  Future<int> registerNotificationTodo(
      String title, String body, DateTime date, int id) async {
    AwesomeNotifications().createNotification(
        schedule: DateTime.now().isAfter(date.subtract(Duration(days: 1)))
            ? null
            : NotificationCalendar.fromDate(
                date: date.subtract(Duration(days: 1))),
        content: NotificationContent(
          id: _notificationsId,
          channelKey: 'todos_channel',
          title: 'Tâche: $title',
          body: body,
          payload: {
            "page": "todo",
            "id": "$id",
          },
        ),
        actionButtons: [
          NotificationActionButton(
            label: "Accomplie",
            buttonType: ActionButtonType.Default,
            enabled: true,
            key: 'accomplie',
          ),
        ]);
    box.put('notification_id', _notificationsId);
    return _notificationsId++;
  }
}
