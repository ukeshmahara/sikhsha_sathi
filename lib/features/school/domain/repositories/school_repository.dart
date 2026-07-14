import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class SchoolListResult {
  final List<SchoolEntity> schools;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const SchoolListResult({
    required this.schools,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

abstract interface class ISchoolRepository {
  Future<Either<Failure, SchoolListResult>> getSchools({
    int page,
    int limit,
    String search,
    String category,
    String stream,
    double? minFee,
    double? maxFee,
    String sort,
  });

  Future<Either<Failure, SchoolEntity>> getSchoolById(String id);

  Future<Either<Failure, Map<String, int>>> getCategoryCounts();
}