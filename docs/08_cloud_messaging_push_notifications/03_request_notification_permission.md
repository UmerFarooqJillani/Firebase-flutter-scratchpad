# <p align="center"> Request Notification Permission </p>

## Step-by-step implementation
1. **Add required dependencies:**
    ```bash
    flutter pub add permission_handler
    flutter pub add firebase_messaging
    ```
    > `permission_handler` is optional but recommended for uniform permission request on Android/iOS.
2. **Create Notification Permission Service:**
    ```dart
    // lib\services\firebase\firebase_messaging_service.dart

    ```
3. **Create Riverpod Provider**
    ```dart
    // lib\features\notification\application\permission_provider.dart
    - Current permission state
    ```
4. **Connect Service and Provider**
    ```dart
    // lib\features\notification\application\notification_controller.dart

    ```
5. **Display Permission Status in UI**
    ```dart
    // lib\features\notification\presentation\notification_screen.dart

    ```

--- 