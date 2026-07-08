import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';

import 'package:sikhsha_sathi/features/school/data/datasources/remote/school_remote_datasource.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';
import 'package:sikhsha_sathi/features/school/domain/repositories/school_repository.dart';

// ================= PROVIDER =================

final schoolRepositoryProvider = Provider<ISchoolRepository>(
  (ref) => SchoolRepository(
    remoteDataSource: ref.read(schoolRemoteDatasourceProvider),
  ),
);

// ================= IMPLEMENTATION =================

class SchoolRepository implements ISchoolRepository {
  final ISchoolRemoteDataSource remoteDataSource;

  SchoolRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, SchoolListResult>> getSchools({
    int page = 1,
    int limit = 10,
    String search = '',
    String category = '',
    String stream = '',
  }) async {
    try {
      final result = await remoteDataSource.getSchools(
        page: page,
        limit: limit,
        search: search,
        category: category,
        stream: stream,
      );

      return Right(
        SchoolListResult(
          schools: result.schools.map((m) => m.toEntity()).toList(),
          page: result.page,
          limit: result.limit,
          total: result.total,
          totalPages: result.totalPages,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to fetch schools",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SchoolEntity>> getSchoolById(String id) async {
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
  }

  @override
  Future<Either<Failure, Map<String, int>>> getCategoryCounts() async {
    try {
      final result = await remoteDataSource.getCategoryCounts();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data?["message"] ?? "Failed to fetch category counts",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}