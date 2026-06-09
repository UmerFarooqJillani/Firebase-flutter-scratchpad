import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_scratchpad/firebase_options.dart';

class FirebaseInitializer {
  const FirebaseInitializer._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized');
    try {
      await FirebaseAppCheck.instance.activate(
        // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
        // argument for `webProvider`
        providerWeb: ReCaptchaV3Provider(
          '6LeJuBMtAAAAAPkYHUOvDMiIr_U5yX6ZeaYvNSye',
        ),
        // Default provider for Android is the Play Integrity provider.
        // Choose from:
        // 1. Debug provider
        // 2. Safety Net provider
        // 3. Play Integrity provider
        providerAndroid: kDebugMode
            ? AndroidDebugProvider()
            : AndroidPlayIntegrityProvider(),
        // Default provider for iOS/macOS is the Device Check provider.
        // Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
        providerApple: kDebugMode
            ? AppleDebugProvider()
            : AppleAppAttestWithDeviceCheckFallbackProvider(),
      );

      // only for debuging Logs
      debugPrint('✅ App Check activated');
      final token = await FirebaseAppCheck.instance.getToken(true);
      // debugPrint('✅ App Check token: $token');
      debugPrint('✅ App Check token: ${token?.substring(0, 20)}...');
    } catch (e) {
      debugPrint('❌ App Check failed: $e');
    }
  }
}
