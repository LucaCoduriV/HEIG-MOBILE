import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/notifications_manager.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rrule/rrule.dart';

part 'horaires.g.dart';

@HiveType(typeId: 4)
class Horaires {
  @HiveField(0)
  int semestre;
  @HiveField(1)
  int annee;
  @HiveField(2)
  late List<HeureDeCours> horaires;
  @HiveField(3)
  String rrule = "";
  @HiveField(4)
  late List<HeureDeCours> horairesRRule;
  @HiveField(5)
  List<int> notificationIds = [];

  var box = Hive.box('heig');

  Horaires(this.semestre, this.annee, this.horaires, this.rrule) {
    horairesRRule = getRRuleDates();
  }

  List<HeureDeCours> getRRuleDates() {
    final List<HeureDeCours> data = [];
    try {
      horaires.forEach((element) {
        if (element.rrule != null && element.rrule != "") {
          final RecurrenceRule parsedRRule =
              RecurrenceRule.fromString("RRULE:" + element.rrule!);
          List<DateTime> startArray =
              parsedRRule.getAllInstances(start: element.debut.toUtc());

          List<DateTime> endArray =
              parsedRRule.getAllInstances(start: element.fin.toUtc());

          for (int i = 0; i < startArray.length; i++) {
            try {
              data.add(HeureDeCours(element.nom, startArray[i], endArray[i],
                  element.prof, element.salle, element.uid, element.rrule));
            } catch (e) {
              log("error!");
            }
          }
        } else {
          data.add(element);
        }
      });
    } catch (e) {
      log(e.toString());
    }
    notificationIds.forEach((element) {
      AwesomeNotifications().cancel(element);
    });
    data.forEach((element) {
      GetIt.I.get<NotificationsManager>().registerNotificationHoraire(
            element.nom,
            element.salle,
            element.debut.subtract(Duration(hours: 1)),
          );
    });
    return data;
  }

  @override
  String toString() {
    return "$semestre, $annee, nombre de cours: ${horaires.length}, ${horaires.toString()}";
  }
}
