import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';

mixin CanNotify {
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
    _notificationId = content.id!;
    _calendar = calendar;
    _content = content;
  }

  void scheduleNotification() {
    assert(_isCanNotifyInitialized);
    assert(!kIsWeb);
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
