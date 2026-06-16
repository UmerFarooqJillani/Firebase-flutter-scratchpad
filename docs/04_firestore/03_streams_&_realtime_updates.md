# <p align=center> Streams & Realtime Updates </p>

In the previous lesson, we learned: `Future<T>`

**which means:**
```
Get data once
Write data once
Update once
Delete once
```
Now we learn: `Stream<T>`

**which means:**
```
Keep listening
Keep receiving updates
Automatically rebuild UI
```

--- 

## What Is A Stream?
A Stream is a continuous flow of data.

**Think:**
```
Future
 ↓
One Package Delivery
```
### **Stream Example:**

`Live GPS Tracking`

You continuously receive:
```
Driver Location
Driver Location
Driver Location
Driver Location
```
until tracking stops.

## Why Firestore Streams Exist
**Traditional apps:** `Refresh Button`<br>
**User clicks:** `Fetch Again`<br>
**Firestore:** `Listen Once`<br>
Then Firestore pushes updates automatically.

## Future vs Stream

### Future
```dart
final doc = await firestore
    .collection('users')
    .doc(uid)
    .get();
```
Returns: `One Snapshot`

### Stream
```dart
firestore
    .collection('users')
    .doc(uid)
    .snapshots();
```
Returns: `Stream<DocumentSnapshot>`

### Flow
```
-------- Future --------
         Request
            ↓
         Response
            ↓
           Done
--------------------------

-------- Stream --------
         Listen
           ↓
         Update
           ↓
         Update
           ↓
         Update
           ↓
         Update

       Keeps going...
--------------------------
```
--- 

## Listening To Entire Collection
**Example:** `usersCollection.snapshots()`<br>
**Returns:** `Stream<QuerySnapshot>`

**Useful for:**
```
Users List
Courses List
Products List
Messages List
```
## User Streaming:
```dart
// \lib\services\firebase\firestore_service.dart
```

### Document Stream vs Collection Stream
- **Document Stream** 
    - `users/doc(uid).snapshots()`
    - **Listen to:** `One User`
- **Collection Stream**
    - `users.snapshots()`
    - **Listen to:** `All Users`

### When To Use Future & stream?
- **Use Future when:**
    ```
    Settings Screen
    One-time Profile Fetch
    Configuration Data
    ```
- **Use Stream when:**
    ```
    Chat App
    User Presence
    Notifications
    Course Progress
    Leaderboard
    Live Dashboard
    Messages
    ```

## Create StreamProvider
```dart
// lib\features\firestore_learning\realtime_streams\application\realtime_user_provider.dart

// Riverpod automatically handles:
    Loading
    Data
    Error
    Dispose
  // for streams.
```

## UI Layer
```dart 
Main Scaffold Screen:
// lib\features\firestore_learning\crud\presentation\firestore_crud_screen.dart

class that return Widget:
// lib\features\firestore_learning\realtime_streams\presentation\realtime_user_screen.dart

// What Is AsyncValue?
  // Riverpod wraps stream state inside:
      AsyncValue<T>
  // States:
      Loading
      Data
      Error
// This is why:
    .when(...)
  // exists.
```

--- 

