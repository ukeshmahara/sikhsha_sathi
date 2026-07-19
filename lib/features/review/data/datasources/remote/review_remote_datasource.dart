import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';

import 'package:sikhsha_sathi/features/review/data/datasources/review_datasource.dart';
import 'package:sikhsha_sathi/features/review/data/models/review_api_model.dart';

// ================= PROVIDER =================

final reviewRemoteDatasourceProvider = Provider<IReviewRemoteDataSource>((ref) {
  return ReviewRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

// ================= IMPLEMENTATION =================

class ReviewRemoteDatasource implements IReviewRemoteDataSource {
  final ApiClient apiClient;

  ReviewRemoteDatasource({required this.apiClient});

  @override
  Future<({List<ReviewApiModel> reviews, double average, int count})>
      getSchoolReviews(String schoolId) async {
    final response = await apiClient.get(
      '${ApiEndpoints.reviews}/school/$schoolId',
    );

    final data = response.data["data"];
    final List<dynamic> reviewsJson = data["reviews"] ?? [];
    final summary = data["summary"] ?? {};

    return (
      reviews: reviewsJson.map((j) => ReviewApiModel.fromJson(j)).toList(),
      average: (summary["average"] as num?)?.toDouble() ?? 0,
      count: (summary["count"] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<ReviewApiModel> createReview({
    required String schoolId,
    required int rating,
    required String comment,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.reviews,
      data: {
        "schoolId": schoolId,
        "rating": rating,
        "comment": comment,
      },
    );

    return ReviewApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<ReviewApiModel> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
  }) async {
    final response = await apiClient.patch(
      '${ApiEndpoints.reviews}/$reviewId',
      data: {
        "rating": rating,
        "comment": comment,
      },
    );

    return ReviewApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<bool> deleteReview(String reviewId) async {
    final response = await apiClient.delete(
      '${ApiEndpoints.reviews}/$reviewId',
    );

    return response.data["success"] == true;
  }

  @override
  Future<List<TopRatedSchoolApiModel>> getTopRatedSchools({
    int limit = 10,
  }) async {
    final response = await apiClient.get(
      '${ApiEndpoints.reviews}/top-schools?limit=$limit',
    );

    final List<dynamic> data = response.data["data"] ?? [];

    return data.map((j) => TopRatedSchoolApiModel.fromJson(j)).toList();
  }
}