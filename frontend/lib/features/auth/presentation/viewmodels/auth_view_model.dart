import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../../domain/use_cases/restore_session_use_case.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';
import '../../domain/use_cases/validate_login_use_case.dart';
import '../../domain/use_cases/validate_registration.dart';
import 'auth_state.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required RegisterUseCase register,
    required SignInUseCase signIn,
    required RestoreSessionUseCase restoreSession,
    required SignOutUseCase signOut,
    ValidateRegistration validateRegistration = const ValidateRegistration(),
    ValidateLoginUseCase validateLogin = const ValidateLoginUseCase(),
  }) : _register = register,
       _signIn = signIn,
       _restoreSession = restoreSession,
       _signOut = signOut,
       _validateRegistration = validateRegistration,
       _validateLogin = validateLogin;

  final RegisterUseCase _register;
  final SignInUseCase _signIn;
  final RestoreSessionUseCase _restoreSession;
  final SignOutUseCase _signOut;
  final ValidateRegistration _validateRegistration;
  final ValidateLoginUseCase _validateLogin;

  AuthState _state = const AuthState.initializing();

  AuthState get state => _state;
  AuthSession? get session => _state.session;

  Future<void> restoreSession() async {
    if (_state.status == AuthStatus.submitting) return;
    _setState(const AuthState.initializing());
    try {
      final session = await _restoreSession();
      _setState(
        session == null
            ? const AuthState.unauthenticated()
            : AuthState(status: AuthStatus.authenticated, session: session),
      );
    } catch (error) {
      _setError(error);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    if (state.isBusy) return false;
    final validation = _validateRegistration(
      RegistrationData(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      ),
    );
    if (!validation.isValid) {
      _setState(
        AuthState(status: AuthStatus.error, fieldErrors: validation.errors),
      );
      return false;
    }
    _setState(const AuthState(status: AuthStatus.submitting));
    try {
      final session = await _register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      _setAuthenticated(session);
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    if (state.isBusy) return false;
    final errors = _validateLogin(LoginData(email: email, password: password));
    if (errors.isNotEmpty) {
      _setState(AuthState(status: AuthStatus.error, fieldErrors: errors));
      return false;
    }
    _setState(const AuthState(status: AuthStatus.submitting));
    try {
      final session = await _signIn(email: email, password: password);
      _setAuthenticated(session);
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  Future<bool> signOut() async {
    if (state.isBusy) return false;
    final previousSession = state.session;
    _setState(const AuthState(status: AuthStatus.submitting, session: null));
    try {
      await _signOut();
      _setState(const AuthState.unauthenticated());
      return true;
    } catch (error) {
      _setError(error, session: previousSession);
      return false;
    }
  }

  void clearError() {
    if (state.status == AuthStatus.error) {
      _setState(
        state.session == null
            ? const AuthState.unauthenticated()
            : AuthState(
                status: AuthStatus.authenticated,
                session: state.session,
              ),
      );
    }
  }

  void _setAuthenticated(AuthSession session) {
    _setState(AuthState(status: AuthStatus.authenticated, session: session));
  }

  void _setError(Object error, {AuthSession? session}) {
    final message = error is AuthFailure
        ? error.message
        : 'Não foi possível concluir a operação. Tente novamente.';
    _setState(
      AuthState(
        status: AuthStatus.error,
        session: session,
        errorMessage: message,
      ),
    );
  }

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
