import 'notes.dart';

class Branche {
  final String nom;
  List<Note> cours = [];
  List<Note> laboratoire = [];
  double moyenne = 1.0;

  Branche(nom, {cours, laboratoire, double moyenne = 0.0}) : nom = nom {
    this.cours = cours;
    this.laboratoire = laboratoire;
    this.moyenne = moyenne;
  }

  factory Branche.fromJson(Map<String, dynamic> json) {
    return Branche(
      json['nom'],
      cours: (json['cours'] as List<dynamic>)
          .map((cours) => new Note("unknown", cours.toDouble()))
          .toList(),
      laboratoire: (json['laboratoire'] as List<dynamic>)
          .map((laboratoire) => new Note("unknown", laboratoire.toDouble()))
          .toList(),
      moyenne: json['moyenne'].toDouble(),
    );
  }

  @override
  String toString() {
    return "Branche($nom, ${cours.toString()}, ${laboratoire.toString()}, ${moyenne.toString()})";
  }
}
