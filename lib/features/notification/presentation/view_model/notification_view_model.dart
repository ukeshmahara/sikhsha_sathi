import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:sikhsha_sathi/features/notification/presentation/state/notification_state.dart';

const String _kLastSeenKey = 'notifications_last_seen_at';

// ================= PROVIDER =================

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
  NotificationViewModel.new,
);

// ================= VIEWMODEL =================

class NotificationViewModel extends Notifier<NotificationState> {
  late GetNotificationsUsecase _getNotificationsUsecase;
  late SharedPreferences _prefs;

  @override
  NotificationState build() {
    _getNotificationsUsecase = ref.read(getNotificationsUsecaseProvider);
    _prefs = ref.read(sharedPreferencesProvider);

    return const NotificationState();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(
      status: NotificationStatus.loading,
      errorMessage: null,
    );

    final result = await _getNotificationsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      ),
      (notifications) {
        final lastSeenString = _prefs.getString(_kLastSeenKey);
        final lastSeen = lastSeenString != null
            ? DateTime.tryParse(lastSeenString)
            : null;

        final unreadCount = lastSeen == null
            ? notifications.length
            : notifications
                .where((n) => n.createdAt.isAfter(lastSeen))
                .length;

        state = state.copyWith(
          status: NotificationStatus.loaded,
          notifications: notifications,
          unreadCount: unreadCount,
        );
      },
    );
  }

  // Called when the user opens the notification list — marks everything
  // currently loaded as "seen" so the bell badge clears.
  Future<void> markAllAsSeen() async {
    if (state.notifications.isEmpty) return;

    final newestCreatedAt = state.notifications
        .map((n) => n.createdAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    await _prefs.setString(_kLastSeenKey, newestCreatedAt.toIso8601String());

    state = state.copyWith(unreadCount: 0);
  }
}