import 'package:sikhsha_sathi/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDataSource {

  // REGISTER
  Future<bool> register(
    AuthHiveModel model,
  );

  // LOGIN
  Future<AuthHiveModel?> login(
    String email,
    String password,
  );

  // GET CURRENT USER
  Future<AuthHiveModel?> getCurrentUser();

  // LOGOUT
  Future<bool> logout();

  // CHECK EMAIL
  Future<bool> isEmailExists(
    String email,
  );
}