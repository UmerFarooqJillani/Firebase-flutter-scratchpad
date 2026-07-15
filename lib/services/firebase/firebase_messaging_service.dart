import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/features/notification/application/providers.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken(); // ask permission for iOS/Web
    debugPrint("✅ FCM Token: $token");
    return token;
  }

  // Notification Permission Service
  Future<bool> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Flow: Token changes → onTokenRefresh emits → your listener executes onUpdate(newToken)
  void listenForTokenRefresh(void Function(String newToken) onUpdate) {
    // Tokens can change due to:
    // - App reinstall
    // - OS reset
    // - Token expiry
    FirebaseMessaging
        .instance
        .onTokenRefresh // a stream that emits a new FCM token whenever it changes.
        .listen(onUpdate);
    // listen(...) subscribes to the stream so your code runs every time a new token is issued.
    // onUpdate is a callback you provide to update Riverpod state or backend storage.
  }

  // handle foreground messages listeners
  void setupForegroundListener(WidgetRef ref) {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
        '🔔 Foreground message received: ${message.notification?.title}',
      );
      // Update Riverpod provider
      ref.read(notificationListProvider.notifier).addNotification(message);
    });
  }

  // setup background messages listeners
  void setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint(
      '🔔 Background message received: ${message.notification?.title}',
    );
    // Optionally update Firestore or log
  }
}
