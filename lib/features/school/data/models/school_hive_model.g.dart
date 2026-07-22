// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolHiveModelAdapter extends TypeAdapter<SchoolHiveModel> {
  @override
  final int typeId = 3;

  @override
  SchoolHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      location: fields[2] as String,
      category: fields[3] as String,
      streamsOffered: (fields[4] as List).cast<String>(),
      fees: fields[5] as double,
      image: fields[6] as String?,
      description: fields[7] as String?,
      facilities: (fields[8] as List).cast<String>(),
      contactPhone: fields[9] as String?,
      contactEmail: fields[10] as String?,
      contactWebsite: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.streamsOffered)
      ..writeByte(5)
      ..write(obj.fees)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.facilities)
      ..writeByte(9)
      ..write(obj.contactPhone)
      ..writeByte(10)
      ..write(obj.contactEmail)
      ..writeByte(11)
      ..write(obj.contactWebsite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryCountsHiveModelAdapter
    extends TypeAdapter<CategoryCountsHiveModel> {
  @override
  final int typeId = 4;

  @override
  CategoryCountsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryCountsHiveModel(
      counts: (fields[0] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryCountsHiveModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.counts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryCountsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
