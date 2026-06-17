# <p align="center"> Firebase Storage / Cloud Storage </p>

## What is Firebase Storage?
Firebase Storage is a service used to store files.<br>
- **Examples:**

    ```
    Images
    Videos
    PDFs
    Book Covers
    Profile Pictures
    Audio Files
    ZIP Files
    QR Images
    ```
- **Think:**

    ```
    Firestore = Stores Data
    Storage = Stores Files
    ```

## Why can't Firestore store images?
Many beginners ask: `Why not save images inside Firestore?`

Because Firestore is a database.

**It is optimized for:**
```json
{
  "name": "Hasnat",
  "email": "abc@gmail.com",
  "age": 22
}
```
**Not for:**
```
10 MB Image
500 MB Video
2 MB PDF
```
Firestore can technically store blobs, but it becomes expensive and inefficient.

**Production apps always use:**
```
File
 ↓
Storage

URL
 ↓
Firestore
```
--- 

## What is Cloud Storage?
Firebase Storage is actually built on top of: **Google Cloud Storage**

**Officially:**
```
Firebase Storage
        ↓
Google Cloud Storage Bucket
```
**Under the hood:**
```
Flutter App
      ↓
Firebase Storage SDK
      ↓
Google Cloud Storage
      ↓
Google Servers
```

## What is a Storage Bucket?
Think of a bucket as a giant cloud folder.
- **Example:**
    ```
    ticklearn-app-bucket
    ```
- **Inside:**
    ```
    profile_images/
    book_covers/
    videos/
    pdfs/
    ```
- **Structure:**
    ```
    Bucket
    ├── profile_images
    ├── books
    ├── users
    └── courses
    ```

## Real-world analogy
- **Imagine:**
    ```
    Firestore = Excel Sheet
    Storage = Google Drive
    ```
- **Firestore stores:**
    ```
    Student Name
    Student ID
    Profile URL
    ```
- **Storage stores:**
    ```
    student.jpg
    ```
This analogy is extremely important.

--- 

## Setup Firebase Storage
1. Open: `Firebase Console` 
    - Select project.
2. Go:
    ```
    Build
    ↓
    Storage
    ```
    - Click: `Get Started`
3. Choose region.
    - Choose nearest region to users.
    - Reason:
        ```
        Less latency
        Faster downloads
        Faster uploads
        ```
4. Enable Storage.
    - Firebase creates: `Cloud Storage Bucket`
    - Example:  
        ```
        ticklearn.appspot.com
        ```
        or
        ```
        ticklearn.firebasestorage.app
        ```
        - depending on project configuration.
5. **Flutter Setup**
    - Install package: `firebase_storage: ^latest` 

### Implementation (code)
- lib/services/firebase/storage_service.dart

    ```dart
    // Basic service:
    import 'package:firebase_storage/firebase_storage.dart';

    class StorageService {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    }
    ```
--- 