import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:sikhsha_sathi/features/dashboard/presentation/pages/home_tab.dart';
import 'package:sikhsha_sathi/features/dashboard/presentation/providers/bottom_nav_provider.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:sikhsha_sathi/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:sikhsha_sathi/features/profile/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:sikhsha_sathi/features/review/domain/usecases/get_top_rated_schools_usecase.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_category_counts_usecase.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_schools_usecase.dart';

class MockGetSchoolsUsecase extends Mock implements GetSchoolsUsecase {}

class MockGetCategoryCountsUsecase extends Mock
    implements GetCategoryCountsUsecase {}

class MockGetFavouritesUsecase extends Mock implements GetFavouritesUsecase {}

class MockAddFavouriteUsecase extends Mock implements AddFavouriteUsecase {}

class MockRemoveFavouriteUsecase extends Mock
    implements RemoveFavouriteUsecase {}

class MockGetNotificationsUsecase extends Mock
    implements GetNotificationsUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockGetTopRatedSchoolsUsecase extends Mock
    implements GetTopRatedSchoolsUsecase {}

// mocktail requires a fallback value registered for ANY custom class used
// with any()/captureAny() — this was missing, which is what caused every
// test in this file to fail with "Bad state: ... registerFallbackValue
// was not previously called ..."
class FakeGetSchoolsParams extends Fake implements GetSchoolsParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGetSchoolsParams());
  });

  late MockGetSchoolsUsecase mockGetSchoolsUsecase;
  late MockGetCategoryCountsUsecase mockGetCategoryCountsUsecase;
  late MockGetFavouritesUsecase mockGetFavouritesUsecase;
  late MockAddFavouriteUsecase mockAddFavouriteUsecase;
  late MockRemoveFavouriteUsecase mockRemoveFavouriteUsecase;
  late MockGetNotificationsUsecase mockGetNotificationsUsecase;
  late MockUploadProfilePictureUsecase mockUploadProfilePictureUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockGetTopRatedSchoolsUsecase mockGetTopRatedSchoolsUsecase;
  late SharedPreferences prefs;
  late ProviderContainer container;

  setUp(() async {
    mockGetSchoolsUsecase = MockGetSchoolsUsecase();
    mockGetCategoryCountsUsecase = MockGetCategoryCountsUsecase();
    mockGetFavouritesUsecase = MockGetFavouritesUsecase();
    mockAddFavouriteUsecase = MockAddFavouriteUsecase();
    mockRemoveFavouriteUsecase = MockRemoveFavouriteUsecase();
    mockGetNotificationsUsecase = MockGetNotificationsUsecase();
    mockUploadProfilePictureUsecase = MockUploadProfilePictureUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
    mockGetTopRatedSchoolsUsecase = MockGetTopRatedSchoolsUsecase();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    // reasonable "nothing loaded yet" defaults so every viewmodel Home
    // depends on can build and load without throwing
    when(() => mockGetSchoolsUsecase(any()))
        .thenAnswer((_) async => const Right(
              SchoolListResult(schools: [], page: 1, limit: 10, total: 0, totalPages: 1),
            ));
    when(() => mockGetCategoryCountsUsecase())
        .thenAnswer((_) async => const Right({
              'international': 4,
              'public': 0,
              'private': 5,
              'budget_friendly': 2,
            }));
    when(() => mockGetFavouritesUsecase())
        .thenAnswer((_) async => const Right([]));
    when(() => mockGetNotificationsUsecase())
        .thenAnswer((_) async => const Right([]));
    when(() => mockGetTopRatedSchoolsUsecase(any()))
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        getSchoolsUsecaseProvider.overrideWithValue(mockGetSchoolsUsecase),
        getCategoryCountsUsecaseProvider
            .overrideWithValue(mockGetCategoryCountsUsecase),
        getFavouritesUsecaseProvider
            .overrideWithValue(mockGetFavouritesUsecase),
        addFavouriteUsecaseProvider.overrideWithValue(mockAddFavouriteUsecase),
        removeFavouriteUsecaseProvider
            .overrideWithValue(mockRemoveFavouriteUsecase),
        getNotificationsUsecaseProvider
            .overrideWithValue(mockGetNotificationsUsecase),
        uploadProfilePictureUsecaseProvider
            .overrideWithValue(mockUploadProfilePictureUsecase),
        getCurrentUserUsecaseProvider
            .overrideWithValue(mockGetCurrentUserUsecase),
        updateProfileUsecaseProvider
            .overrideWithValue(mockUpdateProfileUsecase),
        getTopRatedSchoolsUsecaseProvider
            .overrideWithValue(mockGetTopRatedSchoolsUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildHomeTab() {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: Scaffold(body: HomeTab())),
    );
  }

  testWidgets(
    'should display the good morning greeting',
    (tester) async {
      await tester.pumpWidget(buildHomeTab());
      await tester.pumpAndSettle();

      expect(find.text('Good morning'), findsOneWidget);
    },
  );

  testWidgets(
    'should display all 4 category chips',
    (tester) async {
      await tester.pumpWidget(buildHomeTab());
      await tester.pumpAndSettle();

      expect(find.text('International'), findsOneWidget);
      expect(find.text('Public'), findsOneWidget);
      expect(find.text('Private'), findsOneWidget);
      expect(find.text('Budget friendly'), findsOneWidget);
    },
  );

  testWidgets(
    'should display the AI school recommendation banner',
    (tester) async {
      await tester.pumpWidget(buildHomeTab());
      await tester.pumpAndSettle();

      expect(find.text('AI school recommendation'), findsOneWidget);
    },
  );

  testWidgets(
    'should switch to the Search tab (bottomNavProvider index 1) when a '
    'category chip is tapped',
    (tester) async {
      await tester.pumpWidget(buildHomeTab());
      await tester.pumpAndSettle();

      expect(container.read(bottomNavProvider), 0);

      await tester.tap(find.text('International'));
      await tester.pumpAndSettle();

      expect(container.read(bottomNavProvider), 1);
    },
  );
}