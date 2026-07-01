import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LogoutUsecase(authRepository: repository);
  });

  test(
    'should return true when logout is successful',
    () async {
      // arrange
      when(() => repository.logout())
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await usecase.call();

      // assert
      expect(result, const Right(true));
      verify(() => repository.logout()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'should return ApiFailure when logout fails',
    () async {
      // arrange
      when(() => repository.logout()).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Logout failed')),
      );

      // act
      final result = await usecase.call();

      // assert
      expect(result, Left(ApiFailure(message: 'Logout failed')));
      verify(() => repository.logout()).called(1);
    },
  );
}