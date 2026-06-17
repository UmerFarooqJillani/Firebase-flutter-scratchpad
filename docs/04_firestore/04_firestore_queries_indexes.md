# <p align="center"> Firestore Queries & Indexes </p>

Most beginner apps work fine with: `doc(uid).get()`

But real applications need:
```
Search
Filtering
Sorting
Pagination
Top Records
Latest Records
User-specific Data
```
All of that is done using Queries.

## What Is A Query?
Give me only the documents that match my conditions.

- **Without query:** `usersCollection.get()`

    **Firestore returns:**
    ```
    Ali
    Ahmed
    Hasnat
    Sara
    Fatima
    Bilal
    ```
    everything.

- **With query:** `where('role', isEqualTo: 'student')`

    **Firestore returns:**
    ```
    Ali
    Hasnat
    Fatima
    ```
    only students.

## Real World Example

### Query 1 - where()
```json
{
  "name": "Ali",
  "role": "student"
},
{
  "name": "Ahmed",
  "role": "teacher"
}
```
Returns: `Ali` Only.
```dart
final result =
    await usersCollection
        .where(
          'role',
          isEqualTo: 'student',
        )
        .get();
/*
Give me only documents where:
role == student
*/
```
#### Greater Than
```dart
.where(
  'age',
  isGreaterThan: 18,
)
```
#### Less Than
```dart
.where(
  'age',
  isLessThan: 18,
)
```
#### Greater Than Or Equal
```dart
.where(
  'age',
  isGreaterThanOrEqualTo: 18,
)
```
#### Less Than Or Equal
```dart
.where(
  'age',
  isLessThanOrEqualTo: 18,
)
```

### Query 2 — Multiple Conditions
```dart
await usersCollection
    .where(
      'role',
      isEqualTo: 'student',
    )
    .where(
      'city',
      isEqualTo: 'Lahore',
    )
    .get();

//Only Lahore students
/*
    role = student
    AND
    city = Lahore
*/
``` 
### Query 3 — orderBy()
Used for sorting.
```dart
await usersCollection
    .orderBy('name')
    .get();

/*
Result:
    A
    B
    C
    D
Alphabetical.
*/
```
#### Descending Sort
```dart
await usersCollection
    .orderBy(
      'createdAt',
      descending: true,
    )
    .get();
```

### Query 4 — limit()
Used to restrict result count.
```dart
await usersCollection
    .limit(10)
    .get();

// Only 10 documents

// Leaderboard
//      Top 10 Students
//  No need to load all students.
```

### Combining Queries
```dart
await usersCollection
    .where(
      'role',
      isEqualTo: 'student',
    )
    .orderBy('name')
    .limit(10)
    .get();
/*
Students Only
↓
Sort By Name
↓
Take First 10
*/
```
--- 
## What Is An Index?
Now the most misunderstood topic.

Imagine: `100,000 Students` Collection.

You ask: `Find all Lahore students`

Firestore can:

**Option A**
- Check every document.
- Very slow.

**Option B**
- Use a prepared lookup table.
- Very fast.

**That lookup table is called** `Index`

## Real World Example
Think of a book.
- **Without index:** `Read all 500 pages` to find one topic.
- **With index:** `Look at page index` and jump directly.

Firestore works the same way.

## Single Field Index
Firestore automatically creates indexes for most fields.<br>
Example:
```json
{
  "city": "Lahore"
}
{
  "city": "Karachi"
}
```
**Firestore automatically indexes:** `city` 

Usually no action needed.
## Compound Index
Now imagine:
```dart
.where('city', isEqualTo: 'Lahore')
.orderBy('createdAt')
```
Two fields involved:
```
city
createdAt
```
**Firestore may need:** `Compound Index`

--- 

## Pagination
Very important for production apps.
- **Bad:** `await usersCollection.get();`
    - **Imagine:** `50,000 Users
    - Loads everything, Bad idea.
- **Good:** `.limit(20)`
    - **Load:** `20 Users` only.
    - Then load next page later.
    - Firestore provides: `startAfterDocument()` for pagination.
    - We'll learn full pagination later.

### If I use .limit(5), Firestore always returns the first 5 users. Then how do I get the next 5 users?
Firestore Pagination does NOT work by page number.

Unlike SQL:
```sql
SELECT * FROM users
LIMIT 5 OFFSET 5
```
**Firestore uses:** `Cursor Based Pagination` not `Page Number Pagination`.

## Let's Understand With Real Data
Suppose Firestore has: `users`

Collection:
```
1  Ahmed
2  Ali
3  Ayesha
4  Bilal
5  Fatima
6  Hamza
7  Hasnat
8  Kashif
9  Sara
10 Usman
11 Zain
12 Amna
```
#### First Query
You run:
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('users')
    .orderBy('name')
    .limit(5)
    .get();
```
Result:
```
Ahmed
Ali
Ayesha
Bilal
Fatima
```
Only 5 records.

#### Important Question
> How does Firestore know where to start next time?

It doesn't.

If you run the SAME query again: `.limit(5)`
again

**Result:**
```
Ahmed
Ali
Ayesha
Bilal
Fatima
```
AGAIN.
```
Exactly same 5 records.
```
Because you never told Firestore:
```
Start after Fatima
```
#### Solution: Remember Last Document
When first query returns:
```
Ahmed
Ali
Ayesha
Bilal
Fatima
```
Firestore also returns: `snapshot.docs`

The last document is: `Fatima`

Store it:
```
DocumentSnapshot? lastDocument;
lastDocument = snapshot.docs.last;
```
Now you have a bookmark.

#### Second Query

Now tell Firestore: `.startAfterDocument(lastDocument)`

Query:
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('users')
    .orderBy('name')
    .startAfterDocument(lastDocument!)
    .limit(5)
    .get();
```
--- 

## Beginner Mistake
Using Streams + Huge Collections
- **Bad:** `users.snapshots()`
- **with:** `100,000 documents`

Query first.

Then stream.

--- 

## Example Code:
- Service Layer `firestore_service.dart`
  ```dart
  Future<List<UserProfileModel>>
  getStudents() async {
    final snapshot =
        await usersCollection
            .where(
              'role',
              isEqualTo: 'student',
            )
            .get();

    return snapshot.docs
        .map(
          (doc) => UserProfileModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }
  ```
- Repository Layer
  ```dart
  Future<List<UserProfileModel>>
  getStudents() {
    return service.getStudents();
  }
  ```
- Riverpod Provider
  ```dart
  final studentsProvider =
      FutureProvider<
          List<UserProfileModel>>(
    (ref) {
      return ref
          .watch(
            firestoreRepositoryProvider,
          )
          .getStudents();
    },
  );
  ```
- UI Layer
  ```dart
  final students =
      ref.watch(
        studentsProvider,
      );
  ```

--- 