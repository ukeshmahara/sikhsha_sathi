import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';

import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';

import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';

import 'package:sikhsha_sathi/features/auth/data/datasources/auth_datasource.dart';

import 'package:sikhsha_sathi/features/auth/data/datasources/local/auth_local_datasource.dart';

import 'package:sikhsha_sathi/features/auth/data/models/auth_hive_model.dart';

// ================= PROVIDER =================

final authRepositoryProvider =
    Provider<IAuthRepository>((ref) {

  return AuthRepository(
    authDatasource:
        ref.read(
      authLocalDatasourceProvider,
    ),
  );
});

// ================= REPOSITORY =================

class AuthRepository
    implements IAuthRepository {

  final IAuthDataSource
      _authDatasource;

  AuthRepository({
    required IAuthDataSource
        authDatasource,
  }) : _authDatasource =
          authDatasource;

  // ================= REGISTER =================

  @override
  Future<Either<Failure, bool>>
      register(
    AuthEntity entity,
  ) async {

    try {

      final model =
          AuthHiveModel.fromEntity(
        entity,
      );

      final result =
          await _authDatasource
              .register(
        model,
      );

      if (result) {

        return const Right(true);
      }

      return Left(
        LocalDatabaseFailure(
          message:
              "Failed to register user",
        ),
      );

    } catch (e) {

      return Left(
        LocalDatabaseFailure(
          message: e.toString(),
        ),
      );
    }
  }

  // ================= LOGIN =================

  @override
  Future<Either<Failure, AuthEntity>>
      login(
    String email,
    String password,
  ) async {

    try {

      final result =
          await _authDatasource.login(
        email,
        password,
      );

      if (result != null) {

        final entity =
            result.toEntity();

        return Right(entity);
      }

      return Left(
        LocalDatabaseFailure(
          message:
              "Invalid email or password",
        ),
      );

    } catch (e) {

      return Left(
        LocalDatabaseFailure(
          message: e.toString(),
        ),
      );
    }
  }

  // ================= GET CURRENT USER =================

  @override
  Future<Either<Failure, AuthEntity>>
      getCurrentUser() async {

    try {

      final result =
          await _authDatasource
              .getCurrentUser();

      if (result != null) {

        final entity =
            result.toEntity();

        return Right(entity);
      }

      return Left(
        LocalDatabaseFailure(
          message:
              "User not found",
        ),
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

      final result =
          await _authDatasource
              .logout();

      if (result) {

        return const Right(true);
      }

      return Left(
        LocalDatabaseFailure(
          message:
              "Failed to logout",
        ),
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