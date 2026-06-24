# <p align="center"> Sync Engine Concepts </p>

## What is the Sync Engine?
The Sync Engine is the internal Firestore system responsible for:
```
Keeping:
Local Cache
and
Firebase Server

synchronized.
```
Think:
```
Firestore Cache
        ↕
    Sync Engine
        ↕
Firestore Server
```

## Why does it exist?
Imagine:
```
User updates profile
while offline.
```
**Question:**
```
How does Firebase know
what to upload later?
```
Answer: <big>`Sync Engine`</big>

## Main Responsibilities
The Sync Engine handles:
1. Read Synchronization
    ```
    Cache ↔ Server
    ```
2. Write Synchronization
    ```
    Offline Writes
        ↓
    Upload Later
    ```
3. Conflict Detection
    ```
    Multiple Changes
        ↓
    Determine Final State
    ```
4. Realtime Updates
    ```
    Server Change
        ↓
    Update Cache
        ↓
    Update UI
    ```
### Under the Hood Architecture
```
Flutter UI
    ↓
Riverpod
    ↓
Firestore SDK
    ↓
Local Cache
    ↓
Sync Engine
    ↓
Firestore Backend
```
