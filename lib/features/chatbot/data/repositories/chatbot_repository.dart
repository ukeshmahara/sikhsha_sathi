import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/services/connectivity/network_info.dart';

import 'package:sikhsha_sathi/features/chatbot/data/datasources/chatbot_datasource.dart';
import 'package:sikhsha_sathi/features/chatbot/data/datasources/remote/chatbot_remote_datasource.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/repositories/chatbot_repository.dart';

final chatbotRepositoryProvider = Provider<IChatbotRepository>((ref) {
  return ChatbotRepository(
    remoteDatasource: ref.read(chatbotRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class ChatbotRepository implements IChatbotRepository {
  final IChatbotRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  ChatbotRepository({
    required IChatbotRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  Future<bool> get _isOffline async => !await _networkInfo.isConnected;

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory() async {
    if (await _isOffline) {
      return const Left(ApiFailure(message: "No internet connection."));
    }

    try {
      final result = await _remoteDatasource.getHistory();
      return Right(result.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to load chat history",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage(String message) async {
    if (await _isOffline) {
      return const Left(
        ApiFailure(message: "No internet connection. Connect to chat with the assistant."),
      );
    }

    try {
      final result = await _remoteDatasource.sendMessage(message);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to send message",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearHistory() async {
    if (await _isOffline) {
      return const Left(ApiFailure(message: "No internet connection."));
    }

    try {
      final result = await _remoteDatasource.clearHistory();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?["message"] ?? "Failed to clear chat",
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}