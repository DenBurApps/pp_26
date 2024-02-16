// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_uint_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyUintEntityAdapter extends TypeAdapter<CurrencyUintEntity> {
  @override
  final int typeId = 55;

  @override
  CurrencyUintEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyUintEntity(
      name: fields[2] as String?,
      symbol: fields[3] as String?,
      iconUrl: fields[1] as String?,
      sign: fields[4] as String?,
      uuid: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyUintEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.iconUrl)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.symbol)
      ..writeByte(4)
      ..write(obj.sign);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyUintEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
