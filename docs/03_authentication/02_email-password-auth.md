# <p align="center"> Email & Password Auth </p>

## Firebase Auth Service
- This file directly talks to Firebase Auth.
- Flow: `Screen → Controller → Repository → Service/auth → Firebase`
```dart
// lib/core/auth/firebase_auth_service.dart
File contain these methods:
- AUTH STATE CHANGES
- CURRENT USER
- SIGN UP (CREATE ACCOUNT)
- SIGN IN (LOGIN)
- SIGN OUT (LOGOUT)
- PASSWORD RESET
```

## Riverpod providers
- Riverpod gives dependency injection.
- Instead of manually creating:
    ```
    FirebaseAuthService(FirebaseAuth.instance)
    ```
- inside every screen, Riverpod provides it cleanly.
```dart
// lib\features\authentication\application\auth_providers.dart

File contain these Providers:
--> firebaseAuthProvider
      (access to FirebaseAuth.instance, It is used for login, signup, logout, current user, auth state, etc.)
--> firebaseAuthServiceProvider
       (FirebaseAuthService needs FirebaseAuth, so we read firebaseAuthProvider)
--> authRepositoryProvider
        (The repository is the middle layer between controller and Firebase service)
--> authStateChangesProvider
      (StreamProvider is used because auth state changes over time)
```

## Auth Repository
- It is the middle layer between app logic and Firebase service.
- Later this repository can also:
    - create Firestore user profile after signup
    - fetch user role
    - map Firebase exceptions
    - handle account linking
```dart
// lib\features\authentication\data\auth_repository.dart
This class does not directly use FirebaseAuth.instance.
Instead, it uses FirebaseAuthService.
File contain these methods:
- AUTH STATE CHANGES
- SIGN UP (CREATE ACCOUNT)
- SIGN IN (LOGIN)
- SIGN OUT (LOGOUT)
```

## Auth State
```dart
// lib\features\authentication\application\auth_state.dart
```

## Auth Controller
- The controller is your ViewModel.
- It handles:
    - loading
    - error
    - calling repository
    - exposing state to UI
```dart
// lib\features\authentication\application\auth_controller.dart
```

## Email signup screen
```dart
// lib\features\authentication\presentation\signup_screen.dart
```