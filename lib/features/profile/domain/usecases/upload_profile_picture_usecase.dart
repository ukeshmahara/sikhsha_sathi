import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';
import 'package:sikhsha_sathi/features/profile/data/repositories/profile_repository.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

final uploadProfilePictureUsecaseProvider =
    Provider<UploadProfilePictureUsecase>(
  (ref) => UploadProfilePictureUsecase(
    repository:
        ref.read(profileRepositoryProvider),
  ),
);

class UploadProfilePictureUsecase
    implements
        UsecaseWithParams<String, File> {
  final IProfileRepository
      _repository;

  UploadProfilePictureUsecase({
    required IProfileRepository
        repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, String>>
      call(
    File params,
  ) {
    return _repository
        .uploadProfilePicture(
      params,
    );
  }
}