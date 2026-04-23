# <p align="center"> Concept Of Pagination </p>

Imagine you have 1,000 users in your database. If you try to load all 1,000 at once:
- Slow loading (takes a long time)
- Uses to much memory
- Bad user experience
Pagination means loading data in **small chunks (pages)** instead of all at once.

--- 
## How pagination works in Firestore
Firestore pagination usually uses three things:
- `orderBy(...)`
- `limit(...)`
- cursor methods like `startAfter(...)`

**Pagination with query cursors:** You split query results into batches, define the start point of the next query, and return only a subset of the data.

--- 
## Core idea
**First page**

Fetch the first batch:
- order the data
- limit the count

Example idea:
```dart
query.orderBy('createdAt', descending: true).limit(10)
```
**Next page**

Take the **last document from the previous batch** and use it as the cursor:
```dart
query
  .orderBy('createdAt', descending: true)
  .startAfterDocument(lastDocument)
  .limit(10)
```
That is the standard Firestore cursor-based pagination pattern.

---
## Under the hood
**When you request page 1:**
- Flutter calls repository
- repository calls Firestore service
- Firestore SDK sends ordered query with `limit`
- Firestore returns only that batch
- SDK gives you a `QuerySnapshot`
- you keep the last document as the cursor

**When you request page 2:**
- app sends another query
- same ordering is used
- query starts after the last document of page 1
- Firestore returns the next batch

So pagination in Firestore is not:
- go to page 2 by index
- skip 10 rows like **SQL offset** by default

It is:
- continue from this last known document

That is why cursor-based pagination is the preferred Firebase pattern.

--- 
