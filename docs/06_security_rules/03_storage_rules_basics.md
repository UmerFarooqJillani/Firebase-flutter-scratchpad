# <p align="center"> Firebase Storage Rules </p>

## What Are Storage Rules?
Storage Rules protect files.
- Storage protects:
    ```
    Images
    Videos
    PDFs
    Audio
    Documents
    Any Uploaded File
    ```
## Firebase Storage Rules
```js
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {  // Apply rules to this Storage bucket. e.g: my-app.appspot.com

    // 1. Default rule: block everything unless explicitly allowed
    match /{allPaths=**} {    // This catches every file path. In production, keep it denied by default.
      allow read, write: if false;
    }

    // 2. Public read, authenticated upload
    match /public_files/{fileName} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // 3. Authenticated users only
    match /private_files/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // 4. User-owned files
    match /users/{userId}/{fileName} {    // Good production pattern for profile images, user PDFs, or personal uploads.
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // 5. Course thumbnails: public download, admin upload later
    match /course_images/{courseId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

--- 