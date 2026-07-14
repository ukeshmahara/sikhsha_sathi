import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<SchoolEntity> results;
  final String query;
  final String selectedCategory; // '' means no category filter
  final String selectedStream; // '' means no stream filter
  final double? minFee;
  final double? maxFee;
  final String sortOption; // '' | 'fees_asc' | 'fees_desc' | 'name_asc'
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.query = '',
    this.selectedCategory = '',
    this.selectedStream = '',
    this.minFee,
    this.maxFee,
    this.sortOption = '',
    this.errorMessage,
  });

  bool get hasActiveFilters =>
      selectedCategory.isNotEmpty ||
      selectedStream.isNotEmpty ||
      minFee != null ||
      maxFee != null ||
      sortOption.isNotEmpty;

  SearchState copyWith({
    SearchStatus? status,
    List<SchoolEntity>? results,
    String? query,
    String? selectedCategory,
    String? selectedStream,
    double? minFee,
    double? maxFee,
    String? sortOption,
    bool clearFeeRange = false,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedStream: selectedStream ?? this.selectedStream,
      minFee: clearFeeRange ? null : (minFee ?? this.minFee),
      maxFee: clearFeeRange ? null : (maxFee ?? this.maxFee),
      sortOption: sortOption ?? this.sortOption,
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
        minFee,
        maxFee,
        sortOption,
        errorMessage,
      ];
}