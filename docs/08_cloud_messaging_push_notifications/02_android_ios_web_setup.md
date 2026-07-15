# <p align="center"> Android / iOS / Web Setup </p>

## Native configuration
- **Android:** `android/app/`
- **iOS:** `ios/Runner/`
- **Web:** `web/`

## Step-by-step setup
1. Add dependencies
    - Run:
        ```bash
        flutter pub add firebase_messaging
        ```
    - Optional but recommended:
        ```bash
        flutter pub add flutter_local_notifications
        ```
2. Android Setup
    - **Add permission**
        - Open:
            ```
            android/app/src/main/AndroidManifest.xml
            ```
        - Add:
            ```xml
            <uses-permission android:name="android.permission.INTERNET"/>
            ```
    - **Add messaging service metadata**
        - Inside <application> tag:
            ```xml
            <meta-data
                android:name="com.google.firebase.messaging.default_notification_channel_id"
                android:value="high_importance_channel"/>
            ```
    - **Enable Firebase config**
        - Make sure: `google-services.json`
        - is inside: `android/app/`
    - **Under the hood (Android)**
        - Firebase SDK initializes in native layer
        - Google Play Services handles push delivery
        - device registers with FCM
        - token is generated
3. iOS Setup
    - **Add capabilities**
        - Open Xcode:
        - Enable:
            - Push Notifications
            - Background Modes → Remote notifications
    - **Pod install**
        ```bash
        cd ios
        pod install
        ```
    - **Info.plist updates**
        - Ensure:
        ```xml
        <key>FirebaseAppDelegateProxyEnabled</key>
        <true/>
        ```
    - **Under the hood (iOS)**
        - FCM routes messages through APNs
        - Apple Push Notification Service delivers messages
        - Firebase acts as bridge
4. Web Setup
    - **Add web config in Firebase console**
        - You will already have:
            - apiKey
            - authDomain
            - projectId
    - **Add service worker**
        - Create: `web/firebase-messaging-sw.js`
        - This handles background notifications.
    - **Under the hood (Web)**
        - browser registers service worker
        - service worker listens for push events
        - Firebase injects payload
        - browser displays notification
5. Flutter Firebase Messaging Initialization
    ```dart
    // lib\services\firebase\firebase_messaging_service.dart
    - Init fnc that get/return Token
    ```
6. Riverpod integration (important)
    - We convert messaging into state.
    - **Create provider:** `lib\features\notification\application\providers.dart`
        ```
        // FCM Token Provider
        ```
    - FCM delivers notifications or tokens to the device.
    - We want the app to reactively update UI or store tokens in a global state.
    - **Riverpod helps:**
        - Centralize FCM token state
        - Notify all widgets listening for token changes
        - Keep service layer clean (pure Firebase logic)
7. Where to call this in app
    - **After Firebase initialization:**
        ```dart
        // lib\features\notification\presentation\notification_screen.dart
        // ------------------
        // final messagingService = FirebaseMessagingService();
        // await messagingService.init();
        // -----------------------------------------------------
        final token = await FirebaseMessagingService().init();
        ref.read(fcmTokenProvider.notifier).state = token;
        ```
    ## Fix: Flutter Notification Error
    ### Why it happens
    The notification plugin uses new Java features that older Android systems can't read. **Desugaring** translates these features so the app runs smoothly.
    ### File to open: `android/app/build.gradle.kts`
    #### Code to update
    1. Inside `android { compileOptions { ... } }`, add this line:
        ```kts
        isCoreLibraryDesugaringEnabled = true
        ```
    2. At the very bottom (outside the `android` block), add this block:
        ```kts
        dependencies {
            coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
        }
        ```
8. What is FCM Token?
    - **FCM token** = device identity for messaging
    - **Example:**
        ```
        User A:
        Android Phone → Token A

        User A:
        iPhone → Token B
        ```
        - Same user = multiple tokens.
    - **Under the hood:**
        - Firebase registers device
        - generates unique token
        - stores mapping internally
        - backend uses token to send messages

9. Why call in widget instead of `main()`?
    - `main()` runs before the app widget tree is built
        - In `main()`, you do not have `ref` unless you create a `ProviderContainer` manually (advanced).
        - It's harder to handle async calls, errors, or UI updates.
    - Widget context gives you `ref`
        - You can store the token in Riverpod   
        - UI can react immediately
        - Follows production-friendly separation (service pure, provider handles state, widget handles UI)
    - This is the **recommended approach in production** for `Flutter + Riverpod`.
    - **More Production Friendly details** [Click Here](../../lib/features/notification/presentation/notification_screen.dart)
---- 
## Production recommendations
1. **Always store token in Firestore:** Never rely on local token only.
2. **Refresh token handling**
    - Tokens can change:
        - app reinstall
        - OS updates
        - security reset
    - You must listen: `FirebaseMessaging.instance.onTokenRefresh`
3. **Do NOT call getToken repeatedly:** Call once + listen for updates.
4. **Separate service layer:** Do NOT put FCM logic in UI.
    - Correct:
        ```
        Service → Riverpod → UI
        ```

## Common beginner mistakes
1. **Not requesting permission (iOS/web):** Notifications silently fail.
2. **Putting FirebaseMessaging code inside widgets:** Bad architecture.
3. **Not storing token in backend:** Then notifications cannot be targeted.
    - Explanation:
        - The FCM token is generated on the device.
        - If you **only keep it in local memory (Riverpod or widget state)**, you cannot send notifications to that device later, because your server (or your admin panel) has no way to reach it.
        - **Storing in the backend** is necessary. In most Flutter + Firebase apps, Firestore acts as your backend database, so storing the token there is standard practice.
--- 