import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/review/data/repositories/review_repository.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/repositories/review_repository.dart';

// ================= PROVIDER =================

final getTopRatedSchoolsUsecaseProvider =
    Provider<GetTopRatedSchoolsUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);

  return GetTopRatedSchoolsUsecase(reviewRepository: repository);
});

// ================= USECASE =================

class GetTopRatedSchoolsUsecase
    implements UsecaseWithParams<List<TopRatedSchool>, int> {
  final IReviewRepository _reviewRepository;

  GetTopRatedSchoolsUsecase({required IReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, List<TopRatedSchool>>> call(int limit) {
    return _reviewRepository.getTopRatedSchools(limit: limit);
  }
}