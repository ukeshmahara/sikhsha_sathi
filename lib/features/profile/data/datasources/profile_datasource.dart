import 'dart:io';

import 'package:sikhsha_sathi/features/profile/domain/entities/profile_update_result.dart';

abstract interface class IProfileLocalDataSource {
  Future<void> saveProfilePicture(
    String profilePicture,
  );

  Future<String?> getProfilePicture();

  Future<void> clearProfilePicture();
}

abstract interface class IProfileRemoteDataSource {
  Future<String> uploadProfilePicture(
    File image,
  );

  Future<ProfileUpdateResult> updateProfile({
    String? fullName,
    String? phone,
    String? currentPassword,
    String? newPassword,
  });
}