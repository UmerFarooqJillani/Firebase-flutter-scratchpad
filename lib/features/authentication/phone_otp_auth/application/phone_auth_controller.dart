import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:firebase_scratchpad/core/auth/firebase_auth_service.dart';
import 'package:firebase_scratchpad/features/authentication/email_password_auth/application/auth_providers.dart';
import 'package:firebase_scratchpad/features/authentication/phone_otp_auth/application/phone_auth_state.dart';

// This provider gives access to PhoneAuthController in UI
final phoneAuthControllerProvider =
    StateNotifierProvider<PhoneAuthController, PhoneAuthState>((ref) {
      final service = FirebaseAuthService(ref.read(firebaseAuthProvider));
      // Get FirebaseAuth instance from another provider
      return PhoneAuthController(service);
    });

class PhoneAuthController extends StateNotifier<PhoneAuthState> {
  PhoneAuthController(this._service)
    : super(PhoneAuthState.initial()); // Constructor → set initial state

  final FirebaseAuthService _service;

  // STEP 1: SEND OTP
  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);

    if (kIsWeb) {
      try {
        // final verifier = RecaptchaVerifier(
        //   auth: FirebaseAuth.instance,
        //   size: RecaptchaVerifierSize.normal,
        // );
        final result = await _service.sendOtpWeb(phoneNumber: phone);
        debugPrint('WEB OTP SENT: confirmationResult = $result');

        state = state.copyWith(
          isLoading: false,
          confirmationResult: result,
          codeSent: true,
          error: null,
        );
        debugPrint(
          'WEB STATE AFTER OTP: confirmationResult null? ${state.confirmationResult == null}',
        );
      } on FirebaseAuthException catch (e) {
        state = state.copyWith(isLoading: false, error: e.message ?? e.code);
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    } else {
      await _service.verifyPhoneNumber(
        phoneNumber: phone,
        // Auto verification (mostly Android)
        verificationCompleted: (credential) async {
          // Firebase automatically verifies OTP → direct login
          debugPrint('PHONE AUTH: verificationCompleted');
          await _service.signInWithCredential(credential);
        },

        verificationFailed: (e) {
          debugPrint('PHONE AUTH FAILED: ${e.code} | ${e.message}');
          state = state.copyWith(isLoading: false, error: e.message);
        },

        codeSent: (verificationId, _) {
          debugPrint('PHONE AUTH: codeSent | verificationId=$verificationId');
          state = state.copyWith(
            isLoading: false,
            verificationId: verificationId,
            codeSent: true,
          );
        },

        codeAutoRetrievalTimeout: (verificationId) {
          debugPrint('PHONE AUTH: timeout | verificationId=$verificationId');
          state = state.copyWith(verificationId: verificationId);
        },
      );
    }
  }

  // Verify OTP
  Future<void> verifyOtp(String code) async {
    debugPrint('VERIFY OTP: kIsWeb = $kIsWeb');
    debugPrint(
      'VERIFY OTP: confirmationResult null? ${state.confirmationResult == null}',
    );
    debugPrint(
      'VERIFY OTP: verificationId null? ${state.verificationId == null}',
    );
    if ((!kIsWeb)
        ? (state.verificationId == null)
        : (state.confirmationResult == null)) {
      state = state.copyWith(
        error: 'OTP request not found. Please request OTP again.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    if (kIsWeb) {
      try {
        await _service.confirmOtpWeb(
          confirmationResult: state.confirmationResult!,
          smsCode: code,
        );

        state = state.copyWith(isLoading: false, error: null);
      } on FirebaseAuthException catch (e) {
        state = state.copyWith(isLoading: false, error: e.message ?? e.code);
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    } else {
      try {
        await _service.signInWithOtp(
          verificationId: state.verificationId!,
          smsCode: code,
        );

        state = state.copyWith(isLoading: false);
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }
}
