# <p align="center"> Filestore Rules Basics </p>

## What Is A Firestore Rule?
A Firestore rule tells Firebase:
```
When someone requests data...

Which collection?
Which document?
Which operation?

Allow or deny?
```
Firestore Rules are based on two things:
```
Path Matching + Permission Conditions
```
Firebase first checks **which document path** is being accessed, then checks **which operation** is being performed.

## Full Code with All Basic Operations
```js
rules_version = '2';   // Uses Firebase Security Rules version 2.

service cloud.firestore {   // Every Firestore rule starts with
  match /databases/{database}/documents {  // This is the root path of your Firestore database documents.

    // Users collection rules
    match /users/{userId} {   // Matches documents like: users/abc123, users/user456

      // READ = get document, listen to document, or query documents
      allow read: if request.auth != null;

      // CREATE = add a new user document
      allow create: if request.auth != null;

      // UPDATE = edit an existing user document
      allow update: if request.auth != null;

      // DELETE = remove an existing user document
      allow delete: if request.auth != null;
    }

    // Notes collection rules
    match /notes/{noteId} {

      // Only logged-in users can read notes
      allow read: if request.auth != null;

      // Only logged-in users can create notes
      allow create: if request.auth != null;

      // Only logged-in users can update notes
      allow update: if request.auth != null;

      // Only logged-in users can delete notes
      allow delete: if request.auth != null;
    }

    // Default rule: deny everything else
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

--- 

## Important Note
This rule is good for learning, but not enough for production.

Because:
```
Any logged-in user can access any other logged-in user's data.
```
Example:
```
User A can read User B profile
User A can update User B notes
```
Production rules must check ownership using:
```js
request.auth.uid == userId
```
We will learn this in: `04_user_ownership_rules.md`

--- 