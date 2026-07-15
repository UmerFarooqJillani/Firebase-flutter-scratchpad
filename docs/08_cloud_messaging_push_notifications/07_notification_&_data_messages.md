# <p align="center"> Notification & Data Messages </p>

## Notification Click Navigation
**Purpose:** Handle what happens when a user taps a notification.

**Key points:**
- Use FirebaseMessaging.onMessageOpenedApp to detect taps.
- Navigate users to a specific page or content in the app.
- Store payload in Riverpod provider if needed.
- **Example:**
    ```dart
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final chapterId = message.data['chapterId'];
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => ChapterScreen(chapterId: chapterId),
    ));
    });
    ```
> Even without multiple pages, update the NotificationDemoScreen UI to show tapped notification details.

## Notification vs Data Messages
**Purpose:** Understand two FCM message types.

**Notification Messages:**
- Displayed automatically by OS when app is backgrounded.
- Foreground: you need manual handling.

**Data Messages:**
- Always delivered to app code.
- Can handle silently or create custom UI.
- **Example:**
    ```json
    {
    "notification": {"title": "New Chapter"},
    "data": {"chapterId": "123"}
    }
    ```

## Local Notifications Integration
**Purpose:** Show notifications when app is in foreground using `flutter_local_notifications`.

**Steps:**
1. Add dependency: `flutter_local_notifications`.
2. Configure plugin.
3. On foreground FCM message, display local notification.

--- 
