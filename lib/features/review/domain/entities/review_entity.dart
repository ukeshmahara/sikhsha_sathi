import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String studentId;
  final String studentName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, studentId, studentName, rating, comment, createdAt];
}

class RatingSummary extends Equatable {
  final double average;
  final int count;

  const RatingSummary({
    this.average = 0,
    this.count = 0,
  });

  @override
  List<Object?> get props => [average, count];
}

class SchoolReviewsResult extends Equatable {
  final List<ReviewEntity> reviews;
  final RatingSummary summary;

  const SchoolReviewsResult({
    required this.reviews,
    required this.summary,
  });

  @override
  List<Object?> get props => [reviews, summary];
}