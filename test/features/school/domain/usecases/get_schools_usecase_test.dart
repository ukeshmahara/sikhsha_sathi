import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_schools_usecase.dart';

class MockSchoolRepository extends Mock implements ISchoolRepository {}

void main() {
  late GetSchoolsUsecase usecase;
  late MockSchoolRepository repository;

  setUp(() {
    repository = MockSchoolRepository();
    usecase = GetSchoolsUsecase(schoolRepository: repository);
  });

  const school = SchoolEntity(
    id: 'school-1',
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  const result = SchoolListResult(
    schools: [school],
    page: 1,
    limit: 10,
    total: 1,
    totalPages: 1,
  );

  test(
    'should return SchoolListResult when the repository call succeeds',
    () async {
      // arrange
      when(
        () => repository.getSchools(
          page: 1,
          limit: 10,
          search: '',
          category: '',
          stream: '',
          minFee: null,
          maxFee: null,
          sort: '',
        ),
      ).thenAnswer((_) async => const Right(result));

      // act
      final response = await usecase.call(const GetSchoolsParams());

      // assert
      expect(response, const Right(result));
      verify(
        () => repository.getSchools(
          page: 1,
          limit: 10,
          search: '',
          category: '',
          stream: '',
          minFee: null,
          maxFee: null,
          sort: '',
        ),
      ).called(1);
    },
  );

  test(
    'should pass the search, category and fee params through to the repository',
    () async {
      // arrange
      when(
        () => repository.getSchools(
          page: 1,
          limit: 10,
          search: 'Kathmandu',
          category: 'international',
          stream: '',
          minFee: 50000,
          maxFee: 100000,
          sort: '',
        ),
      ).thenAnswer((_) async => const Right(result));

      // act
      final response = await usecase.call(
        const GetSchoolsParams(
          search: 'Kathmandu',
          category: 'international',
          minFee: 50000,
          maxFee: 100000,
        ),
      );

      // assert
      expect(response, const Right(result));
      verify(
        () => repository.getSchools(
          page: 1,
          limit: 10,
          search: 'Kathmandu',
          category: 'international',
          stream: '',
          minFee: 50000,
          maxFee: 100000,
          sort: '',
        ),
      ).called(1);
    },
  );

  test(
    'should return Failure when the repository call fails',
    () async {
      // arrange
      when(
        () => repository.getSchools(
          page: 1,
          limit: 10,
          search: '',
          category: '',
          stream: '',
          minFee: null,
          maxFee: null,
          sort: '',
        ),
      ).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Failed to fetch schools')),
      );

      // act
      final response = await usecase.call(const GetSchoolsParams());

      // assert
      expect(response, Left(ApiFailure(message: 'Failed to fetch schools')));
    },
  );
}