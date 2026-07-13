import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/notification/data/repositories/notification_repository.dart';
import 'package:sikhsha_sathi/features/notification/domain/entities/notification_entity.dart';
import 'package:sikhsha_sathi/features/notification/domain/repositories/notification_repository.dart';

// ================= PROVIDER =================

final getNotificationsUsecaseProvider =
    Provider<GetNotificationsUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);

  return GetNotificationsUsecase(notificationRepository: repository);
});

// ================= USECASE =================

class GetNotificationsUsecase
    implements UsecaseWithoutPrams<List<NotificationEntity>> {
  final INotificationRepository _notificationRepository;

  GetNotificationsUsecase({
    required INotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() {
    return _notificationRepository.getNotifications();
  }
}