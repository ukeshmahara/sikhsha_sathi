import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/review/data/repositories/review_repository.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/repositories/review_repository.dart';

// ================= PARAMS =================

class UpdateReviewParams {
  final String reviewId;
  final int rating;
  final String comment;

  const UpdateReviewParams({
    required this.reviewId,
    required this.rating,
    required this.comment,
  });
}

// ================= PROVIDER =================

final updateReviewUsecaseProvider = Provider<UpdateReviewUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);

  return UpdateReviewUsecase(reviewRepository: repository);
});

// ================= USECASE =================

class UpdateReviewUsecase
    implements UsecaseWithParams<ReviewEntity, UpdateReviewParams> {
  final IReviewRepository _reviewRepository;

  UpdateReviewUsecase({required IReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, ReviewEntity>> call(UpdateReviewParams params) {
    return _reviewRepository.updateReview(
      reviewId: params.reviewId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}