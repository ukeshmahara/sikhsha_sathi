import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/usecases/get_top_rated_schools_usecase.dart';

// keyed by limit, so Home (small limit) and the "See all" page (larger
// limit) get their own independently-cached results
final topRatedSchoolsProvider =
    FutureProvider.family<List<TopRatedSchool>, int>((ref, limit) async {
  final usecase = ref.read(getTopRatedSchoolsUsecaseProvider);
  final result = await usecase(limit);

  return result.fold(
    (failure) => throw failure,
    (data) => data,
  );
});