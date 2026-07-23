import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/connectivity/network_info.dart';

import 'package:sikhsha_sathi/features/school/data/datasources/school_datasource.dart';
import 'package:sikhsha_sathi/features/school/data/datasources/local/school_local_datasource.dart';
import 'package:sikhsha_sathi/features/school/data/datasources/remote/school_remote_datasource.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';

// ================= PROVIDER =================

final schoolRepositoryProvider = Provider<ISchoolRepository>(
  (ref) => SchoolRepository(
    remoteDataSource: ref.read(schoolRemoteDatasourceProvider),
    localDataSource: ref.read(schoolLocalDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

// ================= IMPLEMENTATION =================

class SchoolRepository implements ISchoolRepository {
  final ISchoolRemoteDataSource remoteDataSource;
  final ISchoolLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SchoolRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // Online: fetch fresh schools from the backend and refresh the local
  // cache so the next offline session shows this same list.
  // Offline: fall back to the cached list, applying the same
  // search/category/stream/fee filters client-side so filtering still
  // does *something* useful rather than just showing everything or
  // nothing — though it can only search within whatever was last cached.
  @override
  Future<Either<Failure, SchoolListResult>> getSchools({
    int page = 1,
    int limit = 10,
    String search = '',
    String category = '',
    String stream = '',
    double? minFee,
    double? maxFee,
    String sort = '',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSchools(
          page: page,
          limit: limit,
          search: search,
          category: category,
          stream: stream,
          minFee: minFee,
          maxFee: maxFee,
          sort: sort,
        );

        final entities = result.schools.map((m) => m.toEntity()).toList();

        // keep the offline cache fresh for next time there's no internet.
        // Only overwrite the full cache on an UNFILTERED first-page fetch,
        // so a narrow search/filter request doesn't wipe out the broader
        // cached list with just a few filtered results.
        if (page == 1 &&
            search.isEmpty &&
            category.isEmpty &&
            stream.isEmpty &&
            minFee == null &&
            maxFee == null) {
          await localDataSource.replaceCache(entities);
        }

        return Right(
          SchoolListResult(
            schools: entities,
            page: result.page,
            limit: result.limit,
            total: result.total,
            totalPages: result.totalPages,
          ),
        );
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data?["message"] ?? "Failed to fetch schools",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        var cached = localDataSource.getCachedSchools();

        if (search.isNotEmpty) {
          final query = search.toLowerCase();
          cached = cached
              .where((s) => s.name.toLowerCase().contains(query))
              .toList();
        }
        if (category.isNotEmpty) {
          cached = cached.where((s) => s.category == category).toList();
        }
        if (stream.isNotEmpty) {
          cached =
              cached.where((s) => s.streamsOffered.contains(stream)).toList();
        }
        if (minFee != null) {
          cached = cached.where((s) => s.fees >= minFee).toList();
        }
        if (maxFee != null) {
          cached = cached.where((s) => s.fees <= maxFee).toList();
        }

        return Right(
          SchoolListResult(
            schools: cached,
            page: 1,
            limit: cached.length,
            total: cached.length,
            totalPages: 1,
          ),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, SchoolEntity>> getSchoolById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSchoolById(id);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data?["message"] ?? "School not found",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      final cached = localDataSource.getCachedSchoolById(id);

      if (cached == null) {
        return const Left(
          LocalDatabaseFailure(
            message: "This school isn't available offline yet.",
          ),
        );
      }

      return Right(cached);
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getCategoryCounts() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCategoryCounts();
        await localDataSource.cacheCategoryCounts(result);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data?["message"] ??
                "Failed to fetch category counts",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        return Right(localDataSource.getCachedCategoryCounts());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}