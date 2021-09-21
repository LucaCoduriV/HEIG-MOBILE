import 'dart:developer';
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
  String rrule = '';

  late List<HeureDeCours> horairesRRule;

  Horaires(this.semestre, this.annee, this.horaires, this.rrule) {
    horairesRRule = getRRuleDates();
  }

  List<HeureDeCours> getRRuleDates() {
    final List<HeureDeCours> data = [];
    try {
      horaires.forEach((element) {
        if (element.rrule != null && element.rrule != '') {
          final RecurrenceRule parsedRRule =
              RecurrenceRule.fromString('RRULE:${element.rrule!}');
          final List<DateTime> startArray = parsedRRule.getAllInstances(
              start: element.debut.add(const Duration(hours: 2)).toUtc());

          final List<DateTime> endArray = parsedRRule.getAllInstances(
              start: element.fin.add(const Duration(hours: 2)).toUtc());

          for (int i = 0; i < startArray.length; i++) {
            try {
              data.add(HeureDeCours(element.nom, startArray[i], endArray[i],
                  element.prof, element.salle, element.uid, element.rrule));
            } catch (e) {
              log('error!: $e');
            }
          }
        } else {
          data.add(element);
        }
      });
    } catch (e) {
      log(e.toString());
    }
    return data;
  }

  @override
  String toString() {
    return '$semestre, $annee, nombre de cours: ${horaires.length}, ${horaires.toString()}';
  }
}
