import 'package:heig_front/models/heure_de_cours.dart';

class Horaires {
  int semestre;
  int annee;
  late List<HeureDeCours> horaires;

  Horaires({required this.semestre, required this.annee, horaires}) {
    // je sais pas si c'est la meilleur manière de faire
    this.horaires = horaires == null ? [] : horaires;
  }
}
