import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';
import 'package:sikhsha_sathi/features/profile/data/repositories/profile_repository.dart';
import 'package:sikhsha_sathi/features/profile/domain/entities/profile_update_result.dart';
import 'package:sikhsha_sathi/features/profile/domain/repositories/profile_repository.dart';

// ================= PARAMS =================

class UpdateProfileParams {
  final String? fullName;
  final String? phone;
  final String? currentPassword;
  final String? newPassword;

  const UpdateProfileParams({
    this.fullName,
    this.phone,
    this.currentPassword,
    this.newPassword,
  });
}

// ================= PROVIDER =================

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(repository: repository);
});

// ================= USECASE =================

class UpdateProfileUsecase
    implements UsecaseWithParams<ProfileUpdateResult, UpdateProfileParams> {
  final IProfileRepository _repository;

  UpdateProfileUsecase({required IProfileRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, ProfileUpdateResult>> call(
    UpdateProfileParams params,
  ) {
    return _repository.updateProfile(
      fullName: params.fullName,
      phone: params.phone,
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}