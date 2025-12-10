/// Notification Model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final String? icon;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.icon,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    String? icon,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      icon: icon ?? this.icon,
    );
  }
}

enum NotificationType {
  transaction,
  security,
  promotion,
  system,
  family,
}

/// Mock Notification Data
/// PHASE 1: Hardcoded data for UI development
/// PHASE 2: Will be fetched from Supabase
class FakeNotifications {
  static List<AppNotification> get allNotifications => [
        AppNotification(
          id: 'notif-001',
          title: 'Payment Received',
          message: 'You received R15,000.00 from Company XYZ',
          type: NotificationType.transaction,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
          icon: '💰',
        ),
        AppNotification(
          id: 'notif-002',
          title: 'Security Alert',
          message: 'New device logged in from Johannesburg',
          type: NotificationType.security,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: false,
          icon: '🔒',
        ),
        AppNotification(
          id: 'notif-003',
          title: 'Card Payment',
          message: 'Payment of R450.00 at Pick n Pay',
          type: NotificationType.transaction,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
          icon: '💳',
        ),
        AppNotification(
          id: 'notif-004',
          title: 'Special Offer',
          message: 'Get 5% cashback on all groceries this month!',
          type: NotificationType.promotion,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          icon: '🎁',
        ),
        AppNotification(
          id: 'notif-005',
          title: 'Card Frozen',
          message: 'Your card has been frozen for security',
          type: NotificationType.security,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
          icon: '❄️',
        ),
        AppNotification(
          id: 'notif-006',
          title: 'Money Transfer',
          message: 'Transfer of R500.00 to Sipho completed',
          type: NotificationType.transaction,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
          icon: '💸',
        ),
        AppNotification(
          id: 'notif-007',
          title: 'System Update',
          message: 'Shield app updated to version 1.2.0',
          type: NotificationType.system,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
          icon: '⚙️',
        ),
        AppNotification(
          id: 'notif-008',
          title: 'Family Account',
          message: 'Your child requested R200 for school supplies',
          type: NotificationType.family,
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
          isRead: true,
          icon: '👨‍👩‍👧‍👦',
        ),
      ];

  /// Get unread notifications count
  static int get unreadCount => allNotifications.where((n) => !n.isRead).length;

  /// Get notifications by type
  static List<AppNotification> getByType(NotificationType type) {
    return allNotifications.where((n) => n.type == type).toList();
  }

  /// Mark notification as read
  static void markAsRead(String id) {
    // In a real app, this would update the backend
    // For now, it's just a placeholder
  }

  /// Mark all notifications as read
  static void markAllAsRead() {
    // In a real app, this would update the backend
    // For now, it's just a placeholder
  }

  /// Delete notification
  static void deleteNotification(String id) {
    // In a real app, this would update the backend
    // For now, it's just a placeholder
  }
}
