import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/favourite/data/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/state/favourite_state.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class MockGetFavouritesUsecase extends Mock implements GetFavouritesUsecase {}

class MockAddFavouriteUsecase extends Mock implements AddFavouriteUsecase {}

class MockRemoveFavouriteUsecase extends Mock
    implements RemoveFavouriteUsecase {}

class MockFavouriteRepository extends Mock implements IFavouriteRepository {}

void main() {
  late MockGetFavouritesUsecase mockGetFavouritesUsecase;
  late MockAddFavouriteUsecase mockAddFavouriteUsecase;
  late MockRemoveFavouriteUsecase mockRemoveFavouriteUsecase;
  late MockFavouriteRepository mockFavouriteRepository;
  late ProviderContainer container;

  const school = SchoolEntity(
    id: 'school-1',
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  const favourite = FavouriteEntity(id: 'fav-1', school: school);

  setUp(() {
    mockGetFavouritesUsecase = MockGetFavouritesUsecase();
    mockAddFavouriteUsecase = MockAddFavouriteUsecase();
    mockRemoveFavouriteUsecase = MockRemoveFavouriteUsecase();
    mockFavouriteRepository = MockFavouriteRepository();

    container = ProviderContainer(
      overrides: [
        getFavouritesUsecaseProvider
            .overrideWithValue(mockGetFavouritesUsecase),
        addFavouriteUsecaseProvider.overrideWithValue(mockAddFavouriteUsecase),
        removeFavouriteUsecaseProvider
            .overrideWithValue(mockRemoveFavouriteUsecase),
        favouriteRepositoryProvider.overrideWithValue(mockFavouriteRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state should be FavouriteState.initial', () {
    final state = container.read(favouriteViewModelProvider);

    expect(state, const FavouriteState());
    expect(state.status, FavouriteStatus.initial);
    expect(state.favourites, isEmpty);
    expect(state.errorMessage, isNull);
  });

  test(
    'should update state to loaded with favourites when loadFavourites succeeds',
    () async {
      when(() => mockGetFavouritesUsecase())
          .thenAnswer((_) async => const Right([favourite]));

      await container.read(favouriteViewModelProvider.notifier).loadFavourites();

      final state = container.read(favouriteViewModelProvider);

      expect(state.status, FavouriteStatus.loaded);
      expect(state.favourites, [favourite]);
    },
  );

  test(
    'should update state to error when loadFavourites fails',
    () async {
      when(() => mockGetFavouritesUsecase()).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Could not load favourites')),
      );

      await container.read(favouriteViewModelProvider.notifier).loadFavourites();

      final state = container.read(favouriteViewModelProvider);

      expect(state.status, FavouriteStatus.error);
      expect(state.errorMessage, 'Could not load favourites');
    },
  );

  test(
    'toggleFavourite should call AddFavouriteUsecase and add the school '
    'locally when it is not already favourited',
    () async {
      when(() => mockAddFavouriteUsecase(school.id!))
          .thenAnswer((_) async => const Right(true));

      final notifier = container.read(favouriteViewModelProvider.notifier);
      final success = await notifier.toggleFavourite(school);

      final state = container.read(favouriteViewModelProvider);

      expect(success, true);
      expect(state.isFavourite(school.id!), true);
      verify(() => mockAddFavouriteUsecase(school.id!)).called(1);
      verifyNever(() => mockRemoveFavouriteUsecase(any()));
    },
  );

  test(
    'toggleFavourite should call RemoveFavouriteUsecase and remove the '
    'school locally when it is already favourited',
    () async {
      // seed the state with an existing favourite first
      when(() => mockGetFavouritesUsecase())
          .thenAnswer((_) async => const Right([favourite]));
      await container.read(favouriteViewModelProvider.notifier).loadFavourites();

      when(() => mockRemoveFavouriteUsecase(school.id!))
          .thenAnswer((_) async => const Right(true));

      final notifier = container.read(favouriteViewModelProvider.notifier);
      final success = await notifier.toggleFavourite(school);

      final state = container.read(favouriteViewModelProvider);

      expect(success, true);
      expect(state.isFavourite(school.id!), false);
      verify(() => mockRemoveFavouriteUsecase(school.id!)).called(1);
      verifyNever(() => mockAddFavouriteUsecase(any()));
    },
  );

  // ================= clearCache =================
  // This protects the actual bug fix: without clearCache() properly
  // wiping both the Hive cache AND the in-memory state, a new user
  // logging in on the same device (without a full app restart) would
  // briefly see the PREVIOUS user's favourited schools.

  test(
    'clearCache should call repository.clearLocalCache and reset state '
    'back to FavouriteState.initial',
    () async {
      // put the viewmodel in a "logged in with favourites" state first,
      // simulating a real user session before logout
      when(() => mockGetFavouritesUsecase())
          .thenAnswer((_) async => const Right([favourite]));
      await container.read(favouriteViewModelProvider.notifier).loadFavourites();

      expect(
        container.read(favouriteViewModelProvider).favourites,
        isNotEmpty,
      );

      when(() => mockFavouriteRepository.clearLocalCache())
          .thenAnswer((_) async {});

      await container.read(favouriteViewModelProvider.notifier).clearCache();

      final state = container.read(favouriteViewModelProvider);

      // state must be back to a completely fresh FavouriteState — not
      // just an empty favourites list, but every field reset to initial
      expect(state, const FavouriteState());
      expect(state.favourites, isEmpty);
      expect(state.status, FavouriteStatus.initial);
      verify(() => mockFavouriteRepository.clearLocalCache()).called(1);
    },
  );
}