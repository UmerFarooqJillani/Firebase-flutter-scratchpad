# <p align="center"> Device And Tool Setup </p>

## PART A — Required tools (Device Setup)
1. **Flutter**
    - Check: `flutter doctor`
2. **Node.js + npm**
    - Check:
        ```bash
        # Firebase CLI depends on Node.
        node --version
        npm --version
        ```
3. **Firebase CLI**
    - Install: `npm install -g firebase-tools`
    - Login:
        ```bash
        # This connects your local machine to your Firebase account.
        firebase login
        # firebase logout
        ```
4. **FlutterFire CLI**
    - Install:
        ```bash
        dart pub global activate flutterfire_cli
        ```
    - Check: `flutterfire --version`
    - If not working:
        - Add this to PATH: `C:\Users\YOUR_USER\AppData\Local\Pub\Cache\bin`
            1. Copy this exactly: `C:\Users\HP 840 G3\AppData\Local\Pub\Cache\bin`
            2. Open Environment Variables
            3. Open Environment Variables panel
            4. Find PATH - In User variables (top section): Select it
            5. Click: Edit
            6. Add new path - Click: New
            7. Paste your path: `C:\Users\HP 840 G3\AppData\Local\Pub\Cache\bin`
            8. OK. (Restart terminal)
## PART B — Connect using CLI
1. **Create Firebase Project**
    - Go to Firebase Console:
        - Create project: `flutter-firebase-learning-lab`
    - This project will contain:
        - Auth
        - Firestore
        - Storage
        - Analytics
        - etc.
2. **Go to Flutter project**
    - `cd your_flutter_project`
    - Must contain: `pubspec.yaml`
3. **Add Firebase Core**
    - `flutter pub add firebase_core`
    - This is the base plugin for Firebase.
4. **Run configure**
    - `flutterfire configure`
    - What happens:
        - asks you to select Firebase project
        - registers your app (Android/iOS/Web)
        - generates config
5. **Generated file**
    - `lib/firebase_options.dart`
    - This file contains: `DefaultFirebaseOptions.currentPlatform`
    - Meaning:
        - Android config
        - iOS config
        - Web config
    - All in one place.

### Under the hood (When you run: `flutterfire configure`)
It does:
- creates Firebase app entry in backend
- links your package name / bundle ID
- generates config values:
    - API key
    - project ID
    - app ID
- creates Dart config file
--- 