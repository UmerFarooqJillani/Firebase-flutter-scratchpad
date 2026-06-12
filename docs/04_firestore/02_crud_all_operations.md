# <p align=center> CRUD Operation </p>

## What Is CRUD?
CRUD means:
```
C = Create
R = Read
U = Update
D = Delete
```
Almost every database operation belongs to one of these.

## Architecture
```
UI
 ↓
Provider
 ↓
Repository
 ↓
Service
 ↓
Firestore
```

1. Create User Model
    ```dart
    // lib\models\user_profile.dart

    // Why Model?
        // Firestore stores:
            {
            "name": "Hasnat",
            "email": "hasnat@gmail.com"
            }
        //Flutter prefers:
            UserProfileModel
        // Model converts:
            Firestore JSON
                ↔
            Dart Object
    ```
2. Create Firestore Service
    ```dart
    // lib\services\firebase\firestore_service.dart

    // What Is Service Layer?
        // Service layer directly talks to Firestore.
        // Only this layer should know:
            FirebaseFirestore.instance
        // Why?
            // UI should not know Firestore details.
        // 
    ```
3. CREATE Operation
    ```dart
    // lib\services\firebase\firestore_service.dart

    // What Happens Under The Hood?
        // When this runs:
            usersCollection.doc(uid).set(...)
        // Firestore creates:
            users
            └── uid123  
        // and stores:
            {
            "name": "Hasnat",
            "email": "hasnat@gmail.com"
            }
        // After signup:
            Firebase Auth
                ↓
            UID Generated
                ↓
            Create Firestore Profile
        // Very common pattern.
    ```
4. READ Operation
    ```dart
    // lib\services\firebase\firestore_service.dart

        // Firestore reads:
            users/uid123
        // and returns:
            {
            "name": "Hasnat",
            "email": "hasnat@gmail.com"
            }
    ```
5. UPDATE Operation
    ```dart
    // lib\services\firebase\firestore_service.dart

    // Difference Between SET and UPDATE
        // SET
            .set({...})
            // Creates or overwrites document.
        // UPDATE
            .update({...})
            // Changes specific fields.
    ```
6. DELETE Operation
    ```dart
    // lib\services\firebase\firestore_service.dart

    // Firestore removes:
        users
        └── uid123
    // completely.
    ```
7. Repository Layer
    ```dart
    // lib\features\firestore_learning\data\firestore_repository.dart

    // Why Repository?
        // Current app:
            UI
            ↓
            Repository
            ↓
            Service
            ↓
            Firestore
        // 
    ```
8. Riverpod Providers
    ```dart
    // lib\features\firestore_learning\application\firestore_provider.dart

    // Providers Includes:
        Firebase Provider
        Service Provider
        Repository Provider

    // Under The Hood
        // When UI needs data:
            UI
            ↓
            Riverpod
            ↓
            Repository
            ↓
            Service
            ↓
            Firestore SDK
            ↓
            Firebase Backend
        // This is dependency injection.
    ```
9. User Interface (UI)
    ```dart
    // lib\features\firestore_learning\presentation\firestore_crud_screen.dart
    ```

--- 

### First Important Thing
- The error was:
    ```
    PERMISSION_DENIED
    Missing or insufficient permissions
    ```
- This error is NOT coming from:
    ```dart
    createUser(user)
    ```
- It is coming from:
    ```
    Firestore Security Rules
    ```
    - on the Firebase backend.

#### What are Firestore Security Rules?
- Think of Firestore like a bank.
- You have:
    ```
    Flutter App
        ↓
    Internet
        ↓
    Firestore Database
    ```
- If there were no rules:
    ```
    Anyone
        ↓
    Can Read Everything
    Can Write Everything
    Can Delete Everything
    ```
    That would be a disaster.

    So Firestore puts a security guard in front of the database.

- That security guard is called:
    ```
    Security Rules
    ```
#### Why Your Request Failed
- **Current situation:**
    - Your app tried: `users/1`
    - Firestore asked: `Am I allowed to create this?`
    - Rules replied: `No`
    - Result: `PERMISSION_DENIED`

#### Where Rules Live
**Open:**
```
Firebase Console
 ↓
Firestore Database
 ↓
Rules
```
**You'll see something like:**
```dart
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /{document=**} {
      allow read, write: if false;
    }

  }
}
```
or another rule.
#### Learning Mode Rule
**While learning CRUD, many developers temporarily use:**
```dart
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /{document=**} {
      allow read, write: if true;
    }

  }
}
```
**Meaning:**
```
Everyone can read
Everyone can write
```
Then Test Again: `Create user`

--- 