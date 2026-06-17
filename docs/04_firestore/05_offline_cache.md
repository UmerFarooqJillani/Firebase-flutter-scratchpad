# <p align="center"> Offline Cache (Firestore) </p>

## What Is Offline Cache?
Firestore stores a local copy of your data on the device and can continue working even when the internet is unavailable.

## What Gets Cached?
**Typically:**
```
Documents
Collections
Query Results
```
that your app reads.

**Example:**
```
await firestore
    .collection('users')
    .doc(uid)
    .get();
```
Firestore may cache: `users/uid` locally.

### Does Flutter Need Extra Packages?

No.

**For Android and iOS:** `Firestore Offline Cache` is enabled by default.

This is one reason Firestore is popular.

## Web Is Different
**For:** `Flutter Web`

> offline persistence is not automatically identical to mobile.

> Web browsers have different storage limitations.

You may need additional persistence configuration depending on requirements.

**For now:**<br>
Remember:
```
Mobile → Automatic
Web → Special Handling
```

## Offline Writes
Now the powerful part.
- Suppose: `Internet OFF.`
- User updates profile.
    ```dart
    await firestore
        .collection('users')
        .doc(uid)
        .update({
        'name': 'Hasnat Ahmed'
        });
    ```
- Question: `Will it fail?`
    - Often: `No`
- Firestore will: `Store Write Locally`
    - and mark it as: `Pending Sync`

### Under The Hood
- **Internet OFF**
    - User updates: `Name`
    - Flow:
        ```
        User
        ↓
        Firestore SDK
        ↓
        Local Cache
        ```
    - Write succeeds locally.
- **Internet ON**
    - Firestore automatically: `Syncs` with backend.
    - Flow:
        ```
        Local Cache
        ↓
        Firestore Backend
        ↓
        Success
        ```

--- 
