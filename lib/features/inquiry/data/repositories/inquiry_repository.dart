import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/connectivity/network_info.dart';

import 'package:sikhsha_sathi/features/inquiry/data/datasources/inquiry_datasource.dart';
import 'package:sikhsha_sathi/features/inquiry/data/datasources/remote/inquiry_remote_datasource.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/repositories/inquiry_repository.dart';

// ================= PROVIDER =================

final inquiryRepositoryProvider = Provider<IInquiryRepository>((ref) {
  return InquiryRepository(
    remoteDatasource: ref.read(inquiryRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// ================= IMPLEMENTATION =================

class InquiryRepository implements IInquiryRepository {
  final IInquiryRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  InquiryRepository({
    required IInquiryRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, InquiryEntity>> createInquiry({
    required String schoolId,
    required String message,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: "No internet connection. Connect to send your question."),
      );
    }

    try {
      final result = await _remoteDatasource.createInquiry(
        schoolId: schoolId,
        message: message,
      );

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to send question",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InquiryEntity>>> getMyInquiries() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: "No internet connection."),
      );
    }

    try {
      final result = await _remoteDatasource.getMyInquiries();

      return Right(result.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to fetch your questions",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}