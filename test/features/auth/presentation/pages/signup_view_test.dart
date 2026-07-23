import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/biometric/biometric_service.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/login_usecase.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/register_usecase.dart';
import 'package:sikhsha_sathi/features/auth/presentation/pages/signup_view.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

// NEW — SignupView shares AuthViewModel with LoginView, and
// AuthViewModel.build() now reads these 2 providers as well (added for
// fingerprint login). Even though SignupView never uses biometric
// features directly, the SHARED viewmodel still needs them mocked for
// build() to succeed — this is what was causing every test here to fail.
class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}
class MockBiometricService extends Mock implements BiometricService {}

class FakeLoginParams extends Fake implements LoginParams {}
class FakeRegisterUsecaseParams extends Fake implements RegisterUsecaseParams {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockBiometricService mockBiometricService;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterUsecaseParams());
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockBiometricService = MockBiometricService();
  });

  Widget buildSignupView() {
    return ProviderScope(
      overrides: [
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        getCurrentUserUsecaseProvider
            .overrideWithValue(mockGetCurrentUserUsecase),
        biometricServiceProvider.overrideWithValue(mockBiometricService),
      ],
      child: const MaterialApp(home: SignupView()),
    );
  }

  // ==================== TEST 1 ====================
  testWidgets(
    'should display Create Account text on screen',
    (tester) async {
      await tester.pumpWidget(buildSignupView());

      expect(find.text('Create Account'), findsOneWidget);
    },
  );

  // ==================== TEST 2 ====================
  testWidgets(
    'should render all 5 input fields',
    (tester) async {
      await tester.pumpWidget(buildSignupView());

      // fullName, email, phone, password, confirmPassword
      expect(find.byType(TextFormField), findsNWidgets(5));
    },
  );

  // ==================== TEST 3 ====================
  testWidgets(
    'should render Register button',
    (tester) async {
      await tester.pumpWidget(buildSignupView());

      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    },
  );

  // ==================== TEST 4 ====================
  testWidgets(
    'should show Login link at the bottom',
    (tester) async {
      await tester.pumpWidget(buildSignupView());

      expect(find.text('Login'), findsOneWidget);
    },
  );

  // ==================== TEST 5 ====================
  testWidgets(
    'should call register usecase when form is filled and submitted',
    (tester) async {
      // arrange — Completer controls when the future resolves (teacher's pattern)
      final completer = Completer<Either<Failure, bool>>();

      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => completer.future);

      await tester.pumpWidget(buildSignupView());
      await tester.pumpAndSettle();

      // signup_view uses labelText — widgetWithText works correctly
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Ukesh Mahara',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'ukeshmahara@gmail.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'),
        '9800000000',
      );

      // scroll down to reach password fields
      await tester.dragUntilVisible(
        find.widgetWithText(TextFormField, 'Password'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'mahara@123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'mahara@123',
      );

      // scroll to Register button
      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Register'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();

      // assert — register usecase was called once
      verify(() => mockRegisterUsecase(any())).called(1);

      // complete the future to clean up
      completer.complete(const Right(true));
    },
  );
}