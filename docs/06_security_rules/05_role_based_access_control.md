# <p align="center"> Role-Based Access Control (RBAC) </p>

## Firestore Rules (RBAC With All Operations)
```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // ---------- Helper Functions ----------

    function isSignedIn() { // Checks whether the user is logged in.
      return request.auth != null;
    }

    function isStudent() {   // Checks whether logged-in user has student role.
      return isSignedIn()
        && request.auth.token.role == "student";
    }

    function isTeacher() {   // Checks whether logged-in user has teacher role.
      return isSignedIn()
        && request.auth.token.role == "teacher";
    }

    function isAdmin() {  // Checks whether logged-in user has admin role.
      return isSignedIn()  
        && request.auth.token.role == "admin";
    }

    function isOwner(userId) {   // Checks whether current user's UID matches the document owner ID.
      return isSignedIn()
        && request.auth.uid == userId;
    }

    // ---------- Users Collection ----------

    match /users/{userId} {

      // Student can read own profile.
      // Teacher/Admin can read user profiles.
      allow read:     // Controls reading documents.
        if isOwner(userId) || isTeacher() || isAdmin();

      // User can create only their own profile document.
      allow create:   // Controls creating new documents.
        if isOwner(userId);

      // User can update own profile.
      // Admin can update any profile.
      allow update:
        if isOwner(userId) || isAdmin();

      // Only admin can delete user profiles.
      allow delete:
        if isAdmin();
    }

    // ---------- Courses Collection ----------

    match /courses/{courseId} {

      // Signed-in users can read courses.
      allow read:
        if isSignedIn();

      // Teacher/Admin can create courses.
      allow create:
        if isTeacher() || isAdmin();

      // Teacher/Admin can update courses.
      allow update:
        if isTeacher() || isAdmin();

      // Only admin can delete courses.
      allow delete:
        if isAdmin();
    }

    // ---------- Admin Dashboard ----------

    match /admin_dashboard/{docId} {

      // Only admin can access admin dashboard data.
      allow read, write:
        if isAdmin();
    }

    // ---------- Default Deny ----------

    match /{document=**} {    // Blocks every path that is not explicitly allowed.
      allow read, write:
        if false;
    }
  }
}
```

--- 