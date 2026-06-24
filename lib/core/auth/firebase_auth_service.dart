// Import Firebase Auth package
// This gives access to FirebaseAuth, User, UserCredential, etc.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
  User? get currentUser {       // I recommended to use: authStateChanges()
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

  // ----------------- Phone Verification -----------------------------------------------------

  // Send OTP to user's phone number
  // -------------------------------
  Future<void> verifyPhoneNumber({
    required String phoneNumber,

    // Called automatically when Firebase verifies the phone instantly (Android mostly)
    required PhoneVerificationCompleted verificationCompleted,

    // Called if something goes wrong (invalid number, quota exceeded, etc.)
    required PhoneVerificationFailed verificationFailed,

    // Called when OTP is successfully sent to the user
    required PhoneCodeSent codeSent,

    // Called when auto-retrieval of OTP times out
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      // All callbacks are passed from controller
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,

      // Firebase will wait 60 seconds for auto OTP detection
      timeout: const Duration(seconds: 60),
    );
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  // Verify OTP entered by user
  Future<UserCredential> signInWithOtp({
    required String verificationId, // received when OTP is sent
    required String smsCode, // user entered OTP
  }) {
    // Create credential using OTP + verificationId
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    // Sign in user with this credential
    return _auth.signInWithCredential(credential);
  }

  // ------------------- Web OTP Verification -----------------------------------------------------
  Future<ConfirmationResult> sendOtpWeb({
    required String phoneNumber,
    RecaptchaVerifier? verifier,
  }) async {
    if (!kIsWeb) {
      // A constant that is true if the application was compiled to run on the web.
      throw UnsupportedError('sendOtpWeb is only for Flutter Web.');
    }

    return _auth.signInWithPhoneNumber(phoneNumber, verifier);
  }

  Future<UserCredential> confirmOtpWeb({
    required ConfirmationResult confirmationResult,
    required String smsCode,
  }) async {
    if (!kIsWeb) {
      throw UnsupportedError('confirmOtpWeb is only for Flutter Web.');
    }

    return confirmationResult.confirm(smsCode);
  }
}
