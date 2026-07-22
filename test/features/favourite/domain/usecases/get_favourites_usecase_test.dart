import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class MockFavouriteRepository extends Mock implements IFavouriteRepository {}

void main() {
  late GetFavouritesUsecase usecase;
  late MockFavouriteRepository repository;

  setUp(() {
    repository = MockFavouriteRepository();
    usecase = GetFavouritesUsecase(favouriteRepository: repository);
  });

  const school = SchoolEntity(
    id: 'school-1',
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  const favourites = [
    FavouriteEntity(id: 'fav-1', school: school),
  ];

  test(
    'should return a list of FavouriteEntity when fetched successfully',
    () async {
      // arrange
      when(() => repository.getFavourites())
          .thenAnswer((_) async => const Right(favourites));

      // act
      final result = await usecase.call();

      // assert
      expect(result, const Right(favourites));
      verify(() => repository.getFavourites()).called(1);
    },
  );

  test(
    'should return Failure when fetching favourites fails',
    () async {
      // arrange
      when(() => repository.getFavourites()).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Could not load favourites')),
      );

      // act
      final result = await usecase.call();

      // assert
      expect(result, Left(ApiFailure(message: 'Could not load favourites')));
      verify(() => repository.getFavourites()).called(1);
    },
  );
}