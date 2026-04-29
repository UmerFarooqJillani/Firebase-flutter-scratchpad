# <p align="center"> Initialize Firebase </p>

## What initialization means
Before using:
```dart
FirebaseAuth
Firestore
Storage
```
You must run:
```dart
Firebase.initializeApp()
```
**Otherwise:** Firebase is not ready.

## Where to implement
Create file: `lib/services/firebase/firebase_initializer.dart`

**Code**
```dart
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class FirebaseInitializer {
  const FirebaseInitializer._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
```
Use in `main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'services/firebase/firebase_initializer.dart';

Future<void> main() async {
  // Firebase uses native platform plugins.
  // Flutter must be ready before using them.
  WidgetsFlutterBinding.ensureInitialized();

  // reads firebase_options.dart
  // connects to correct Firebase project
  // starts native Firebase SDK
  await FirebaseInitializer.initialize();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
```
**Flow:**
```
main()
→ Flutter binding ready
→ Firebase.initializeApp()
→ native Firebase SDK starts
→ app connects to backend
→ services ready
```
--- 
