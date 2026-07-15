# <p align="center"> Analytics & Crashlytics </p>

## What it is
- **Firebase Analytics** (what users are doing)
    - Firebase Analytics is a free service that automatically collects user behavior and engagement data in your app.
    - You can track:
        - screen views
        - button taps
        - user properties (like age, gender)
        - custom events
- **Firebase Crashlytics** (why app is failing)
    - Firebase Crashlytics is a real-time crash reporter.
    - It captures:
        - app crashes
        - stack traces
        - device info
        - custom logs
    - Helps you debug issues in production.

## Why it’s needed
- **Analytics:** Know which features users engage with. Make data-driven improvements.
- **Crashlytics:** Detect and fix bugs quickly before they affect more users.
- **Production apps:** Both services are essential for monitoring, improving UX, and maintaining app quality.

## How to implement Firebase Analytics step by step
1. **Add dependency**
    ```bash
    flutter pub add firebase_analytics
    ```
2. **Initialize Firebase** (Alreay init)
3. **Create an Analytics Service**
    ```dart
    // lib\services\firebase\analytics_service.dart

    ```
4. **Integrate with Riverpod Provider**
    ```dart
    // lib\features\analytics\application\analytics_provider.dart

    ```
5. **Log events from a screen**
    ```dart
    // lib\features\analytics\presentation\analytics_demo_screen.dart
    ```

## How to implement Crashlytics
1. **Add dependency**
    ```dart
    flutter pub add firebase_crashlytics
    ```
2. **Initialize Crashlytics**
    ```dart
    // lib\services\firebase\crashlytics_service.dart

    ```
3. **Integrate with Riverpod**
    ```dart
    // lib\features\analytics_crashlytics\application\provider.dart
    - crashlyticsProvider
    ```
4. **Log an error manually**
    ```dart
    // lib\features\analytics_crashlytics\presentation\analytics_demo_screen.dart

    ```
5. **Test Crash**
    ```dart
    final crashlytics = ref.watch(crashlyticsProvider);
    await crashlytics.testCrash(); // This will crash the app
    ```
    - Only use testCrash() in development.
    - Verify in Firebase console that crash appears.

--- 