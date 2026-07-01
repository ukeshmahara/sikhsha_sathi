import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';
import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: repository);
  });

  const correctEmail = 'ukeshmahara@gmail.com';
  const correctPassword = 'mahara@123';

  const returnUser = AuthEntity(
    userId: '1',
    fullName: 'Ukesh Mahara',
    email: correctEmail,
    password: correctPassword,
  );

  test(
    'should return AuthEntity when passed correct email and password',
    () async {
      // arrange
      when(() => repository.login(any(), any())).thenAnswer((invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;

        if (email == correctEmail && password == correctPassword) {
          return const Right(returnUser);
        }
        return Left(ApiFailure(message: 'invalid credentials'));
      });

      // act
      final result = await usecase.call(
        const LoginParams(email: correctEmail, password: correctPassword),
      );

      // assert
      expect(result, const Right(returnUser));
      verify(() => repository.login(correctEmail, correctPassword)).called(1);
    },
  );

  test(
    'should return Failure when passed incorrect email and password',
    () async {
      // arrange
      when(() => repository.login(any(), any())).thenAnswer((invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;

        if (email == correctEmail && password == correctPassword) {
          return const Right(returnUser);
        }
        return Left(ApiFailure(message: 'invalid credentials'));
      });

      // act
      final result = await usecase.call(
        const LoginParams(email: correctEmail, password: 'wrongpassword'),
      );

      // assert
      expect(result, Left(ApiFailure(message: 'invalid credentials')));
    },
  );
}