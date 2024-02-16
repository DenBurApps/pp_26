// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletEntityAdapter extends TypeAdapter<WalletEntity> {
  @override
  final int typeId = 1;

  @override
  WalletEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletEntity(
      balance: fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WalletEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
