// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../horaires.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HorairesAdapter extends TypeAdapter<Horaires> {
  @override
  final int typeId = 4;

  @override
  Horaires read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Horaires(
      fields[0] as int,
      fields[1] as int,
      horaires: (fields[2] as List).cast<HeureDeCours>(),
    );
  }

  @override
  void write(BinaryWriter writer, Horaires obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.semestre)
      ..writeByte(1)
      ..write(obj.annee)
      ..writeByte(2)
      ..write(obj.horaires);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HorairesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
