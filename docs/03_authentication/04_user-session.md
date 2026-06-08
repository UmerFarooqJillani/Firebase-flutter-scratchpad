# <p align="center"> Store User Session / Profile (Name) </p>

Firebase Auth only stores identity information.

In real apps, we almost always use:
```
Firebase Auth
+
Firestore User Profile
```
Think of it like a school.
## Firebase Auth
**Stores:** Student ID Card

**Example:**
```
{
  "uid": "abc123",
  "phone": "+923001234567",
  "email": "ali@gmail.com"
}
```
**Auth only knows:**
- Who is this person?
- Is this person logged in?

## Firestore
**Stores:** Student Record
**Example:**
```
{
  "uid": "abc123",
  "name": "Ali",
  "phone": "+923001234567",
  "role": "student",
  "school": "ABC School",
  "profileImage": "...",
  "createdAt": "...",
  "lastLoginAt": "..."
}
```
This is your actual application data.

## Production Strategy
Whenever a user signs up:

**Step 1**
- Create account in Firebase Auth: `Firebase Auth`
- Result: `uid = abc123`

**Step 2**
- Create user profile in Firestore:
    ```
    users/
    abc123
    ```
- Document:
    ```
    {
    "uid": "abc123",
    "name": "Ali",
    "phone": "+923001234567",
    "email": null,
    "role": "user",
    "isProfileCompleted": false,
    "createdAt": serverTimestamp,
    "lastLoginAt": serverTimestamp
    }
    ```
## Where to Store User Data
**Firebase Auth** Store ONLY:
```
uid
email
phone
provider
```
**Firestore** Store:
```
name
role
profile image
address
school
progress
settings
subscription
```
--- 
## Session Strategy
- Many beginners think:<br>
`Store login in SharedPreferences/SecureStorage`
- ❌ Don't do this.

## Production Session Strategy
**Use:** 
```dart
// lib\core\auth\firebase_auth_service.dart
// Auth State Changes

FirebaseAuth.instance.authStateChanges()
```
**Firebase automatically stores:**
```
ID Token
Refresh Token
Session
```
internally.

## Under The Hood
**User logs in:**
```
Firebase Auth
↓
ID Token generated
↓
Refresh Token generated
↓
Stored securely by Firebase SDK
```
App closes.<br>
**User opens app again:**
```
Firebase SDK checks session
↓
Refresh token still valid
↓
New ID token issued
↓
User restored
```
No login screen.

--- 

## Remember this:
```
Firebase Auth
=
Identity
```
```
Firestore
=
User Profile + Business Data
```
**And:**
```
Firebase Session
=
Automatically managed by Firebase SDK
```
--- 

