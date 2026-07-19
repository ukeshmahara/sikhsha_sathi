import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';

abstract interface class IReviewRepository {
  Future<Either<Failure, SchoolReviewsResult>> getSchoolReviews(
    String schoolId,
  );

  Future<Either<Failure, ReviewEntity>> createReview({
    required String schoolId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, ReviewEntity>> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, bool>> deleteReview(String reviewId);

  Future<Either<Failure, List<TopRatedSchool>>> getTopRatedSchools({
    int limit = 10,
  });
}