import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/login_usecase.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/register_usecase.dart';
import 'package:sikhsha_sathi/features/auth/presentation/pages/login_view.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class FakeLoginParams extends Fake implements LoginParams {}
class FakeRegisterUsecaseParams extends Fake implements RegisterUsecaseParams {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterUsecaseParams());
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
  });

  Widget buildLoginView() {
    return ProviderScope(
      overrides: [
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
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

      // tap Login button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
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