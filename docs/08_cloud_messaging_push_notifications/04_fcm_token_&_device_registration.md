# <p align="center"> FCM Token & Device Registration </p>

## What is an FCM Token?
- A unique device identifier for Firebase Cloud Messaging.
- Tied to your app + device + platform.
- Needed to send notifications to a specific device.

## Why Device Registration is Required
- One user may have multiple devices.
- Backend needs token mapping to know which devices to notify.
- Tokens can **change** (app reinstall, OS update, token refresh).

    **Production impact:**
- Without token storage, you cannot send personalized notifications.
- Without refresh handling, notifications may fail silently.

## Step-by-step Implementation
1. **Service to get token**
    ```dart
    // lib\services\firebase\firebase_messaging_service.dart
    Fnc: 
    - listenForTokenRefresh

    Question: Why we call FirebaseMessaging.instance instead of _messaging.
        - _messaging is just a local variable in the class.
        - FirebaseMessaging.instance is the singleton provided by the SDK.
        - Using .instance ensures you always get the same FirebaseMessaging object across your app.
        - This is required because FCM maintains internal state (token, listeners, background handlers) that must be consistent.
        
        Short rule: Use FirebaseMessaging.instance to access the real messaging singleton.
    ```
2. **Register token to backend (Firestore example)**
    ```dart
    // lib\features\notification\data\token_repo.dart
    // ----------------------------------------------
    Fnc:
    - Register Token
    - Remove Token

    // ----------------------------------------------
    Question: why you often see FirebaseMessaging.instance or FirebaseFirestore.instance declared multiple times, even if you already have it in firebase_service.dart

        Even if you call FirebaseMessaging.instance in multiple files:
            - Internally, Firebase SDK always returns the same singleton object.
            - No actual new object is created.
            - Using a central reference is mainly for code organization and maintainability, not raw performance.
        ✅ Recommendation
            - Centralize all Firebase service singletons in one service class.
            - Access through this class everywhere in your app.
            - Combine with Riverpod if you want to reactively store tokens, auth state, or other service-related state.
    // ----------------------------------------------
    ```
3. **Integrate with Riverpod**
    ```dart
    // lib\features\notification\application\notification_controller.dart
    Modify the `requestAndInitToken` Fnc:
        - Set the Backend Token
            - This fetches the current valid FCM token immediately after permission is granted.
            - This ensures your backend and provider have at least one token right now, so the user can receive notifications immediately.
        - onTokenRefresh listens for any future changes to the token.
            - So the listener is for automatic updates, not a repeat of the initial token fetch.
            - If a refresh happens, the old token in the provider is replaced with the new one automatically. This is expected behavior.
    ```
    > You are not replacing the old token unnecessarily, you’re just making sure both current and future tokens are saved. Production apps need this to ensure notifications always reach the device.
--- 
