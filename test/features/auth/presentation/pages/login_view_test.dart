import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/biometric/biometric_service.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/login_usecase.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/register_usecase.dart';
import 'package:sikhsha_sathi/features/auth/presentation/pages/login_view.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

// NEW — LoginView's initState() calls _checkBiometricAvailability(),
// which reads userSessionServiceProvider (needs real SharedPreferences)
// and biometricServiceProvider — neither was mocked before, which is
// what caused every test in this file to fail with UnimplementedError.
class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}
class MockBiometricService extends Mock implements BiometricService {}

class FakeLoginParams extends Fake implements LoginParams {}
class FakeRegisterUsecaseParams extends Fake implements RegisterUsecaseParams {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockBiometricService mockBiometricService;
  late SharedPreferences prefs;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterUsecaseParams());
  });

  setUp(() async {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockBiometricService = MockBiometricService();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    // biometric login is off by default in these tests, so the
    // fingerprint button doesn't appear and change what the existing
    // tests below are asserting about the screen's contents
    when(() => mockBiometricService.canCheckBiometrics())
        .thenAnswer((_) async => false);
  });

  Widget buildLoginView() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        getCurrentUserUsecaseProvider
            .overrideWithValue(mockGetCurrentUserUsecase),
        biometricServiceProvider.overrideWithValue(mockBiometricService),
      ],
      child: const MaterialApp(home: LoginView()),
    );
  }

  // ==================== TEST 1 ====================
  testWidgets(
    'should display Welcome text on screen',
    (tester) async {
      await tester.pumpWidget(buildLoginView());

      expect(find.text('Welcome'), findsOneWidget);
    },
  );

  // ==================== TEST 2 ====================
  testWidgets(
    'should render email and password TextFormFields',
    (tester) async {
      await tester.pumpWidget(buildLoginView());

      expect(find.byType(TextFormField), findsNWidgets(2));
    },
  );

  // ==================== TEST 3 ====================
  testWidgets(
    'should render Login button',
    (tester) async {
      await tester.pumpWidget(buildLoginView());

      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    },
  );

  // ==================== TEST 4 ====================
  testWidgets(
    'should show SignUp link at the bottom',
    (tester) async {
      await tester.pumpWidget(buildLoginView());

      expect(find.text('SignUp'), findsOneWidget);
    },
  );

  // ==================== TEST 5 ====================
  testWidgets(
    'should call login usecase with correct credentials when form is submitted',
    (tester) async {
      // arrange — Completer controls when the future resolves (teacher's pattern)
      final completer = Completer<Either<Failure, AuthEntity>>();

      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => completer.future);

      await tester.pumpWidget(buildLoginView());

      // login_view uses hintText not labelText — find by index
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'test@gmail.com');
      await tester.enterText(fields.at(1), 'test123');

      // tap Login button — scroll it into view first, since the default
      // test screen size (800x600) is too short to fit the whole form,
      // so the button starts out below the visible area
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pump();

      // assert — usecase was called with correct params
      verify(() => mockLoginUsecase(
        const LoginParams(email: 'test@gmail.com', password: 'test123'),
      )).called(1);

      // complete the future to clean up
      completer.complete(const Right(AuthEntity(
        userId: '1',
        fullName: 'Ukesh Mahara',
        email: 'ukeshmahara@gmail.com',
        password: 'ukesh@123',
      )));
    },
  );
}