import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/compare/presentation/pages/compare_tab.dart';
import 'package:sikhsha_sathi/features/compare/presentation/view_model/compare_view_model.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_schools_usecase.dart';
import 'package:sikhsha_sathi/features/school/presentation/view_model/school_view_model.dart';

class MockGetSchoolsUsecase extends Mock implements GetSchoolsUsecase {}

class FakeGetSchoolsParams extends Fake implements GetSchoolsParams {}

void main() {
  late MockGetSchoolsUsecase mockGetSchoolsUsecase;
  late SharedPreferences prefs;
  late ProviderContainer container;

  const school1 = SchoolEntity(
    id: 'school-1',
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  const school2 = SchoolEntity(
    id: 'school-2',
    name: 'KMC',
    location: 'Lalitpur',
    category: 'private',
    streamsOffered: ['management'],
    fees: 350000,
  );

  setUpAll(() {
    registerFallbackValue(FakeGetSchoolsParams());
  });

  setUp(() async {
    mockGetSchoolsUsecase = MockGetSchoolsUsecase();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    when(() => mockGetSchoolsUsecase(any())).thenAnswer(
      (_) async => const Right(
        SchoolListResult(
          schools: [school1, school2],
          page: 1,
          limit: 10,
          total: 2,
          totalPages: 1,
        ),
      ),
    );

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        getSchoolsUsecaseProvider.overrideWithValue(mockGetSchoolsUsecase),
      ],
    );

    // seed the school list so the picker sheet has something to show —
    // CompareTab itself never triggers loadSchools(), it just reads
    // whatever Home/Search already loaded into the shared SchoolViewModel
    await container.read(schoolViewModelProvider.notifier).loadSchools();
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildCompareTab() {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: CompareTab()),
    );
  }

  testWidgets(
    'should display the empty-state prompt when no schools are selected',
    (tester) async {
      await tester.pumpWidget(buildCompareTab());
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Select two schools above to see a\nside by side comparison',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should open the school picker and select school1 when the first '
    'empty slot is tapped',
    (tester) async {
      await tester.pumpWidget(buildCompareTab());
      await tester.pumpAndSettle();

      // tap the first empty slot ("Add first school")
      await tester.tap(find.text('Add first school'));
      await tester.pumpAndSettle();

      // the picker bottom sheet should now show both seeded schools
      expect(find.text('Select a school'), findsOneWidget);
      expect(find.text(school1.name), findsOneWidget);
      expect(find.text(school2.name), findsOneWidget);

      // tap the first school in the list
      await tester.tap(find.text(school1.name));
      await tester.pumpAndSettle();

      // the viewmodel's state should now reflect that selection
      final compareState = container.read(compareViewModelProvider);
      expect(compareState.school1, school1);

      // and the slot itself should now show the selected school's name
      // instead of the "Add first school" placeholder
      expect(find.text(school1.name), findsOneWidget);
      expect(find.text('Add first school'), findsNothing);
    },
  );
}