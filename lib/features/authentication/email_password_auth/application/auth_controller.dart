import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/features/authentication/email_password_auth/application/auth_state.dart';
import 'package:firebase_scratchpad/features/authentication/email_password_auth/application/auth_providers.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref);
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(AuthState.initial());

  final Ref _ref;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email: email, password: password);

      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password);

      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }
}
