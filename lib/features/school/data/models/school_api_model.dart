import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class SchoolApiModel {
  final String? id;
  final String name;
  final String location;
  final String category;
  final List<String> streamsOffered;
  final double fees;
  final String? image;

  SchoolApiModel({
    this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.streamsOffered,
    required this.fees,
    this.image,
  });

  factory SchoolApiModel.fromEntity(SchoolEntity entity) {
    return SchoolApiModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      category: entity.category,
      streamsOffered: entity.streamsOffered,
      fees: entity.fees,
      image: entity.image,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "location": location,
      "category": category,
      "streamsOffered": streamsOffered,
      "fees": fees,
    };
  }

  factory SchoolApiModel.fromJson(Map<String, dynamic> json) {
    return SchoolApiModel(
      id: json["_id"] ?? json["id"],
      name: json["name"] ?? "",
      location: json["location"] ?? "",
      category: json["category"] ?? "",
      streamsOffered: json["streamsOffered"] != null
          ? List<String>.from(json["streamsOffered"])
          : <String>[],
      fees: (json["fees"] ?? 0).toDouble(),
      image: json["image"],
    );
  }
}