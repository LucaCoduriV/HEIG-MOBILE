enum JourSemaine { LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE }

class HeureDeCours {
  String nom;
  int debut;
  int periodes;
  JourSemaine jour;
  String prof;
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