import 'package:hive/hive.dart';

import 'package:sikhsha_sathi/core/constants/hive_table_constant.dart';
import 'package:sikhsha_sathi/features/notification/domain/entities/notification_entity.dart';

part 'notification_hive_model.g.dart';

@HiveType(
  typeId: HiveTableConstant.notificationTypeId,
)
class NotificationHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String createdAt; // stored as ISO 8601 string

  NotificationHiveModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  factory NotificationHiveModel.fromEntity(NotificationEntity entity) {
    return NotificationHiveModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.parse(createdAt),
    );
  }

  static List<NotificationEntity> toEntityList(
    List<NotificationHiveModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}