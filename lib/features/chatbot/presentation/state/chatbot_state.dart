import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';

enum ChatbotStatus { initial, loading, loaded, sending, error }

class ChatbotState extends Equatable {
  final ChatbotStatus status;
  final List<ChatMessageEntity> messages;
  final String? errorMessage;

  const ChatbotState({
    this.status = ChatbotStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  ChatbotState copyWith({
    ChatbotStatus? status,
    List<ChatMessageEntity>? messages,
    String? errorMessage,
  }) {
    return ChatbotState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}