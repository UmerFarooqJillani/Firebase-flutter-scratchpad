# <p align="center"> Setup Firebase Auth </p>

## Step 1 — Add package
Run:
```bash
flutter pub add firebase_auth
```
You already need:
```bash
flutter pub add firebase_core
```
Firebase Auth for Flutter requires the `firebase_auth` plugin, and the sign-in providers must also be enabled in Firebase Console.

## Step 2 — Enable Email/Password in Firebase Console
```
Firebase Console
→ Authentication
→ Sign-in method
→ Email/Password & Phone
→ Enable
```
> For testing, add test phone numbers in Firebase Console so you do not waste SMS quota.

> Without enabling it in Console, your Flutter code will fail even if your code is correct.

--- 