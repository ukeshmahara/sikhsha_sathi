import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/review/data/repositories/review_repository.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/repositories/review_repository.dart';

// ================= PROVIDER =================

final getSchoolReviewsUsecaseProvider =
    Provider<GetSchoolReviewsUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);

  return GetSchoolReviewsUsecase(reviewRepository: repository);
});

// ================= USECASE =================

class GetSchoolReviewsUsecase
    implements UsecaseWithParams<SchoolReviewsResult, String> {
  final IReviewRepository _reviewRepository;

  GetSchoolReviewsUsecase({required IReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, SchoolReviewsResult>> call(String schoolId) {
    return _reviewRepository.getSchoolReviews(schoolId);
  }
}