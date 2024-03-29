import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
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
            ledOnMs: 500,
            ledOffMs: 500,
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
        ledOnMs: 500,
        ledOffMs: 500,
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
    log(activeNotifs.length.toString());
    activeNotifs.forEach((element) {
      log('${element.title}, ${element.body}');
    });
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
