import 'package:hive_flutter/adapters.dart';

import 'notes.dart';

part 'branche.g.dart';

@HiveType(typeId: 2)
class Branche {
  @HiveField(0)
  final String nom;
  @HiveField(1)
  List<Note> cours = [];
  @HiveField(2)
  List<Note> laboratoire = [];
  @HiveField(3)
  double moyenne = 1;

  Branche(this.nom,
      {required this.cours, required this.laboratoire, this.moyenne = 0});

  factory Branche.fromJson(Map<String, dynamic> json) {
    return Branche(
      json['nom'],
      cours: (json['cours'] as List<dynamic>)
          .map((cours) => Note(
              cours['titre'],
              cours['note']?.toDouble() ?? 0,
              cours['moyenneClasse']?.toDouble() ?? 0,
              cours['coef']?.toDouble() ?? 0))
          .toList(),
      laboratoire: (json['laboratoire'] as List<dynamic>)
          .map((laboratoire) => Note(
              laboratoire['titre'],
              laboratoire['note']?.toDouble() ?? 0,
              laboratoire['moyenneClasse']?.toDouble() ?? 0,
              laboratoire['coef']?.toDouble() ?? 0))
          .toList(),
      moyenne: json['moyenne']?.toDouble() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Branche($nom, ${cours.toString()}, ${laboratoire.toString()}, ${moyenne.toString()})';
  }
}
