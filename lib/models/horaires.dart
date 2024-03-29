import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rrule/rrule.dart';

import 'heure_de_cours.dart';

part 'horaires.g.dart';

@HiveType(typeId: 4)
class Horaires {
  @HiveField(0)
  int semestre;
  @HiveField(1)
  int annee;
  @HiveField(2)
  late List<HeureDeCours> _horaires;

  //late List<HeureDeCours> horairesRRule;

  List<HeureDeCours> get horaires => _horaires;

  set horaires(List<HeureDeCours> horaires) {
    _horaires = getRRuleDates(horaires);
  }

  Horaires(this.semestre, this.annee,
      {List<HeureDeCours> horaires = const []}) {
    _horaires = horaires;
  }

  List<HeureDeCours> getRRuleDates(List<HeureDeCours> horaires) {
    final List<HeureDeCours> data = [];
    try {
      horaires.forEach((element) {
        if (element.rrule != null && element.rrule != '') {
          final RecurrenceRule parsedRRule =
              RecurrenceRule.fromString('RRULE:${element.rrule!}');

          final List<DateTime> startArray = parsedRRule.getAllInstances(
              start: element.debut.copyWith(isUtc: true));

          final duration = element.fin.difference(element.debut);
          for (int i = 0; i < startArray.length; i++) {
            try {
              data.add(HeureDeCours(
                  element.nom,
                  startArray[i],
                  startArray[i].add(duration),
                  element.prof,
                  element.salle,
                  element.uid,
                  ''));
            } catch (e) {
              debugPrint('error: $e');
            }
          }
        } else {
          data.add(element);
        }
      });
    } catch (e) {
      debugPrint('error2: $e');
    }

    return data;
  }

  @override
  String toString() {
    return '$semestre, $annee, nombre de cours: ${horaires.length}, ${horaires.toString()}';
  }
}
