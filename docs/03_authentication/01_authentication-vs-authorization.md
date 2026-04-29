# <p align=center> Authentication vs Authorization </p>

## What Authentication is
Authentication means Firebase verifies the user’s identity.

**Examples:**
```
Email + password
Phone + OTP
Google sign-in
Apple sign-in
```
After login, Firebase gives the app a signed-in user object.

**In Flutter:**
```
FirebaseAuth.instance.currentUser
```
This gives the currently signed-in user if one exists.

## What Authorization is
Authorization means checking what that authenticated user can access.

**Example:**
```
User A can read only users/userA
User B can read only users/userB
Admin can read all users
```
Authorization is usually enforced in:
```
Firestore Rules
Storage Rules
Custom backend rules
```
Not only in Flutter UI.<br>
**Bad thinking:**
```
Hide button = secure
```
Correct thinking:
```
Backend rules = secure
```
## Firebase Auth flow under the hood
```
Flutter UI
→ Riverpod AuthController
→ AuthRepository
→ FirebaseAuthService
→ firebase_auth plugin
→ native Firebase SDK
→ Firebase Auth backend
→ user session returned
```
Firebase sessions use ID tokens and refresh tokens

--- 