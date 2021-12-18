// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../branche.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrancheAdapter extends TypeAdapter<Branche> {
  @override
  final int typeId = 2;

  @override
  Branche read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Branche(
      fields[0] as String,
      cours: (fields[1] as List).cast<Note>(),
      laboratoire: (fields[2] as List).cast<Note>(),
      moyenne: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Branche obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nom)
      ..writeByte(1)
      ..write(obj.cours)
      ..writeByte(2)
      ..write(obj.laboratoire)
      ..writeByte(3)
      ..write(obj.moyenne);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrancheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
