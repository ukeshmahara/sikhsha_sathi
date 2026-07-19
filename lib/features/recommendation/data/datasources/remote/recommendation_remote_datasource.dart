import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';

import 'package:sikhsha_sathi/features/recommendation/data/datasources/recommendation_datasource.dart';
import 'package:sikhsha_sathi/features/recommendation/data/models/recommendation_api_model.dart';

// ================= PROVIDER =================

final recommendationRemoteDatasourceProvider =
    Provider<IRecommendationRemoteDataSource>((ref) {
  return RecommendationRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

// ================= IMPLEMENTATION =================

class RecommendationRemoteDatasource implements IRecommendationRemoteDataSource {
  final ApiClient apiClient;

  RecommendationRemoteDatasource({required this.apiClient});

  @override
  Future<({List<RecommendationApiModel> recommendations, bool usedAi})>
      getRecommendations({
    required String stream,
    required double minFee,
    required double maxFee,
    String? location,
    String? notes,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.recommendations,
      data: {
        "stream": stream,
        "minFee": minFee,
        "maxFee": maxFee,
        if (location != null && location.isNotEmpty) "location": location,
        if (notes != null && notes.isNotEmpty) "notes": notes,
      },
    );

    final data = response.data["data"];
    final List<dynamic> recommendationsJson = data["recommendations"] ?? [];

    return (
      recommendations: recommendationsJson
          .map((j) => RecommendationApiModel.fromJson(j))
          .toList(),
      usedAi: data["usedAi"] == true,
    );
  }
}