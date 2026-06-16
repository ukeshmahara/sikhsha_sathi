import '../models/auth_hive_model.dart';
import '../models/auth_api_model.dart';

abstract interface class IAuthLocalDataSource {
  Future<bool> register(
    AuthHiveModel model,
  );

  Future<AuthHiveModel?> login(
    String email,
    String password,
  );

  Future<AuthHiveModel?> getCurrentUser();

  Future<bool> logout();

  Future<bool> isEmailExists(
    String email,
  );
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(
    AuthApiModel model,
  );

  Future<AuthApiModel?> login(
    String email,
    String password,
  );

  Future<AuthApiModel?> getCurrentUser();

  Future<bool> logout();
}