import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/connectivity/network_info.dart';

import 'package:sikhsha_sathi/features/recommendation/data/datasources/recommendation_datasource.dart';
import 'package:sikhsha_sathi/features/recommendation/data/datasources/remote/recommendation_remote_datasource.dart';
import 'package:sikhsha_sathi/features/recommendation/domain/entities/recommendation_entity.dart';
import 'package:sikhsha_sathi/features/recommendation/domain/repositories/recommendation_repository.dart';

// ================= PROVIDER =================

final recommendationRepositoryProvider =
    Provider<IRecommendationRepository>((ref) {
  return RecommendationRepository(
    remoteDatasource: ref.read(recommendationRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// ================= IMPLEMENTATION =================

class RecommendationRepository implements IRecommendationRepository {
  final IRecommendationRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  RecommendationRepository({
    required IRecommendationRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, RecommendationResult>> getRecommendations({
    required String stream,
    required double minFee,
    required double maxFee,
    String? location,
    String? notes,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(
          message:
              "No internet connection. AI recommendations require a live connection.",
        ),
      );
    }

    try {
      final result = await _remoteDatasource.getRecommendations(
        stream: stream,
        minFee: minFee,
        maxFee: maxFee,
        location: location,
        notes: notes,
      );

      return Right(
        RecommendationResult(
          recommendations:
              result.recommendations.map((m) => m.toEntity()).toList(),
          usedAi: result.usedAi,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ??
              "Failed to get recommendations",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}