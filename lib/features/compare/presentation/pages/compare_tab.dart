import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/features/compare/presentation/state/compare_state.dart';
import 'package:sikhsha_sathi/features/compare/presentation/view_model/compare_view_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/presentation/view_model/school_view_model.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class CompareTab extends ConsumerWidget {
  const CompareTab({super.key});

  String? _imageUrl(String? image) {
    if (image == null || image.isEmpty) return null;
    final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
    return '$domain$image';
  }

  Map<String, Color> _categoryColors(String category) {
    switch (category) {
      case 'international':
        return {'bg': const Color(0xFFEEEDFE), 'text': const Color(0xFF3C3489)};
      case 'public':
        return {'bg': const Color(0xFFEAF3DE), 'text': const Color(0xFF27500A)};
      case 'private':
        return {'bg': const Color(0xFFE6F1FB), 'text': const Color(0xFF0C447C)};
      case 'budget_friendly':
        return {'bg': const Color(0xFFFAEEDA), 'text': const Color(0xFF854F0B)};
      default:
        return {'bg': Colors.grey.shade100, 'text': Colors.grey.shade700};
    }
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'international':
        return 'International';
      case 'public':
        return 'Public';
      case 'private':
        return 'Private';
      case 'budget_friendly':
        return 'Budget friendly';
      default:
        return category;
    }
  }

  String _streamLabel(String stream) {
    switch (stream) {
      case 'science':
        return 'Science';
      case 'management':
        return 'Management';
      case 'humanities':
        return 'Humanities';
      default:
        return stream;
    }
  }

  String _formatFees(double fees) {
    final wholeNumber = fees.toStringAsFixed(0);
    final buffer = StringBuffer();

    for (int i = 0; i < wholeNumber.length; i++) {
      final positionFromEnd = wholeNumber.length - i;
      buffer.write(wholeNumber[i]);

      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  void _openSchoolPicker(
    BuildContext context,
    WidgetRef ref,
    bool isFirstSlot,
  ) {
    final schoolState = ref.read(schoolViewModelProvider);
    final compareState = ref.read(compareViewModelProvider);

    // don't let the same school be picked for both slots
    final otherSelectedId = isFirstSlot
        ? compareState.school2?.id
        : compareState.school1?.id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            final availableSchools = schoolState.schools
                .where((s) => s.id != otherSelectedId)
                .toList();

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Select a school',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: availableSchools.isEmpty
                      ? const Center(child: Text('No schools available'))
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          itemCount: availableSchools.length,
                          itemBuilder: (context, index) {
                            final school = availableSchools[index];
                            final imageUrl = _imageUrl(school.image);

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _pickerPlaceholder(),
                                      )
                                    : _pickerPlaceholder(),
                              ),
                              title: Text(
                                school.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                school.location,
                                style: const TextStyle(fontSize: 11),
                              ),
                              onTap: () {
                                if (isFirstSlot) {
                                  ref
                                      .read(compareViewModelProvider.notifier)
                                      .selectSchool1(school);
                                } else {
                                  ref
                                      .read(compareViewModelProvider.notifier)
                                      .selectSchool2(school);
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _pickerPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      color: Colors.grey.shade200,
      child: Icon(Icons.school, size: 20, color: Colors.grey.shade400),
    );
  }

  Widget _buildSlot({
    required BuildContext context,
    required WidgetRef ref,
    required SchoolEntity? school,
    required bool isFirstSlot,
  }) {
    if (school == null) {
      return GestureDetector(
        onTap: () => _openSchoolPicker(context, ref, isFirstSlot),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 20, color: Colors.grey.shade500),
              const SizedBox(height: 4),
              Text(
                isFirstSlot ? 'Add first school' : 'Add second school',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    final imageUrl = _imageUrl(school.image);

    return GestureDetector(
      onTap: () => _openSchoolPicker(context, ref, isFirstSlot),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 70,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _slotPlaceholder(),
                    )
                  : _slotPlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                school.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotPlaceholder() {
    return Container(
      height: 70,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Icon(Icons.school, size: 26, color: Colors.grey.shade400),
    );
  }

  Widget _buildRow(String label, Widget value1, Widget value2, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: value1),
              const SizedBox(width: 8),
              Expanded(child: value2),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareState = ref.watch(compareViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              color: _kPrimaryBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compare schools',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pick two schools to compare side by side',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SELECTOR ROW
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildSlot(
                            context: context,
                            ref: ref,
                            school: compareState.school1,
                            isFirstSlot: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSlot(
                            context: context,
                            ref: ref,
                            school: compareState.school2,
                            isFirstSlot: false,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // COMPARISON TABLE — only once both schools picked
                    if (compareState.isComplete) ...[
                      _buildComparisonTable(compareState),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => ref
                              .read(compareViewModelProvider.notifier)
                              .reset(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPrimaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Change schools',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'Select two schools above to see a\nside by side comparison',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable(CompareState compareState) {
    final school1 = compareState.school1!;
    final school2 = compareState.school2!;
    final categoryColors1 = _categoryColors(school1.category);
    final categoryColors2 = _categoryColors(school2.category);

    // lower fees = better value, highlight whichever is cheaper
    final school1IsCheaper = school1.fees < school2.fees;
    final school2IsCheaper = school2.fees < school1.fees;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow(
            'Location',
            Text(school1.location, style: const TextStyle(fontSize: 12)),
            Text(school2.location, style: const TextStyle(fontSize: 12)),
          ),
          _buildRow(
            'Category',
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: categoryColors1['bg'],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _categoryLabel(school1.category),
                style: TextStyle(fontSize: 10, color: categoryColors1['text']),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: categoryColors2['bg'],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _categoryLabel(school2.category),
                style: TextStyle(fontSize: 10, color: categoryColors2['text']),
              ),
            ),
          ),
          _buildRow(
            'Annual fee',
            Row(
              children: [
                Text(
                  'Rs ${_formatFees(school1.fees)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: school1IsCheaper
                        ? const Color(0xFF27500A)
                        : Colors.black87,
                  ),
                ),
                if (school1IsCheaper) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check, size: 13, color: Color(0xFF27500A)),
                ],
              ],
            ),
            Row(
              children: [
                Text(
                  'Rs ${_formatFees(school2.fees)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: school2IsCheaper
                        ? const Color(0xFF27500A)
                        : Colors.black87,
                  ),
                ),
                if (school2IsCheaper) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check, size: 13, color: Color(0xFF27500A)),
                ],
              ],
            ),
          ),
          _buildRow(
            'Streams offered',
            Text(
              school1.streamsOffered.isEmpty
                  ? '-'
                  : school1.streamsOffered.map(_streamLabel).join(', '),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              school2.streamsOffered.isEmpty
                  ? '-'
                  : school2.streamsOffered.map(_streamLabel).join(', '),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          _buildRow(
            'Facilities',
            Text(
              school1.facilities.isEmpty ? '-' : school1.facilities.join(', '),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              school2.facilities.isEmpty ? '-' : school2.facilities.join(', '),
              style: const TextStyle(fontSize: 12),
            ),
            last: true,
          ),
        ],
      ),
    );
  }
}