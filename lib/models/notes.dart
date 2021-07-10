import 'package:hive_flutter/adapters.dart';

part 'notes.g.dart';

@HiveType(typeId: 5)
class Note {
  @HiveField(0)
  String nom = "";
  @HiveField(1)
  double note = 1;

  Note(String nom, double note) {
    this.nom = nom;
    this.note = note;
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(json['nom'], json['note']);
  }

  @override
  String toString() {
    return "${note.toString()}";
  }
}
