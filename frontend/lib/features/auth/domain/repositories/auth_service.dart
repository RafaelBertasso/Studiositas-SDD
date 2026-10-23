import '../entities/auth_session.dart';

/// Portão de autenticação usado pelo domínio sem expor o SDK do Firebase.
abstract interface class AuthService {
  Future<AuthSession> register({
    required String email,
    required String password,
  });

  Future<AuthSession> signIn({
    required String email,
    required String password,
  });

  Future<AuthSession?> restoreSession();

  Future<void> signOut();
}
