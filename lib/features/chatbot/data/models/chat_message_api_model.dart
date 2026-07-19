import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';

class ChatMessageApiModel {
  final String id;
  final ChatRole role;
  final String content;
  final DateTime createdAt;

  ChatMessageApiModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      role: role,
      content: content,
      createdAt: createdAt,
    );
  }

  factory ChatMessageApiModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageApiModel(
      id: json["_id"] ?? json["id"] ?? '',
      role: json["role"] == "assistant" ? ChatRole.assistant : ChatRole.user,
      content: json["content"] ?? '',
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
    );
  }
}