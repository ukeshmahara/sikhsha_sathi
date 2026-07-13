import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/notification/domain/entities/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
}