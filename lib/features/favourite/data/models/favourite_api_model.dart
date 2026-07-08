import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/school/data/models/school_api_model.dart';

class FavouriteApiModel {
  final SchoolApiModel school;

  FavouriteApiModel({
    required this.school,
  });

  FavouriteEntity toEntity() {
    return FavouriteEntity(
      school: school.toEntity(),
    );
  }

  factory FavouriteApiModel.fromJson(Map<String, dynamic> json) {
    return FavouriteApiModel(
      school: SchoolApiModel.fromJson(json),
    );
  }
}