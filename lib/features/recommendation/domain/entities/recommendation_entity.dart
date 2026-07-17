import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class RecommendationEntity extends Equatable {
  final String schoolId;
  final double matchScore;
  final String reasoning;
  final SchoolEntity school;

  const RecommendationEntity({
    required this.schoolId,
    required this.matchScore,
    required this.reasoning,
    required this.school,
  });

  @override
  List<Object?> get props => [schoolId, matchScore, reasoning, school];
}

class RecommendationResult extends Equatable {
  final List<RecommendationEntity> recommendations;
  final bool usedAi;

  const RecommendationResult({
    required this.recommendations,
    required this.usedAi,
  });

  @override
  List<Object?> get props => [recommendations, usedAi];
}