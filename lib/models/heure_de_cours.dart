import 'package:hive_flutter/adapters.dart';

part 'heure_de_cours.g.dart';

@HiveType(typeId: 6)
enum JourSemaine {
  @HiveField(0)
  LUNDI,
  @HiveField(1)
  MARDI,
  @HiveField(2)
  MERCREDI,
  @HiveField(3)
  JEUDI,
  @HiveField(4)
  VENDREDI,
  @HiveField(5)
  SAMEDI,
  @HiveField(6)
  DIMANCHE,
}

@HiveType(typeId: 3)
class HeureDeCours {
  @HiveField(0)
  String nom;
  @HiveField(1)
  int debut;
  @HiveField(2)
  int periodes;
  @HiveField(3)
  JourSemaine jour;
  @HiveField(4)
  String prof;
  @HiveField(5)
  String salle;

  HeureDeCours({
    required this.nom,
    required this.debut,
    required this.periodes,
    required this.jour,
    required this.prof,
    required this.salle,
  });

  factory HeureDeCours.fromJson(Map<String, dynamic> json) {
    return HeureDeCours(
      nom: json['nom'],
      debut: json['debut'],
      periodes: json['periodes'],
      jour: JourSemaine.values[json['jour']],
      prof: json['prof'],
      salle: json['salle'],
    );
  }

  @override
  String toString() {
    return "HeureDeCours(${this.nom}, ${this.debut}, ${this.periodes} périodes, ${this.jour}, ${this.prof}, ${this.salle})";
  }
}
