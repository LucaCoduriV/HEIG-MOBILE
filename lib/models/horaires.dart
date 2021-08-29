import 'package:heig_front/models/heure_de_cours.dart';
import 'package:hive_flutter/adapters.dart';

part 'horaires.g.dart';

@HiveType(typeId: 4)
class Horaires {
  @HiveField(0)
  int semestre;
  @HiveField(1)
  int annee;
  @HiveField(2)
  late List<HeureDeCours> horaires;

  Horaires({required this.semestre, required this.annee, required horaires}) {
    // je sais pas si c'est la meilleur manière de faire
    this.horaires = horaires;
  }

  @override
  String toString() {
    return "$semestre, $annee, nombre de cours: ${horaires.length}, ${horaires.toString()}";
  }
}
