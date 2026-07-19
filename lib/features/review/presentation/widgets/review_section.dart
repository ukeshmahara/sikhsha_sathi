import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/presentation/state/review_action_state.dart';
import 'package:sikhsha_sathi/features/review/presentation/view_model/review_action_view_model.dart';
import 'package:sikhsha_sathi/features/review/presentation/providers/reviews_for_school_provider.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);
const Color _kStarColor = Color(0xFFFFA726);

class ReviewSection extends ConsumerWidget {
  final String schoolId;

  const ReviewSection({super.key, required this.schoolId});

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 30) return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    if (difference.inDays >= 1) return '${difference.inDays}d ago';
    if (difference.inHours >= 1) return '${difference.inHours}h ago';
    if (difference.inMinutes >= 1) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  Widget _stars(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final halfFilled = !filled && index < rating;
        return Icon(
          halfFilled ? Icons.star_half : (filled ? Icons.star : Icons.star_border),
          size: size,
          color: _kStarColor,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsForSchoolProvider(schoolId));
    final currentUserId = ref.read(userSessionServiceProvider).getUserId();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showReviewFormSheet(context, ref),
              icon: const Icon(Icons.rate_review_outlined, size: 16),
              label: const Text('Write a review'),
              style: TextButton.styleFrom(foregroundColor: _kPrimaryBlue),
            ),
          ],
        ),
        const SizedBox(height: 10),
        reviewsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Could not load reviews',
              style: TextStyle(color: context.appTextSecondary, fontSize: 13),
            ),
          ),
          data: (result) => _buildLoaded(context, ref, result, currentUserId),
        ),
      ],
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    WidgetRef ref,
    SchoolReviewsResult result,
    String? currentUserId,
  ) {
    if (result.reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No reviews yet — be the first to share your experience.',
          style: TextStyle(color: context.appTextSecondary, fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RATING SUMMARY
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: context.appSurfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                result.summary.average.toStringAsFixed(1),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stars(result.summary.average, size: 18),
                  const SizedBox(height: 2),
                  Text(
                    '${result.summary.count} review${result.summary.count == 1 ? '' : 's'}',
                    style: TextStyle(fontSize: 12, color: context.appTextSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),

        // REVIEW LIST
        ...result.reviews.map((review) {
          final isMine = currentUserId != null && review.studentId == currentUserId;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.appBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            review.studentName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isMine) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: _kPrimaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'You',
                                style: TextStyle(fontSize: 9, color: _kPrimaryBlue),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isMine)
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            size: 18, color: context.appTextSecondary),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showReviewFormSheet(
                              context,
                              ref,
                              existingReview: review,
                            );
                          } else if (value == 'delete') {
                            _confirmDelete(context, ref, review);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _stars(review.rating.toDouble(), size: 14),
                    const SizedBox(width: 8),
                    Text(
                      _timeAgo(review.createdAt),
                      style: TextStyle(fontSize: 11, color: context.appTextSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  review.comment,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ReviewEntity review) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete review?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref
                  .read(reviewActionViewModelProvider.notifier)
                  .removeReview(reviewId: review.id, schoolId: schoolId);

              if (!success && context.mounted) {
                final message =
                    ref.read(reviewActionViewModelProvider).errorMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message ?? 'Could not delete review')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReviewFormSheet(
    BuildContext context,
    WidgetRef ref, {
    ReviewEntity? existingReview,
  }) {
    final commentController =
        TextEditingController(text: existingReview?.comment ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        int selectedRating = existingReview?.rating ?? 5;

        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final actionState = ref.watch(reviewActionViewModelProvider);
            final isSubmitting =
                actionState.status == ReviewActionStatus.submitting;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existingReview != null ? 'Edit your review' : 'Write a review',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return GestureDetector(
                          onTap: () => setSheetState(() => selectedRating = starValue),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              starValue <= selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 36,
                              color: _kStarColor,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Share your experience with this school...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final comment = commentController.text.trim();
                              if (comment.length < 2) {
                                ScaffoldMessenger.of(sheetContext).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please write a short comment'),
                                  ),
                                );
                                return;
                              }

                              final notifier =
                                  ref.read(reviewActionViewModelProvider.notifier);

                              final success = existingReview != null
                                  ? await notifier.editReview(
                                      reviewId: existingReview.id,
                                      schoolId: schoolId,
                                      rating: selectedRating,
                                      comment: comment,
                                    )
                                  : await notifier.submitReview(
                                      schoolId: schoolId,
                                      rating: selectedRating,
                                      comment: comment,
                                    );

                              if (success && sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              } else if (sheetContext.mounted) {
                                final message = ref
                                    .read(reviewActionViewModelProvider)
                                    .errorMessage;
                                ScaffoldMessenger.of(sheetContext).showSnackBar(
                                  SnackBar(
                                    content: Text(message ?? 'Could not submit review'),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPrimaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              existingReview != null ? 'Update review' : 'Submit review',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}