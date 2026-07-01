import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/profile/domain/repositories/profile_repository.dart';
import 'package:sikhsha_sathi/features/profile/domain/usecases/upload_profile_picture_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

class FakeFile extends Fake implements File {}

void main() {
  late UploadProfilePictureUsecase usecase;
  late MockProfileRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    repository = MockProfileRepository();
    usecase = UploadProfilePictureUsecase(repository: repository);
  });

  final tFile = File('test/assets/test_image.jpg');
  const tImageUrl = '/uploads/profile_123.jpg';

  test(
    'should return image URL string when upload is successful',
    () async {
      // arrange
      when(() => repository.uploadProfilePicture(any()))
          .thenAnswer((_) async => const Right(tImageUrl));

      // act
      final result = await usecase.call(tFile);

      // assert
      expect(result, const Right(tImageUrl));
      verify(() => repository.uploadProfilePicture(any())).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'should return ApiFailure when upload fails',
    () async {
      // arrange
      when(() => repository.uploadProfilePicture(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Upload failed')),
      );

      // act
      final result = await usecase.call(tFile);

      // assert
      expect(result, Left(ApiFailure(message: 'Upload failed')));
      verify(() => repository.uploadProfilePicture(any())).called(1);
    },
  );
}