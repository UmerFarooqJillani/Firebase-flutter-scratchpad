# <p align="center"> FCM & Push Notifications </p>

## What is a Push Notification?
A Push Notification is a message sent to a user's device even when the app is:
- Open
- Minimized
- In background
- Closed (terminated)

**Examples:**
- **WhatsApp**
    > Ali sent you a message
- **Daraz**
    > Flash Sale starts in 10 minutes
- **Foodpanda**
    > Your rider is arriving
- **Facebook**
    > You have 3 new friend requests

All of these are **push notifications**.

--- 
## What is Firebase Cloud Messaging (FCM)?
**FCM stands for:** Firebase Cloud Messaging

It is Google's free service that delivers push notifications from your backend to user devices.
- **Think of FCM as:**
    ```
    Post Office for Notifications
    ```
    - You don't send directly to phones.
- **Instead:**
    ```
    Your Backend
        ↓
    Firebase Cloud Messaging
        ↓
    User Device
    ```
    - FCM is the delivery network.

## Real World Example
A student purchases Biology Notes.

- You want to send:
    ```
    New Biology Chapter Uploaded
    ```
    - to 50,000 students.
- Without FCM:
    ```
    Backend
    ↓
    50,000 Direct Device Connections
    ```
    - Very difficult.
- With FCM:
    ```
    Backend
    ↓
    FCM
    ↓
    50,000 Devices
    ```
    - FCM handles delivery.

--- 
## Actual Flow
```
Backend Server
      ↓
Firebase Cloud Messaging
      ↓
Google Infrastructure
      ↓
Android/iOS/Web Notification Service
      ↓
    Device
      ↓
Flutter App
```

--- 
## Important Distinction
**Many beginners confuse:**
```
Notification
```
with
```
FCM
```
They are different.

### Notification
The message itself.

Example:
```
Your order has shipped
```
FCM
```
The delivery system.
```
Example:
```
Delivery truck carrying the message
```
--- 

## Types of Push Notifications
1. **Broadcast Notifications**
    - Send to everyone.
    - `Example:`
        ```
        New app update available
        ```
2. **User Specific Notifications**
    - Send to one user.
    - `Example:`
        ```
        Your payment was successful
        ```
3. Topic Notifications
    - Send to subscribers.
    - `Example:`
        ```
        All Biology Students
        ```
        - receive:
            ```
            New Biology Notes Uploaded
            ```
4. Silent Notifications
    - User sees nothing.
    - App receives data only.
    - Used for:
        - sync
        - refresh
        - cache updates

### FCM Supported Platforms
- **Android**
    - Most common.
- **iOS**
    - Uses Apple Push Notification Service internally.
- **Web**
    - Browser notifications.
- **Desktop**
    - Limited support depending on platform.
--- 

## Mental Model
```
Auth
    = Who is the user?

Firestore
    = What data belongs to user?

Storage
    = What files belong to user?

FCM
    = How do we reach the user?
```

### Thinking FCM works only when app is open:
- Wrong.
- FCM can work when:
    ```
    Foreground
    Background
    Terminated
    ```
- Depending on message type and platform.

--- 