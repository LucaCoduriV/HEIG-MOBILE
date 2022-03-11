import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:heig_front/utils/notification.dart' show CanNotify;
import 'package:hive_flutter/adapters.dart';

part 'heure_de_cours.g.dart';

@HiveType(typeId: 3)
class HeureDeCours with CanNotify {
  @HiveField(0)
  final String nom;
  @HiveField(1)
  final DateTime debut;
  @HiveField(2)
  final DateTime fin;
  @HiveField(3)
  final String prof;
  @HiveField(4)
  final String salle;
  @HiveField(5)
  final String uid;
  @HiveField(6)
  final String? rrule;

  HeureDeCours(
    this.nom,
    this.debut,
    this.fin,
    this.prof,
    this.salle,
    this.uid,
    this.rrule,
  ) {
    final String dateSlug =
        "${debut.hour.toString().padLeft(2, '0')}:${debut.minute.toString().padLeft(2, '0')}";

    final dateMinus20 = debut.subtract(const Duration(minutes: 20));
    initCanNotifyMixin(
        NotificationCalendar(
          day: dateMinus20.day,
          year: dateMinus20.year,
          month: dateMinus20.month,
          hour: dateMinus20.hour,
          minute: dateMinus20.minute,
          second: dateMinus20.second,
          allowWhileIdle: true,
        ),
        NotificationContent(
          category: NotificationCategory.Reminder,
          id: 0, //debut.toUtc().millisecondsSinceEpoch,
          channelKey: 'horaires_channel',
          title: 'Cours: $nom Classe: $salle',
          body: dateSlug,
        ));
  }

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
}
