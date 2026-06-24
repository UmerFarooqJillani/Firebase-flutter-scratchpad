# <p align="center"> Auth Persistence? </p>

**Many beginners think:**
```
User logs in
↓
App closes
↓
User should login again
```
But Firebase does not work like that.

## What is Auth Persistence?
Auth Persistence means:
```
Firebase remembers
the authenticated user
after app restart.
```
**Example:**
```
Login Today
↓
Close App
↓
Open Tomorrow
↓
Still Logged In
```
No login screen appears.

## Why does Firebase provide this?
**Without persistence:**
```
Open App
↓
Login

Close App
↓
Open Again

Login Again
```
Terrible user experience.

Modern apps remember users.

**Examples:**
```
WhatsApp
Facebook
Instagram
Gmail
TikTok
```
You don't login every day.

## Under the Hood
**When login succeeds:**
```
Email + Password
↓
Firebase Auth Server
↓
Generate Tokens
↓
Store Session Locally
```
The SDK saves authentication data on the device.

--- 
## How to check current user?
```dart
final user = FirebaseAuth.instance.currentUser;
```
**Example:**
```dart
if (user != null) {
  print("Logged In");
}
```
--- 
## authStateChanges()
- Most production apps use:
  ```dart
  FirebaseAuth.instance.authStateChanges()
  ```
- **Why?** Because auth state can change at any time.
```
// Flow
User Login
    ↓
Auth State Changed
    ↓
Stream Emits User

User Logout
    ↓
Auth State Changed  
    ↓
Stream Emits Null
```
**Riverpod Implementation**
```dart
final authStateProvider =
StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
```
### Example
```dart
final authState = ref.watch(authStateProvider);
```
- **If:**
  ```
  User Exists
  ```
  - Show:
    ```
    Home Screen
    ``` 
- **If:**
  ```
  User == null
  ```
  - Show:
    ```
    Login Screen
    ```
--- 