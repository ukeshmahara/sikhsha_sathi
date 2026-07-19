import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/usecases/clear_chat_history_usecase.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/usecases/get_chat_history_usecase.dart';
import 'package:sikhsha_sathi/features/chatbot/domain/usecases/send_chat_message_usecase.dart';
import 'package:sikhsha_sathi/features/chatbot/presentation/state/chatbot_state.dart';

final chatbotViewModelProvider =
    NotifierProvider<ChatbotViewModel, ChatbotState>(ChatbotViewModel.new);

class ChatbotViewModel extends Notifier<ChatbotState> {
  late GetChatHistoryUsecase _getChatHistoryUsecase;
  late SendChatMessageUsecase _sendChatMessageUsecase;
  late ClearChatHistoryUsecase _clearChatHistoryUsecase;

  @override
  ChatbotState build() {
    _getChatHistoryUsecase = ref.read(getChatHistoryUsecaseProvider);
    _sendChatMessageUsecase = ref.read(sendChatMessageUsecaseProvider);
    _clearChatHistoryUsecase = ref.read(clearChatHistoryUsecaseProvider);
    return const ChatbotState();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(status: ChatbotStatus.loading, errorMessage: null);

    final result = await _getChatHistoryUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatbotStatus.error,
        errorMessage: failure.message,
      ),
      (messages) => state = state.copyWith(
        status: ChatbotStatus.loaded,
        messages: messages,
      ),
    );
  }

  Future<bool> sendMessage(String content) async {
    // optimistically show the user's own message immediately, so the chat
    // feels responsive rather than waiting for a full round trip
    final optimisticUserMessage = ChatMessageEntity(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      role: ChatRole.user,
      content: content,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      status: ChatbotStatus.sending,
      messages: [...state.messages, optimisticUserMessage],
      errorMessage: null,
    );

    final result = await _sendChatMessageUsecase(content);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ChatbotStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (assistantMessage) {
        state = state.copyWith(
          status: ChatbotStatus.loaded,
          messages: [...state.messages, assistantMessage],
        );
        return true;
      },
    );
  }

  Future<void> clearChat() async {
    final result = await _clearChatHistoryUsecase();

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) => state = state.copyWith(messages: []),
    );
  }
}