import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/school/data/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';

// ================= PROVIDER =================

final getSchoolByIdUsecaseProvider = Provider<GetSchoolByIdUsecase>((ref) {
  final repository = ref.read(schoolRepositoryProvider);

  return GetSchoolByIdUsecase(schoolRepository: repository);
});

// ================= USECASE =================

class GetSchoolByIdUsecase
    implements UsecaseWithParams<SchoolEntity, String> {
  final ISchoolRepository _schoolRepository;

  GetSchoolByIdUsecase({required ISchoolRepository schoolRepository})
      : _schoolRepository = schoolRepository;

  @override
  Future<Either<Failure, SchoolEntity>> call(String id) {
    return _schoolRepository.getSchoolById(id);
  }
}