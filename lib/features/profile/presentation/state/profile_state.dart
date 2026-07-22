import 'package:equatable/equatable.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;

  final String? profilePicture;

  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profilePicture,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? profilePicture,
    // errorMessage is deliberately NOT given a "?? this.errorMessage"
    // fallback like the other fields — callers need to be able to pass
    // null explicitly and have it actually clear the error (clearError(),
    // and the start of any fresh operation), not silently keep the old
    // message around forever.
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profilePicture:
          profilePicture ?? this.profilePicture,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profilePicture,
        errorMessage,
      ];
}