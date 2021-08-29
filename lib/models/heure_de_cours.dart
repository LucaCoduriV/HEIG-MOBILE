import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

part 'heure_de_cours.g.dart';

@HiveType(typeId: 3)
class HeureDeCours {
  @HiveField(0)
  String nom;
  @HiveField(1)
  DateTime debut;
  @HiveField(2)
  DateTime fin;
  @HiveField(3)
  String prof;
  @HiveField(4)
  String salle;
  @HiveField(5)
  String uid;

  HeureDeCours({
    required this.nom,
    required this.debut,
    required this.fin,
    required this.prof,
    required this.salle,
    required this.uid,
  });

  factory HeureDeCours.fromJson(Map<String, dynamic> json) {
    String startString = (json['DTSTART;TZID=Europe/Zurich'] as String);
    String endString = (json['DTEND;TZID=Europe/Zurich'] as String);

    int startYear = int.parse(startString.substring(0, 4));
    int startMonth = int.parse(startString.substring(4, 6));
    int startDay = int.parse(startString.substring(6, 8));
    int startHour = int.parse(startString.substring(9, 11));
    int startMinute = int.parse(startString.substring(11, 13));
    int startSecond = int.parse(startString.substring(13, 15));

    int endYear = int.parse(endString.substring(0, 4));
    int endMonth = int.parse(endString.substring(4, 6));
    int endDay = int.parse(endString.substring(6, 8));
    int endHour = int.parse(endString.substring(9, 11));
    int endMinute = int.parse(endString.substring(11, 13));
    int endSecond = int.parse(endString.substring(13, 15));

    return HeureDeCours(
      nom: json['SUMMARY'],
      debut: DateTime(
          startYear, startMonth, startDay, startHour, startMinute, startSecond),
      fin: DateTime(endYear, endMonth, endDay, endHour, endMinute, endSecond),
      prof: 'Professeur inconnu',
      salle: json['LOCATION'],
      uid: json['UID'],
    );
  }

  @override
  String toString() {
    return "HeureDeCours(${this.nom}, ${this.debut}, ${this.fin} périodes, ${this.prof}, ${this.salle}, ${this.uid})";
  }
}
