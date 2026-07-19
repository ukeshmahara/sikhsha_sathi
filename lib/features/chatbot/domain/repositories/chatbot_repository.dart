import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';

abstract interface class IChatbotRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory();

  Future<Either<Failure, ChatMessageEntity>> sendMessage(String message);

  Future<Either<Failure, bool>> clearHistory();
}