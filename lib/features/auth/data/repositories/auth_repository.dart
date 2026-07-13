import'package:dartz/dartz.dart';
import'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sikhsha_sathi/features/auth/data/models/auth_api_model.dart';

import'../../../../core/error/failures.dart';
import'../../../../core/services/connectivity/network_info.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

import '../datasources/auth_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_hive_model.dart';

final authRepositoryProvider =
    Provider<IAuthRepository>((ref) {
  return AuthRepository(
    remoteDatasource:
        ref.read(authRemoteDatasourceProvider),
    localDatasource:
        ref.read(authLocalDatasourceProvider),
    networkInfo:
        ref.read(networkInfoProvider),
  );
});

class AuthRepository
    implements IAuthRepository {
  final IAuthRemoteDataSource
      _remoteDatasource;

  final IAuthLocalDataSource
      _localDatasource;

  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthRemoteDataSource
        remoteDatasource,
    required IAuthLocalDataSource
        localDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource =
            remoteDatasource,
        _localDatasource =
            localDatasource,
        _networkInfo = networkInfo;

  // ================= REGISTER =================

  @override
  Future<Either<Failure, bool>>
      register(
    AuthEntity entity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel =
            AuthApiModel.fromEntity(
          entity,
        );

        final registeredModel =
            await _remoteDatasource
                .register(apiModel);

        // Cache locally too, so login still works later if the user
        // goes offline without ever logging in again after this register.
        // The API response's password field is always empty (the backend
        // never sends it back), so we use the plaintext password the user
        // just typed in (entity.password) instead of registeredModel.password.
        try {
          await _localDatasource.register(
            AuthHiveModel(
              userId: registeredModel.id,
              fullName: registeredModel.fullName,
              email: registeredModel.email,
              password: entity.password,
              phoneNumber: registeredModel.phoneNumber,
              profilePicture: registeredModel.profilePicture,
            ),
          );
        } catch (_) {
          // caching failure should never block a successful register
        }

        return const Right(true);
      } catch (e) {
        return Left(
          ApiFailure(
            message: e.toString(),
          ),
        );
      }
    } else {
      try {
        final exists =
            await _localDatasource
                .isEmailExists(
          entity.email,
        );

        if (exists) {
          return const Left(
            LocalDatabaseFailure(
              message:
                  "Email already exists",
            ),
          );
        }

        final hiveModel =
            AuthHiveModel.fromEntity(
          entity,
        );

        await _localDatasource
            .register(
          hiveModel,
        );

        return const Right(true);
      } catch (e) {
        return Left(
          LocalDatabaseFailure(
            message: e.toString(),
          ),
        );
      }
    }
  }

  // ================= LOGIN =================

  @override
  Future<Either<Failure, AuthEntity>>
      login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result =
            await _remoteDatasource
                .login(
          email,
          password,
        );

        if (result == null) {
          return const Left(
            ApiFailure(
              message:
                  "Invalid credentials",
            ),
          );
        }

        // Cache locally too, so login still works later if the user
        // goes offline. The API response's password field is always
        // empty (the backend never sends it back), so we use the
        // plaintext password just entered instead of result.password.
        try {
          await _localDatasource.register(
            AuthHiveModel(
              userId: result.id,
              fullName: result.fullName,
              email: result.email,
              password: password,
              phoneNumber: result.phoneNumber,
              profilePicture: result.profilePicture,
            ),
          );
        } catch (_) {
          // caching failure should never block a successful login
        }

        return Right(
          result.toEntity(),
        );
      } catch (e) {
        return Left(
          ApiFailure(
            message: e.toString(),
          ),
        );
      }
    } else {
      try {
        final result =
            await _localDatasource
                .login(
          email,
          password,
        );

        if (result == null) {
          return const Left(
            LocalDatabaseFailure(
              message:
                  "Invalid credentials",
            ),
          );
        }

        return Right(
          result.toEntity(),
        );
      } catch (e) {
        return Left(
          LocalDatabaseFailure(
            message: e.toString(),
          ),
        );
      }
    }
  }

  // ================= GET CURRENT USER =================

  @override
  Future<Either<Failure, AuthEntity>>
      getCurrentUser() async {
    try {
      final user =
          await _localDatasource
              .getCurrentUser();

      if (user == null) {
        return const Left(
          LocalDatabaseFailure(
            message:
                "No user logged in",
          ),
        );
      }

      return Right(
        user.toEntity(),
      );
    } catch (e) {
      return Left(
        LocalDatabaseFailure(
          message: e.toString(),
        ),
      );
    }
  }

  // ================= LOGOUT =================

  @override
  Future<Either<Failure, bool>>
      logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDatasource
            .logout();
      }

      await _localDatasource
          .logout();

      return const Right(true);
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }

  // ================= FORGOT PASSWORD =================
  // Always requires a live connection — there's no meaningful offline
  // version of "email me a reset link".

  @override
  Future<Either<Failure, bool>> forgotPassword(
    String email,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(
          message:
              "No internet connection. Connect to request a password reset.",
        ),
      );
    }

    try {
      await _remoteDatasource.forgotPassword(email);
      return const Right(true);
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }
}