import 'package:sikhsha_sathi/features/notification/domain/entities/notification_entity.dart';

class NotificationApiModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;

  NotificationApiModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      type: type,
      createdAt: createdAt,
    );
  }

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    return NotificationApiModel(
      id: json["_id"] ?? json["id"] ?? '',
      title: json["title"] ?? '',
      message: json["message"] ?? '',
      type: json["type"] ?? 'general',
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
    );
  }
}