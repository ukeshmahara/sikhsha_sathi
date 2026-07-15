import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/app/locale/app_strings.dart';
import 'package:sikhsha_sathi/app/locale/locale_state.dart';
import 'package:sikhsha_sathi/app/locale/locale_view_model.dart';
import 'package:sikhsha_sathi/app/theme/app_colors.dart';
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

  String _categoryLabel(String category, AppLanguage lang) {
    switch (category) {
      case 'international':
        return AppStrings.get('international', lang);
      case 'public':
        return AppStrings.get('public', lang);
      case 'private':
        return AppStrings.get('private', lang);
      default:
        return category;
    }
  }

  String _streamLabel(String stream, AppLanguage lang) {
    switch (stream) {
      case 'science':
        return AppStrings.get('science', lang);
      case 'management':
        return AppStrings.get('management', lang);
      case 'humanities':
        return AppStrings.get('humanities', lang);
      default:
        return stream;
    }
  }

  // Formats 1500000 -> "1,500,000" without needing the intl package
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteState = ref.watch(favouriteViewModelProvider);
    final isFavourite =
        school.id != null && favouriteState.isFavourite(school.id!);
    final lang = ref.watch(localeViewModelProvider).language;

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
                              errorMessage ??
                                  AppStrings.get('couldNotUpdateFavourite', lang),
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
                      errorBuilder: (errorContext, error, stackTrace) =>
                          _headerPlaceholder(context),
                    )
                  : _headerPlaceholder(context),
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
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: context.appTextSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          school.location,
                          style: TextStyle(
                            color: context.appTextSecondary,
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
                          _categoryLabel(school.category, lang),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Rs ${_formatFees(school.fees)}${AppStrings.get('perYear', lang)}',
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
                    Text(
                      AppStrings.get('streamsOffered', lang),
                      style: const TextStyle(
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
                              label: Text(_streamLabel(stream, lang)),
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
                    Text(
                      AppStrings.get('about', lang),
                      style: const TextStyle(
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
                    Text(
                      AppStrings.get('facilities', lang),
                      style: const TextStyle(
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
                    Text(
                      AppStrings.get('contact', lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (school.contactPhone != null &&
                        school.contactPhone!.isNotEmpty)
                      _contactRow(context, Icons.phone, school.contactPhone!),
                    if (school.contactEmail != null &&
                        school.contactEmail!.isNotEmpty)
                      _contactRow(context, Icons.email, school.contactEmail!),
                    if (school.contactWebsite != null &&
                        school.contactWebsite!.isNotEmpty)
                      _contactRow(context, Icons.language, school.contactWebsite!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerPlaceholder(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: Icon(
        Icons.school,
        size: 80,
        color: Colors.blue.shade300,
      ),
    );
  }

  Widget _contactRow(BuildContext context, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.appTextSecondary),
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