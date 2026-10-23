import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  /// Coordena autenticação e associação do perfil do usuário.
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  Future<AuthSession> signIn({
    required String email,
    required String password,
  });

  Future<AuthSession?> restoreSession();

  Future<void> signOut();
}
