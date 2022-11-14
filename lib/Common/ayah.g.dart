// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AyahBMAdapter extends TypeAdapter<AyahBM> {
  @override
  final int typeId = 2;

  @override
  AyahBM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AyahBM(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3],
    );
  }

  @override
  void write(BinaryWriter writer, AyahBM obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ayah)
      ..writeByte(1)
      ..write(obj.ayahnum)
      ..writeByte(2)
      ..write(obj.surahnum)
      ..writeByte(3)
      ..write(obj.translation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahBMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
