import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/usecases/get_school_reviews_usecase.dart';

// Riverpod caches one result per schoolId automatically. When a review is
// created/updated/deleted, ReviewActionViewModel calls
// ref.invalidate(reviewsForSchoolProvider(schoolId)) to force a fresh fetch.
final reviewsForSchoolProvider =
    FutureProvider.family<SchoolReviewsResult, String>((ref, schoolId) async {
  final usecase = ref.read(getSchoolReviewsUsecaseProvider);
  final result = await usecase(schoolId);

  return result.fold(
    (failure) => throw failure,
    (data) => data,
  );
});