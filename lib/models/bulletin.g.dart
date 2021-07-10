// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulletin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BulletinAdapter extends TypeAdapter<Bulletin> {
  @override
  final int typeId = 1;

  @override
  Bulletin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bulletin(
      (fields[0] as List?)?.cast<Branche>(),
    );
  }

  @override
  void write(BinaryWriter writer, Bulletin obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.branches);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BulletinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
