import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/connectivity/network_info.dart';

import 'package:sikhsha_sathi/features/review/data/datasources/review_datasource.dart';
import 'package:sikhsha_sathi/features/review/data/datasources/remote/review_remote_datasource.dart';
import 'package:sikhsha_sathi/features/review/domain/entities/review_entity.dart';
import 'package:sikhsha_sathi/features/review/domain/repositories/review_repository.dart';

// ================= PROVIDER =================

final reviewRepositoryProvider = Provider<IReviewRepository>((ref) {
  return ReviewRepository(
    remoteDatasource: ref.read(reviewRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// ================= IMPLEMENTATION =================

class ReviewRepository implements IReviewRepository {
  final IReviewRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  ReviewRepository({
    required IReviewRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  Future<T> _guard<T>(Future<T> Function() action) async {
    // helper used by every method below to avoid repeating the same
    // connectivity check + try/catch/DioException handling five times
    if (!await _networkInfo.isConnected) {
      throw const ApiFailure(
        message: "No internet connection. Reviews require a live connection.",
      );
    }
    return action();
  }

  @override
  Future<Either<Failure, SchoolReviewsResult>> getSchoolReviews(
    String schoolId,
  ) async {
    try {
      final result = await _guard(
        () => _remoteDatasource.getSchoolReviews(schoolId),
      );

      return Right(
        SchoolReviewsResult(
          reviews: result.reviews.map((m) => m.toEntity()).toList(),
          summary: RatingSummary(
            average: result.average,
            count: result.count,
          ),
        ),
      );
    } on ApiFailure catch (f) {
      return Left(f);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to fetch reviews",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> createReview({
    required String schoolId,
    required int rating,
    required String comment,
  }) async {
    try {
      final result = await _guard(
        () => _remoteDatasource.createReview(
          schoolId: schoolId,
          rating: rating,
          comment: comment,
        ),
      );

      return Right(result.toEntity());
    } on ApiFailure catch (f) {
      return Left(f);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to post review",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
  }) async {
    try {
      final result = await _guard(
        () => _remoteDatasource.updateReview(
          reviewId: reviewId,
          rating: rating,
          comment: comment,
        ),
      );

      return Right(result.toEntity());
    } on ApiFailure catch (f) {
      return Left(f);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to update review",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReview(String reviewId) async {
    try {
      final result = await _guard(
        () => _remoteDatasource.deleteReview(reviewId),
      );

      return Right(result);
    } on ApiFailure catch (f) {
      return Left(f);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to delete review",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TopRatedSchool>>> getTopRatedSchools({
    int limit = 10,
  }) async {
    try {
      final result = await _guard(
        () => _remoteDatasource.getTopRatedSchools(limit: limit),
      );

      return Right(result.map((m) => m.toEntity()).toList());
    } on ApiFailure catch (f) {
      return Left(f);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ??
              "Failed to fetch top rated schools",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}