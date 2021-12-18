import 'package:hive_flutter/adapters.dart';

import 'branche.dart';
import 'notes.dart';

part 'type_adapters/bulletin.g.dart';

@HiveType(typeId: 1)
class Bulletin {
  @HiveField(0)
  late List<Branche> branches;
  @HiveField(1)
  late int year;

  Bulletin(List<Branche>? branches, {this.year = 2020}) {
    this.branches = branches ?? [];
  }

  /// Get all grades in newB that is not in oldB.
  static List<Note> getDiff(Bulletin oldB, Bulletin newB) {
    final List<Note> oldGrades = [];
    final List<Note> newGrades = [];
    final List<Note> diffGrades = [];

    for (final Branche branche in oldB.branches) {
      [...branche.cours, ...branche.laboratoire].forEach(oldGrades.add);
    }
    for (final Branche branche in newB.branches) {
      [...branche.cours, ...branche.laboratoire].forEach(newGrades.add);
    }

    for (final Note note in newGrades) {
      if (!oldGrades.contains(note)) {
        diffGrades.add(note);
      }
    }

    return diffGrades;
  }

  @override
  String toString() {
    return 'nombre de branches: ${branches.length}, ${branches.toString()}';
  }
}
