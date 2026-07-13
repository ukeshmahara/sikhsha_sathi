import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/connectivity/network_info.dart';

import 'package:sikhsha_sathi/features/notification/data/datasources/notification_datasource.dart';
import 'package:sikhsha_sathi/features/notification/data/datasources/local/notification_local_datasource.dart';
import 'package:sikhsha_sathi/features/notification/data/datasources/remote/notification_remote_datasource.dart';
import 'package:sikhsha_sathi/features/notification/domain/entities/notification_entity.dart';
import 'package:sikhsha_sathi/features/notification/domain/repositories/notification_repository.dart';

// ================= PROVIDER =================

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepository(
    remoteDatasource: ref.read(notificationRemoteDatasourceProvider),
    localDatasource: ref.read(notificationLocalDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// ================= IMPLEMENTATION =================

class NotificationRepository implements INotificationRepository {
  final INotificationRemoteDataSource _remoteDatasource;
  final INotificationLocalDataSource _localDatasource;
  final NetworkInfo _networkInfo;

  NotificationRepository({
    required INotificationRemoteDataSource remoteDatasource,
    required INotificationLocalDataSource localDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _networkInfo = networkInfo;

  // Online: fetch fresh list from backend and refresh the local cache.
  // Offline: fall back to whatever was last cached (read-only).
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDatasource.getNotifications();
        final entities = result.map((m) => m.toEntity()).toList();

        // keep the offline cache fresh for next time there's no internet
        await _localDatasource.replaceCache(entities);

        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data?["message"] ??
                "Failed to fetch notifications",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final cached = _localDatasource.getCachedNotifications();
        return Right(cached);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}