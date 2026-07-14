import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class SchoolCard extends ConsumerWidget {
  final SchoolEntity school;
  final VoidCallback? onTap;

  const SchoolCard({
    super.key,
    required this.school,
    this.onTap,
  });

  // backend already stores image as "/uploads/<filename>", so just append it to domain
  String? get _imageUrl {
    if (school.image == null || school.image!.isEmpty) return null;

    final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
    return '$domain${school.image}';
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
    final categoryColors = _categoryColors(school.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _imageUrl != null
                      ? Image.network(
                          _imageUrl!,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          errorBuilder: (errorContext, error, stackTrace) =>
                              _placeholderImage(context),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 76,
                              height: 76,
                              color: context.appSurfaceMuted,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        )
                      : _placeholderImage(context),
                ),
                if (school.id != null)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () async {
                        final success = await ref
                            .read(favouriteViewModelProvider.notifier)
                            .toggleFavourite(school);

                        if (!success && context.mounted) {
                          final errorMessage = ref
                              .read(favouriteViewModelProvider)
                              .errorMessage;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                errorMessage ??
                                    'Could not update favourite',
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          size: 11,
                          color: const Color(0xFFA32D2D),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    school.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 10,
                        color: context.appTextSecondary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          school.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.appTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColors['bg'],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _categoryLabel(school.category),
                          style: TextStyle(
                            fontSize: 10,
                            color: categoryColors['text'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Rs ${_formatFees(school.fees)}/yr',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF185FA5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      color: context.appSurfaceMuted,
      child: Icon(
        Icons.school,
        size: 28,
        color: context.appTextSecondary,
      ),
    );
  }
}