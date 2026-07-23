import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/repositories/review_repository.dart';
import 'package:sikhsha_sathi/features/review/domain/usecases/get_school_reviews_usecase.dart';

class MockReviewRepository extends Mock implements IReviewRepository {}

void main() {
  late GetSchoolReviewsUsecase usecase;
  late MockReviewRepository repository;

  setUp(() {
    repository = MockReviewRepository();
    usecase = GetSchoolReviewsUsecase(reviewRepository: repository);
  });

  const schoolId = 'school-1';

  final review = ReviewEntity(
    id: 'review-1',
    studentId: 'student-1',
    studentName: 'Ukesh Mahara',
    rating: 5,
    comment: 'Great school with excellent facilities.',
    createdAt: DateTime(2026, 7, 1),
  );

  final result = SchoolReviewsResult(
    reviews: [review],
    summary: const RatingSummary(average: 5.0, count: 1),
  );

  test(
    'should return SchoolReviewsResult with reviews and rating summary '
    'when the repository call succeeds',
    () async {
      // arrange
      when(() => repository.getSchoolReviews(schoolId))
          .thenAnswer((_) async => Right(result));

      // act
      final response = await usecase.call(schoolId);

      // assert
      expect(response, Right(result));
      verify(() => repository.getSchoolReviews(schoolId)).called(1);
    },
  );

  test(
    'should return Failure when the repository call fails',
    () async {
      // arrange
      when(() => repository.getSchoolReviews(schoolId)).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Failed to fetch reviews')),
      );

      // act
      final response = await usecase.call(schoolId);

      // assert
      expect(response, Left(ApiFailure(message: 'Failed to fetch reviews')));
      verify(() => repository.getSchoolReviews(schoolId)).called(1);
    },
  );
}