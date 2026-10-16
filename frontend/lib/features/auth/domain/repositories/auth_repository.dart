import '../entities/auth_session.dart';
import '../entities/user_profile.dart';

abstract interface class AuthRepository {
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
