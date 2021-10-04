import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:heig_front/utils/id_generator.dart';

abstract class Notifiable {
  static final idGen = IdGenerator('notification');

  late int notificationId;

  Notifiable({int? notificationId}) {
    if (notificationId == null || notificationId == -1) {
      this.notificationId = idGen.nextId();
    } else {
      this.notificationId = notificationId;
    }
  }

  void scheduleNotification();

  Future<void> cancelNotification() async {
    await AwesomeNotifications().cancelSchedule(notificationId);
  }
}
