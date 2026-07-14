import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
}
