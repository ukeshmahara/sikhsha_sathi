import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/chatbot/data/repositories/chatbot_repository.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/repositories/chatbot_repository.dart';

final clearChatHistoryUsecaseProvider =
    Provider<ClearChatHistoryUsecase>((ref) {
  final repository = ref.read(chatbotRepositoryProvider);
  return ClearChatHistoryUsecase(chatbotRepository: repository);
});

class ClearChatHistoryUsecase implements UsecaseWithoutPrams<bool> {
  final IChatbotRepository _chatbotRepository;

  ClearChatHistoryUsecase({required IChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _chatbotRepository.clearHistory();
  }
}