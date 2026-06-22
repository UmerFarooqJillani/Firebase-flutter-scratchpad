# <p align="center"> Security Rules & Setup </p>

## Security Rules?
Security Rules are server-side permission rules.
- Rules run on Firebase servers. Not in Flutter.

**They tell Firebase:**
```txt
Who can read?
Who can write?
Who can delete?
Who can upload?
Who can download?
```
--- 

## Two Main Rule Systems
Firebase has two independent rule systems.
### Firestore Rules
- **Protect:**
    ```
    Collections
    Documents
    Subcollections
    ```
- **Example:**
    ```
    users/
    posts/
    orders/
    notes/
    ```
### Storage Rules
- **Protect:**
    ```
    Images
    Videos
    PDFs
    Audio Files
    Documents
    ```
- **Example:**
    ```
    profile_images/
    book_covers/
    videos/
    documents/
    ```

--- 

## Default Firebase Behavior
When Firestore is first created:

You usually see something similar to:
```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
      // allow read, write: if true;  // Everyone can do everything.
    }
  }
}
```
**Meaning:** `Nobody can access anything.` very secure.

--- 

## Firestore Rules Language
- Rules are not Dart.
- Rules are not JavaScript.
- Rules are a **special Firebase language**.
- **Example:**
    ```js
    allow read: if request.auth != null;
    ```
- **Meaning:**
    ```
    Allow reading
    ONLY IF
    User is logged in
    ```
--- 

## Setup Location
Open:
```
Firebase Console
```
Then:
```
Firestore Database
      ↓
Rules
```
You will see:
```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

  }
}
```

--- 
## Why UI Protection Is Not Security
Bad thinking:
```dart
if (user.isAdmin) {
  showDeleteButton();
}
```
Many beginners think:
```
Delete button hidden
= secure
```
Wrong.

**A hacker can bypass UI.**

Real protection:
```
Firestore Rules
Storage Rules
```
because they execute on Firebase servers.

--- 
## Rule Categories
1. Level 1
    ```js
    // Public
    allow read: if true;
    ```
2. Level 2
    ```js
    // Authenticated
    allow read: if request.auth != null;
    ```
3. Level 3
    ```js
    // Ownership
    allow read:
    if request.auth.uid == userId;
    ```
4. Level 4
    ```js
    // Role Based
    allow delete:
    if isAdmin();
    ```
5. Level 5
    ```js
    // Production Validation
    allow create:
    if request.resource.data.name is string;
    ```
    - This prevents bad data entering database.

--- 