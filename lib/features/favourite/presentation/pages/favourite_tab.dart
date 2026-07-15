import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/app/locale/app_strings.dart';
import 'package:sikhsha_sathi/app/locale/locale_state.dart';
import 'package:sikhsha_sathi/app/locale/locale_view_model.dart';
import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/state/favourite_state.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:sikhsha_sathi/features/school/presentation/pages/school_detail_page.dart';

class FavouriteTab extends ConsumerStatefulWidget {
  const FavouriteTab({super.key});

  @override
  ConsumerState<FavouriteTab> createState() => _FavouriteTabState();
}

class _FavouriteTabState extends ConsumerState<FavouriteTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(favouriteViewModelProvider.notifier).loadFavourites();
    });
  }

  String? _imageUrl(String? image) {
    if (image == null || image.isEmpty) return null;
    final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
    return '$domain$image';
  }

  // Category badge colors, matching the Home tab category chips
  Map<String, Color> _categoryColors(String category) {
    switch (category) {
      case 'international':
        return {'bg': const Color(0xFFEEEDFE), 'text': const Color(0xFF3C3489)};
      case 'public':
        return {'bg': const Color(0xFFEAF3DE), 'text': const Color(0xFF27500A)};
      case 'private':
        return {'bg': const Color(0xFFE6F1FB), 'text': const Color(0xFF0C447C)};
      default:
        return {'bg': Colors.grey.shade100, 'text': Colors.grey.shade700};
    }
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
  Widget build(BuildContext context) {
    final favouriteState = ref.watch(favouriteViewModelProvider);
    final count = favouriteState.favourites.length;
    final lang = ref.watch(localeViewModelProvider).language;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            decoration: BoxDecoration(
              color: context.appSurface,
              border: Border(
                bottom: BorderSide(color: context.appBorder),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.get('favourites', lang),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: context.appTextPrimary,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDEBEC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 13,
                            color: Color(0xFFA32D2D),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA32D2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.get('schoolsSavedForQuickAccess', lang),
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(favouriteViewModelProvider.notifier)
                    .loadFavourites();
              },
              child: _buildBody(favouriteState, lang),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(FavouriteState favouriteState, AppLanguage lang) {
    if (favouriteState.status == FavouriteStatus.loading &&
        favouriteState.favourites.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favouriteState.status == FavouriteStatus.error &&
        favouriteState.favourites.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              favouriteState.errorMessage ??
                  AppStrings.get('somethingWentWrong', lang),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () => ref
                  .read(favouriteViewModelProvider.notifier)
                  .loadFavourites(),
              child: Text(AppStrings.get('retry', lang)),
            ),
          ),
        ],
      );
    }

    if (favouriteState.favourites.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: context.appSurfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 32,
                color: context.appTextSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              AppStrings.get('noFavouritesYet', lang),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.appTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppStrings.get('tapHeartToSave', lang),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: context.appTextSecondary,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: favouriteState.favourites.length,
      itemBuilder: (context, index) {
        final favourite = favouriteState.favourites[index];
        final school = favourite.school;
        final imageUrl = _imageUrl(school.image);
        final categoryColors = _categoryColors(school.category);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.appBorder),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SchoolDetailPage(school: school),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _thumbnailPlaceholder(),
                        )
                      : _thumbnailPlaceholder(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        school.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 11,
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
                              _categoryLabel(school.category, lang),
                              style: TextStyle(
                                fontSize: 10,
                                color: categoryColors['text'],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Rs ${_formatFees(school.fees)}${AppStrings.get('perYearShort', lang)}',
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
                GestureDetector(
                  onTap: school.id == null
                      ? null
                      : () async {
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
                                      AppStrings.get(
                                          'couldNotRemoveFavourite', lang),
                                ),
                              ),
                            );
                          }
                        },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDEBEC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 15,
                      color: Color(0xFFA32D2D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: context.appSurfaceMuted,
      child: Icon(Icons.school, size: 24, color: context.appTextSecondary),
    );
  }
}