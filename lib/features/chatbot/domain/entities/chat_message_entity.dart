import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

class ChatMessageEntity extends Equatable {
  final String id;
  final ChatRole role;
  final String content;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, role, content, createdAt];
}