import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/core/presentation/widgets/glass_card.dart';
import 'package:rightlogistics/src/core/presentation/widgets/empty_state.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/notifications/data/notifications_repository.dart';
import 'package:rightlogistics/src/features/notifications/domain/notification_model.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryBlue,
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'No Notifications',
                description: 'You are all caught up!',
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(24.w),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(context, notification);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
  ) {
    IconData icon;
    Color iconColor = AppTheme.primaryBlue;

    switch (notification.type) {
      case NotificationType.alert:
        icon = Icons.warning_amber_rounded;
        iconColor = AppTheme.accentOrange;
        break;
      case NotificationType.shipment:
        icon = Icons.local_shipping_rounded;
        break;
      case NotificationType.promo:
        icon = Icons.local_offer_rounded;
        break;
      case NotificationType.info:
        icon = Icons.info_outline_rounded;
        break;
      case NotificationType.message:
        icon = Icons.mail_rounded;
        break;
    }

    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.go('/notifications/details', extra: notification);
        },
        borderRadius: BorderRadius.circular(16.w),
        child: Stack(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16.w),
              leading: CircleAvatar(
                backgroundColor: iconColor.withValues(alpha: 0.1),
                child: Icon(icon, color: iconColor, size: 20.w),
              ),
              title: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: !notification.isRead
                      ? FontWeight.w900
                      : FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _formatTime(notification.timestamp),
                    style: TextStyle(color: AppTheme.textGrey, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
