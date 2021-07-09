import 'dart:ffi';

import 'notes.dart';

class Branche {
  final String nom;
  List<Notes> cours = [];
  List<Notes> laboratoire = [];
  double moyenne = 1.0;

  Branche(nom, {cours, laboratoire, moyenne}) : nom = nom {
    this.cours = cours;
    this.laboratoire = laboratoire;
    this.moyenne = moyenne;
  }

  factory Branche.fromJson(Map<String, dynamic> json) {
    return Branche(
      json['nom'],
      cours: json['cours'],
      laboratoire: json['laboratoire'],
      moyenne: json['moyenne'],
    );
  }
}
