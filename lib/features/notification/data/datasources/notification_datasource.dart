import 'package:sikhsha_sathi/features/notification/data/models/notification_api_model.dart';
import 'package:sikhsha_sathi/features/notification/domain/entities/notification_entity.dart';

abstract interface class INotificationLocalDataSource {
  List<NotificationEntity> getCachedNotifications();

  Future<void> replaceCache(List<NotificationEntity> notifications);
}

abstract interface class INotificationRemoteDataSource {
  Future<List<NotificationApiModel>> getNotifications();
}