import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/recommendation/domain/usecases/get_recommendations_usecase.dart';
import 'package:sikhsha_sathi/features/recommendation/presentation/state/recommendation_state.dart';

final recommendationViewModelProvider =
    NotifierProvider<RecommendationViewModel, RecommendationState>(
  RecommendationViewModel.new,
);

class RecommendationViewModel extends Notifier<RecommendationState> {
  late GetRecommendationsUsecase _getRecommendationsUsecase;

  @override
  RecommendationState build() {
    _getRecommendationsUsecase = ref.read(getRecommendationsUsecaseProvider);
    return const RecommendationState();
  }

  Future<void> getRecommendations({
    required String stream,
    required double minFee,
    required double maxFee,
    String? location,
    String? notes,
  }) async {
    state = state.copyWith(
      status: RecommendationStatus.loading,
      errorMessage: null,
    );

    final result = await _getRecommendationsUsecase(
      GetRecommendationsParams(
        stream: stream,
        minFee: minFee,
        maxFee: maxFee,
        location: location,
        notes: notes,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: RecommendationStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: RecommendationStatus.loaded,
        recommendations: data.recommendations,
        usedAi: data.usedAi,
      ),
    );
  }

  void reset() {
    state = const RecommendationState();
  }
}