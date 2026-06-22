# <p align="center"> Auth Based Rules </p>

## What Are Auth-Based Rules?
Auth-Based Rules are Security Rules that check:
```
Is the user authenticated?
```
before allowing access.

**Simple idea:**
```
Logged In?
      ↓
Yes → Allow

No → Deny
```
--- 
## The First Security Check

Firebase gives us:
```js
request.auth  // Current Logged In User inside Security Rules.

request.auth == null  // No authenticated user exists.

request.auth.uid  // This is the authenticated user's Firebase UID. which returns: uid(abc123xyz)

allow read, write: if request.auth != null;  // Only authenticated users, can read and write.
```
This is the most important object in auth-based security.
### What Does This Protect?
**Collection:**
```
notes/
```
**Now:**
```
Guest User
Denied
Logged-In User
Allowed
```
```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, write:
          if request.auth != null;
    }
  }
}
```
### Storage Example
**Open:**
```
Storage
    ↓
Rules
```
**Only authenticated users can:**
```
Upload files
Download files
Delete files
```
**Example:**
```js
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {

    match /{allPaths=**} {

      allow read, write:
          if request.auth != null;
    }
  }
}
```
### Why This Is Still NOT Enough
Many beginners stop here.

Bad idea.

**Example:**
- User A:
    ```
    UID = abc123
    ```
- User B:
    ```
    UID = xyz999
    ```
- Rule:
    ```js
    allow read, write:
        if request.auth != null;
    ```
**Problem:**
```
User A can access User B data.
```
**Because:**
- Rule only checks login.
- It does NOT check ownership.

--- 