import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/recommendation/domain/entities/recommendation_entity.dart';

abstract interface class IRecommendationRepository {
  Future<Either<Failure, RecommendationResult>> getRecommendations({
    required String stream,
    required double minFee,
    required double maxFee,
    String? location,
    String? notes,
  });
}