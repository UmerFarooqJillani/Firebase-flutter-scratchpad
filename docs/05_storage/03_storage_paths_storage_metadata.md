# <p align="center"> Storage Paths Storage Metadata </p>

## What is a Storage Path?

A Storage Path is simply:

> The location of a file inside your Firebase Storage bucket.

**Example:**
```
users/uid123/profile.jpg
```
This is called a path.

## Real World Analogy
- Think: `Google Drive`
- You have:
    ```
    My Drive
    ├── Books
    ├── Photos
    └── Videos
    ```
- **File:** Photos/profile.jpg
- **Path:** Photos/profile.jpg

Firebase Storage works exactly the same way.

## Why Same Filename?
- **Because:** Folder is unique
- The uid already identifies the user.
- **No need for:** `profile_987654321.jpg`

## Implementation
- Storage Path Generation
    - `lib/core/storage_paths.dart`

    ```dart
    class StoragePaths {

    static String userProfile(String uid) {
        return 'users/$uid/profile.jpg';
    }

    static String bookCover(String bookId) {
        return 'books/$bookId/cover.jpg';
    }

    static String courseThumbnail(
        String courseId,
    ) {
        return 'courses/$courseId/thumbnail.jpg';
    }
    }
    ```
- Storage Service
    - `lib/services/firebase/storage_service.dart`
    ```dart
    import 'dart:io';
    import 'package:firebase_storage/firebase_storage.dart';
    import '../../core/storage_paths.dart';

    class StorageService {
    final FirebaseStorage _storage;

    StorageService(this._storage);

    Future<String> uploadUserProfileImage({
        required String uid,
        required File file,
    }) async {
        final path = StoragePaths.userProfileImage(uid);
        final ref = _storage.ref(path);

        await ref.putFile(file);

        final downloadUrl = await ref.getDownloadURL();

        return downloadUrl;
    }

    Future<void> deleteUserProfileImage({
        required String uid,
    }) async {
        final path = StoragePaths.userProfileImage(uid);

        final ref = _storage.ref(path);

        await ref.delete();
    }
    }
    ```
    ```dart
    File
    ↓
    Firebase Storage
    ↓
    Download URL

    // It does not update Firestore.
    // Its only job is Storage.
    ```
- Firestore Service
    - `lib/services/firebase/firestore_service.dart`
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';

    class FirestoreService {
    final FirebaseFirestore _firestore;

    FirestoreService(this._firestore);

    Future<void> updateUserProfileImageUrl({
        required String uid,
        required String imageUrl,
    }) async {
        await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        });
    }

    Future<void> removeUserProfileImageUrl({
        required String uid,
    }) async {
        await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': null,
        'updatedAt': FieldValue.serverTimestamp(),
        });
    }
    }

    /* 
        Download URL
              ↓
        Firestore user document
    */
    ```
- User Repository
    - `lib/repositories/user_repository.dart`
    ```dart
    import 'dart:io';
    import '../services/firebase/firestore_service.dart';
    import '../services/firebase/storage_service.dart';

    // This is the main connection file.
    class UserRepository {
    final StorageService storageService;
    final FirestoreService firestoreService;

    UserRepository({
        required this.storageService,
        required this.firestoreService,
    });

    Future<void> updateProfileImage({
        required String uid,
        required File file,
    }) async {
        // 1. Upload image to Storage
        final imageUrl = await storageService.uploadUserProfileImage(
        uid: uid,
        file: file,
        );

        // 2. Save URL in Firestore
        await firestoreService.updateUserProfileImageUrl(
        uid: uid,
        imageUrl: imageUrl,
        );
    }
  
    Future<void> deleteProfileImage({
        required String uid,
    }) async {
        await storageService.deleteUserProfileImage(uid: uid);

        await firestoreService.removeUserProfileImageUrl(uid: uid);
    }
    }
    ```
- Profile Provider
    - `lib/features/profile/providers/profile_provider.dart`
    ```dart
    import 'dart:io';

    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_auth/firebase_auth.dart';
    import 'package:firebase_storage/firebase_storage.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';

    import '../../../repositories/user_repository.dart';
    import '../../../services/firebase/firestore_service.dart';
    import '../../../services/firebase/storage_service.dart';

    // Storage
    final storageServiceProvider = Provider<StorageService>((ref) {
    return StorageService(FirebaseStorage.instance);
    });

    // Firestore
    final firestoreServiceProvider = Provider<FirestoreService>((ref) {
    return FirestoreService(FirebaseFirestore.instance);
    });

    // Init the Repo
    final userRepositoryProvider = Provider<UserRepository>((ref) {
    return UserRepository(
        storageService: ref.read(storageServiceProvider),
        firestoreService: ref.read(firestoreServiceProvider),
    );
    });

    // Current User
    final currentUserProvider = Provider<User?>((ref) {
    return FirebaseAuth.instance.currentUser;
    });

    final profileImageControllerProvider =
        StateNotifierProvider<ProfileImageController, AsyncValue<void>>((ref) {
    return ProfileImageController(
        repository: ref.read(userRepositoryProvider),
    );
    });

    class ProfileImageController extends StateNotifier<AsyncValue<void>> {
    final UserRepository repository;

    ProfileImageController({
        required this.repository,
    }) : super(const AsyncData(null));

    Future<void> uploadProfileImage({
        required String uid,
        required File file,
    }) async {
        // The upload takes:
                // 2-5 seconds
            // During those seconds, your app doesn't know the result yet.
        state = const AsyncLoading();

        try {
        await repository.updateProfileImage(
            uid: uid,
            file: file,
        );

        state = const AsyncData(null);
        } catch (error, stackTrace) {
        state = AsyncError(error, stackTrace);
        }
    }

    Future<void> deleteProfileImage({
        required String uid,
    }) async {
        state = const AsyncLoading();

        try {
        await repository.deleteProfileImage(uid: uid);

        state = const AsyncData(null);
        } catch (error, stackTrace) {
        state = AsyncError(error, stackTrace);
        }
    }
    }
    /*
    User Click Upload
        │
        ▼
    AsyncLoading()

        │
        ▼
    Uploading...

        │
        ▼
       Success?
      /       \
     Yes       No
     │         │
     ▼         ▼
    AsyncData  AsyncError
    */
    ```
- Profile Screen
    - `lib/features/profile/presentation/screens/profile_screen.dart`
    ```dart
    import 'dart:io';

    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:image_picker/image_picker.dart';

    import '../../providers/profile_provider.dart';

    class ProfileScreen extends ConsumerWidget {
    const ProfileScreen({super.key});

    Future<File?> _pickImage() async {
        final picker = ImagePicker();

        final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        );

        if (pickedImage == null) return null;

        return File(pickedImage.path);
    }

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final user = ref.watch(currentUserProvider);
        final uploadState = ref.watch(profileImageControllerProvider);

        return Scaffold(
        appBar: AppBar(
            title: const Text('Profile Image'),
        ),
        body: Center(
            child: user == null
                ? const Text('No user logged in')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    if (uploadState.isLoading)
                        const CircularProgressIndicator(),

                    const SizedBox(height: 16),

                    ElevatedButton(
                        onPressed: uploadState.isLoading
                            ? null
                            : () async {
                                final file = await _pickImage();

                                if (file == null) return;

                                await ref
                                    .read(profileImageControllerProvider.notifier)
                                    .uploadProfileImage(
                                    uid: user.uid,
                                    file: file,
                                    );
                            },
                        child: const Text('Upload Profile Image'),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                        onPressed: uploadState.isLoading
                            ? null
                            : () async {
                                await ref
                                    .read(profileImageControllerProvider.notifier)
                                    .deleteProfileImage(
                                    uid: user.uid,
                                    );
                            },
                        child: const Text('Delete Profile Image'),
                    ),

                    const SizedBox(height: 16),

                    uploadState.when(
                        data: (_) => const Text('Ready'),
                        loading: () => const Text('Uploading...'),
                        error: (error, _) => Text(
                        'Error: $error',
                        textAlign: TextAlign.center,
                        ),
                    ),
                    ],
                ),
        ),
        );
    }
    }
    ```
--- 
## How all files work together
```dart
profile_screen.dart     // When user taps Upload Profile Image, picks image, then calls
        ↓
profile_provider.dart   // Provider calls
        ↓
user_repository.dart    // Repository calls
        ↓
storage_service.dart    // Storage uploads file and returns URL. Then repository calls
        ↓
firestore_service.dart  // Firestore saves URL in user document.
    
    then

User Repository
      ↓
Firestore Service
      ↓
Firestore users/{uid}
```

--- 