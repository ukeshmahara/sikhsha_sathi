import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/school/data/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';

// ================= PARAMS =================

class GetSchoolsParams {
  final int page;
  final int limit;
  final String search;
  final String category;
  final String stream;
  final double? minFee;
  final double? maxFee;
  final String sort; // '' | 'fees_asc' | 'fees_desc' | 'name_asc'

  const GetSchoolsParams({
    this.page = 1,
    this.limit = 10,
    this.search = '',
    this.category = '',
    this.stream = '',
    this.minFee,
    this.maxFee,
    this.sort = '',
  });
}

// ================= PROVIDER =================

final getSchoolsUsecaseProvider = Provider<GetSchoolsUsecase>((ref) {
  final repository = ref.read(schoolRepositoryProvider);

  return GetSchoolsUsecase(schoolRepository: repository);
});

// ================= USECASE =================

class GetSchoolsUsecase
    implements UsecaseWithParams<SchoolListResult, GetSchoolsParams> {
  final ISchoolRepository _schoolRepository;

  GetSchoolsUsecase({required ISchoolRepository schoolRepository})
      : _schoolRepository = schoolRepository;

  @override
  Future<Either<Failure, SchoolListResult>> call(
    GetSchoolsParams params,
  ) {
    return _schoolRepository.getSchools(
      page: params.page,
      limit: params.limit,
      search: params.search,
      category: params.category,
      stream: params.stream,
      minFee: params.minFee,
      maxFee: params.maxFee,
      sort: params.sort,
    );
  }
}