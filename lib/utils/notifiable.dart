import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:heig_front/utils/id_generator.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';

abstract class Notifiable {
  // notification can have an id from 0 to 10'000
  static final _idGen =
      IdGenerator(BOX_NOTIFICATION, max: HEURE_COURS_NOTIFICATION_MAX_ID);

  @HiveField(200)
  late int notificationId;

  Notifiable({int? notificationId}) {
    this.notificationId = notificationId == null || notificationId == -1
        ? _idGen.nextId()
        : notificationId;
  }

  void scheduleNotification();

  Future<void> cancelNotification() async {
    await AwesomeNotifications().cancelSchedule(notificationId);
  }
}
