# <p align="center"> Production Rule </p>

## Only allow specific fields.
- **Example:**
    ```js
    allow create:
        if request.resource.data.keys()
            .hasOnly([
            'uid',
            'name',
            'email'
            ]);
    ```

## What Is request.resource?
- `resource`
    - Current document in database.
- `request.resource`
    - Incoming new document.
### Example:
- Current document:
    ```json
    {
    "name": "Ali"
    }
    ```
- User updates:
    ```json
    {
    "name": "Hasnat"
    }
    ```
Rules see:
```js
resource.data.name
```
- **Current value:** Ali

and:
```js
request.resource.data.name
```
- **New value:** Hasnat

--- 
## Field Validation
Never trust data types.

Bad:
```json
{
  "age": "hello"
}
```
Production:
```js
allow create:
if request.resource.data.age is int;
```
--- 

## Required Fields
Bad:
```json
{
  "name": "Hasnat"
}
```
- **Missing:**
    ```
    email
    uid
    createdAt
    ```
- **Production:**
    ```js
    allow create:
    if request.resource.data.keys()
    .hasAll([   // All required fields must exist.
    'uid',
    'name',
    'email'
    ]);
    ```

--- 

## Prevent Role Manipulation
Very common attack.

User updates:
```json
{
  "role": "admin"
}
```
- Production:
    ```
    Never allow client to write role.
    ```
- Bad:
    ```js
    allow update:
    if request.auth != null;
    ```
- Better:
```js
allow update:
if request.resource.data.role
   == resource.data.role;
```
**Meaning:**
```
Role cannot change.
```
--- 
## Protect createdAt
Common mistake:

User modifies:
```json
{
  "createdAt": "2050"
}
```
Production:
```js
allow update:
if request.resource.data.createdAt
   == resource.data.createdAt;
```
Meaning:
```
createdAt cannot be changed.
```

--- 
## Separate Read and Write Rules
Bad:
```js
allow read, write:
if request.auth != null;
```
Production:
```js
allow read:
if isOwner();

allow create:
if isOwner();

allow update:
if isOwner();

allow delete:
if isAdmin();
```
why?
```
Because permissions become explicit.
```

--- 
## Helper Functions
- Bad:
    ```js
    request.auth.uid == userId
    ```
    - everywhere.
- Production:
    ```js
    function isOwner(userId) {
    return request.auth.uid == userId;
    }
    ```
- Usage:
    ```js
    allow read:
    if isOwner(userId);
    ```
    - Cleaner.
```js
match /users/{userId} {

  allow read:
      if isOwner(userId);

  allow create:
      if isOwner(userId);

  allow update:
      if isOwner(userId);

  allow delete:
      if false;
}
```
--- 
## Premium Features
**s**

Custom Claim:
```json
{
  "plan": "premium"
}
```
Rule:
```js
allow read:
if request.auth.token.plan
   == "premium";
```
Meaning:
```
Premium Users
Only
```

--- 