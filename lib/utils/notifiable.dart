import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:heig_front/utils/id_generator.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';

mixin CanNotify {
  // notification can have an id from 0 to 10'000
  static final _idGen =
      IdGenerator(BOX_NOTIFICATION, max: HEURE_COURS_NOTIFICATION_MAX_ID);

  @HiveField(200)
  late final int notificationId;
  late final NotificationCalendar _calendar;
  late final NotificationContent _content;
  bool isInitialized = false;

  void initCanNotifyMixin(
    NotificationCalendar? calendar,
    NotificationContent content, {
    int? notificationId,
  }) {
    isInitialized = true;
    this.notificationId = notificationId == null || notificationId == -1
        ? _idGen.nextId()
        : notificationId;
  }

  void scheduleNotification() {
    assert(isInitialized);
    assert(!kIsWeb);
    _content.id = notificationId;
    AwesomeNotifications().createNotification(
      schedule: _calendar,
      content: _content,
    );
  }

  Future<void> cancelNotification() async {
    assert(isInitialized);
    await AwesomeNotifications().cancelSchedule(notificationId);
  }
}
