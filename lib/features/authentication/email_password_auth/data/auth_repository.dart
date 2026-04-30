import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_scratchpad/core/auth/firebase_auth_service.dart';

// Repository layer.
// This class does not directly use FirebaseAuth.instance.
// Instead, it uses FirebaseAuthService.
class AuthRepository {
  AuthRepository(this._authService);
  final FirebaseAuthService _authService;

  // This returns a stream of the current auth state.
  // If user logs in, stream gives User.
  // If user logs out, stream gives null.
  Stream<User?> authStateChanges() {
    return _authService.authStateChanges();
  }

  // Creates a new user account using email and password.
  // Returns UserCredential, which contains user account info.
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _authService.signUpWithEmail(email: email, password: password);
  }

  // Logs in an existing user using email and password.
  // Returns UserCredential if login is successful.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _authService.signInWithEmail(email: email, password: password);
  }

  // Logs out the current user.
  // After this, authStateChanges() will emit null.
  Future<void> signOut() {
    return _authService.signOut();
  }
}
