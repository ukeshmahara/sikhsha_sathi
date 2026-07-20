import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage/user_session_service.dart';
import '../../../auth/domain/usecases/get_current_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_picture_usecase.dart';
import '../state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);

class ProfileViewModel
    extends Notifier<ProfileState> {

  late UploadProfilePictureUsecase
      _uploadProfilePictureUsecase;

  late GetCurrentUserUsecase
      _getCurrentUserUsecase;

  late UpdateProfileUsecase
      _updateProfileUsecase;

  @override
  ProfileState build() {
    _uploadProfilePictureUsecase =
        ref.read(
      uploadProfilePictureUsecaseProvider,
    );

    _getCurrentUserUsecase = ref.read(
      getCurrentUserUsecaseProvider,
    );

    _updateProfileUsecase = ref.read(
      updateProfileUsecaseProvider,
    );

    // load previously saved profile picture (persists across app restarts)
    final savedProfilePicture = ref
        .read(userSessionServiceProvider)
        .getProfilePicture();

    return ProfileState(
      profilePicture: savedProfilePicture,
    );
  }

  // Verifies the profile against the backend using the SAME offline-first
  // logic already built for Auth: online -> GET /auth/whoami and refresh
  // the local cache; offline -> silently keep whatever's already cached
  // (no error shown, since stale-but-present data is fine for a profile
  // screen — this just quietly keeps things in sync when there's a
  // connection, rather than blindly trusting old SharedPreferences forever).
  Future<void> refreshProfile() async {
    final result = await _getCurrentUserUsecase(const CurrentUserParams());

    result.fold(
      (failure) {
        // offline or a real failure — keep showing whatever's already
        // cached rather than clearing the screen or showing an error,
        // since the user can still see their last-known profile info
      },
      (user) async {
        final session = ref.read(userSessionServiceProvider);

        await session.saveUserSession(
          userId: user.userId ?? "",
          email: user.email,
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
          profilePicture: user.profilePicture,
        );

        state = state.copyWith(
          profilePicture: user.profilePicture,
        );
      },
    );
  }

  Future<void> uploadProfilePicture(
    File image,
  ) async {
    state = state.copyWith(
      status: ProfileStatus.loading,
    );

    final result =
        await _uploadProfilePictureUsecase(
      image,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage:
              failure.message,
        );
      },
      (profilePicture) async {

        // Save image URL permanently
        await ref
            .read(userSessionServiceProvider)
            .saveProfilePicture(
              profilePicture,
            );

        state = state.copyWith(
          status: ProfileStatus.loaded,
          profilePicture:
              profilePicture,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
    );
  }

  // Updates fullName/phone and optionally the password. Returns true/false
  // so the Edit Profile screen knows whether to pop back or show the
  // error inline (e.g. "Current password is incorrect").
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? currentPassword,
    String? newPassword,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);

    final result = await _updateProfileUsecase(
      UpdateProfileParams(
        fullName: fullName,
        phone: phone,
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (updated) async {
        final session = ref.read(userSessionServiceProvider);

        await session.saveUserSession(
          userId: session.getUserId() ?? '',
          email: updated.email,
          fullName: updated.fullName,
          phoneNumber: updated.phone,
          profilePicture: updated.profileImage ?? state.profilePicture,
        );

        state = state.copyWith(
          status: ProfileStatus.loaded,
          profilePicture: updated.profileImage ?? state.profilePicture,
        );
        return true;
      },
    );
  }
}