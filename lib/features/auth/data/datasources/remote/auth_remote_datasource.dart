import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';

import '../../../../../core/services/storage/token_service.dart';
import '../../../../../core/services/storage/user_session_service.dart';

import '../../models/auth_api_model.dart';

import '../auth_datasource.dart';

final authRemoteDatasourceProvider =
    Provider<IAuthRemoteDataSource>(
  (ref) => AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService:
        ref.read(userSessionServiceProvider),
    tokenService:
        ref.read(tokenServiceProvider),
  ),
);

class AuthRemoteDatasource
    implements IAuthRemoteDataSource {
  final ApiClient apiClient;

  final UserSessionService
      userSessionService;

  final TokenService
      tokenService;

  AuthRemoteDatasource({
    required this.apiClient,
    required this.userSessionService,
    required this.tokenService,
  });

  @override
  Future<AuthApiModel> register(
    AuthApiModel model,
  ) async {
    final response =
        await apiClient.post(
      ApiEndpoints.register,
      data: model.toJson(),
    );

    return AuthApiModel.fromJson(
      response.data["data"],
    );
  }

  @override
  Future<AuthApiModel?> login(
    String email,
    String password,
  ) async {
    final response =
        await apiClient.post(
      ApiEndpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    final token =
        response.data["data"]["token"]; // ✅ fixed: was "access_token"

    if (token != null) {
      await tokenService.saveToken(
        token,
      );
    }

    final user =
        AuthApiModel.fromJson(
      response.data["data"]["user"],
    );

    await userSessionService
        .saveUserSession(
      userId: user.id ?? "",
      email: user.email,
      fullName: user.fullName,
      phoneNumber:
          user.phoneNumber,
      profilePicture:
          user.profilePicture,
    );

    return user;
  }

  @override
  Future<AuthApiModel?> getCurrentUser() async {
    // ✅ fixed: was returning null, now calls GET /auth/whoami
    final response =
        await apiClient.get(
      ApiEndpoints.whoami,
    );

    if (response.data["success"] == true) {
      return AuthApiModel.fromJson(
        response.data["data"],
      );
    }

    return null;
  }

  @override
  Future<bool> logout() async {
    await tokenService.removeToken();

    await userSessionService
        .clearSession();

    return true;
  }
}