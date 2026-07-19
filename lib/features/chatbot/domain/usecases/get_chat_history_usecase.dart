import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/chatbot/data/repositories/chatbot_repository.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/repositories/chatbot_repository.dart';

final getChatHistoryUsecaseProvider = Provider<GetChatHistoryUsecase>((ref) {
  final repository = ref.read(chatbotRepositoryProvider);
  return GetChatHistoryUsecase(chatbotRepository: repository);
});

class GetChatHistoryUsecase
    implements UsecaseWithoutPrams<List<ChatMessageEntity>> {
  final IChatbotRepository _chatbotRepository;

  GetChatHistoryUsecase({required IChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository;

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call() {
    return _chatbotRepository.getHistory();
  }
}