# <p align=center> Firestore Setup & Firestore vs Realtime DataBase </p>

## What is Firestore?
Cloud Firestore is Firebase's modern NoSQL cloud database.<br>
**Think:**
```
Flutter App
      ↓
Cloud Firestore
      ↓
Google Cloud Infrastructure
```
Firestore stores data in the cloud and synchronizes it across devices in real-time.

## Firestore Under The Hood
**When you write:**
```
await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .set({
      'name': 'Ali',
    });
```
many things happen.
1. **Flutter UI calls:** `Firestore SDK`
2. **FlutterFire Plugin receives request.**

    ```
    Dart
    ↓
    FlutterFire
    ```
3. **Native SDK receives request.**
    - Android: `Firebase Android SDK`
    - iOS: `Firebase iOS SDK`
4. **SDK sends HTTPS request.**
    - Google Firestore Backend
5. **Backend validates:**
    ```
    Security Rules
    Authentication
    Request Data
    ```
6. **Data is stored.**
7. Response comes back.
    ```
    Success
    ```
    or
    ```
    Permission Denied
    ```
    or
    ```
    Network Error
    ```
## Firestore Mental Model
Most beginners think: `Database = Tables`

because of SQL.

Firestore is different.

## SQL Thinking
```
Users Table

id
name
email
```
## Firestore Thinking
```
users
 ├── user_1
 ├── user_2
 ├── user_3
```
Every user is a document.

--- 

## Firestore Setup
Since you already completed: `Firebase Initialization`

Firestore setup is simple.
1. Add Package: `cloud_firestore: ^latest`
2. Enable Firestore:
    - **Firebase Console:**
        ```
        Project
        ↓
        Firestore Database
        ↓
        Create Database
        ```
    - Choose: `Production Mode` for learning repository.
    - We will learn Rules properly later.

--- 
## Where Firestore Code Should Live

Since you're learning Riverpod + Production Architecture:<br>
**Never do:**
```dart
onPressed() {
  FirebaseFirestore.instance...
}
```
inside widgets.

Bad habit.

--- 

## Firestore vs Realtime Database
This is one of the most important beginner topics.

Firebase has TWO databases.
1. **Realtime Database**
    - **Older Firebase database.**
        - Structure:
            ```
            {
            "users": {
                "123": {
                "name": "Ali"
                }
            }
            }
            ```
        - Looks like one giant JSON tree.
    - **Advantages**
        - Simple, Fast.
        - Good for:
            ```
            Live Chat
            IoT Devices
            Presence Systems
            ```
    - **Disadvantages**
        - Large projects become difficult.
        - Deep nesting becomes messy.
        - Queries are limited.
2. **Firestore**
    - Modern Firebase database.
    - Collection → Document model.
    - **Advantages**
        - Better scalability.
        - Better querying.
        - Better indexing.
        - Cleaner structure.
        - Offline support.
        - Recommended by Firebase for most modern apps.
    - **Disadvantages**
        - Slightly more expensive for some heavy read patterns.
        - Need understanding of document design.

--- 