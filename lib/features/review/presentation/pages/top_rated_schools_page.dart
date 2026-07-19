import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/features/review/presentation/providers/top_rated_schools_provider.dart';
import 'package:sikhsha_sathi/features/school/presentation/pages/school_detail_page.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class TopRatedSchoolsPage extends ConsumerWidget {
  const TopRatedSchoolsPage({super.key});

  String? _imageUrl(String? image) {
    if (image == null || image.isEmpty) return null;
    final domain = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');
    return '$domain$image';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topRatedAsync = ref.watch(topRatedSchoolsProvider(50));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top rated schools'),
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
      ),
      body: topRatedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Could not load top rated schools',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (schools) {
          if (schools.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No ratings yet — be the first to review a school!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final entry = schools[index];
              final school = entry.school;
              final imageUrl = _imageUrl(school.image);
              final rank = index + 1;

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
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text(
                          '$rank',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: rank <= 3
                                ? const Color(0xFF854F0B)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _placeholder(),
                              )
                            : _placeholder(),
                      ),
                      const SizedBox(width: 10),
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
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 13, color: Color(0xFFEF9F27)),
                                const SizedBox(width: 3),
                                Text(
                                  entry.average.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${entry.count} review${entry.count == 1 ? '' : 's'})',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
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
            },
          );
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 46,
      height: 46,
      color: Colors.grey.shade200,
      child: Icon(Icons.school, size: 20, color: Colors.grey.shade400),
    );
  }
}