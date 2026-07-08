import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class SchoolApiModel {
  final String? id;
  final String name;
  final String location;
  final String category;
  final List<String> streamsOffered;
  final double fees;
  final String? image;
  final String? description;
  final List<String> facilities;
  final String? contactPhone;
  final String? contactEmail;
  final String? contactWebsite;

  SchoolApiModel({
    this.id,
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

  factory SchoolApiModel.fromEntity(SchoolEntity entity) {
    return SchoolApiModel(
      id: entity.id,
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

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "location": location,
      "category": category,
      "streamsOffered": streamsOffered,
      "fees": fees,
      "description": description,
      "facilities": facilities,
      "contactPhone": contactPhone,
      "contactEmail": contactEmail,
      "contactWebsite": contactWebsite,
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
      description: json["description"],
      facilities: json["facilities"] != null
          ? List<String>.from(json["facilities"])
          : <String>[],
      contactPhone: json["contactPhone"],
      contactEmail: json["contactEmail"],
      contactWebsite: json["contactWebsite"],
    );
  }
}