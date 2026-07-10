import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:sikhsha_sathi/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:sikhsha_sathi/features/school/presentation/pages/school_detail_page.dart';
import 'package:sikhsha_sathi/features/school/presentation/state/school_state.dart';
import 'package:sikhsha_sathi/features/school/presentation/view_model/school_view_model.dart';
import 'package:sikhsha_sathi/features/school/presentation/widgets/school_card.dart';

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
    });
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
          color: isSelected ? _kPrimaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.grey.shade500,
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
  }) {
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final schoolState = ref.watch(schoolViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
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
                // BLUE HEADER
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 44),
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
                          const Text(
                            'Good morning',
                            style: TextStyle(
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
                      _buildProfileAvatar(context, ref),
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
                        // FLOATING SEARCH BAR
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                child: TextField(
                                  onSubmitted: (value) {
                                    ref
                                        .read(schoolViewModelProvider.notifier)
                                        .search(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search school, keyword',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 20,
                                      color: Colors.grey.shade500,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
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

                        const SizedBox(height: 14),

                        // LOCATION
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: _kPrimaryBlue,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Kathmandu, Nepal',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // CATEGORY CHIPS — scrollable, no "All" chip
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
                                  label: 'International',
                                  count: schoolState.categoryCounts[
                                          'international'] ??
                                      0,
                                  isSelected: schoolState.selectedCategory ==
                                      'international',
                                  onTap: () => ref
                                      .read(schoolViewModelProvider.notifier)
                                      .selectCategory('international'),
                                ),
                                _buildCategoryChip(
                                  icon: Icons.account_balance,
                                  label: 'Public',
                                  count: schoolState.categoryCounts['public'] ??
                                      0,
                                  isSelected:
                                      schoolState.selectedCategory == 'public',
                                  onTap: () => ref
                                      .read(schoolViewModelProvider.notifier)
                                      .selectCategory('public'),
                                ),
                                _buildCategoryChip(
                                  icon: Icons.business,
                                  label: 'Private',
                                  count:
                                      schoolState.categoryCounts['private'] ??
                                          0,
                                  isSelected: schoolState.selectedCategory ==
                                      'private',
                                  onTap: () => ref
                                      .read(schoolViewModelProvider.notifier)
                                      .selectCategory('private'),
                                ),
                                _buildCategoryChip(
                                  icon: Icons.monetization_on,
                                  label: 'Budget friendly',
                                  count: schoolState.categoryCounts[
                                          'budget_friendly'] ??
                                      0,
                                  isSelected: schoolState.selectedCategory ==
                                      'budget_friendly',
                                  onTap: () => ref
                                      .read(schoolViewModelProvider.notifier)
                                      .selectCategory('budget_friendly'),
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
                          title: 'AI school recommendation',
                          subtitle: 'Get suggestions based on your needs',
                          textColor: const Color(0xFF3C3489),
                        ),

                        // AI CHATBOT BANNER
                        _buildAiBanner(
                          bg: const Color(0xFFE6F1FB),
                          iconBg: const Color(0xFF378ADD),
                          icon: Icons.chat_bubble_outline,
                          title: 'AI school assistant',
                          subtitle: 'Ask anything about schools',
                          textColor: const Color(0xFF0C447C),
                        ),

                        const SizedBox(height: 12),

                        // SCHOOL LIST HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              schoolState.selectedCategory.isEmpty
                                  ? 'All schools'
                                  : 'Filtered schools',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (schoolState.selectedCategory.isNotEmpty)
                              TextButton(
                                onPressed: () => ref
                                    .read(schoolViewModelProvider.notifier)
                                    .selectCategory(
                                      schoolState.selectedCategory,
                                    ),
                                child: const Text(
                                  'Clear filter',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _kPrimaryBlue,
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  // TODO: navigate to Search tab with full list once built
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

                        // SCHOOL LIST — full-width vertical cards
                        _buildSchoolList(schoolState),
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

  Widget _buildSchoolList(SchoolState schoolState) {
    if (schoolState.status == SchoolStatus.loading &&
        schoolState.schools.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (schoolState.status == SchoolStatus.error &&
        schoolState.schools.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Text(
              schoolState.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref
                  .read(schoolViewModelProvider.notifier)
                  .loadSchools(reset: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (schoolState.schools.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text('No schools found')),
      );
    }

    return Column(
      children: schoolState.schools.map((school) {
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
      }).toList(),
    );
  }
}