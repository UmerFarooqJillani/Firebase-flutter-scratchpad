# <p align="center"> Upload, Download & Delete Files </p>

## First Understand Storage CRUD
Suppose TickLearn allows teachers to upload book covers.
- **The flow:**
    ```
    Teacher
    ↓
    Select Image
    ↓
    Upload to Storage
    ↓
    Get URL
    ↓
    Save URL in Firestore
    ```
- **Later:**
    ```
    Student Opens App
        ↓
    Firestore Reads URL
        ↓
    Image Downloaded
        ↓
    Book Cover Visible
    ```
--- 
## Step-by-Step Implementation
1. Required Packages
    - You already have: `firebase_storage:`
    - Now add: `image_picker:`
    - **Why?**
        - Because Storage uploads files.
        - We need a way to select files.
    - **What is image_picker?**
        - It allows:
            ```
            Gallery Image
            Camera Image

            selection.
            ```
        - Without it:
            ```
            No File
            No Upload
            ```
2. Create Storage Service [`lib/services/firebase/storage_service.dart`]
    ```dart
    import 'dart:io';

    import 'package:firebase_storage/firebase_storage.dart';

    class StorageService {
    final FirebaseStorage _storage = FirebaseStorage.instance;

    Future<String> uploadProfileImage({
        required String uid,
        required File file,
    }) async {
        final ref = _storage
            .ref()   // Creates a root reference.
            .child('users')
            .child(uid)
            .child('profile.jpg');

        await ref.putFile(file); // Uploads file.

        return await ref.getDownloadURL(); // Returns: https://....
    }
    }
    ```
3. Download File
    - Most apps don't manually download.
    - Instead: `Image.network(url)`
4. Delete File
    - Add to: `storage_service.dart`
    - Code
        ```dart
        Future<void> deleteProfileImage(
        String uid,
        ) async {
        await _storage
            .ref()
            .child('users')
            .child(uid)
            .child('profile.jpg')
            .delete();
        }
        ```
5. Update File
    - Storage doesn't have: `update()` like Firestore.
    - Instead:
        ```
        Delete old file
        OR
        Upload to same path
        ```
    - New file overwrites old file.
    - Example: `users/uid123/profile.jpg`
        - upload again.
        - Old file replaced.

--- 
