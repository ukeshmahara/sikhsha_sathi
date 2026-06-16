import '../../domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  factory AuthApiModel.fromEntity(
    AuthEntity entity,
  ) {
    return AuthApiModel(
      id: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber ?? '',
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      userId: id,
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
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
      phoneNumber: json["phoneNumber"] ?? "",
    );
  }
}