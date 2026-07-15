import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/legacy.dart';

final notificationPermissionProvider = StateProvider<bool>((ref) => false);
final fcmTokenProvider = StateProvider<String?>(
  (ref) => null,
); // Stores current FCM token in state.

final initialMessageProvider =
    StateProvider //Use StateProvider because only one screen is active.
    <RemoteMessage?>((ref) => null); // Init Messages

final notificationListProvider =
    StateNotifierProvider<NotificationListNotifier, List<RemoteMessage>>(
      (ref) => NotificationListNotifier(),
    );

class NotificationListNotifier extends StateNotifier<List<RemoteMessage>> {
  NotificationListNotifier()
    : super([]); // Stores list of received notifications.

  void addNotification(RemoteMessage message) {
    // Always prepend new messages for most recent first.
    state = [message, ...state];
  }
}
