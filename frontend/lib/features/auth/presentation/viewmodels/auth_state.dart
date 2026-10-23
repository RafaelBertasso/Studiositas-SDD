import '../../domain/entities/auth_session.dart';

enum AuthStatus {
  initializing,
  unauthenticated,
  submitting,
  authenticated,
  error,
}

class AuthState {
  const AuthState({
    required this.status,
    this.session,
    this.errorMessage,
    this.fieldErrors = const {},
  });

  const AuthState.initializing() : this(status: AuthStatus.initializing);

  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;
  final Map<String, String> fieldErrors;

  bool get isBusy =>
      status == AuthStatus.initializing || status == AuthStatus.submitting;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}
