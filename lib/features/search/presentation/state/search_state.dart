import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<SchoolEntity> results;
  final String query;
  final String selectedCategory; // '' means no category filter
  final String selectedStream; // '' means no stream filter
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.query = '',
    this.selectedCategory = '',
    this.selectedStream = '',
    this.errorMessage,
  });

  bool get hasActiveFilters =>
      selectedCategory.isNotEmpty || selectedStream.isNotEmpty;

  SearchState copyWith({
    SearchStatus? status,
    List<SchoolEntity>? results,
    String? query,
    String? selectedCategory,
    String? selectedStream,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedStream: selectedStream ?? this.selectedStream,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        results,
        query,
        selectedCategory,
        selectedStream,
        errorMessage,
      ];
}