import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/remove_favourite_usecase.dart';

class MockFavouriteRepository extends Mock implements IFavouriteRepository {}

void main() {
  late RemoveFavouriteUsecase usecase;
  late MockFavouriteRepository repository;

  setUp(() {
    repository = MockFavouriteRepository();
    usecase = RemoveFavouriteUsecase(favouriteRepository: repository);
  });

  const schoolId = 'school-1';

  test(
    'should return true when the school is removed from favourites successfully',
    () async {
      // arrange
      when(() => repository.removeFavourite(schoolId))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await usecase.call(schoolId);

      // assert
      expect(result, const Right(true));
      verify(() => repository.removeFavourite(schoolId)).called(1);
    },
  );

  test(
    'should return Failure when removing the favourite fails',
    () async {
      // arrange
      when(() => repository.removeFavourite(schoolId)).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Could not remove favourite')),
      );

      // act
      final result = await usecase.call(schoolId);

      // assert
      expect(result, Left(ApiFailure(message: 'Could not remove favourite')));
      verify(() => repository.removeFavourite(schoolId)).called(1);
    },
  );
}