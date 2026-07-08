import 'package:hive/hive.dart';

import 'package:sikhsha_sathi/core/constants/hive_table_constant.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

part 'favourite_hive_model.g.dart';

@HiveType(
  typeId: HiveTableConstant.favouriteTypeId,
)
class FavouriteHiveModel extends HiveObject {
  @HiveField(0)
  final String schoolId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final double fees;

  @HiveField(5)
  final String? image;

  FavouriteHiveModel({
    required this.schoolId,
    required this.name,
    required this.location,
    required this.category,
    required this.fees,
    this.image,
  });

  factory FavouriteHiveModel.fromEntity(FavouriteEntity entity) {
    return FavouriteHiveModel(
      schoolId: entity.school.id ?? '',
      name: entity.school.name,
      location: entity.school.location,
      category: entity.school.category,
      fees: entity.school.fees,
      image: entity.school.image,
    );
  }

  FavouriteEntity toEntity() {
    return FavouriteEntity(
      school: SchoolEntity(
        id: schoolId,
        name: name,
        location: location,
        category: category,
        streamsOffered: const [],
        fees: fees,
        image: image,
      ),
    );
  }

  static List<FavouriteEntity> toEntityList(
    List<FavouriteHiveModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}