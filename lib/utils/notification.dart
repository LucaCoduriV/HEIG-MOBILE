import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/notification.dart';
import 'package:heig_front/utils/id_generator.dart';
import 'package:timezone/timezone.dart';

mixin CanNotify {
  static final IdGenerator _idGenerator = IdGenerator('notification');
  late final int _notificationId;
  late final TZDateTime _calendar;
  late final String _title;
  late final String _body;
  bool _isCanNotifyInitialized = false;

  bool get isCanNotifyInitialized => _isCanNotifyInitialized;

  @protected
  void initCanNotifyMixin(
    TZDateTime calendar,
    String title,
    String body,
  ) {
    _isCanNotifyInitialized = true;
    _notificationId = _idGenerator.nextId();
    _calendar = calendar;
    _title = title;
    _body = body;
  }

  void scheduleNotification() {
    assert(_isCanNotifyInitialized);
    assert(!kIsWeb);
    log('Cours enregistré: $_title à ${_calendar.hour}:${_calendar.minute} le ${_calendar.day}/${_calendar.month}/${_calendar.year}');

    GetIt.I.get<NotificationController>().schedule(
          _notificationId,
          _title,
          _body,
          _calendar,
          const NotificationDetails(
              android: AndroidNotificationDetails(
            'horaires_channel',
            'Horaire',
            channelDescription: 'Notification channel for schedules',
            enableLights: true,
            ledColor: Colors.white,
            color: Colors.red,
            importance: Importance.high,
          )),
        );
  }

  Future<void> cancelNotification() async {
    assert(_isCanNotifyInitialized);
    assert(!kIsWeb);
    await GetIt.I.get<NotificationController>().cancelSchedule(_notificationId);
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
