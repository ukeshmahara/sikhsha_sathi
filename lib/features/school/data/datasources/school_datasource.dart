import 'package:sikhsha_sathi/features/school/data/models/school_api_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

abstract interface class ISchoolLocalDataSource {
  List<SchoolEntity> getCachedSchools();

  Future<void> replaceCache(List<SchoolEntity> schools);

  SchoolEntity? getCachedSchoolById(String id);

  Map<String, int> getCachedCategoryCounts();

  Future<void> cacheCategoryCounts(Map<String, int> counts);
}

// ================= RESULT WRAPPER =================

class SchoolRemoteListResult {
  final List<SchoolApiModel> schools;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const SchoolRemoteListResult({
    required this.schools,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

abstract interface class ISchoolRemoteDataSource {
  Future<SchoolRemoteListResult> getSchools({
    required int page,
    required int limit,
    required String search,
    required String category,
    required String stream,
    double? minFee,
    double? maxFee,
    required String sort,
  });

  Future<SchoolApiModel> getSchoolById(String id);

  Future<Map<String, int>> getCategoryCounts();
}