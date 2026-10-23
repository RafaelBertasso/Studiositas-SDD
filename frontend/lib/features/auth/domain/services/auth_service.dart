import '../entities/auth_account.dart';

/// Contrato de autenticação independente da infraestrutura utilizada.
abstract interface class AuthService {
  Future<AuthAccount> register({
    required String email,
    required String password,
  });

  Future<AuthAccount> signIn({
    required String email,
    required String password,
  });

  Future<AuthAccount?> restoreSession();

  Future<void> signOut();
}
