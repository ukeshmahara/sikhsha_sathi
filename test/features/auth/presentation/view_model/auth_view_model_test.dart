import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/login_usecase.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/register_usecase.dart';
import 'package:sikhsha_sathi/features/auth/presentation/state/auth_state.dart';
import 'package:sikhsha_sathi/features/auth/presentation/view_model/auth_view_model.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class FakeLoginParams extends Fake implements LoginParams {}
class FakeRegisterUsecaseParams extends Fake implements RegisterUsecaseParams {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterUsecaseParams());
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();

    container = ProviderContainer(
      overrides: [
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // ==================== TEST 1 ====================
  test('initial state should be AuthStatus.initial', () {
    final state = container.read(authViewModelProvider);

    expect(state.status, AuthStatus.initial);
    expect(state.user, isNull);
    expect(state.errorMessage, isNull);
  });

  // ==================== TEST 2 ====================
  test(
    'should set status to authenticated when login is successful',
    () async {
      const tUser = AuthEntity(
        userId: '1',
        fullName: 'Test User',
        email: 'ukeshmahara@gmail.com',
        password: 'mahara@123',
      );

      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(tUser));

      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'ukeshmahara@gmail.com', password: 'mahara@123');

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, tUser);
    },
  );

  // ==================== TEST 3 ====================
  test(
    'should set status to error when login fails',
    () async {
      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Invalid credentials')),
      );

      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'wrong@gmail.com', password: 'wrongpass');

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
    },
  );

  // ==================== TEST 4 ====================
  test(
    'should set status to registered when registration is successful',
    () async {
      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => const Right(true));

      await container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'Ukesh Mahara',
            email: 'ukeshmahara@gmail.com',
            password: 'mahara@123',
            phoneNumber: '9800000000',
          );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.registered);
    },
  );

  // ==================== TEST 5 ====================
  test(
    'should reset state to initial when resetState is called',
    () async {
      // first login to change state
      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'error')),
      );

      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'ukeshmahara@gmail.com', password: 'mahara@123');

      // act
      container.read(authViewModelProvider.notifier).resetState();

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    },
  );
}