import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/review/domain/usecases/create_review_usecase.dart';
import 'package:sikhsha_sathi/features/review/domain/usecases/delete_review_usecase.dart';
import 'package:sikhsha_sathi/features/review/domain/usecases/update_review_usecase.dart';
import 'package:sikhsha_sathi/features/review/presentation/state/review_action_state.dart';
import 'package:sikhsha_sathi/features/review/presentation/providers/reviews_for_school_provider.dart';

final reviewActionViewModelProvider =
    NotifierProvider<ReviewActionViewModel, ReviewActionState>(
  ReviewActionViewModel.new,
);

class ReviewActionViewModel extends Notifier<ReviewActionState> {
  late final CreateReviewUsecase _createReviewUsecase;
  late final UpdateReviewUsecase _updateReviewUsecase;
  late final DeleteReviewUsecase _deleteReviewUsecase;

  @override
  ReviewActionState build() {
    _createReviewUsecase = ref.read(createReviewUsecaseProvider);
    _updateReviewUsecase = ref.read(updateReviewUsecaseProvider);
    _deleteReviewUsecase = ref.read(deleteReviewUsecaseProvider);

    return const ReviewActionState();
  }

  Future<bool> submitReview({
    required String schoolId,
    required int rating,
    required String comment,
  }) async {
    state = state.copyWith(
      status: ReviewActionStatus.submitting,
      errorMessage: null,
    );

    final result = await _createReviewUsecase(
      CreateReviewParams(schoolId: schoolId, rating: rating, comment: comment),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ReviewActionStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ReviewActionStatus.success);
        // refresh this school's review list so the new review shows immediately
        ref.invalidate(reviewsForSchoolProvider(schoolId));
        return true;
      },
    );
  }

  Future<bool> editReview({
    required String reviewId,
    required String schoolId,
    required int rating,
    required String comment,
  }) async {
    state = state.copyWith(
      status: ReviewActionStatus.submitting,
      errorMessage: null,
    );

    final result = await _updateReviewUsecase(
      UpdateReviewParams(reviewId: reviewId, rating: rating, comment: comment),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ReviewActionStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ReviewActionStatus.success);
        ref.invalidate(reviewsForSchoolProvider(schoolId));
        return true;
      },
    );
  }

  Future<bool> removeReview({
    required String reviewId,
    required String schoolId,
  }) async {
    state = state.copyWith(
      status: ReviewActionStatus.submitting,
      errorMessage: null,
    );

    final result = await _deleteReviewUsecase(reviewId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ReviewActionStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ReviewActionStatus.success);
        ref.invalidate(reviewsForSchoolProvider(schoolId));
        return true;
      },
    );
  }

  void resetState() {
    state = const ReviewActionState();
  }
}