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
}
