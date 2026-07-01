import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';
import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    repository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: repository);
  });

  const tParams = RegisterUsecaseParams(
    fullName: 'Ukesh Mahara',
    email: 'ukeshmahara@gmail.com',
    password: 'mahara@123',
    phoneNumber: '9800000000',
  );

  test(
    'should return true when registration is successful',
    () async {
      // arrange
      when(() => repository.register(any()))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await usecase.call(tParams);

      // assert
      expect(result, const Right(true));
      verify(() => repository.register(any())).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'should return ApiFailure when email already exists',
    () async {
      // arrange
      when(() => repository.register(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Email already exists')),
      );

      // act
      final result = await usecase.call(tParams);

      // assert
      expect(result, Left(ApiFailure(message: 'Email already exists')));
    },
  );
}