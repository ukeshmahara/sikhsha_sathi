import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/chatbot/data/repositories/chatbot_repository.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/repositories/chatbot_repository.dart';

final sendChatMessageUsecaseProvider =
    Provider<SendChatMessageUsecase>((ref) {
  final repository = ref.read(chatbotRepositoryProvider);
  return SendChatMessageUsecase(chatbotRepository: repository);
});

class SendChatMessageUsecase
    implements UsecaseWithParams<ChatMessageEntity, String> {
  final IChatbotRepository _chatbotRepository;

  SendChatMessageUsecase({required IChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository;

  @override
  Future<Either<Failure, ChatMessageEntity>> call(String message) {
    return _chatbotRepository.sendMessage(message);
  }
}