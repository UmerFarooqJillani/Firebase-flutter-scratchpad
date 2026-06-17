# <p align="center"> Firestore Transactions </p>

## What Is A Transaction?
A transaction is a group of Firestore operations that execute as a single atomic unit.

**Meaning:**
```
All Succeed
      OR
All Fail
```
No partial state.

## Real World Example

Imagine your learning app.
- **Student has:** `Coins = 100`
- **Purchases:**
    ```
    Premium Quiz
    Cost = 50 Coins
    ```

- **Normal CRUD:**
    ```
    Read Coins
    Update Coins
    Unlock Quiz
    ```
    - Looks fine.
- **But imagine:**
    ```
    Phone
    Tablet
    ```
    - both make purchase requests simultaneously.
- **You can accidentally end up with:** 
    ```dart
    Coins = -50
    // or
    Quiz unlocked twice
    ```
- This is called a: `Race Condition`

## What Is A Race Condition?
Two operations try to modify the same document at nearly the same time.<br>
- **Example:**
    ```
    Initial: Coins = 100
    ```
    | Operations          | Device A Coins      | Device B Coins   |
    | :-----------------: | :-----------------: | :--------------: |
    | Reads               | 100                 | 100              |
    | Updates             | 50                  | 50               |
    - Expected: 0
    - Actual: 50

Data corruption.

### Why CRUD Is Not Enough
- **Normal update:**

    ```dart
    await docRef.update({
    'coins': 50,
    });
    ```
    ```
    Read
    ↓
    Update
    ```
    - does not guarantee that nobody changed the value before you.
- **Transactions guarantee:**

    ```
    Rea Latest Value
    ↓
    Modify
    ↓
    Write Safely
    ```
    ```
     Read
      ↓
    Verify Latest State
      ↓
    Update
      ↓
    Commit
    ```
--- 

## Code Example:
- firestore_service.dart
    ```dart
    Future<void> addCoins({
    required String uid,
    required int coinsToAdd,
    }) async {
    final docRef =
        usersCollection.doc(uid);

    await firestore.runTransaction( //Firestore enters transaction mode.
        (transaction) async {
        final snapshot =
            await transaction.get(docRef);   // Read latest document

        final currentCoins =
            snapshot.data()?['coins'] ?? 0;

        final updatedCoins =
            currentCoins + coinsToAdd;  // Calculate value
        
        if (coins < 50) {   // Condition if needed
            throw Exception(
                'Not enough coins',
            );
        }

        transaction.update(   // Update
            docRef,
            {
            'coins': updatedCoins,
            },
        );
        },
    );
    }
    /*
    Commit:
        If everything is valid:
            Commit Success
        Otherwise:
            Retry (Firestore Retries Automatically)
    */
    ```
--- 
