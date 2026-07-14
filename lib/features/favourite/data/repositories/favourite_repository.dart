import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/connectivity/network_info.dart';

import 'package:sikhsha_sathi/features/favourite/data/datasources/favourite_datasource.dart';
import 'package:sikhsha_sathi/features/favourite/data/datasources/local/favourite_local_datasource.dart';
import 'package:sikhsha_sathi/features/favourite/data/datasources/remote/favourite_remote_datasource.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';

// ================= PROVIDER =================

final favouriteRepositoryProvider = Provider<IFavouriteRepository>((ref) {
  return FavouriteRepository(
    remoteDatasource: ref.read(favouriteRemoteDatasourceProvider),
    localDatasource: ref.read(favouriteLocalDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// ================= IMPLEMENTATION =================

class FavouriteRepository implements IFavouriteRepository {
  final IFavouriteRemoteDataSource _remoteDatasource;
  final IFavouriteLocalDataSource _localDatasource;
  final NetworkInfo _networkInfo;

  FavouriteRepository({
    required IFavouriteRemoteDataSource remoteDatasource,
    required IFavouriteLocalDataSource localDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _networkInfo = networkInfo;

  // ================= GET FAVOURITES =================
  // Online: fetch fresh list from backend and refresh the local cache.
  // Offline: fall back to whatever was last cached (read-only).

  @override
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDatasource.getFavourites();
        final entities = result.map((m) => m.toEntity()).toList();

        // keep the offline cache fresh for next time there's no internet
        await _localDatasource.replaceCache(entities);

        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final cached = _localDatasource.getCachedFavourites();
        return Right(cached);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  // ================= ADD FAVOURITE =================
  // Requires a live connection — favourites are shared across the Flutter
  // app and the web dashboard through the same backend, so an offline
  // "add" can't be safely queued without a sync mechanism.

  @override
  Future<Either<Failure, bool>> addFavourite(String schoolId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: "No internet connection. Connect to add a favourite."),
      );
    }

    try {
      final success = await _remoteDatasource.addFavourite(schoolId);
      return Right(success);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= REMOVE FAVOURITE =================

  @override
  Future<Either<Failure, bool>> removeFavourite(String schoolId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: "No internet connection. Connect to remove a favourite."),
      );
    }

    try {
      final success = await _remoteDatasource.removeFavourite(schoolId);

      if (success) {
        await _localDatasource.removeCachedFavourite(schoolId);
      }

      return Right(success);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ================= CLEAR LOCAL CACHE =================
  // Called on logout so the next user on this device never sees
  // whatever the previous user had cached.

  @override
  Future<void> clearLocalCache() async {
    await _localDatasource.clearCache();
  }
}