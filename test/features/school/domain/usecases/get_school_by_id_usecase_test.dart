import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_school_by_id_usecase.dart';

class MockSchoolRepository extends Mock implements ISchoolRepository {}

void main() {
  late GetSchoolByIdUsecase usecase;
  late MockSchoolRepository repository;

  setUp(() {
    repository = MockSchoolRepository();
    usecase = GetSchoolByIdUsecase(schoolRepository: repository);
  });

  const schoolId = 'school-1';

  const school = SchoolEntity(
    id: schoolId,
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  test(
    'should return SchoolEntity when the school exists',
    () async {
      // arrange
      when(() => repository.getSchoolById(schoolId))
          .thenAnswer((_) async => const Right(school));

      // act
      final result = await usecase.call(schoolId);

      // assert
      expect(result, const Right(school));
      verify(() => repository.getSchoolById(schoolId)).called(1);
    },
  );

  test(
    'should return Failure when the school does not exist',
    () async {
      // arrange
      when(() => repository.getSchoolById(schoolId)).thenAnswer(
        (_) async => Left(ApiFailure(message: 'School not found')),
      );

      // act
      final result = await usecase.call(schoolId);

      // assert
      expect(result, Left(ApiFailure(message: 'School not found')));
      verify(() => repository.getSchoolById(schoolId)).called(1);
    },
  );
}