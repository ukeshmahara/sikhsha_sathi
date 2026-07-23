import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/services/hive/hive_service.dart';

import 'package:sikhsha_sathi/features/school/data/datasources/school_datasource.dart';
import 'package:sikhsha_sathi/features/school/data/models/school_hive_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

// ================= PROVIDER =================

final schoolLocalDatasourceProvider = Provider<ISchoolLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return SchoolLocalDatasource(hiveService: hiveService);
});

// ================= DATASOURCE =================

class SchoolLocalDatasource implements ISchoolLocalDataSource {
  final HiveService _hiveService;

  SchoolLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  List<SchoolEntity> getCachedSchools() {
    final models = _hiveService.getCachedSchools();
    return SchoolHiveModel.toEntityList(models);
  }

  @override
  Future<void> replaceCache(List<SchoolEntity> schools) async {
    final models = schools.map((s) => SchoolHiveModel.fromEntity(s)).toList();
    await _hiveService.replaceCachedSchools(models);
  }

  @override
  SchoolEntity? getCachedSchoolById(String id) {
    final model = _hiveService.getCachedSchoolById(id);
    return model?.toEntity();
  }

  @override
  Map<String, int> getCachedCategoryCounts() {
    return _hiveService.getCachedCategoryCounts();
  }

  @override
  Future<void> cacheCategoryCounts(Map<String, int> counts) async {
    await _hiveService.cacheCategoryCounts(counts);
  }
}