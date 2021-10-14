import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:heig_front/models/notifiable.dart';
import 'package:hive_flutter/adapters.dart';

part 'heure_de_cours.g.dart';

@HiveType(typeId: 3)
class HeureDeCours extends Notifiable {
  @HiveField(0)
  String nom;
  @HiveField(1)
  DateTime debut;
  @HiveField(2)
  DateTime fin;
  @HiveField(3)
  String prof;
  @HiveField(4)
  String salle;
  @HiveField(5)
  String uid;
  @HiveField(6)
  String? rrule;

  HeureDeCours(
    this.nom,
    this.debut,
    this.fin,
    this.prof,
    this.salle,
    this.uid,
    this.rrule, {
    int? notificationId,
  }) : super(notificationId: notificationId);

  factory HeureDeCours.fromJson(Map<String, dynamic> json) {
    final String startString = json['DTSTART;TZID=Europe/Zurich'] as String;
    final String endString = json['DTEND;TZID=Europe/Zurich'] as String;

    final int startYear = int.parse(startString.substring(0, 4));
    final int startMonth = int.parse(startString.substring(4, 6));
    final int startDay = int.parse(startString.substring(6, 8));
    final int startHour = int.parse(startString.substring(9, 11));
    final int startMinute = int.parse(startString.substring(11, 13));
    final int startSecond = int.parse(startString.substring(13, 15));

    final int endYear = int.parse(endString.substring(0, 4));
    final int endMonth = int.parse(endString.substring(4, 6));
    final int endDay = int.parse(endString.substring(6, 8));
    final int endHour = int.parse(endString.substring(9, 11));
    final int endMinute = int.parse(endString.substring(11, 13));
    final int endSecond = int.parse(endString.substring(13, 15));

    return HeureDeCours(
      json['SUMMARY'],
      DateTime(
          startYear, startMonth, startDay, startHour, startMinute, startSecond),
      DateTime(endYear, endMonth, endDay, endHour, endMinute, endSecond),
      'Professeur inconnu',
      json['LOCATION'],
      json['UID'],
      json['RRULE'],
    );
  }

  @override
  String toString() {
    return 'HeureDeCours($nom, $debut, $fin périodes, $prof, $salle, $uid)';
  }

  @override
  void scheduleNotification() {
    final String dateSlug =
        "${debut.hour.toString().padLeft(2, '0')}:${debut.minute.toString().padLeft(2, '0')}";

    AwesomeNotifications().createNotification(
        schedule: NotificationCalendar.fromDate(
            date: debut.subtract(const Duration(minutes: 20))),
        content: NotificationContent(
          id: notificationId,
          channelKey: 'horaires_channel',
          title: 'Cours: $nom Classe: $salle',
          body: dateSlug,
        ));
  }
}