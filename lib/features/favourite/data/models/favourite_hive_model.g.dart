// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteHiveModelAdapter extends TypeAdapter<FavouriteHiveModel> {
  @override
  final int typeId = 1;

  @override
  FavouriteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteHiveModel(
      schoolId: fields[0] as String,
      name: fields[1] as String,
      location: fields[2] as String,
      category: fields[3] as String,
      fees: fields[4] as double,
      image: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.schoolId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.fees)
      ..writeByte(5)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
