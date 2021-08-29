// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heure_de_cours.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      debut: fields[1] as DateTime,
      fin: fields[2] as DateTime,
      prof: fields[3] as String,
      salle: fields[4] as String,
      uid: fields[5] as String,
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
      ..write(obj.fin)
      ..writeByte(3)
      ..write(obj.prof)
      ..writeByte(4)
      ..write(obj.salle)
      ..writeByte(5)
      ..write(obj.uid);
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
