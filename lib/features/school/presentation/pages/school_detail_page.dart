import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class SchoolDetailPage extends ConsumerWidget {
  final SchoolEntity school;

  const SchoolDetailPage({super.key, required this.school});

  String? get _imageUrl {
    if (school.image == null || school.image!.isEmpty) return null;

    final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
    return '$domain${school.image}'; // backend already returns "/uploads/<filename>"
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'international':
        return 'International';
      case 'public':
        return 'Public';
      case 'private':
        return 'Private';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteState = ref.watch(favouriteViewModelProvider);
    final isFavourite =
        school.id != null && favouriteState.isFavourite(school.id!);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.blue,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              if (school.id != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () async {
                      final success = await ref
                          .read(favouriteViewModelProvider.notifier)
                          .toggleFavourite(school);

                      if (!success && context.mounted) {
                        final errorMessage =
                            ref.read(favouriteViewModelProvider).errorMessage;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              errorMessage ?? 'Could not update favourite',
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _imageUrl != null
                  ? Image.network(
                      _imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _headerPlaceholder(),
                    )
                  : _headerPlaceholder(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME + CATEGORY
                  Text(
                    school.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          school.location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // CATEGORY + FEES ROW
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _categoryLabel(school.category),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Rs ${school.fees.toStringAsFixed(0)}/year',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // STREAMS OFFERED
                  if (school.streamsOffered.isNotEmpty) ...[
                    const Text(
                      'Streams offered',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: school.streamsOffered
                          .map(
                            (stream) => Chip(
                              label: Text(_streamLabel(stream)),
                              backgroundColor: Colors.purple.shade50,
                              labelStyle: TextStyle(
                                color: Colors.purple.shade700,
                                fontSize: 13,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // DESCRIPTION
                  if (school.description != null &&
                      school.description!.isNotEmpty) ...[
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      school.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // FACILITIES
                  if (school.facilities.isNotEmpty) ...[
                    const Text(
                      'Facilities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: school.facilities
                          .map(
                            (facility) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Colors.green.shade700,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    facility,
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // CONTACT INFO
                  if (school.contactPhone != null ||
                      school.contactEmail != null ||
                      school.contactWebsite != null) ...[
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (school.contactPhone != null &&
                        school.contactPhone!.isNotEmpty)
                      _contactRow(Icons.phone, school.contactPhone!),
                    if (school.contactEmail != null &&
                        school.contactEmail!.isNotEmpty)
                      _contactRow(Icons.email, school.contactEmail!),
                    if (school.contactWebsite != null &&
                        school.contactWebsite!.isNotEmpty)
                      _contactRow(Icons.language, school.contactWebsite!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerPlaceholder() {
    return Container(
      color: Colors.blue.shade100,
      child: Icon(
        Icons.school,
        size: 80,
        color: Colors.blue.shade300,
      ),
    );
  }

  Widget _contactRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}