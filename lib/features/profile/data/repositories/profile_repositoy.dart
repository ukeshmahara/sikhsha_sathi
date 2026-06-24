import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity/network_info.dart';

import '../../domain/repositories/profile_repository.dart';

import '../datasources/profile_datasource.dart';
import '../datasources/remote/profile_remote_datasource.dart';

final profileRepositoryProvider =
    Provider<IProfileRepository>(
  (ref) {
    return ProfileRepository(
      networkInfo:
          ref.read(networkInfoProvider),

      profileRemoteDatasource:
          ref.read(
        profileRemoteDatasourceProvider,
      ),
    );
  },
);

class ProfileRepository
    implements IProfileRepository {
  final NetworkInfo _networkInfo;

  final IProfileRemoteDataSource
      _profileRemoteDatasource;

  ProfileRepository({
    required NetworkInfo networkInfo,
    required IProfileRemoteDataSource
        profileRemoteDatasource,
  })  : _networkInfo = networkInfo,
        _profileRemoteDatasource =
            profileRemoteDatasource;

  @override
  Future<Either<Failure, String>>
      uploadProfilePicture(
    File image,
  ) async {
    if (await _networkInfo
        .isConnected) {
      try {
        final profilePicture =
            await _profileRemoteDatasource
                .uploadProfilePicture(
          image,
        );

        return Right(
          profilePicture,
        );
      } on SocketException {
        return Left(
          ApiFailure(
            message:
                'No Internet Connection',
          ),
        );
      } catch (e) {
        return Left(
          ApiFailure(
            message: e.toString(),
          ),
        );
      }
    } else {
      return Left(
        ApiFailure(
          message:
              'No Internet Connection',
        ),
      );
    }
  }
}