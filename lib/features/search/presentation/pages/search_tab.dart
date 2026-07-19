import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/features/school/presentation/pages/school_detail_page.dart';
import 'package:sikhsha_sathi/features/school/presentation/widgets/school_card.dart';
import 'package:sikhsha_sathi/features/search/presentation/state/search_state.dart';
import 'package:sikhsha_sathi/features/search/presentation/view_model/search_view_model.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const _categories = [
    {'value': 'international', 'label': 'International'},
    {'value': 'public', 'label': 'Public'},
    {'value': 'private', 'label': 'Private'},
    {'value': 'budget_friendly', 'label': 'Budget friendly'},
  ];

  static const _streams = [
    {'value': 'science', 'label': 'Science'},
    {'value': 'management', 'label': 'Management'},
    {'value': 'humanities', 'label': 'Humanities'},
  ];

  static const _sortOptions = [
    {'value': 'fees_asc', 'label': 'Price: Low to High'},
    {'value': 'fees_desc', 'label': 'Price: High to Low'},
    {'value': 'name_asc', 'label': 'Name A-Z'},
  ];

  static const double _maxPossibleFee = 2000000;

  String _categoryLabel(String value) {
    return _categories.firstWhere(
      (c) => c['value'] == value,
      orElse: () => {'label': value},
    )['label']!;
  }

  String _streamLabel(String value) {
    return _streams.firstWhere(
      (s) => s['value'] == value,
      orElse: () => {'label': value},
    )['label']!;
  }

  String _sortLabel(String value) {
    return _sortOptions.firstWhere(
      (s) => s['value'] == value,
      orElse: () => {'label': value},
    )['label']!;
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final searchState = ref.watch(searchViewModelProvider);

            return StatefulBuilder(
              builder: (context, setSheetState) {
                RangeValues currentRange = RangeValues(
                  searchState.minFee ?? 0,
                  searchState.maxFee ?? _maxPossibleFee,
                );

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.appTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Category',
                          style: TextStyle(fontSize: 12, color: context.appTextSecondary),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((cat) {
                            final isSelected =
                                searchState.selectedCategory == cat['value'];
                            return GestureDetector(
                              onTap: () => ref
                                  .read(searchViewModelProvider.notifier)
                                  .setCategory(cat['value']!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? _kPrimaryBlue : context.appSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected
                                      ? null
                                      : Border.all(color: context.appBorder),
                                ),
                                child: Text(
                                  cat['label']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : context.appTextPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Stream',
                          style: TextStyle(fontSize: 12, color: context.appTextSecondary),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _streams.map((stream) {
                            final isSelected =
                                searchState.selectedStream == stream['value'];
                            return GestureDetector(
                              onTap: () => ref
                                  .read(searchViewModelProvider.notifier)
                                  .setStream(stream['value']!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? _kPrimaryBlue : context.appSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected
                                      ? null
                                      : Border.all(color: context.appBorder),
                                ),
                                child: Text(
                                  stream['label']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : context.appTextPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fee range',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.appTextSecondary,
                              ),
                            ),
                            Text(
                              'Rs ${currentRange.start.toStringAsFixed(0)} — Rs ${currentRange.end.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: context.appTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: currentRange,
                          min: 0,
                          max: _maxPossibleFee,
                          divisions: 20,
                          activeColor: _kPrimaryBlue,
                          labels: RangeLabels(
                            'Rs ${currentRange.start.toStringAsFixed(0)}',
                            'Rs ${currentRange.end.toStringAsFixed(0)}',
                          ),
                          onChanged: (values) {
                            setSheetState(() {
                              currentRange = values;
                            });
                          },
                          onChangeEnd: (values) {
                            final isFullRange =
                                values.start == 0 && values.end == _maxPossibleFee;

                            ref.read(searchViewModelProvider.notifier).setFeeRange(
                                  isFullRange ? null : values.start,
                                  isFullRange ? null : values.end,
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sort by',
                          style: TextStyle(fontSize: 12, color: context.appTextSecondary),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _sortOptions.map((sort) {
                            final isSelected =
                                searchState.sortOption == sort['value'];
                            return GestureDetector(
                              onTap: () => ref
                                  .read(searchViewModelProvider.notifier)
                                  .setSort(sort['value']!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? _kPrimaryBlue : context.appSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected
                                      ? null
                                      : Border.all(color: context.appBorder),
                                ),
                                child: Text(
                                  sort['label']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : context.appTextPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kPrimaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 14,
                16,
                14,
              ),
              color: _kPrimaryBlue,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: false,
                        onChanged: (value) {
                          ref
                              .read(searchViewModelProvider.notifier)
                              .onQueryChanged(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search school, keyword',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: context.appTextSecondary,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: context.appTextSecondary,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (searchState.query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        color: context.appTextSecondary,
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchViewModelProvider.notifier).clearQuery();
                        },
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _openFilterSheet(context),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: _kPrimaryBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.tune, size: 13, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Filters',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (searchState.selectedCategory.isNotEmpty)
                            _activeFilterChip(
                              label: _categoryLabel(searchState.selectedCategory),
                              onRemove: () => ref
                                  .read(searchViewModelProvider.notifier)
                                  .setCategory(searchState.selectedCategory),
                            ),
                          if (searchState.selectedStream.isNotEmpty)
                            _activeFilterChip(
                              label: _streamLabel(searchState.selectedStream),
                              onRemove: () => ref
                                  .read(searchViewModelProvider.notifier)
                                  .setStream(searchState.selectedStream),
                            ),
                          if (searchState.minFee != null || searchState.maxFee != null)
                            _activeFilterChip(
                              label:
                                  'Rs ${(searchState.minFee ?? 0).toStringAsFixed(0)} — Rs ${(searchState.maxFee ?? _maxPossibleFee).toStringAsFixed(0)}',
                              onRemove: () => ref
                                  .read(searchViewModelProvider.notifier)
                                  .clearFeeRange(),
                            ),
                          if (searchState.sortOption.isNotEmpty)
                            _activeFilterChip(
                              label: _sortLabel(searchState.sortOption),
                              onRemove: () => ref
                                  .read(searchViewModelProvider.notifier)
                                  .setSort(searchState.sortOption),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildBody(searchState),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 12, color: context.appTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchState searchState) {
    if (searchState.status == SearchStatus.initial) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search, size: 40, color: context.appTextSecondary),
              const SizedBox(height: 12),
              Text(
                'Search for a school by name,\nor use filters to narrow results',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: context.appTextSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (searchState.status == SearchStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (searchState.status == SearchStatus.error) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            searchState.errorMessage ?? 'Something went wrong',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (searchState.results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 40, color: context.appTextSecondary),
              const SizedBox(height: 12),
              Text(
                'No schools found',
                style: TextStyle(fontSize: 13, color: context.appTextSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${searchState.results.length} results found',
          style: TextStyle(fontSize: 12, color: context.appTextSecondary),
        ),
        const SizedBox(height: 10),
        ...searchState.results.map((school) {
          return SchoolCard(
            school: school,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SchoolDetailPage(school: school),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}