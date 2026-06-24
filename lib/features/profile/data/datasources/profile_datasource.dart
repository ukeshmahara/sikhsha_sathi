import 'dart:io';

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
}