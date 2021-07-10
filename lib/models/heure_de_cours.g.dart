// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heure_de_cours.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JourSemaineAdapter extends TypeAdapter<JourSemaine> {
  @override
  final int typeId = 6;

  @override
  JourSemaine read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JourSemaine.LUNDI;
      case 1:
        return JourSemaine.MARDI;
      case 2:
        return JourSemaine.MERCREDI;
      case 3:
        return JourSemaine.JEUDI;
      case 4:
        return JourSemaine.VENDREDI;
      case 5:
        return JourSemaine.SAMEDI;
      case 6:
        return JourSemaine.DIMANCHE;
      default:
        return JourSemaine.LUNDI;
    }
  }

  @override
  void write(BinaryWriter writer, JourSemaine obj) {
    switch (obj) {
      case JourSemaine.LUNDI:
        writer.writeByte(0);
        break;
      case JourSemaine.MARDI:
        writer.writeByte(1);
        break;
      case JourSemaine.MERCREDI:
        writer.writeByte(2);
        break;
      case JourSemaine.JEUDI:
        writer.writeByte(3);
        break;
      case JourSemaine.VENDREDI:
        writer.writeByte(4);
        break;
      case JourSemaine.SAMEDI:
        writer.writeByte(5);
        break;
      case JourSemaine.DIMANCHE:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JourSemaineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HeureDeCoursAdapter extends TypeAdapter<HeureDeCours> {
  @override
  final int typeId = 3;

  @override
  HeureDeCours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HeureDeCours(
      nom: fields[0] as String,
      debut: fields[1] as int,
      periodes: fields[2] as int,
      jour: fields[3] as JourSemaine,
      prof: fields[4] as String,
      salle: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HeureDeCours obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nom)
      ..writeByte(1)
      ..write(obj.debut)
      ..writeByte(2)
      ..write(obj.periodes)
      ..writeByte(3)
      ..write(obj.jour)
      ..writeByte(4)
      ..write(obj.prof)
      ..writeByte(5)
      ..write(obj.salle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeureDeCoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
