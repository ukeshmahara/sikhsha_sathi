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
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profilePicture:
          profilePicture ?? this.profilePicture,
      errorMessage:
          errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profilePicture,
        errorMessage,
      ];
}