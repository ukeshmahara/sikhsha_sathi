import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/pages/favourite_tab.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class MockGetFavouritesUsecase extends Mock implements GetFavouritesUsecase {}

class MockAddFavouriteUsecase extends Mock implements AddFavouriteUsecase {}

class MockRemoveFavouriteUsecase extends Mock
    implements RemoveFavouriteUsecase {}

void main() {
  late MockGetFavouritesUsecase mockGetFavouritesUsecase;
  late MockAddFavouriteUsecase mockAddFavouriteUsecase;
  late MockRemoveFavouriteUsecase mockRemoveFavouriteUsecase;

  const school = SchoolEntity(
    id: 'school-1',
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  const favourite = FavouriteEntity(id: 'fav-1', school: school);

  setUp(() async {
    mockGetFavouritesUsecase = MockGetFavouritesUsecase();
    mockAddFavouriteUsecase = MockAddFavouriteUsecase();
    mockRemoveFavouriteUsecase = MockRemoveFavouriteUsecase();

    // LocaleViewModel and UserSessionService both read SharedPreferences
    // under the hood — give them a clean, real (but empty) instance so
    // the app defaults to English with no crash on startup.
    SharedPreferences.setMockInitialValues({});
  });

  Widget commonMaterialApp() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(home: SizedBox());
        }

        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(snapshot.data!),
            getFavouritesUsecaseProvider
                .overrideWithValue(mockGetFavouritesUsecase),
            addFavouriteUsecaseProvider
                .overrideWithValue(mockAddFavouriteUsecase),
            removeFavouriteUsecaseProvider
                .overrideWithValue(mockRemoveFavouriteUsecase),
          ],
          child: const MaterialApp(home: Scaffold(body: FavouriteTab())),
        );
      },
    );
  }

  testWidgets(
    'should display Favourites title and empty state when there are no favourites',
    (tester) async {
      when(() => mockGetFavouritesUsecase())
          .thenAnswer((_) async => const Right([]));

      await tester.pumpWidget(commonMaterialApp());
      await tester.pumpAndSettle();

      expect(find.text('Favourites'), findsOneWidget);
      expect(find.text('No favourites yet'), findsOneWidget);
    },
  );

  testWidgets(
    'should display a favourited school and call RemoveFavouriteUsecase '
    'when the heart icon is tapped',
    (tester) async {
      when(() => mockGetFavouritesUsecase())
          .thenAnswer((_) async => const Right([favourite]));
      when(() => mockRemoveFavouriteUsecase(school.id!))
          .thenAnswer((_) async => const Right(true));

      await tester.pumpWidget(commonMaterialApp());
      await tester.pumpAndSettle();

      expect(find.text(school.name), findsOneWidget);

      // the removable heart button is the only Icons.favorite wrapped in
      // a GestureDetector — the count badge at the top uses the same
      // icon but isn't tappable, so this finder targets the right one
      final heartButton = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byIcon(Icons.favorite),
      );

      expect(heartButton, findsOneWidget);

      await tester.tap(heartButton);
      await tester.pumpAndSettle();

      verify(() => mockRemoveFavouriteUsecase(school.id!)).called(1);
    },
  );
}