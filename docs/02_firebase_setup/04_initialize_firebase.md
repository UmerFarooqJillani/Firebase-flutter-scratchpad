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

## Firebase initialization with try/catch and timeout
1. **What is Firebase initialization?**
    - Firebase initialization means preparing Firebase before using any Firebase service.
      ```dart
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      ```
    - This connects your Flutter app to the correct Firebase project using the generated `firebase_options.dart` file. Firebase’s Flutter setup uses this same pattern after running FlutterFire CLI.
2. **Why initialization is needed**
    - Because Firebase does not yet know:
      - which Firebase project to use
      - which platform config to load
      - which app instance is the default app
    - FlutterFire requires a default Firebase app before Firebase services can work correctly.
3. **Beginner normal approach**
    ```dart
    // lib/main.dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:firebase_core/firebase_core.dart';

    import 'app/app.dart';
    import 'firebase_options.dart';

    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized(); // prepares Flutter before using platform plugins

      await Firebase.initializeApp( // starts Firebase Core
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(
        const ProviderScope(  // starts Riverpod
          child: App(), // starts your UI
        ),
      );
    }
    ```
4. **`.timeout()` mean?**
    - Some people write:
      ```dart
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 5)); // Wait maximum 5 seconds for Firebase initialization.
      // If it does not finish in 5 seconds, throw a timeout error.
      ```
    - **Why people use timeout**
      - They use it to avoid this bad experience:
        ```
        App opens
        → splash/loading screen
        → Firebase init stuck or very slow
        → user waits forever
        ```
      - So they force:
        ```
        If Firebase does not initialize in 5 seconds
        → show fallback/error screen
        ```
5. **What does `try/catch` do?**
    - Example:
      ```dart
      // Try Firebase initialization.
      // If success → run normal app.
      // If error → run error/fallback app.
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ).timeout(const Duration(seconds: 5));

        runApp(const ProviderScope(child: App()));
      } catch (e) {
        runApp(const FirebaseStartupErrorApp());
      }
      ```
    - Errors can happen because of:
      - missing `firebase_options.dart`
      - wrong platform config
      - unsupported platform
      - plugin setup issue
      - timeout
      - native Firebase setup issue
6. **Important beginner warning**
    - `.timeout()` does not always mean Firebase failed.
    - It only means:
      > Firebase did not complete within your selected time limit.
    - Maybe Firebase would complete after 6 seconds.
    - So if your timeout is 5 seconds, you can create a fake failure.
    - That is why I do not recommend timeout for you right now.
7. **Recommended production approach**
    - For production, I recommend:
      - use try/catch
      - log the error
      - show a clean startup error screen
      - avoid timeout unless you have a strong reason
      ```dart
      import 'package:flutter/material.dart';
      import 'package:flutter_riverpod/flutter_riverpod.dart';

      import 'app/app.dart';
      import 'services/firebase/firebase_initializer.dart';

      Future<void> main() async {
        WidgetsFlutterBinding.ensureInitialized();

        try {
          await FirebaseInitializer.initialize();

          runApp(
            const ProviderScope(
              child: App(),
            ),
          );
        } catch (error, stackTrace) {
          debugPrint('Firebase startup failed: $error');
          debugPrintStack(stackTrace: stackTrace);

          runApp(
            const FirebaseStartupErrorApp(),
          );
        }
      }

      class FirebaseStartupErrorApp extends StatelessWidget {
        const FirebaseStartupErrorApp({super.key});

        @override
        Widget build(BuildContext context) {
          return MaterialApp(
            title: 'Startup Error',
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'App failed to start. Please check Firebase configuration.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }
      }
      ```

## `timeout` Better Than Approach
- When your app starts, Firebase takes a little time to initialize.
- So you have 3 possible states:
  1. Loading → Firebase is initializing
  2. Success → Firebase ready
  3. Error → Firebase failed
- This pattern handles all 3 states cleanly.
  ```dart
  class StartupScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return FutureBuilder(
        // FutureBuilder is a widget that:
        // waits for a Future
        // rebuilds UI based on its state
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {   // snapshot contains the result of the Future (Is it loading? , Did it succeed? , Did it fail?)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasError) {
            return const ErrorScreen();
          }

          return const MainApp();
        },
      );
    }
  }
  ```
- Visual Flow
  ```
                      App Start
                        ↓
                    FutureBuilder
                        ↓
                Firebase.initializeApp()
                        ↓
  ┌───────────────┬───────────────┬───────────────┐
  │ Loading       │ Error         │ Success       │
  │               │               │               │
  ↓               ↓               ↓
  SplashScreen   ErrorScreen     MainApp
  ```
--- 