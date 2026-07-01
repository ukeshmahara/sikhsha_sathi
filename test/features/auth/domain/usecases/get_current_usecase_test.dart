import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';
import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/get_current_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetCurrentUserUsecase usecase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = GetCurrentUserUsecase(authRepository: repository);
  });

  const tAuthEntity = AuthEntity(
    userId: '1',
    fullName: 'Ukesh Mahara',
    email: 'ukeshmahara@gmail.com',
    password: '',
    phoneNumber: '9800000000',
  );

  test(
    'should return AuthEntity when current user is logged in',
    () async {
      // arrange
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => const Right(tAuthEntity));

      // act
      final result = await usecase.call(const CurrentUserParams());

      // assert
      expect(result, const Right(tAuthEntity));
      verify(() => repository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'should return LocalDatabaseFailure when no user is logged in',
    () async {
      // arrange
      when(() => repository.getCurrentUser()).thenAnswer(
        (_) async =>
            const Left(LocalDatabaseFailure(message: 'No user logged in')),
      );

      // act
      final result = await usecase.call(const CurrentUserParams());

      // assert
      expect(
        result,
        const Left(LocalDatabaseFailure(message: 'No user logged in')),
      );
    },
  );
}