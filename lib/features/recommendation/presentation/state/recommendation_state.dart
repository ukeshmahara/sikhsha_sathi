import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/recommendation/domain/entities/recommendation_entity.dart';

enum RecommendationStatus { initial, loading, loaded, error }

class RecommendationState extends Equatable {
  final RecommendationStatus status;
  final List<RecommendationEntity> recommendations;
  final bool usedAi;
  final String? errorMessage;

  const RecommendationState({
    this.status = RecommendationStatus.initial,
    this.recommendations = const [],
    this.usedAi = false,
    this.errorMessage,
  });

  RecommendationState copyWith({
    RecommendationStatus? status,
    List<RecommendationEntity>? recommendations,
    bool? usedAi,
    String? errorMessage,
  }) {
    return RecommendationState(
      status: status ?? this.status,
      recommendations: recommendations ?? this.recommendations,
      usedAi: usedAi ?? this.usedAi,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recommendations, usedAi, errorMessage];
}