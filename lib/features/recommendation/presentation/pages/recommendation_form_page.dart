import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/recommendation/presentation/pages/recommendation_results_page.dart';
import 'package:sikhsha_sathi/features/recommendation/presentation/state/recommendation_state.dart';
import 'package:sikhsha_sathi/features/recommendation/presentation/view_model/recommendation_view_model.dart';

const Color _kPrimaryPurple = Color(0xFF7F77DD);

class RecommendationFormPage extends ConsumerStatefulWidget {
  const RecommendationFormPage({super.key});

  @override
  ConsumerState<RecommendationFormPage> createState() =>
      _RecommendationFormPageState();
}

class _RecommendationFormPageState
    extends ConsumerState<RecommendationFormPage> {
  String? _selectedStream;
  RangeValues _feeRange = const RangeValues(0, 1500000);
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  static const _streams = [
    {'value': 'science', 'label': 'Science', 'icon': Icons.science_outlined},
    {'value': 'management', 'label': 'Management', 'icon': Icons.business_center_outlined},
    {'value': 'humanities', 'label': 'Humanities', 'icon': Icons.menu_book_outlined},
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedStream == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a stream first')),
      );
      return;
    }

    await ref.read(recommendationViewModelProvider.notifier).getRecommendations(
          stream: _selectedStream!,
          minFee: _feeRange.start,
          maxFee: _feeRange.end,
          location: _locationController.text.trim(),
          notes: _notesController.text.trim(),
        );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RecommendationResultsPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendationState = ref.watch(recommendationViewModelProvider);
    final isLoading =
        recommendationState.status == RecommendationStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendation'),
        backgroundColor: _kPrimaryPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _kPrimaryPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: _kPrimaryPurple),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tell us what you\'re looking for, and our AI will pick the best matching schools for you.',
                      style: TextStyle(
                        fontSize: 13,
                        color: _kPrimaryPurple.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Preferred stream',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _streams.map((stream) {
                final isSelected = _selectedStream == stream['value'];
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedStream = stream['value'] as String;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? _kPrimaryPurple : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          stream['icon'] as IconData,
                          size: 18,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          stream['label'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Budget range',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rs ${_feeRange.start.toStringAsFixed(0)} — Rs ${_feeRange.end.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            RangeSlider(
              values: _feeRange,
              min: 0,
              max: 1500000,
              divisions: 20,
              activeColor: _kPrimaryPurple,
              labels: RangeLabels(
                'Rs ${_feeRange.start.toStringAsFixed(0)}',
                'Rs ${_feeRange.end.toStringAsFixed(0)}',
              ),
              onChanged: (values) => setState(() => _feeRange = values),
            ),

            const SizedBox(height: 12),

            const Text(
              'Preferred location (optional)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'e.g. Kathmandu, Lalitpur',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Anything else? (optional)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: 'e.g. I want good sports facilities and a hostel',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _submit,
                icon: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome, color: Colors.white),
                label: Text(
                  isLoading ? 'Finding schools...' : 'Get AI recommendations',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}