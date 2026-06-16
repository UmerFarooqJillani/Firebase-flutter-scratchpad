import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_scratchpad/models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore firestore;

  FirestoreService(this.firestore);

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      firestore.collection('users');

  // CREATE Operation
  // ----------------
  // Future<void> createUser({
  //   required String uid,
  //   required String name,
  //   required String email,
  // }) async {
  //   await usersCollection.doc(uid).set({'name': name, 'email': email});
  // }
  // Using User Model
  Future<void> createUser(UserProfileModel user) async {
    await usersCollection.doc(user.id).set(user.toMap());
  }

  // READ Operation
  // --------------
  // Future<Map<String, dynamic>?> getUser(String uid) async {
  //   final doc = await usersCollection.doc(uid).get();

  //   return doc.data();
  // }
  // Using User Model
  Future<UserProfileModel?> getUser(String uid) async {
    final doc = await usersCollection.doc(uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return UserProfileModel.fromMap(doc.id, doc.data()!);
  }

  // UPDATE Operation
  // ----------------
  Future<void> updateUserName({
    required String uid,
    required String name,
  }) async {
    await usersCollection.doc(uid).update({'name': name});
  }

  // DELETE Operation
  // ----------------
  Future<void> deleteUser(String uid) async {
    await usersCollection.doc(uid).delete();
  }

  // Streaming
  Stream<UserProfileModel?> watchUser(String uid) {
    return usersCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return UserProfileModel.fromMap(snapshot.id, snapshot.data()!);
    });
  }
}
