class AuthState {
  final bool isLoading;
  final String? errorMessage;

  const AuthState({required this.isLoading, required this.errorMessage});

  factory AuthState.initial() {
    return const AuthState(isLoading: false, errorMessage: null);
  }

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
