import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_schools_usecase.dart';
import 'package:sikhsha_sathi/features/search/presentation/pages/search_tab.dart';

class MockGetSchoolsUsecase extends Mock implements GetSchoolsUsecase {}

class FakeGetSchoolsParams extends Fake implements GetSchoolsParams {}

void main() {
  late MockGetSchoolsUsecase mockGetSchoolsUsecase;
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

  setUpAll(() {
    registerFallbackValue(FakeGetSchoolsParams());
  });

  setUp(() async {
    mockGetSchoolsUsecase = MockGetSchoolsUsecase();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        getSchoolsUsecaseProvider.overrideWithValue(mockGetSchoolsUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildSearchTab() {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: Scaffold(body: SearchTab())),
    );
  }

  testWidgets(
    'should display the search bar hint text',
    (tester) async {
      await tester.pumpWidget(buildSearchTab());
      await tester.pumpAndSettle();

      expect(find.text('Search school, keyword'), findsOneWidget);
    },
  );

  testWidgets(
    'should display the initial empty-state prompt before any search is made',
    (tester) async {
      await tester.pumpWidget(buildSearchTab());
      await tester.pumpAndSettle();

      expect(
        find.text('Search for a school by name,\nor use filters to narrow results'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should call GetSchoolsUsecase with the typed query when text is entered',
    (tester) async {
      when(() => mockGetSchoolsUsecase(any())).thenAnswer(
        (_) async => const Right(
          SchoolListResult(schools: [school], page: 1, limit: 10, total: 1, totalPages: 1),
        ),
      );

      await tester.pumpWidget(buildSearchTab());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Kathmandu');

      // the search debounces for 500ms after typing stops
      await tester.pump(const Duration(milliseconds: 600));

      final captured =
          verify(() => mockGetSchoolsUsecase(captureAny())).captured;
      final passedParams = captured.last as GetSchoolsParams;

      expect(passedParams.search, 'Kathmandu');
    },
  );

  testWidgets(
    'should display the results count once schools are found',
    (tester) async {
      when(() => mockGetSchoolsUsecase(any())).thenAnswer(
        (_) async => const Right(
          SchoolListResult(schools: [school], page: 1, limit: 10, total: 1, totalPages: 1),
        ),
      );

      await tester.pumpWidget(buildSearchTab());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Kathmandu');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('1 results found'), findsOneWidget);
      expect(find.text(school.name), findsOneWidget);
    },
  );
}