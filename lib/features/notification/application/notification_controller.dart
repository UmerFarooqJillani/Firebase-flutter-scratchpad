import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/features/notification/data/token_repo.dart';
import 'package:firebase_scratchpad/services/firebase/firebase_messaging_service.dart';
import 'package:firebase_scratchpad/features/notification/application/providers.dart';

final permissionControllerProvider = Provider<PermissionController>((ref) {
  final service = FirebaseMessagingService();
  final backendService = FCMBackendService();
  return PermissionController(ref, service, backendService);
});

class PermissionController {
  final Ref ref;
  final FirebaseMessagingService service;
  final FCMBackendService backendService;

  // Future<void> requestAndInitToken() async {
  //   bool granted = await service.requestPermission();
  //   ref.read(notificationPermissionProvider.notifier).state = granted;

  //   if (granted) {
  //     final token = await service.init(); // returns FCM token
  //     ref.read(fcmTokenProvider.notifier).state = token;
  //   }
  // }
  PermissionController(this.ref, this.service, this.backendService);
  // Merge token initialization in controller
  Future<void> requestAndInitToken(String userId) async {
    bool granted = await service.requestPermission();
    ref.read(notificationPermissionProvider.notifier).state = granted;

    if (granted) {
      // This fetches the current valid FCM token immediately after permission is granted.
      final token = await service.init(); // get current token
      ref.read(fcmTokenProvider.notifier).state = token;

      // register token with backend
      if (token != null) {
        await backendService.registerToken(userId, token);
      }

      // Listen for token refresh
      service.listenForTokenRefresh((newToken) async {
        // When a new token is issued, the listener fires and updates provider + backend automatically.
        ref.read(fcmTokenProvider.notifier).state = newToken;
        await backendService.registerToken(userId, newToken);
      });
    }
  }
}
