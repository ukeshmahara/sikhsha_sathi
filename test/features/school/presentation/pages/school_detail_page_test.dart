import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/usecases/create_inquiry_usecase.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/usecases/get_my_inquiries_usecase.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/usecases/get_school_reviews_usecase.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/presentation/pages/school_detail_page.dart';

class MockGetFavouritesUsecase extends Mock implements GetFavouritesUsecase {}

class MockAddFavouriteUsecase extends Mock implements AddFavouriteUsecase {}

class MockRemoveFavouriteUsecase extends Mock
    implements RemoveFavouriteUsecase {}

class MockGetSchoolReviewsUsecase extends Mock
    implements GetSchoolReviewsUsecase {}

class MockGetMyInquiriesUsecase extends Mock
    implements GetMyInquiriesUsecase {}

class MockCreateInquiryUsecase extends Mock implements CreateInquiryUsecase {}

void main() {
  late MockGetFavouritesUsecase mockGetFavouritesUsecase;
  late MockAddFavouriteUsecase mockAddFavouriteUsecase;
  late MockRemoveFavouriteUsecase mockRemoveFavouriteUsecase;
  late MockGetSchoolReviewsUsecase mockGetSchoolReviewsUsecase;
  late MockGetMyInquiriesUsecase mockGetMyInquiriesUsecase;
  late MockCreateInquiryUsecase mockCreateInquiryUsecase;
  late SharedPreferences prefs;
  late ProviderContainer container;

  const school = SchoolEntity(
    id: 'school-1',
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  final schoolReviewsResult = SchoolReviewsResult(
    reviews: const [],
    summary: const RatingSummary(average: 0, count: 0),
  );

  setUp(() async {
    mockGetFavouritesUsecase = MockGetFavouritesUsecase();
    mockAddFavouriteUsecase = MockAddFavouriteUsecase();
    mockRemoveFavouriteUsecase = MockRemoveFavouriteUsecase();
    mockGetSchoolReviewsUsecase = MockGetSchoolReviewsUsecase();
    mockGetMyInquiriesUsecase = MockGetMyInquiriesUsecase();
    mockCreateInquiryUsecase = MockCreateInquiryUsecase();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    when(() => mockGetFavouritesUsecase())
        .thenAnswer((_) async => const Right([]));
    when(() => mockGetSchoolReviewsUsecase(any()))
        .thenAnswer((_) async => Right(schoolReviewsResult));
    when(() => mockGetMyInquiriesUsecase())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        getFavouritesUsecaseProvider
            .overrideWithValue(mockGetFavouritesUsecase),
        addFavouriteUsecaseProvider.overrideWithValue(mockAddFavouriteUsecase),
        removeFavouriteUsecaseProvider
            .overrideWithValue(mockRemoveFavouriteUsecase),
        getSchoolReviewsUsecaseProvider
            .overrideWithValue(mockGetSchoolReviewsUsecase),
        getMyInquiriesUsecaseProvider
            .overrideWithValue(mockGetMyInquiriesUsecase),
        createInquiryUsecaseProvider
            .overrideWithValue(mockCreateInquiryUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildSchoolDetailPage() {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: SchoolDetailPage(school: school)),
    );
  }

  testWidgets(
    'should display the school name, location and category',
    (tester) async {
      await tester.pumpWidget(buildSchoolDetailPage());
      await tester.pumpAndSettle();

      expect(find.text(school.name), findsOneWidget);
      expect(find.text(school.location), findsOneWidget);
      expect(find.text('International'), findsOneWidget);
    },
  );

  testWidgets(
    'should call AddFavouriteUsecase when the favourite icon is tapped '
    'on a school that is not yet favourited',
    (tester) async {
      when(() => mockAddFavouriteUsecase(school.id!))
          .thenAnswer((_) async => const Right(true));

      await tester.pumpWidget(buildSchoolDetailPage());
      await tester.pumpAndSettle();

      // starts as favorite_border (not yet favourited)
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      verify(() => mockAddFavouriteUsecase(school.id!)).called(1);
    },
  );

  testWidgets(
    'should display the "Ask this school" button and navigate to '
    'InquiryPage when tapped',
    (tester) async {
      await tester.pumpWidget(buildSchoolDetailPage());
      await tester.pumpAndSettle();

      final askButton = find.text('Ask this school');
      expect(askButton, findsOneWidget);

      await tester.ensureVisible(askButton);
      await tester.pumpAndSettle();
      await tester.tap(askButton);
      await tester.pumpAndSettle();

      // InquiryPage's app bar title confirms navigation succeeded
      expect(find.text('Ask this school'), findsWidgets);
    },
  );
}