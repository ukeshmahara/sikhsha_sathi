import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/recommendation/data/repositories/recommendation_repository.dart';
import 'package:sikhsha_sathi/features/recommendation/domain/entities/recommendation_entity.dart';
import 'package:sikhsha_sathi/features/recommendation/domain/repositories/recommendation_repository.dart';

// ================= PARAMS =================

class GetRecommendationsParams {
  final String stream; // 'science' | 'management' | 'humanities'
  final double minFee;
  final double maxFee;
  final String? location;
  final String? notes;

  const GetRecommendationsParams({
    required this.stream,
    this.minFee = 0,
    this.maxFee = 1500000,
    this.location,
    this.notes,
  });
}

// ================= PROVIDER =================

final getRecommendationsUsecaseProvider =
    Provider<GetRecommendationsUsecase>((ref) {
  final repository = ref.read(recommendationRepositoryProvider);

  return GetRecommendationsUsecase(recommendationRepository: repository);
});

// ================= USECASE =================

class GetRecommendationsUsecase
    implements
        UsecaseWithParams<RecommendationResult, GetRecommendationsParams> {
  final IRecommendationRepository _recommendationRepository;

  GetRecommendationsUsecase({
    required IRecommendationRepository recommendationRepository,
  }) : _recommendationRepository = recommendationRepository;

  @override
  Future<Either<Failure, RecommendationResult>> call(
    GetRecommendationsParams params,
  ) {
    return _recommendationRepository.getRecommendations(
      stream: params.stream,
      minFee: params.minFee,
      maxFee: params.maxFee,
      location: params.location,
      notes: params.notes,
    );
  }
}