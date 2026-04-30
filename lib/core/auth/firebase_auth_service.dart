// Import Firebase Auth package
// This gives access to FirebaseAuth, User, UserCredential, etc.
import 'package:firebase_auth/firebase_auth.dart';

// This class is your "Auth Service"
// It acts as a bridge between your app and Firebase Authentication
class FirebaseAuthService {
  // Constructor: receives FirebaseAuth instance from outside
  // This is called "Dependency Injection" (used with Riverpod)
  FirebaseAuthService(this._auth);

  // Private variable that holds FirebaseAuth instance
  final FirebaseAuth _auth;

  // AUTH STATE CHANGES
  // -------------------------------
  // This returns a STREAM of User? (User OR null)
  // Example:
  // - user logs in → emits User
  // - user logs out → emits null
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // CURRENT USER
  // -------------------------------
  // This returns the current logged-in user (if any)
  // If no user is logged in → returns null
  // This is NOT a stream (just a snapshot at this moment)
  User? get currentUser {
    return _auth.currentUser;
  }

  // SIGN UP (CREATE ACCOUNT)
  // -------------------------------
  // This function creates a new user account using email & password
  // "Future" means: this is async (takes time)
  // It returns UserCredential (contains user info)
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // SIGN IN (LOGIN)
  // -------------------------------
  // This function logs in an existing user
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // SIGN OUT (LOGOUT)
  // -------------------------------
  // This logs out the current user
  // After this:
  // authStateChanges() will emit null
  Future<void> signOut() {
    return _auth.signOut();
  }

  // PASSWORD RESET
  // -------------------------------
  // This sends a password reset email to the user
  // Firebase handles email sending automatically
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }
}
