import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart'; 
import 'package:sikhsha_sathi/features/profile/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:sikhsha_sathi/features/profile/presentation/state/profile_state.dart';
import 'package:sikhsha_sathi/features/profile/presentation/view_model/profile_view_model.dart';

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class FakeFile extends Fake implements File {}

void main() {
  late MockUploadProfilePictureUsecase mockUploadUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeFile());
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    mockUploadUsecase = MockUploadProfilePictureUsecase();

    container = ProviderContainer(
      overrides: [
        uploadProfilePictureUsecaseProvider
            .overrideWithValue(mockUploadUsecase),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  final tFile = File('test/assets/test_image.jpg');
  const tImageUrl = '/uploads/profile_123.jpg';

  // ==================== TEST 1 ====================
  test('initial state should be ProfileStatus.initial', () {
    final state = container.read(profileViewModelProvider);

    expect(state.status, ProfileStatus.initial);
    expect(state.profilePicture, isNull);
    expect(state.errorMessage, isNull);
  });

  // ==================== TEST 2 ====================
  test(
    'should set status to loaded with imageUrl when upload is successful',
    () async {
      when(() => mockUploadUsecase(any()))
          .thenAnswer((_) async => const Right(tImageUrl));

      await container
          .read(profileViewModelProvider.notifier)
          .uploadProfilePicture(tFile);

      final state = container.read(profileViewModelProvider);

      expect(state.status, ProfileStatus.loaded);
      expect(state.profilePicture, tImageUrl);
    },
  );

  // ==================== TEST 3 ====================
  test(
    'should set status to error when upload fails',
    () async {
      when(() => mockUploadUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Upload failed')),
      );

      await container
          .read(profileViewModelProvider.notifier)
          .uploadProfilePicture(tFile);

      final state = container.read(profileViewModelProvider);

      expect(state.status, ProfileStatus.error);
      expect(state.errorMessage, 'Upload failed');
    },
  );

  // ==================== TEST 4 ====================
  test(
    'should set status to loading before upload completes',
    () async {
      when(() => mockUploadUsecase(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return const Right(tImageUrl);
      });

      // do not await — check state immediately after call starts
      final future = container
          .read(profileViewModelProvider.notifier)
          .uploadProfilePicture(tFile);

      final stateWhileLoading = container.read(profileViewModelProvider);

      await future;

      expect(stateWhileLoading.status, ProfileStatus.loading);
    },
  );

  // ==================== TEST 5 ====================
  test(
    'should clear errorMessage when clearError is called',
    () async {
      when(() => mockUploadUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Upload failed')),
      );

      await container
          .read(profileViewModelProvider.notifier)
          .uploadProfilePicture(tFile);

      // act
      container.read(profileViewModelProvider.notifier).clearError();

      final state = container.read(profileViewModelProvider);

      expect(state.errorMessage, isNull);
    },
  );
}