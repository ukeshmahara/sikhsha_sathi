import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/features/profile/domain/entities/profile_update_result.dart';

import '../../../../core/error/failures.dart';

abstract interface class IProfileRepository {

  Future<Either<Failure, String>>
      uploadProfilePicture(
    File image,
  );

  Future<Either<Failure, ProfileUpdateResult>> updateProfile({
    String? fullName,
    String? phone,
    String? currentPassword,
    String? newPassword,
  });
}