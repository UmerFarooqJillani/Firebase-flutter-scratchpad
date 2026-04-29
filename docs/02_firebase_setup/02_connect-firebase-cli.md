# <p align="center"> Connect using CLI </p>

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