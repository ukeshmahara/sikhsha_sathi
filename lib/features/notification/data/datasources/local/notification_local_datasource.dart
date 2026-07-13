import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/services/hive/hive_service.dart';

import 'package:sikhsha_sathi/features/notification/data/datasources/notification_datasource.dart';
import 'package:sikhsha_sathi/features/notification/data/models/notification_hive_model.dart';
import 'package:sikhsha_sathi/features/notification/domain/entities/notification_entity.dart';

// ================= PROVIDER =================

final notificationLocalDatasourceProvider =
    Provider<INotificationLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);

  return NotificationLocalDatasource(hiveService: hiveService);
});

// ================= DATASOURCE =================

class NotificationLocalDatasource implements INotificationLocalDataSource {
  final HiveService _hiveService;

  NotificationLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  List<NotificationEntity> getCachedNotifications() {
    final models = _hiveService.getCachedNotifications();
    return NotificationHiveModel.toEntityList(models);
  }

  @override
  Future<void> replaceCache(List<NotificationEntity> notifications) async {
    final models = notifications
        .map((n) => NotificationHiveModel.fromEntity(n))
        .toList();

    await _hiveService.replaceCachedNotifications(models);
  }
}