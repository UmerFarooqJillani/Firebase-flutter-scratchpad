import 'package:cloud_firestore/cloud_firestore.dart';

class FCMBackendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerToken(String userId, String token) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.set({
      'fcmTokens': FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true));
  }

  Future<void> removeToken(String userId, String token) async {
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.update({
      'fcmTokens': FieldValue.arrayRemove([token]),
    });
  }
}
