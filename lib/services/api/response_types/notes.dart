import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

part 'notes.g.dart';

@immutable
@HiveType(typeId: 5)
class Note {
  @HiveField(0)
  final String nom;
  @HiveField(1)
  final double note;
  @HiveField(2)
  final double moyenneClasse;
  @HiveField(3)
  final double coef;

  const Note(this.nom, this.note, this.moyenneClasse, this.coef);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(json['nom'], json['note'], json['moyenneClasse'], json['coef']);
  }

  @override
  String toString() {
    return note.toString();
  }

  @override
  bool operator ==(covariant Note other) {
    return nom == other.nom &&
        note == other.note &&
        moyenneClasse == other.moyenneClasse &&
        coef == other.coef;
  }

  @override
  int get hashCode => hashValues(
      nom.hashCode, note.hashCode, moyenneClasse.hashCode, coef.hashCode);
}
