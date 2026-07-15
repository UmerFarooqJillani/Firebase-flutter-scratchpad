# <p align="center"> Receive Notifications in Terminated State </p>

## Why this step matters
- Foreground & background messages are handled via listeners.
- Terminated messages cannot be received via `onMessage` or `onBackgroundMessage`.
- The app must **capture the initial message** that triggered launch.
- Missing this leads to **lost notifications** and poor UX.

## Where to add the code
Since you only have one screen (NotificationDemoScreen) and no routing yet:
- Keep the **initial message handling** in a service or provider (clean for production)
- Integrate it in `main.dart` after Firebase initialization
- Update `NotificationDemoScreen` to read from the provider and display the message
- Avoid `.overrideWithValue(initialMessage)` since this is causing errors in your `main.dart` — **it is unnecessary in a single-screen learning setup.**

## Step-by-step Implementation (With singel page)
1. **Add a provider for initial message**
    ```dart
    // lib\features\notification\application\providers.dart
    Provider: 
    - initialMessageProvider    // Stores the message that opened the app when terminated.
    ```
2. **Fetch initial message in `NotificationDemoScreen` initState**
    ```dart
    // lib\features\notification\presentation\notification_screen.dart
    - Get FCM initial message
    /*
    - Initial message is now fetched inside initState and saved to the provider.
    - Also adds the initial message to notificationListProvider so it appears on the screen.
    */
    ```

3. Display the initial message in `NotificationDemoScreen`
    ```dart
    // lib\features\notification\presentation\notification_screen.dart

    ```

--- 