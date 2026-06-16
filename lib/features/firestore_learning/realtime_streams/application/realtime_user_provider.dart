import 'package:firebase_scratchpad/features/firestore_learning/crud/application/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/models/user_profile.dart';
// import 'package:firebase_scratchpad/features/firestore_learning/crud/application/firestore_provider.dart';

final userStreamProvider = StreamProvider.family<UserProfileModel?, String>((
  ref,
  uid,
) {
  return ref.read(firestoreRepositoryProvider).watchUser(uid);
});
