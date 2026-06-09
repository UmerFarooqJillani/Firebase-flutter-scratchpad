# <p align="center"> App Check </p>

## App Check — what, why, when, how
App Check verifies that requests are coming from your real app, not from a fake script, cloned app, bot, or unauthorized client.

It is different from Authentication:
```
Authentication = verifies the user
App Check      = verifies the app/device
Rules          = verify data permission
```

## Simple real-world example
Imagine your Firebase project is a school app.

**A real student opens your Flutter app:** `Real Flutter app → Firebase Auth → Firestore`

**But an attacker writes a Python script using your public Firebase config:** `Fake script → Firestore`

Without App Check, Firebase mainly depends on Auth + Rules.

**With App Check enabled:** `Fake script has no valid App Check token → rejected`

## When to use App Check
Use App Check when:
- your app is close to production
- your Firestore/Storage is used by real users
- you want to reduce abuse, fake clients, bots, and scripted traffic
- your Firebase config is public in GitHub or app files
- you use Firestore, Storage, Realtime Database, Functions, or supported Firebase services

Do not enforce it on day one while you are still learning setup. First make Auth + Firestore work, then add App Check.

## How App Check works under the hood
**Flow:**
```
Flutter app starts
↓
Firebase initializes
↓
App Check asks platform provider for proof
↓
Provider verifies app/device
↓
Firebase App Check returns token
↓
Firebase SDK attaches token to requests
↓
Firestore/Storage accepts only valid requests
```

## Platform providers
### Android Use:
`Play Integrity`

This checks that the request comes from a genuine Android app/device environment. Firebase lists Play Integrity as the default Android provider for Flutter App Check.
### iOS Use:
`DeviceCheck`

**or stronger:** `App Attest`

Firebase lists Apple platform providers such as DeviceCheck/App Attest for App Check.

### Web Use:
`reCAPTCHA v3 / reCAPTCHA Enterprise`

Web needs this because browsers are easier to imitate than installed apps.

--- 

## Where to add code
**Use:** `lib/services/firebase/firebase_initializer.dart`

Because App Check should activate immediately after Firebase initialization.

1. Add package
    - Run: `flutter pub add firebase_app_check`
2. Basic implementation
    - File: `lib/services/firebase/firebase_initializer.dart`

## Register App on Firebase

Replace this placeholder in the code: `providerWeb: ReCaptchaV3Provider('recaptcha-v3-site-key'),`

with your **real reCAPTCHA v3 site key** from Firebase/App Check setup. Otherwise web App Check will not work.

Use:
```dart
await FirebaseAppCheck.instance.activate(
  providerWeb: ReCaptchaV3Provider('YOUR_REAL_RECAPTCHA_V3_SITE_KEY'),

  providerAndroid: kDebugMode
      ? AndroidDebugProvider()
      : AndroidPlayIntegrityProvider(),

  providerApple: kDebugMode
      ? AppleDebugProvider()
      : AppleAppAttestProvider(),
);
```
Your Android, iOS, and Web apps are still `not registered in App Check`. You must click Register for each platform in Firebase Console.

Setup:
1. Android → Register → choose Play Integrity
2. iOS → Register → choose App Attest or DeviceCheck
3. Web → Register → choose reCAPTCHA v3
4. Keep enforcement OFF until testing is successful

Your current code means:
```
- Debug mode:
    Android → AndroidDebugProvider
    Apple   → AppleDebugProvider
- Release mode:
    Android → Play Integrity
    Apple   → App Attest
- Web:
    reCAPTCHA v3
```
**Production note:** for Apple, safer compatibility is:
```
providerApple: kDebugMode
    ? AppleDebugProvider()
    : AppleAppAttestWithDeviceCheckFallbackProvider(),
```
because App Attest needs newer Apple OS support.

### Android App Check → Play Integrity registration

#### SHA-256 fingerprint
For production
You will eventually have:
```
Debug SHA-256
Release SHA-256
Play Store SHA-256
```
#### Token Time To Live (TTL)
- You currently have: `1 Hour`
- Keep it exactly like that.
- **What is TTL?**
    - When App Check verifies your app:
        ```
        App verified
        ↓
        Firebase issues App Check Token
        ↓
        Token stays valid for TTL duration
        ```
    - With: `1 hour` (Google's default recommendation is typically sufficient.)
    - Firebase will automatically refresh the token when needed.

#### You add SHA-256 fingerprints here:
```
Firebase Console
→ Project Settings
→ General
→ Your apps
→ Android app
→ Add fingerprint
```
Then paste the SHA-256 value and save.

**To generate each SHA-256**
1. Debug SHA-256
2. Release SHA-256 (Used when you build APK/AAB yourself with your release key.)
3. Play Store SHA-256 (Used when app is uploaded to Google Play.)

**For production**, 
- Add all three in Firebase.
- You do NOT need to remove old SHA fingerprints.
- Firebase supports multiple SHA fingerprints:
    ```
    Firebase Project
    ├─ Debug SHA
    ├─ Release SHA
    └─ Play Store SHA
    ```
- All can exist together.

### Web App check → reCAPTCHA v3
1. Open reCAPTCHA Console
    - Go to: `https://www.google.com/recaptcha/admin`
    - Login with the same Google account you use for Firebase.
2. Register a new site
    - Select: `reCAPTCHA v3`
    - Fill:
        ```
        Label:
        Firebase Scratchpad

        Domains:
            - localhost
            - yourdomain.com (later)
        ```
    - For learning Flutter Web `localhost` is enough.
3. Create
    - Google will generate: `Site Key` & `Secret Key`
4. Firebase Console (your current screen)
    - Paste: `Secret Key` into `reCAPTCHA secret key` field.
    ```
    Secret Key = Private = Firebase Console
    ```
5. Flutter Code
    - Use:
        ```dart
        providerWeb: ReCaptchaV3Provider(
        'SITE_KEY',
        ),
        ```
    - Example:
        ```dart
        providerWeb: ReCaptchaV3Provider(
        '6Lcxxxxxxxxxxxxxxxx',
        ),
        ```
    ```
    Site Key = Public = Flutter App
    ```
```
Flutter uses SITE KEY
Firebase Console uses SECRET KEY
```
### For Android debug provider
In debug mode, Firebase usually prints an App Check debug token in console.

**It looks like:** `Firebase App Check Debug Token: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`

**Copy it and add here:**
```
Firebase Console
→ App Check
→ Android app
→ Manage debug tokens
→ Add token
```
Without adding this token, debug App Check requests may fail when enforcement is enabled.

### What `Enforcement OFF` means
App Check has two modes:
1. **Monitoring mode / Enforcement OFF**
    - Firebase checks App Check tokens, but does not block requests yet.
    - **Meaning:**
        ```
        Invalid App Check request → still allowed
        Valid App Check request   → allowed
        ```
    - Use this while testing.
2. **Enforcement ON**
    - Firebase blocks requests without a valid App Check token.
    - Meaning:
        ```
        Invalid App Check request → blocked
        Valid App Check request   → allowed
        ```
    - Use this only after your app is fully tested.
#### Why keep enforcement OFF first?
- Because if your setup has a mistake, Firebase may block your own app.
**Example:**
    ```
    Wrong SHA-256
    Wrong reCAPTCHA key
    Debug token not added
    iOS provider not configured
    ```
- If enforcement is ON, your app may suddenly fail with:
    ```
    permission-denied
    app-check-token-invalid
    unauthenticated
    ```
#### Where to control enforcement
- Go to:
    ```
    Firebase Console
    → App Check
    → APIs tab
    ```
- Then select services like:
    ```
    Cloud Firestore
    Firebase Storage
    Realtime Database
    Cloud Functions
    ```
- You will see an option like:
    ```
    Enforce
    ```
    or

    ```
    Enable enforcement
    ```
- Keep it **OFF** for now.

--- 

## Beginner testing workflow
Do this order:
```
1. Register Android/iOS/Web in App Check
2. Add App Check code in Flutter
3. Run app in debug mode
4. Add debug token if needed
5. Test Auth
6. Test Firestore read/write
7. Test Storage upload
8. Check App Check metrics
9. Then enable enforcement
```

--- 