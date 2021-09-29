import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:heig_front/utils/id_generator.dart';

abstract class Notifiable {
  static final idGen = IdGenerator('notification');

  int notificationId = -1;

  Notifiable() {
    notificationId = idGen.nextId();
  }

  void scheduleNotification();

  Future<void> cancelNotification() async {
    await AwesomeNotifications().cancelSchedule(notificationId);
  }
}
