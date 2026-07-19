import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/review/data/repositories/review_repository.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/repositories/review_repository.dart';

// ================= PARAMS =================

class CreateReviewParams {
  final String schoolId;
  final int rating;
  final String comment;

  const CreateReviewParams({
    required this.schoolId,
    required this.rating,
    required this.comment,
  });
}

// ================= PROVIDER =================

final createReviewUsecaseProvider = Provider<CreateReviewUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);

  return CreateReviewUsecase(reviewRepository: repository);
});

// ================= USECASE =================

class CreateReviewUsecase
    implements UsecaseWithParams<ReviewEntity, CreateReviewParams> {
  final IReviewRepository _reviewRepository;

  CreateReviewUsecase({required IReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, ReviewEntity>> call(CreateReviewParams params) {
    return _reviewRepository.createReview(
      schoolId: params.schoolId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}