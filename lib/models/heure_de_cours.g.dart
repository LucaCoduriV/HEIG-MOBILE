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
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as DateTime,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HeureDeCours obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.uid)
      ..writeByte(6)
      ..write(obj.rrule);
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
