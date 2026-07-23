import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';

import 'package:sikhsha_sathi/features/school/data/datasources/school_datasource.dart';
import 'package:sikhsha_sathi/features/school/data/models/school_api_model.dart';

// ================= PROVIDER =================

final schoolRemoteDatasourceProvider = Provider<ISchoolRemoteDataSource>(
  (ref) => SchoolRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  ),
);

// ================= IMPLEMENTATION =================

class SchoolRemoteDatasource implements ISchoolRemoteDataSource {
  final ApiClient apiClient;

  SchoolRemoteDatasource({required this.apiClient});

  @override
  Future<SchoolRemoteListResult> getSchools({
    required int page,
    required int limit,
    required String search,
    required String category,
    required String stream,
    double? minFee,
    double? maxFee,
    required String sort,
  }) async {
    final query = <String>[
      'page=$page',
      'limit=$limit',
      if (search.isNotEmpty) 'search=${Uri.encodeQueryComponent(search)}',
      if (category.isNotEmpty) 'category=$category',
      if (stream.isNotEmpty) 'stream=$stream',
      if (minFee != null) 'minFee=${minFee.toStringAsFixed(0)}',
      if (maxFee != null) 'maxFee=${maxFee.toStringAsFixed(0)}',
      if (sort.isNotEmpty) 'sort=$sort',
    ].join('&');

    final response = await apiClient.get(
      '${ApiEndpoints.schools}?$query',
    );

    final List<dynamic> data = response.data["data"] ?? [];
    final meta = response.data["meta"];

    return SchoolRemoteListResult(
      schools: data.map((json) => SchoolApiModel.fromJson(json)).toList(),
      page: meta?["page"] ?? page,
      limit: meta?["limit"] ?? limit,
      total: meta?["total"] ?? 0,
      totalPages: meta?["totalPages"] ?? 1,
    );
  }

  @override
  Future<SchoolApiModel> getSchoolById(String id) async {
    final response = await apiClient.get(
      '${ApiEndpoints.schools}/$id',
    );

    return SchoolApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<Map<String, int>> getCategoryCounts() async {
    final response = await apiClient.get(
      ApiEndpoints.schoolCategoryCounts,
    );

    final Map<String, dynamic> data = response.data["data"] ?? {};

    return data.map((key, value) => MapEntry(key, (value as num).toInt()));
  }
}