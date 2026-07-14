import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage/user_session_service.dart';
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

  @override
  ProfileState build() {
    _uploadProfilePictureUsecase =
        ref.read(
      uploadProfilePictureUsecaseProvider,
    );

    // load previously saved profile picture (persists across app restarts)
    final savedProfilePicture = ref
        .read(userSessionServiceProvider)
        .getProfilePicture();

    return ProfileState(
      profilePicture: savedProfilePicture,
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
}