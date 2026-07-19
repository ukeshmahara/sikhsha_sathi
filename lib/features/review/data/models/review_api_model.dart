import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/school/data/models/school_api_model.dart';

class ReviewApiModel {
  final String id;
  final String studentId;
  final String studentName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewApiModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      studentId: studentId,
      studentName: studentName,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
    );
  }

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) {
    // studentId comes back populated as { "_id": "...", "fullName": "..." }
    // from GET /reviews/school/:schoolId — but stays a plain string id in
    // the response to POST/PATCH /reviews since those don't populate.
    final studentField = json["studentId"];
    String studentId;
    String studentName;

    if (studentField is Map<String, dynamic>) {
      studentId = studentField["_id"] ?? '';
      studentName = studentField["fullName"] ?? 'Anonymous';
    } else {
      studentId = studentField?.toString() ?? '';
      studentName = 'You';
    }

    return ReviewApiModel(
      id: json["_id"] ?? json["id"] ?? '',
      studentId: studentId,
      studentName: studentName,
      rating: (json["rating"] as num?)?.toInt() ?? 0,
      comment: json["comment"] ?? '',
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
    );
  }
}

class TopRatedSchoolApiModel {
  final SchoolApiModel school;
  final double average;
  final int count;

  TopRatedSchoolApiModel({
    required this.school,
    required this.average,
    required this.count,
  });

  TopRatedSchool toEntity() {
    return TopRatedSchool(
      school: school.toEntity(),
      average: average,
      count: count,
    );
  }

  factory TopRatedSchoolApiModel.fromJson(Map<String, dynamic> json) {
    return TopRatedSchoolApiModel(
      school: SchoolApiModel.fromJson(json["school"]),
      average: (json["average"] as num?)?.toDouble() ?? 0,
      count: (json["count"] as num?)?.toInt() ?? 0,
    );
  }
}