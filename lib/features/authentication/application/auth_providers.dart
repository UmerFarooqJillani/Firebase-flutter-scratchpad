import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/features/authentication/data/auth_repository.dart';
import 'package:firebase_scratchpad/core/auth/firebase_auth_service.dart';

//------------------------------------------------------
// This provider gives access to FirebaseAuth.instance.
// FirebaseAuth.instance is the main Firebase Auth object.
// It is used for login, signup, logout, current user, auth state, etc.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

//------------------------------------------------------
// This provider creates FirebaseAuthService.
// FirebaseAuthService needs FirebaseAuth, so we read firebaseAuthProvider.
// This keeps FirebaseAuthService reusable and testable.
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return FirebaseAuthService(firebaseAuth);
});

//------------------------------------------------------
// This provider creates AuthRepository.
// AuthRepository needs FirebaseAuthService.
// The repository is the middle layer between controller and Firebase service.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return AuthRepository(authService);
});

//------------------------------------------------------
// This provider listens to login/logout changes.
// User? means:
// - User object = user is logged in
// - null = user is not logged in
// StreamProvider is used because auth state changes over time.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return authService.authStateChanges();
});
