import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.profilePicture,
  });

  factory AuthApiModel.fromEntity(
    AuthEntity entity,
  ) {
    return AuthApiModel(
      id: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      userId: id,
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "profilePicture": profilePicture,
    };
  }

  factory AuthApiModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthApiModel(
      id: json["id"] ?? json["_id"],
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
      password: "",
      phoneNumber: json["phoneNumber"],
      profilePicture: json["profilePicture"],
    );
  }
}