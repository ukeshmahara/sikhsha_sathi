import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:sikhsha_sathi/features/school/presentation/state/school_state.dart';
import 'package:sikhsha_sathi/features/school/presentation/view_model/school_view_model.dart';

import '../widgets/category_card.dart';
import '../widgets/school_card.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();
    // load real school data once the widget mounts
    Future.microtask(() {
      ref.read(schoolViewModelProvider.notifier).loadSchools();
      ref.read(schoolViewModelProvider.notifier).loadCategoryCounts();
    });
  }

  Widget _buildProfileAvatar(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profilePicture = profileState.profilePicture;

    String? imageUrl;
    if (profilePicture != null && profilePicture.isNotEmpty) {
      final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
      imageUrl = '$domain$profilePicture'; // backend already returns "/uploads/<filename>"
    }

    return GestureDetector(
      onTap: () {
        // TODO: navigate to Profile tab if desired
      },
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        child: imageUrl == null
            ? const Icon(
                Icons.person,
                color: Colors.blue,
                size: 26,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schoolState = ref.watch(schoolViewModelProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(schoolViewModelProvider.notifier).loadSchools(reset: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BLUE SECTION
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Ukesh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Find the best school for you',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    _buildProfileAvatar(context, ref),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SEARCH
                    Row(
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
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: const Icon(Icons.tune),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // LOCATION
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Kathmandu, Nepal',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // CATEGORY — now tappable and connected to backend categories
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => ref
                                .read(schoolViewModelProvider.notifier)
                                .selectCategory('international'),
                            child: CategoryCard(
                              image: 'assets/images/international_school.png',
                              title:
                                  'International Schools (${schoolState.categoryCounts['international'] ?? 0})',
                              color: schoolState.selectedCategory ==
                                      'international'
                                  ? Colors.blue.shade700
                                  : Colors.blue,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ref
                                .read(schoolViewModelProvider.notifier)
                                .selectCategory('public'),
                            child: CategoryCard(
                              image: 'assets/images/public_school.png',
                              title:
                                  'Public Schools (${schoolState.categoryCounts['public'] ?? 0})',
                              color: schoolState.selectedCategory == 'public'
                                  ? Colors.green.shade700
                                  : Colors.green,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ref
                                .read(schoolViewModelProvider.notifier)
                                .selectCategory('budget_friendly'),
                            child: CategoryCard(
                              image: 'assets/images/budget_friendly.png',
                              title:
                                  'Budget Friendly (${schoolState.categoryCounts['budget_friendly'] ?? 0})',
                              color: schoolState.selectedCategory ==
                                      'budget_friendly'
                                  ? Colors.purple.shade700
                                  : Colors.purple,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ref
                                .read(schoolViewModelProvider.notifier)
                                .selectCategory('private'),
                            child: CategoryCard(
                              image: 'assets/images/top_rated.png',
                              title:
                                  'Private Schools (${schoolState.categoryCounts['private'] ?? 0})',
                              color: schoolState.selectedCategory == 'private'
                                  ? Colors.orange.shade700
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // SCHOOL LIST HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          schoolState.selectedCategory.isEmpty
                              ? 'All Schools'
                              : 'Filtered Schools',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (schoolState.selectedCategory.isNotEmpty)
                          TextButton(
                            onPressed: () => ref
                                .read(schoolViewModelProvider.notifier)
                                .selectCategory(schoolState.selectedCategory),
                            child: const Text('Clear filter'),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // SCHOOL LIST — loading / error / data states
                    _buildSchoolList(schoolState),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolList(SchoolState schoolState) {
    if (schoolState.status == SchoolStatus.loading &&
        schoolState.schools.isEmpty) {
      return const SizedBox(
        height: 230,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (schoolState.status == SchoolStatus.error &&
        schoolState.schools.isEmpty) {
      return SizedBox(
        height: 230,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(schoolState.errorMessage ?? 'Something went wrong'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref
                    .read(schoolViewModelProvider.notifier)
                    .loadSchools(reset: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (schoolState.schools.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text('No schools found')),
      );
    }

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: schoolState.schools.length,
        itemBuilder: (context, index) {
          final school = schoolState.schools[index];
          return SchoolCard(
            school: school,
            onTap: () {
              // TODO: navigate to school detail page once built
            },
          );
        },
      ),
    );
  }
}