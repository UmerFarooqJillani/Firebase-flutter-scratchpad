# <p align="center"> What is Local-First & Cache </p>

## What is Local-First?
Most beginners think:
> My app asks Firebase for data every time.

Wrong.

**Modern apps try to:**
```
Read local data immediately
↓
Show UI instantly
↓
Sync with server
↓
Update if newer data exists
```
This is called: <big>Local-First Architecture</big>

## What is Cache?
**Cache simply means:**
```
Temporary stored data
```
so we don't need to fetch everything again.

**Think of it as:**
```
Shortcut copy of data
```

## Firebase Cache
Firebase SDK stores data locally.
- Instead of:
    ```
    Firestore
    ↓
    Internet
    ↓
    Server
    ```
- **it becomes:**
    ```
    Firestore
    ↓
    Local Cache
    ↓
    Internet
    ↓
    Server
    ```
--- 
## Two Types of Cache
You must know:
1. Memory Cache
2. Disk Cache

### Memory Cache
Stored in RAM.

Characteristics: `Very fast`

but 
```
Lost when app closes
```
Example:
```
Riverpod provider state
```
Usually lives in memory.
#### Example
- **Suppose:**
    ```dart
    final userProvider =
    StateProvider<String>((ref) => "Hasnat");
    ```
- Stored in: `RAM`<br>
- Close app: `Data gone`

### Disk Cache
Stored on: `Phone storage` or `Computer storage`
Characteristics:
```
Slower than RAM
```
but
```
Survives app restart
```
#### Example
- Firestore offline cache.
- User downloads:
    ```
    Notes
    ```
- Firestore saves them to disk.
- User closes app.
- User reopens app.
- Notes still available.
- **Why?** Because cache lives on disk.
--- 
## Firestore Offline Cache
Stores:
```
Data on disk
```
and survives restart.<br>
**This is persistence.**

--- 
## Important Production Rule
Never assume:
```
Provider = Saved Data
```
Wrong.

**Provider means:**
```
State Management
```
not permanent storage.

--- 