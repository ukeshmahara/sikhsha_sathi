import 'package:sikhsha_sathi/features/recommendation/data/models/recommendation_api_model.dart';

abstract interface class IRecommendationRemoteDataSource {
  Future<({List<RecommendationApiModel> recommendations, bool usedAi})>
      getRecommendations({
    required String stream,
    required double minFee,
    required double maxFee,
    String? location,
    String? notes,
  });
}