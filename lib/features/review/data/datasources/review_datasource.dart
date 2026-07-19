import 'package:sikhsha_sathi/features/review/data/models/review_api_model.dart';

abstract interface class IReviewRemoteDataSource {
  Future<({List<ReviewApiModel> reviews, double average, int count})>
      getSchoolReviews(String schoolId);

  Future<ReviewApiModel> createReview({
    required String schoolId,
    required int rating,
    required String comment,
  });

  Future<ReviewApiModel> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
  });

  Future<bool> deleteReview(String reviewId);

  Future<List<TopRatedSchoolApiModel>> getTopRatedSchools({int limit = 10});
}