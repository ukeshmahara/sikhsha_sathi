import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/school/data/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';

// Provider

final getCategoryCountsUsecaseProvider =
    Provider<GetCategoryCountsUsecase>((ref) {
  final repository = ref.read(schoolRepositoryProvider);

  return GetCategoryCountsUsecase(schoolRepository: repository);
});

// UseCase

class GetCategoryCountsUsecase
    implements UsecaseWithoutPrams<Map<String, int>> {
  final ISchoolRepository _schoolRepository;

  GetCategoryCountsUsecase({required ISchoolRepository schoolRepository})
      : _schoolRepository = schoolRepository;

  @override
  Future<Either<Failure, Map<String, int>>> call() {
    return _schoolRepository.getCategoryCounts();
  }
}