import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';

import 'package:sikhsha_sathi/features/notification/data/datasources/notification_datasource.dart';
import 'package:sikhsha_sathi/features/notification/data/models/notification_api_model.dart';

// ================= PROVIDER =================

final notificationRemoteDatasourceProvider =
    Provider<INotificationRemoteDataSource>((ref) {
  return NotificationRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

// ================= IMPLEMENTATION =================

class NotificationRemoteDatasource implements INotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDatasource({required this.apiClient});

  @override
  Future<List<NotificationApiModel>> getNotifications() async {
    final response = await apiClient.get(ApiEndpoints.notifications);

    final List<dynamic> data = response.data["data"] ?? [];

    return data.map((json) => NotificationApiModel.fromJson(json)).toList();
  }
}