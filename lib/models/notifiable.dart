import 'package:heig_front/utils/id_generator.dart';

abstract class Notifiable {
  static final idGen = IdGenerator('notification');

  int _notificationId = -1;

  Notifiable() {
    _notificationId = idGen.nextId();
  }

  int get notificationId => _notificationId;

  void scheduleNotification(String title, String body, DateTime dateTime);
}
