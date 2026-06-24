import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;

  final String fullName;

  final String email;

  final String password;

  final String? phoneNumber;

  final String? profilePicture;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        password,
        phoneNumber,
        profilePicture,
      ];
}