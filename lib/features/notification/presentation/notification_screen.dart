/*
-------------------------------
Placing FCM initialization code

    ------------------- Current Code ----------------------
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await FirebaseMessagingService().init();
      ref.read(fcmTokenProvider.notifier).state = token;
    });
    ------------------------------------------------------
    - You are inside a widget’s initState.
    - You are calling FirebaseMessagingService().init() and updating a Riverpod provider.

-------------------------------
Is this production-friendly?
    ✅ Partially okay for learning/demo purposes, because:
        - You need ref to update Riverpod state.
        - You are only initializing once at app start.

    ❌ But in production, you usually want:
        1. FCM initialization at the top level (after Firebase.initializeApp()) in main.dart or a dedicated AppInitializer.
        2. The token should also be sent to backend immediately after fetching.
        3. Widget screens should not be responsible for initialization.

    Why?
        - Widgets can be destroyed/rebuilt anytime.
        - You might open another screen that also tries to fetch the token → duplicate logic.
        - Lifecycle issues: if the widget is not yet loaded, you miss the token fetch.


*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/features/notification/application/providers.dart';
import 'package:firebase_scratchpad/services/firebase/firebase_messaging_service.dart';
import 'package:firebase_scratchpad/features/notification/application/notification_controller.dart';

class NotificationDemoScreen extends ConsumerStatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  ConsumerState<NotificationDemoScreen> createState() =>
      _NotificationDemoScreenState();
}

class _NotificationDemoScreenState
    extends ConsumerState<NotificationDemoScreen> {
  final _fcmService = FirebaseMessagingService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;

        if (userId != null) {
          final controller = ref.read(
            permissionControllerProvider,
          ); // Get your controller from Riverpod
          await controller.requestAndInitToken(
            userId,
          ); // Pass the userId to your method
          debugPrint('✅ User logged in. Initialize FCM token.');

          // Setup foreground listener
          _fcmService.setupForegroundListener(ref);

          // Setup background listener (once at app start)
          _fcmService.setupBackgroundHandler();
        } else {
          // Handle case when user is not logged in yet
          debugPrint('❌ User not logged in. Cannot initialize FCM token.');
        }
      } catch (e, stack) {
        debugPrint('❌ Error initializing FCM token: $e');
        debugPrint('❌ ${stack.toString()}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(fcmTokenProvider);
    final isGranted = ref.watch(notificationPermissionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FCM Token Demo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Notification Permission: ${isGranted ? "Granted" : "Denied"}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                token ?? 'Token not generated yet',
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   final token = ref.watch(fcmTokenProvider);

  //   return Scaffold(
  //     appBar: AppBar(title: const Text('FCM Token Demo')),
  //     body: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Text(
  //           token ?? 'Token not generated yet',
  //           textAlign: TextAlign.justify,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// -----------------------------------------------------------------
// ✅ Recommended pattern

// 1. Create a dedicated FCM service:

// class FirebaseMessagingService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   Future<String?> initAndGetToken() async {
//     await _messaging.requestPermission();
//     final token = await _messaging.getToken();
//     // Save to Firestore immediately
//     if (token != null) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUserId)
//           .update({'fcmToken': token});
//     }
//     return token;
//   }
// }

// 2. Initialize in main.dart after Firebase init:

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   // In Riverpod, a ProviderContainer is essentially a standalone instance of the Riverpod state system.
//   final container = ProviderContainer();  // A container holds all your providers and their state outside of the widget tree.

//   final token = await FirebaseMessagingService().initAndGetToken();
//   container.read(fcmTokenProvider.notifier).state = token;

//   runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
// }

/*
Key difference from ref:
  - ref         → tied to a widget; listens and rebuilds UI automatically.
  - container   → global, top-level, can initialize state before any widgets exist.
*/
