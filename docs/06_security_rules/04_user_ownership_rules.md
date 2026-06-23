# <p align="center"> User Ownership Rules </p>

## Core Concept
- Authentication tells Firebase:
    ```
    Who are you?
    ```
- Ownership Rules tell Firebase:
    ```
    Is this your data?
    ```

## Problem
This rule:
```js
allow read, write:
    if request.auth != null;
```
only checks:
```
User is logged in
```
It does NOT check:
```
Does this user own the document?
```
Result:
```
User A can access User B data
❌ Not secure
```

## Ownership Rule
### Firestore
- Structure:
    ```js
    users/
    abc123

    users/
    xyz999
    ```
- Rule:
    ```js
    match /users/{userId} {

    allow read, write:
        if request.auth.uid == userId;

    }
    ```
### How It Works
- Current User:
    ```js
    request.auth.uid = abc123
    ```
    - Request:
        ```
        users/abc123
        ``` 
    - Comparison:
        ```
        abc123 == abc123
        ```
    - Result: `ALLOW`
- Current User:
    ```js
    request.auth.uid = abc123
    ```
    - Request:
        ```
        users/xyz999
        ```
    - Comparison:
        ```
        abc123 == xyz999
        ```
    - Result: `DENY`
--- 
## Firestore Operations
- Read
    ```js
    allow read:
        if request.auth.uid == userId;
    ```
    - User can read own document.
- Create
    ```js
    allow create:
        if request.auth != null;
    ```
    - User can create profile after signup.
- Update
    ```js
    allow update:
        if request.auth.uid == userId;
    ```
    - User can update own profile.

- Delete
    ```js
    allow delete:
        if false;
    ```
    - Usually disabled for users.

**Complete Production Example:**
```js
match /users/{userId} {

  allow create:
      if request.auth != null;

  allow read:
      if request.auth.uid == userId;

  allow update:
      if request.auth.uid == userId;

  allow delete:
      if false;
}
```
--- 

## Subcollection Ownership
```js
// Firestore:

users/
   abc123/
      notes/
         note1
```
**Rule:**
```js
match /users/{userId}/notes/{noteId} {

  allow read, write:
      if request.auth.uid == userId;

}
```
**Result:**
```js
User can access only their notes.
Storage Ownership
```

## Storage Structure:
```
users/
   abc123/
      profile.jpg
```
**Rule:**
```js
match /users/{userId}/{fileName} {

  allow read, write:
      if request.auth.uid == userId;

}
```
- Allowed
    - Current User: `abc123`
    - Path: `users/abc123/profile.jpg`
    - **ALLOW**
- Not Allowed
    - Current User: `abc123`
    - Path: `users/xyz999/profile.jpg`
    - **DENY**
    
--- 
