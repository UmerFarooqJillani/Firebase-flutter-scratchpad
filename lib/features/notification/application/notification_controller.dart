import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/core/providers/fcm_provider.dart';
import 'package:firebase_scratchpad/services/firebase/firebase_messaging_service.dart';
import 'package:firebase_scratchpad/features/notification/application/permission_provider.dart';

class PermissionController {
  final WidgetRef ref;
  final FirebaseMessagingService service;

  PermissionController(this.ref, this.service);
  // Merge token initialization in controller
  Future<void> requestAndInitToken() async {
    bool granted = await service.requestPermission();
    ref.read(notificationPermissionProvider.notifier).state = granted;

    if (granted) {
      final token = await service.init();
      ref.read(fcmTokenProvider.notifier).state = token;
    }
  }
}
