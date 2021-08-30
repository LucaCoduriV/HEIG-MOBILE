import 'package:flutter/material.dart';
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

  Horaires(this.semestre, this.annee, this.horaires, this.rrule);

  List<HeureDeCours> getHoraireRRule() {
    final RecurrenceRule parsedRRule =
        RecurrenceRule.fromString("RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=SU");
    List<HeureDeCours> fin = [];

    RruleL10nEn.create().then((value) {
      debugPrint(parsedRRule.toText(l10n: value));
    });

    horaires.forEach((element) {
      final startDate = parsedRRule
          .getInstances(
            start: element.debut.toUtc(),
            after: element.debut.toUtc(),
            before: DateTime.utc(2023, 3, 14),
          )
          .toList();

      final endDate = parsedRRule
          .getInstances(
            start: element.fin.toUtc(),
            after: element.fin.toUtc(),
            before: DateTime.utc(2023, 3, 14).toUtc(),
          )
          .toList();

      for (int i = 0; i < startDate.length; i++) {
        fin.add(HeureDeCours(
            debut: startDate[i],
            fin: endDate[i],
            nom: element.nom,
            prof: element.prof,
            salle: element.salle,
            uid: element.uid));
      }
    });

    return fin;
  }

  @override
  String toString() {
    return "$semestre, $annee, nombre de cours: ${horaires.length}, ${horaires.toString()}";
  }
}
