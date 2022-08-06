import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:heig_front/utils/id_generator.dart';

mixin CanNotify {
  static final IdGenerator _idGenerator = IdGenerator('notification');
  late final int _notificationId;
  late final NotificationCalendar? _calendar;
  late final NotificationContent _content;
  bool _isCanNotifyInitialized = false;

  bool get isCanNotifyInitialized => _isCanNotifyInitialized;

  @protected
  void initCanNotifyMixin(
    NotificationCalendar? calendar,
    NotificationContent content,
  ) {
    _isCanNotifyInitialized = true;
    _notificationId = _idGenerator.nextId();
    _calendar = calendar;
    _content = content;
  }

  void scheduleNotification() {
    assert(_isCanNotifyInitialized);
    assert(!kIsWeb);
    log('Cours enregistré: ${_content.title} à ${_calendar!.hour}:${_calendar!.minute} le ${_calendar!.day}/${_calendar!.month}/${_calendar!.year}');
    AwesomeNotifications().createNotification(
      schedule: _calendar,
      content: _content,
    );
  }

  Future<void> cancelNotification() async {
    assert(_isCanNotifyInitialized);
    assert(!kIsWeb);
    await AwesomeNotifications().cancelSchedule(_notificationId);
  }
}

void registerMultipleNotifications(Iterable<CanNotify> notifications) {
  for (final notification in notifications) {
    if (notification.isCanNotifyInitialized) {
      notification.scheduleNotification();
    }
  }
}

void cancelMultipleNotifications(Iterable<CanNotify> notifications) {
  for (final notification in notifications) {
    if (notification.isCanNotifyInitialized) {
      notification.cancelNotification();
    }
  }
}

void cancelMultipleNotificationsWithChannelKey(String channelKey) {
  AwesomeNotifications().cancelSchedulesByChannelKey(channelKey);
}

Future<void> showScheduledNotifications() async {
  final list = await AwesomeNotifications().listScheduledNotifications();
  log(list.toString());
}
