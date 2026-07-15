# <p align="center"> Receive Notifications in Foreground & Background </p>

## Why this step is needed
- **Foreground:** FCM does **not automatically display notifications**. Your app must handle them.
- **Background:** FCM delivers notification to OS, you can tap notification to launch app.
- Proper handling ensures **users never miss messages** and UI is updated correctly.

## Step-by-step implementation
1. **Create Riverpod provider**
    ```dart
    // lib\features\notification\application\providers.dart
    - notificationListProvider   // Provider
    - NotificationListNotifier   // Notifier Class

    ```
2. **Create FCM Message Service**
```dart
// lib\services\firebase\firebase_messaging_service.dart
Fnc:
- setupForegroundListener
- setupBackgroundHandler
- _firebaseMessagingBackgroundHandler
```

3. **Initializing FCM listeners in NotificationDemoScreen**
```dart
// lib\features\notification\presentation\notification_screen.dart
In `initState()`:
- setupForegroundListener(ref) → uses your Riverpod provider to store incoming messages
- setupBackgroundHandler() → registers top-level handler for background/terminated state
- You don’t need to call getToken() again here; the token is already handled in your PermissionController.
```

--- 
