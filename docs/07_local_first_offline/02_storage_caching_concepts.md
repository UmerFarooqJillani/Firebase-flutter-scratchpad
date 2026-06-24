# <p align="center"> Storage Caching Concepts </p>

<p align="center">Firestore and Firebase Storage caching are completely different.</p>

## What is Storage Caching?
Storage caching means:
```
Downloaded files
(images, PDFs, videos)
are stored locally
so they don't need to be downloaded again.
```
**Example:**
```
First Open
↓
Download image
↓
Save locally

Second Open
↓
Load local copy
↓
No download needed
```

--- 
## Firestore vs Storage Cache
### Firestore
```
Firebase SDK
automatically manages cache.
```
**You get:**
```
Offline Reads
Offline Writes
Automatic Sync
```
### Storage
```
Firebase Storage
does NOT automatically provide
Firestore-style offline persistence.
```
**Storage only provides:**
```
File download
File upload
Download URL
```
**Caching is usually handled by:**
- browser cache
- image cache
- file cache packages
- local storage

--- 
## Under the Hood
**When loading an image:**
```
Flutter App
    ↓
Firebase Storage
    ↓
Download URL
    ↓
Image Download
    ↓
Local Cache
```
**Next time:**
```
Flutter App
    ↓
Local Cache
    ↓
Show Image
```
No network request needed.

--- 