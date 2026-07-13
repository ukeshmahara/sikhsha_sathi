import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/school/domain/usecases/get_schools_usecase.dart';
import 'package:sikhsha_sathi/features/search/presentation/state/search_state.dart';

// ================= PROVIDER =================

final searchViewModelProvider =
    NotifierProvider<SearchViewModel, SearchState>(SearchViewModel.new);

// ================= VIEWMODEL =================

class SearchViewModel extends Notifier<SearchState> {
  late final GetSchoolsUsecase _getSchoolsUsecase;
  Timer? _debounce;

  @override
  SearchState build() {
    _getSchoolsUsecase = ref.read(getSchoolsUsecaseProvider);

    ref.onDispose(() {
      _debounce?.cancel();
    });

    return const SearchState();
  }

  // Called on every keystroke — waits 500ms after the user stops typing
  // before actually hitting the API, so we don't fire a request per letter.
  void onQueryChanged(String query) {
    state = state.copyWith(query: query);

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _runSearch();
    });
  }

  void setCategory(String category) {
    final newCategory = state.selectedCategory == category ? '' : category;
    state = state.copyWith(selectedCategory: newCategory);
    _runSearch();
  }

  void setStream(String stream) {
    final newStream = state.selectedStream == stream ? '' : stream;
    state = state.copyWith(selectedStream: newStream);
    _runSearch();
  }

  void clearFilters() {
    state = state.copyWith(selectedCategory: '', selectedStream: '');
    _runSearch();
  }

  void clearQuery() {
    state = state.copyWith(query: '');
    _runSearch();
  }

  Future<void> _runSearch() async {
    // an empty query with no filters means nothing has been searched yet —
    // don't hit the API, just show the initial empty state
    if (state.query.trim().isEmpty && !state.hasActiveFilters) {
      state = state.copyWith(status: SearchStatus.initial, results: []);
      return;
    }

    state = state.copyWith(status: SearchStatus.loading, errorMessage: null);

    final params = GetSchoolsParams(
      page: 1,
      limit: 20,
      search: state.query.trim(),
      category: state.selectedCategory,
      stream: state.selectedStream,
    );

    final result = await _getSchoolsUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: SearchStatus.loaded,
        results: data.schools,
      ),
    );
  }
}