import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/add_favourite_usecase.dart';

class MockFavouriteRepository extends Mock implements IFavouriteRepository {}

void main() {
  late AddFavouriteUsecase usecase;
  late MockFavouriteRepository repository;

  setUp(() {
    repository = MockFavouriteRepository();
    usecase = AddFavouriteUsecase(favouriteRepository: repository);
  });

  const schoolId = 'school-1';

  test(
    'should return true when the school is added to favourites successfully',
    () async {
      // arrange
      when(() => repository.addFavourite(schoolId))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await usecase.call(schoolId);

      // assert
      expect(result, const Right(true));
      verify(() => repository.addFavourite(schoolId)).called(1);
    },
  );

  test(
    'should return Failure when adding the favourite fails',
    () async {
      // arrange
      when(() => repository.addFavourite(schoolId)).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Could not add favourite')),
      );

      // act
      final result = await usecase.call(schoolId);

      // assert
      expect(result, Left(ApiFailure(message: 'Could not add favourite')));
      verify(() => repository.addFavourite(schoolId)).called(1);
    },
  );
}