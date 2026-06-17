# <p align="center"> Firestore Batch Writes </p>

## What Is A Batch Write?
A Batch Write allows multiple write operations to be executed together as one atomic operation.
- Meaning:

    ```
    Create
    Update
    Delete
    ```
    - multiple documents together.

- Either: 
    ```
    All Succeed
    ````
    or
    ```
    All Fail
    ```

## Real World Example
Student completes a quiz.

**You need to:**
```
Update User Progress
Create Quiz Attempt Record
Update User Score
Create Activity Log
```

**Batch Write Mental Model**
- **Think:**
    ```
    Prepare Operations
            ↓
    Put Into Box
            ↓
    Commit Box
    ```
    - The **box** is the batch.

## Transaction vs Batch

### Transaction
**Used when:** Need Current Value

Example:
```
Wallet Balance
Inventory Count
Quiz Coins
Likes Counter
```
You must:
```
Read
 ↓
Calculate
 ↓
Write
```
### Batch
**Used when:** No Read Required

You already know what to write.

Example:
```
Create Profile
Create Settings
Create Activity Log
```

Firestore Batch Lifecycle:
```
Create Batch
       ↓
Add Operations
       ↓
    Commit
       ↓
Success / Failure
```

--- 

## Where To Implement
- `firestore_service.dart`
- User Registration Batch
- **Goal Create:**

    ```
    users/uid
    user_settings/uid
    user_stats/uid
    ```
    - in one operation.
- **Code:**
    ```dart
    Future<void> createUserData({
    required String uid,
    required String name,
    required String email,
    }) async {
    final batch = firestore.batch();   // Create batch (Empty Write Container)

    final userRef =
        firestore.collection('users').doc(uid);

    final settingsRef =
        firestore
            .collection('user_settings')
            .doc(uid);

    final statsRef =
        firestore
            .collection('user_stats')
            .doc(uid);

    batch.set(  // Add operations (Only queued)
        userRef,
        {
        'name': name,
        'email': email,
        },
    );

    batch.set(
        settingsRef,
        {
        'theme': 'light',
        'language': 'en',
        },
    );

    batch.set(
        statsRef,
        {
        'points': 0,
        'coursesCompleted': 0,
        },
    );
    // batch.update(...) // Update
    // batch.delete(...)  // Delete

    await batch.commit();   // Now Firestore sends all operations together.
    }
    ```
    - Mixed Operations
    ```dart
    Future<void> completeCourse({
    required String uid,
    required String courseId,
    }) async {
    final batch = firestore.batch();

    final progressRef =
        firestore
            .collection('progress')
            .doc(uid);

    final completedRef =
        firestore
            .collection('completed_courses')
            .doc(courseId);

    final tempRef =
        firestore
            .collection('draft_courses')
            .doc(courseId);

    batch.update(
        progressRef,
        {
        'completedCourses':
            FieldValue.increment(1),
        },
    );

    batch.set(
        completedRef,
        {
        'completedAt':
            FieldValue.serverTimestamp(),
        },
    );

    batch.delete(tempRef);

    await batch.commit();
    }
    ```

--- 


