# <p align="center"> FCM Architecture & Message Flow </p>

## What is FCM Architecture?
**FCM Architecture means:**
> How a push notification travels from your `backend Server (Your API / Admin Panel) → Firebase (FCM) → Platform Layer (Andriod, Ios, Web) → user device → Flutter app (Foreground / Background Handler)`
- It is NOT a single step.
- It is a multi-stage delivery pipeline.

## Step-by-step Message Journey
1. **Backend creates message**
    - You press “Send Notification” in admin panel.
    - **Payload:**
        ```json
        {
        "title": "New Chapter Uploaded",
        "body": "Biology Chapter 5 is now available",
        "token": "device_token_here"
        }
        ```
    - **Your server decides:**
        - who should receive message
        - what message to send
2. **Backend sends to FCM**
    - Your server sends request to Firebase:
        ``` js
        POST https://fcm.googleapis.com/fcm/send
        ```
    - FCM now becomes responsible for delivery.
3. **FCM processes message**
    - FCM does:
        - validate request
        - find device(s)
        - check routing type:
            - token-based
            - topic-based
            - condition-based
        - prepare delivery pipeline
4. **FCM sends to platform services**
    - Now routing happens:
        - **Android:**
            ```
            FCM → Google Play Services → Device
            ```
        - **iOS:**
            ```
            FCM → APNs (Apple Push Notification Service) → Device
            ```
        - **Web:**
            ```
            FCM → Browser Push Service → Browser
            ```
5. **Device receives notification**
    - Now OS decides behavior:
        - **If app is in background:**
            - OS shows notification automatically
        - **If app is terminated:**
            - OS stores notification and shows it
        - **If app is in foreground:**
            - Flutter app receives it directly (no automatic UI display)
6. **Flutter handles notification**
    - Flutter receives data via:
        - `FirebaseMessaging.onMessage`
        - `FirebaseMessaging.onBackgroundMessage`
    - Then you decide:
        - show UI
        - update state
        - navigate screen
        - store data locally
--- 

## Types of Message Flow
1. **Notification Message Flow**
    - **Flow:**
        ```
        Backend → FCM → OS → Notification shown automatically
        ```
    - **Used for:**
        - simple alerts
        - marketing
        - reminders
    - **Limitation:**
        > You cannot fully control UI when app is killed/background.

2. **Data Message Flow (IMPORTANT FOR FLUTTER)**
    - **Flow:**
        ```
        Backend → FCM → Flutter App (handled by code)
        ```
    - **Used for:**
        - chat apps
        - custom UI notifications
        - silent updates
        - state sync
    - **Advantage:**
        - Full control in Flutter.

### Note:
- **Always separate message types:**
    - notification
    - data
    - silent sync
- **Always store notification history (if needed)**
    - FCM does NOT store messages for you.
    - You must use Firestore.

--- 
