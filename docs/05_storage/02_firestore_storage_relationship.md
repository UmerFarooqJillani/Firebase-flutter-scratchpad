# <p align="center"> Firestore Storage Relationship </p>

| **Firestore** | **Storage** |
| :------------ | :---------- |
| Firestore = Database | Storage = File System |
| Stores: `Metadata`   | Stores: `Files`       |


## Repo Example To Store Url
```dart
class BookRepository {

  final StorageService storageService;
  final FirestoreService firestoreService;

  BookRepository({
    required this.storageService,
    required this.firestoreService,
  });

  Future<void> uploadBookCover({
    required String bookId,
    required File file,
  }) async {

    final imageUrl =
        await storageService.uploadBookCover(
      bookId: bookId,
      file: file,
    );

    await firestoreService.updateBookCover(
      bookId: bookId,
      imageUrl: imageUrl,
    );
  }
}
```

--- 
