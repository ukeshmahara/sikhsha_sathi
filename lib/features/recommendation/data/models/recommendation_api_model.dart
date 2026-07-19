import 'package:sikhsha_sathi/features/recommendation/domain/entities/recommendation_entity.dart';
import 'package:sikhsha_sathi/features/school/data/models/school_api_model.dart';

class RecommendationApiModel {
  final String schoolId;
  final double matchScore;
  final String reasoning;
  final SchoolApiModel school;

  RecommendationApiModel({
    required this.schoolId,
    required this.matchScore,
    required this.reasoning,
    required this.school,
  });

  RecommendationEntity toEntity() {
    return RecommendationEntity(
      schoolId: schoolId,
      matchScore: matchScore,
      reasoning: reasoning,
      school: school.toEntity(),
    );
  }

  factory RecommendationApiModel.fromJson(Map<String, dynamic> json) {
    return RecommendationApiModel(
      schoolId: json["schoolId"] ?? '',
      matchScore: (json["matchScore"] as num?)?.toDouble() ?? 0,
      reasoning: json["reasoning"] ?? '',
      school: SchoolApiModel.fromJson(json["school"]),
    );
  }
}