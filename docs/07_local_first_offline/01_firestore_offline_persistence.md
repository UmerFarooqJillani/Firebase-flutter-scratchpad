# <p align="center"> Firestore Offline Persistence </p>

## What is Firestore Offline Persistence?
Firestore Offline Persistence means:
```
Firestore automatically stores data locally
and keeps working even when internet is unavailable.
```
So:
```
Read → Works offline
Write → Works offline
Sync → Happens automatically later
```
--- 

## How to know data is from cache?
Firestore snapshot metadata provides:
```dart
snapshot.metadata.isFromCache
```
**Example:**
```dart
if (snapshot.metadata.isFromCache) {
  print("Data came from cache");
}
```
--- 
## How to know pending writes exist?
```dart
snapshot.metadata.hasPendingWrites
```
**Example:**
```dart
if (snapshot.metadata.hasPendingWrites) {
  print("Waiting for server sync");
}
```
--- 
## Riverpod Flow
```
Firestore
    ↓
StreamProvider
    ↓
UI
```
**Example:**
```dart
final userProvider =
StreamProvider((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc('uid')
      .snapshots();
});
```
**Firestore automatically decides:**
```
Cache
or
Server
```
Riverpod doesn't need to care.

--- 
