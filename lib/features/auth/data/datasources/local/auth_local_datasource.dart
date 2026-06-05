import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/services/hive/hive_service.dart';

import 'package:sikhsha_sathi/features/auth/data/datasources/auth_datasource.dart';

import 'package:sikhsha_sathi/features/auth/data/models/auth_hive_model.dart';

// ================= PROVIDER =================

final authLocalDatasourceProvider =
    Provider<AuthLocalDatasource>((ref) {

  final hiveService =
      ref.read(hiveServiceProvider);

  return AuthLocalDatasource(
    hiveService: hiveService,
  );
});

// ================= DATASOURCE =================

class AuthLocalDatasource
    implements IAuthDataSource {

  final HiveService _hiveService;

  AuthLocalDatasource({
    required HiveService hiveService,
  }) : _hiveService = hiveService;

  // ================= REGISTER =================

  @override
  Future<bool> register(
    AuthHiveModel model,
  ) async {

    try {

      await _hiveService.registerUser(
        model,
      );

      return true;

    } catch (e) {

      return false;
    }
  }

  // ================= LOGIN =================

  @override
  Future<AuthHiveModel?> login(
    String email,
    String password,
  ) async {

    try {

      final user =
          await _hiveService.login(
        email,
        password,
      );

      return user;

    } catch (e) {

      return null;
    }
  }

  // ================= GET CURRENT USER =================

  @override
  Future<AuthHiveModel?> getCurrentUser() async {

    try {

      return null;

    } catch (e) {

      return null;
    }
  }

  // ================= LOGOUT =================

  @override
  Future<bool> logout() async {

    try {

      await _hiveService.logoutUser();

      return true;

    } catch (e) {

      return false;
    }
  }

  // ================= CHECK EMAIL =================

  @override
  Future<bool> isEmailExists(
    String email,
  ) async {

    try {

      final exists =
          _hiveService.isEmailExists(
        email,
      );

      return exists;

    } catch (e) {

      return false;
    }
  }
}