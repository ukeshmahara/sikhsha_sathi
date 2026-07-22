import 'package:hive/hive.dart';

import 'package:sikhsha_sathi/core/constants/hive_table_constant.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

part 'school_hive_model.g.dart';

@HiveType(
  typeId: HiveTableConstant.schoolTypeId,
)
class SchoolHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final List<String> streamsOffered;

  @HiveField(5)
  final double fees;

  @HiveField(6)
  final String? image;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final List<String> facilities;

  @HiveField(9)
  final String? contactPhone;

  @HiveField(10)
  final String? contactEmail;

  @HiveField(11)
  final String? contactWebsite;

  SchoolHiveModel({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.streamsOffered,
    required this.fees,
    this.image,
    this.description,
    this.facilities = const [],
    this.contactPhone,
    this.contactEmail,
    this.contactWebsite,
  });

  factory SchoolHiveModel.fromEntity(SchoolEntity entity) {
    return SchoolHiveModel(
      id: entity.id ?? '',
      name: entity.name,
      location: entity.location,
      category: entity.category,
      streamsOffered: entity.streamsOffered,
      fees: entity.fees,
      image: entity.image,
      description: entity.description,
      facilities: entity.facilities,
      contactPhone: entity.contactPhone,
      contactEmail: entity.contactEmail,
      contactWebsite: entity.contactWebsite,
    );
  }

  SchoolEntity toEntity() {
    return SchoolEntity(
      id: id,
      name: name,
      location: location,
      category: category,
      streamsOffered: streamsOffered,
      fees: fees,
      image: image,
      description: description,
      facilities: facilities,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      contactWebsite: contactWebsite,
    );
  }

  static List<SchoolEntity> toEntityList(List<SchoolHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

// Caches the category-counts map as a single stored entry (key "current")
@HiveType(
  typeId: HiveTableConstant.categoryCountsTypeId,
)
class CategoryCountsHiveModel extends HiveObject {
  @HiveField(0)
  final Map<String, int> counts;

  CategoryCountsHiveModel({required this.counts});
}