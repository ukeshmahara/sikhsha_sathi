import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity/network_info.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

import '../datasources/auth_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

import '../models/auth_api_model.dart';
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

  @override
  Future<Either<Failure, bool>>
      register(
    AuthEntity entity,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final apiModel =
            AuthApiModel.fromEntity(
          entity,
        );

        await _remoteDatasource
            .register(apiModel);

        return const Right(true);
      } else {
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
            AuthHiveModel(
          userId: entity.userId,
          fullName: entity.fullName,
          email: entity.email,
          password: entity.password,
          phoneNumber:
              entity.phoneNumber,
        );

        await _localDatasource
            .register(
          hiveModel,
        );

        return const Right(true);
      }
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AuthEntity>>
      login(
    String email,
    String password,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
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

        return Right(
          result.toEntity(),
        );
      } else {
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
      }
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }

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

  @override
  Future<Either<Failure, bool>>
      logout() async {
    try {
      await _remoteDatasource
          .logout();

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
}