import 'package:firebase_scratchpad/models/user_profile.dart';
import 'package:firebase_scratchpad/services/firebase/firestore_service.dart';

class FirestoreRepository {
  final FirestoreService service;

  FirestoreRepository(this.service);

  // Create
  // Future<void> createUser({
  //   required String uid,
  //   required String name,
  //   required String email,
  // }) {
  //   return service.createUser(uid: uid, name: name, email: email);
  // }
  // With user Model
  Future<void> createUser(UserProfileModel user) {
    return service.createUser(user);
  }

  // Read
  // Future<Map<String, dynamic>?> getUser(String uid) {
  //   return service.getUser(uid);
  // }
  // with user Model
  Future<UserProfileModel?> getUser(String uid) {
    return service.getUser(uid);
  }

  // Update
  Future<void> updateUserName({required String uid, required String name}) {
    return service.updateUserName(uid: uid, name: name);
  }

  // Delete
  Future<void> deleteUser(String uid) {
    return service.deleteUser(uid);
  }

  // Streaming
  Stream<UserProfileModel?> watchUser(String uid) {
    return service.watchUser(uid);
  }
}
