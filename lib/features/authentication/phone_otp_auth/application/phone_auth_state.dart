import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthState {
  final bool isLoading;
  final String? verificationId; // For Mobile plateform
  final ConfirmationResult? confirmationResult; // For web plateform
  final String? error;
  final bool codeSent;

  const PhoneAuthState({
    required this.isLoading,
    required this.verificationId,
    required this.confirmationResult,
    required this.error,
    required this.codeSent,
  });

  // Initial/default state
  factory PhoneAuthState.initial() => const PhoneAuthState(
    isLoading: false,
    verificationId: null,
    confirmationResult: null,
    error: null,
    codeSent: false,
  );

  PhoneAuthState copyWith({
    bool? isLoading,
    String? verificationId,
    ConfirmationResult? confirmationResult,
    String? error,
    bool? codeSent,
  }) {
    return PhoneAuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      confirmationResult: confirmationResult ?? this.confirmationResult,
      error: error,
      codeSent: codeSent ?? this.codeSent,
    );
  }
}
