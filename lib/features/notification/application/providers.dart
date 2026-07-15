import 'package:flutter_riverpod/legacy.dart';

final notificationPermissionProvider = StateProvider<bool>((ref) => false);
final fcmTokenProvider = StateProvider<String?>(
  (ref) => null,
); // Stores current FCM token in state.
