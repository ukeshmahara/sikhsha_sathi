import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_category_counts_usecase.dart';

class MockSchoolRepository extends Mock implements ISchoolRepository {}

void main() {
  late GetCategoryCountsUsecase usecase;
  late MockSchoolRepository repository;

  setUp(() {
    repository = MockSchoolRepository();
    usecase = GetCategoryCountsUsecase(schoolRepository: repository);
  });

  const counts = {
    'international': 4,
    'public': 0,
    'private': 5,
    'budget_friendly': 2,
  };

  test(
    'should return category counts map when the repository call succeeds',
    () async {
      // arrange
      when(() => repository.getCategoryCounts())
          .thenAnswer((_) async => const Right(counts));

      // act
      final result = await usecase.call();

      // assert
      expect(result, const Right(counts));
      verify(() => repository.getCategoryCounts()).called(1);
    },
  );

  test(
    'should return Failure when the repository call fails',
    () async {
      // arrange
      when(() => repository.getCategoryCounts()).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Failed to fetch category counts')),
      );

      // act
      final result = await usecase.call();

      // assert
      expect(
        result,
        Left(ApiFailure(message: 'Failed to fetch category counts')),
      );
      verify(() => repository.getCategoryCounts()).called(1);
    },
  );
}