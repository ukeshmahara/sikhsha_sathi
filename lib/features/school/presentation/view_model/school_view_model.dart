import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/school/domain/usecases/get_category_counts_usecase.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_schools_usecase.dart';
import 'package:sikhsha_sathi/features/school/presentation/state/school_state.dart';

// ================= PROVIDER =================

final schoolViewModelProvider =
    NotifierProvider<SchoolViewModel, SchoolState>(SchoolViewModel.new);

// ================= VIEWMODEL =================

class SchoolViewModel extends Notifier<SchoolState> {
  late GetSchoolsUsecase _getSchoolsUsecase;
  late GetCategoryCountsUsecase _getCategoryCountsUsecase;

  @override
  SchoolState build() {
    _getSchoolsUsecase = ref.read(getSchoolsUsecaseProvider);
    _getCategoryCountsUsecase = ref.read(getCategoryCountsUsecaseProvider);

    return const SchoolState();
  }

  Future<void> loadSchools({bool reset = false}) async {
    state = state.copyWith(status: SchoolStatus.loading, errorMessage: null);

    final params = GetSchoolsParams(
      page: reset ? 1 : state.page,
      limit: 10,
      search: state.searchQuery,
      category: state.selectedCategory,
    );

    final result = await _getSchoolsUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: SchoolStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: SchoolStatus.loaded,
        schools: data.schools,
        page: data.page,
        totalPages: data.totalPages,
      ),
    );
  }

  Future<void> loadCategoryCounts() async {
    final result = await _getCategoryCountsUsecase();

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (counts) => state = state.copyWith(categoryCounts: counts),
    );
  }

  void selectCategory(String category) {
    // tapping the same category again clears the filter
    final newCategory = state.selectedCategory == category ? '' : category;

    state = state.copyWith(selectedCategory: newCategory, page: 1);
    loadSchools(reset: true);
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query, page: 1);
    loadSchools(reset: true);
  }

  void nextPage() {
    if (state.page < state.totalPages) {
      state = state.copyWith(page: state.page + 1);
      loadSchools();
    }
  }
}