import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/app/locale/app_strings.dart';
import 'package:sikhsha_sathi/app/locale/locale_state.dart';
import 'package:sikhsha_sathi/app/locale/locale_view_model.dart';
import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/features/chatbot/presentation/pages/chatbot_page.dart';
import 'package:sikhsha_sathi/features/dashboard/presentation/providers/bottom_nav_provider.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:sikhsha_sathi/features/notification/presentation/pages/notification_page.dart';
import 'package:sikhsha_sathi/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:sikhsha_sathi/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:sikhsha_sathi/features/recommendation/presentation/pages/recommendation_form_page.dart';
import 'package:sikhsha_sathi/features/review/presentation/pages/top_rated_schools_page.dart';
import 'package:sikhsha_sathi/features/review/presentation/providers/top_rated_schools_provider.dart';
import 'package:sikhsha_sathi/features/school/presentation/pages/school_detail_page.dart';
import 'package:sikhsha_sathi/features/school/presentation/view_model/school_view_model.dart';
import 'package:sikhsha_sathi/features/search/presentation/view_model/search_view_model.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(schoolViewModelProvider.notifier).loadSchools();
      ref.read(schoolViewModelProvider.notifier).loadCategoryCounts();
      ref.read(favouriteViewModelProvider.notifier).loadFavourites();
      ref.read(notificationViewModelProvider.notifier).loadNotifications();
    });
  }

  Widget _buildNotificationBell(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationViewModelProvider);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationPage()),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (notificationState.unreadCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFA32D2D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kPrimaryBlue, width: 1.5),
                ),
                constraints: const BoxConstraints(minWidth: 18),
                child: Text(
                  notificationState.unreadCount > 9
                      ? '9+'
                      : '${notificationState.unreadCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profilePicture = profileState.profilePicture;

    String? imageUrl;
    if (profilePicture != null && profilePicture.isNotEmpty) {
      final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
      imageUrl = '$domain$profilePicture';
    }

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? const Icon(Icons.person, color: Colors.white, size: 18)
          : null,
    );
  }

  // Sets the tapped category on SearchViewModel then switches the bottom
  // nav to the Search tab (index 1) so the user lands there with that
  // filter already applied, instead of Home showing a second inline list.
  void _goToSearchWithCategory(WidgetRef ref, String category) {
    ref.read(searchViewModelProvider.notifier).setCategory(category);
    ref.read(bottomNavProvider.notifier).state = 1;
  }

  Widget _buildCategoryChip({
    required IconData icon,
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _kPrimaryBlue : context.appSurface,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: context.appBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : context.appTextSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : context.appTextPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : context.appTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiBanner({
    required Color bg,
    required Color iconBg,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 18, color: textColor),
        ],
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schoolState = ref.watch(schoolViewModelProvider);
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _kPrimaryBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotPage()),
          );
        },
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(schoolViewModelProvider.notifier)
                .loadSchools(reset: true);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BLUE HEADER — padding.top pushes content below the status
                // bar while the blue color itself still fills all the way
                // to the true top edge (matches the status bar icons set to
                // light/white in main.dart via SystemUiOverlayStyle)
                Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).padding.top + 14,
                    20,
                    44,
                  ),
                  decoration: const BoxDecoration(
                    color: _kPrimaryBlue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.get('goodMorning', lang),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ref.read(userSessionServiceProvider).getFullName() ??
                                'there',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildNotificationBell(context, ref),
                          const SizedBox(width: 10),
                          _buildProfileAvatar(context, ref),
                        ],
                      ),
                    ],
                  ),
                ),

                // FLOATING CONTENT — overlaps the header
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FLOATING SEARCH BAR — tap-only, navigates to Search
                        // tab rather than searching inline on Home (keeps
                        // all real searching/filtering in one place)
                        GestureDetector(
                          onTap: () {
                            ref.read(bottomNavProvider.notifier).state = 1;
                          },
                          child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.appSurface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 20,
                                        color: context.appTextSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppStrings.get('searchSchoolKeyword', lang),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: context.appTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F1FB),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.tune,
                                  size: 18,
                                  color: _kPrimaryBlue,
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // LOCATION
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: _kPrimaryBlue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              AppStrings.get('kathmanduNepal', lang),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // CATEGORY CHIPS — pure navigation shortcuts to
                        // Search tab, no chip is ever shown as "selected"
                        // here since Home itself no longer filters anything
                        Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          thickness: 3,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                _buildCategoryChip(
                                  icon: Icons.public,
                                  label: AppStrings.get('international', lang),
                                  count: schoolState.categoryCounts[
                                          'international'] ??
                                      0,
                                  isSelected: false,
                                  onTap: () => _goToSearchWithCategory(
                                    ref,
                                    'international',
                                  ),
                                ),
                                _buildCategoryChip(
                                  icon: Icons.account_balance,
                                  label: AppStrings.get('public', lang),
                                  count: schoolState.categoryCounts['public'] ??
                                      0,
                                  isSelected: false,
                                  onTap: () => _goToSearchWithCategory(
                                    ref,
                                    'public',
                                  ),
                                ),
                                _buildCategoryChip(
                                  icon: Icons.business,
                                  label: AppStrings.get('private', lang),
                                  count:
                                      schoolState.categoryCounts['private'] ??
                                          0,
                                  isSelected: false,
                                  onTap: () => _goToSearchWithCategory(
                                    ref,
                                    'private',
                                  ),
                                ),
                                _buildCategoryChip(
                                  icon: Icons.monetization_on,
                                  label: AppStrings.get('budgetFriendly', lang),
                                  count: schoolState.categoryCounts[
                                          'budget_friendly'] ??
                                      0,
                                  isSelected: false,
                                  onTap: () => _goToSearchWithCategory(
                                    ref,
                                    'budget_friendly',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // AI RECOMMENDATION BANNER
                        _buildAiBanner(
                          bg: const Color(0xFFEEEDFE),
                          iconBg: const Color(0xFF7F77DD),
                          icon: Icons.auto_awesome,
                          title: AppStrings.get('aiRecommendationTitle', lang),
                          subtitle:
                              AppStrings.get('aiRecommendationSubtitle', lang),
                          textColor: const Color(0xFF3C3489),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RecommendationFormPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // TOP RATED SCHOOLS HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 16,
                                  color: Color(0xFF854F0B),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Top rated schools',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TopRatedSchoolsPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _kPrimaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // TOP RATED SCHOOLS LIST — small preview, full list
                        // lives on TopRatedSchoolsPage via "See all"
                        _buildTopRatedSchools(ref),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRatedSchools(WidgetRef ref) {
    final topRatedAsync = ref.watch(topRatedSchoolsProvider(3));

    return topRatedAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'Could not load top rated schools',
            style: TextStyle(color: context.appTextSecondary, fontSize: 13),
          ),
        ),
      ),
      data: (schools) {
        if (schools.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No ratings yet — be the first to review a school!',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.appTextSecondary, fontSize: 13),
              ),
            ),
          );
        }

        return Column(
          children: schools.map((entry) {
            final school = entry.school;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchoolDetailPage(school: school),
                  ),
                );
              },
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
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: school.image != null && school.image!.isNotEmpty
                          ? Image.network(
                              '${ApiEndpoints.baseUrl.replaceAll('/api/v1', '')}${school.image}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _topRatedPlaceholder(),
                            )
                          : _topRatedPlaceholder(),
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
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 13, color: Color(0xFFEF9F27)),
                              const SizedBox(width: 3),
                              Text(
                                entry.average.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${entry.count} review${entry.count == 1 ? '' : 's'})',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: context.appTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs ${school.fees.toStringAsFixed(0)}/yr',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _kPrimaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _topRatedPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade200,
      child: Icon(Icons.school, size: 24, color: Colors.grey.shade400),
    );
  }
}