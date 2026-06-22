# <p align="center"> Upload Progress Tracking </p>

## First Understand The Problem
Suppose a user uploads: `profile.jpg`
- Size: `200 KB`
- Upload completes quickly.
- No problem.


Now imagine: `course_video.mp4`
- Size: `500 MB`
- Upload may take:
    ```
    30 sec
    1 min
    5 min
    ```
- **Without progress:** User thinks app froze.
- Bad UX.

## What Firebase Gives Us
- When you upload: `ref.putFile(file);`
- Firebase actually returns: `UploadTask`
- not just a future.
```dart
// await ref.putFile(file);
Internally:
        File
          ↓
        Chunk 1
          ↓
        Chunk 2
          ↓
        Chunk 3
          ↓
        Chunk 4
          ↓
    Upload Complete

Firebase tracks progress during these chunks.
```
--- 

## What is UploadTask?
- Think: `UploadTask` is a controller for the upload.
- It allows:
    ```
    Track progress
    Pause
    Resume
    Cancel
    Listen for updates
    ```
- Instead of:
    ```dart
    await ref.putFile(file);
    ```
- Do:
    ```dart
    final uploadTask = ref.putFile(file);
    ```
- Now you can monitor it.

--- 
## Visual Flow
```
UploadTask
    ↓
snapshotEvents
    ↓
TaskSnapshot
    ↓
Progress %
    ↓
   UI
```

--- 

## Storage Service
```dart
// lib/services/firebase/storage_service.dart
Future<UploadTask> uploadFile({
  required String path,
  required File file,
}) async {

  final ref =
      FirebaseStorage.instance.ref(path);

  return ref.putFile(file);
}
```
--- 

## Why Return UploadTask?
Because: `Future<String>`
- only tells us: `Finished`

But: `UploadTask`
- gives:

    ```
    Progress
    Pause
    Resume
    Cancel
    ```

--- 
## Understanding snapshotEvents
```dart
// Example:
uploadTask.snapshotEvents.listen(
  (snapshot) {
    print(snapshot.bytesTransferred);
  },
);
```
### What Happens?
```
Firebase emits:

Chunk Uploaded
Chunk Uploaded
Chunk Uploaded
Chunk Uploaded
```
Each chunk creates a snapshot.

### Snapshot Contains
```
bytesTransferred
totalBytes
state
metadata
```

### Real Example
Suppose:
```
Total File Size:
1000 bytes
```
1. First snapshot:
    ```
    bytesTransferred = 100
    ```
    - Progress:
        ```
        10%
        ```
2. Second snapshot:
    ```
    500
    ```
    - Progress:
        ```
        50%
        ```
3. Third snapshot:
    ```
    1000
    ```
    - Progress:
        ```
        100%
        ```
### Calculate Progress %
```dart
// Formula:
final progress = snapshot.bytesTransferred / snapshot.totalBytes;
```

--- 