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
),
);

class AuthRemoteDatasource
implements IAuthRemoteDataSource {
final ApiClient apiClient;

final UserSessionService
userSessionService;

AuthRemoteDatasource({
required this.apiClient,
required this.userSessionService,
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
    response.data["token"];

if (token != null) {
  await TokenService.saveToken(
    token,
  );
}

final user =
    AuthApiModel.fromJson(
  response.data["data"],
);

await userSessionService
    .saveUserSession(
  userId: user.id ?? "",
  email: user.email,
  fullName: user.fullName,
  phoneNumber:
      user.phoneNumber,
);

return user;


}

@override
Future<AuthApiModel?> getCurrentUser()
async {
return null;
}

@override
Future<bool> logout() async {
await TokenService.clearToken();

await userSessionService
    .clearSession();

return true;


}
}
