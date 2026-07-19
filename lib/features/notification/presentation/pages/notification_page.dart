import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/features/notification/presentation/state/notification_state.dart';
import 'package:sikhsha_sathi/features/notification/presentation/view_model/notification_view_model.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(notificationViewModelProvider.notifier).loadNotifications();
      // mark as seen once they've actually opened this page
      await ref.read(notificationViewModelProvider.notifier).markAllAsSeen();
    });
  }

  Map<String, Color> _typeColors(String type) {
    switch (type) {
      case 'important':
        return {'bg': const Color(0xFFFDEBEC), 'icon': const Color(0xFFA32D2D)};
      case 'wish':
        return {'bg': const Color(0xFFEAF3DE), 'icon': const Color(0xFF27500A)};
      default:
        return {'bg': const Color(0xFFE6F1FB), 'icon': const Color(0xFF0C447C)};
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'important':
        return Icons.priority_high;
      case 'wish':
        return Icons.celebration_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationViewModelProvider);

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(notificationViewModelProvider.notifier)
            .loadNotifications(),
        child: _buildBody(notificationState),
      ),
    );
  }

  Widget _buildBody(NotificationState state) {
    if (state.status == NotificationStatus.loading &&
        state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == NotificationStatus.error &&
        state.notifications.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () => ref
                  .read(notificationViewModelProvider.notifier)
                  .loadNotifications(),
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (state.notifications.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: context.appSurfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 32,
                color: context.appTextSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.appTextPrimary,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        final colors = _typeColors(notification.type);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors['bg'],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _typeIcon(notification.type),
                  size: 18,
                  color: colors['icon'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.appTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(fontSize: 12, color: context.appTextSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _timeAgo(notification.createdAt),
                      style: TextStyle(fontSize: 10, color: context.appTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}