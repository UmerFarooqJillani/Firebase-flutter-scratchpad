# <p align=center> Collection Document Model </p>

## What Is A Collection?
Think of a collection as a folder.

Example: `users`

This is a collection.

Real World Example:

- **Imagine TickLearn App.**
    - You have:
        ```
        users
        courses
        quizzes
        progress
        ```
    - Each of these is a collection.
    - Example:
        ```
        Firestore Database

        users
        courses
        quizzes
        progress
        ```

## What Is A Document?
Inside a collection, you store documents.

**Example:**
```
users
 ├── user_001
 ├── user_002
 └── user_003
```
These are documents.

Each document contains data.

**Example:**
```
users
 └── user_001
```
contains:
```
{
  "name": "Hasnat",
  "email": "hasnat@gmail.com",
  "role": "student"
}
```

--- 
 
## Real World Example
**School Management App**
- Collection: `students`
- Documents:
    ```dart
    students
    ├── student_001 // Every document has a unique ID.
    ├── student_002
    ├── student_003
    ```
    - **Auto Generated IDs**
        - Firestore can generate IDs.
            - **Example:**
                ```
                FirebaseFirestore.instance
                    .collection('notes')
                    .doc();
                ```
            - **Generates:** `K2dj3kdjD9dk2` automatically.
    - Each document:
        ```json
        {
        "name": "Ali",
        "class": "10th",
        "age": 15
        }
        ```
- Field?
    - A document contains fields.
        ```
        name
        class
        age
        // are fields
        ```
- Values can be:
    ```
    String
    Number
    Boolean
    List
    Map
    Timestamp
    ```
- Subcollection?
    - Collection inside a document.
    - **Example:**
        ```
        users
        └── user_001
            └── notes
        ```
    - Here: `notes` is a subcollection.
--- 

## Firestore References
- When you write: `FirebaseFirestore.instance`
- **You get:** Firestore Database Reference

- **Collection Reference:**
    ```dart
    FirebaseFirestore.instance
        .collection('users');
    ```
    - Points to: `users`
- **Document Reference:**
    ```dart
    FirebaseFirestore.instance
        .collection('users')
        .doc('uid123');
    ```
    - points to:
        ```
        users
        └── uid123
        ```
    - **Under The Hood:** it creates a path: `users/uid123`
--- 

    