import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/review/data/repositories/review_repository.dart';
import 'package:sikhsha_sathi/features/review/domain/repositories/review_repository.dart';

// ================= PROVIDER =================

final deleteReviewUsecaseProvider = Provider<DeleteReviewUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);

  return DeleteReviewUsecase(reviewRepository: repository);
});

// ================= USECASE =================

class DeleteReviewUsecase implements UsecaseWithParams<bool, String> {
  final IReviewRepository _reviewRepository;

  DeleteReviewUsecase({required IReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, bool>> call(String reviewId) {
    return _reviewRepository.deleteReview(reviewId);
  }
}