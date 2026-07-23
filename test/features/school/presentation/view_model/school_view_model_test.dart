import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_category_counts_usecase.dart';
import 'package:sikhsha_sathi/features/school/domain/usecases/get_schools_usecase.dart';
import 'package:sikhsha_sathi/features/school/presentation/state/school_state.dart';
import 'package:sikhsha_sathi/features/school/presentation/view_model/school_view_model.dart';

class MockGetSchoolsUsecase extends Mock implements GetSchoolsUsecase {}

class MockGetCategoryCountsUsecase extends Mock
    implements GetCategoryCountsUsecase {}

// GetSchoolsParams isn't Equatable, so a bare `any()` is used when
// stubbing/verifying calls, and the actual argument passed each time is
// captured and inspected field-by-field instead of comparing whole objects.
class FakeGetSchoolsParams extends Fake implements GetSchoolsParams {}

void main() {
  late MockGetSchoolsUsecase mockGetSchoolsUsecase;
  late MockGetCategoryCountsUsecase mockGetCategoryCountsUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeGetSchoolsParams());
  });

  const school = SchoolEntity(
    id: 'school-1',
    name: 'Kathmandu International School',
    location: 'Guheshwori, Kathmandu',
    category: 'international',
    streamsOffered: ['science'],
    fees: 80000,
  );

  const successResult = SchoolListResult(
    schools: [school],
    page: 1,
    limit: 10,
    total: 1,
    totalPages: 3,
  );

  setUp(() {
    mockGetSchoolsUsecase = MockGetSchoolsUsecase();
    mockGetCategoryCountsUsecase = MockGetCategoryCountsUsecase();

    container = ProviderContainer(
      overrides: [
        getSchoolsUsecaseProvider.overrideWithValue(mockGetSchoolsUsecase),
        getCategoryCountsUsecaseProvider
            .overrideWithValue(mockGetCategoryCountsUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state should be SchoolState.initial', () {
    final state = container.read(schoolViewModelProvider);

    expect(state, const SchoolState());
    expect(state.status, SchoolStatus.initial);
    expect(state.schools, isEmpty);
  });

  test(
    'loadSchools should update state to loaded with schools and pagination info',
    () async {
      when(() => mockGetSchoolsUsecase(any()))
          .thenAnswer((_) async => const Right(successResult));

      await container.read(schoolViewModelProvider.notifier).loadSchools();

      final state = container.read(schoolViewModelProvider);

      expect(state.status, SchoolStatus.loaded);
      expect(state.schools, [school]);
      expect(state.totalPages, 3);
    },
  );

  test(
    'loadSchools should update state to error when the usecase fails',
    () async {
      when(() => mockGetSchoolsUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Failed to fetch schools')),
      );

      await container.read(schoolViewModelProvider.notifier).loadSchools();

      final state = container.read(schoolViewModelProvider);

      expect(state.status, SchoolStatus.error);
      expect(state.errorMessage, 'Failed to fetch schools');
    },
  );

  test(
    'loadCategoryCounts should update categoryCounts in state on success',
    () async {
      const counts = {'international': 4, 'public': 0, 'private': 5};

      when(() => mockGetCategoryCountsUsecase())
          .thenAnswer((_) async => const Right(counts));

      await container
          .read(schoolViewModelProvider.notifier)
          .loadCategoryCounts();

      final state = container.read(schoolViewModelProvider);

      expect(state.categoryCounts, counts);
    },
  );

  test(
    'selectCategory should set selectedCategory, reset page to 1 and '
    'trigger loadSchools with that category',
    () async {
      when(() => mockGetSchoolsUsecase(any()))
          .thenAnswer((_) async => const Right(successResult));

      container.read(schoolViewModelProvider.notifier).selectCategory(
            'international',
          );

      // let the async loadSchools() triggered inside selectCategory finish
      await Future<void>.delayed(Duration.zero);

      final state = container.read(schoolViewModelProvider);
      expect(state.selectedCategory, 'international');
      expect(state.page, 1);

      final captured =
          verify(() => mockGetSchoolsUsecase(captureAny())).captured;
      final passedParams = captured.last as GetSchoolsParams;

      expect(passedParams.category, 'international');
      expect(passedParams.page, 1);
    },
  );

  test(
    'selectCategory should clear the filter (toggle off) when the SAME '
    'category is tapped again',
    () async {
      when(() => mockGetSchoolsUsecase(any()))
          .thenAnswer((_) async => const Right(successResult));

      final notifier = container.read(schoolViewModelProvider.notifier);

      // tap once — filter is applied
      notifier.selectCategory('international');
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(schoolViewModelProvider).selectedCategory,
        'international',
      );

      // tap the SAME category again — should clear back to '' (All)
      notifier.selectCategory('international');
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(schoolViewModelProvider).selectedCategory,
        '',
      );
    },
  );

  test(
    'search should set searchQuery, reset page to 1 and trigger loadSchools',
    () async {
      when(() => mockGetSchoolsUsecase(any()))
          .thenAnswer((_) async => const Right(successResult));

      container.read(schoolViewModelProvider.notifier).search('Kathmandu');
      await Future<void>.delayed(Duration.zero);

      final state = container.read(schoolViewModelProvider);
      expect(state.searchQuery, 'Kathmandu');
      expect(state.page, 1);

      final captured =
          verify(() => mockGetSchoolsUsecase(captureAny())).captured;
      final passedParams = captured.last as GetSchoolsParams;

      expect(passedParams.search, 'Kathmandu');
    },
  );

  test(
    'nextPage should NOT advance or call loadSchools when already on the last page',
    () async {
      // seed state at the last page (page 3 of 3) via a successful load
      const lastPageResult = SchoolListResult(
        schools: [school],
        page: 3,
        limit: 10,
        total: 21,
        totalPages: 3,
      );

      when(() => mockGetSchoolsUsecase(any()))
          .thenAnswer((_) async => const Right(lastPageResult));

      final notifier = container.read(schoolViewModelProvider.notifier);
      await notifier.loadSchools();

      expect(container.read(schoolViewModelProvider).page, 3);

      clearInteractions(mockGetSchoolsUsecase);

      notifier.nextPage();
      await Future<void>.delayed(Duration.zero);

      // page should stay at 3, and loadSchools should never be called again
      expect(container.read(schoolViewModelProvider).page, 3);
      verifyNever(() => mockGetSchoolsUsecase(any()));
    },
  );
}