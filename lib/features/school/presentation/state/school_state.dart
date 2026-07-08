import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

enum SchoolStatus { initial, loading, loaded, error }

class SchoolState extends Equatable {
  final SchoolStatus status;
  final List<SchoolEntity> schools;
  final Map<String, int> categoryCounts;
  final String selectedCategory; // '' means "All"
  final String searchQuery;
  final int page;
  final int totalPages;
  final String? errorMessage;

  const SchoolState({
    this.status = SchoolStatus.initial,
    this.schools = const [],
    this.categoryCounts = const {},
    this.selectedCategory = '',
    this.searchQuery = '',
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  SchoolState copyWith({
    SchoolStatus? status,
    List<SchoolEntity>? schools,
    Map<String, int>? categoryCounts,
    String? selectedCategory,
    String? searchQuery,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return SchoolState(
      status: status ?? this.status,
      schools: schools ?? this.schools,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        schools,
        categoryCounts,
        selectedCategory,
        searchQuery,
        page,
        totalPages,
        errorMessage,
      ];
}