import 'package:hive_flutter/adapters.dart';

part 'notes.g.dart';

@HiveType(typeId: 5)
class Note {
  @HiveField(0)
  String nom = '';
  @HiveField(1)
  double note = 1;
  @HiveField(2)
  double moyenneClasse = 0;
  @HiveField(3)
  double coef = 0;

  Note(this.nom, this.note, this.moyenneClasse, this.coef);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(json['nom'], json['note'], json['moyenneClasse'], json['coef']);
  }

  @override
  String toString() {
    return note.toString();
  }
}
