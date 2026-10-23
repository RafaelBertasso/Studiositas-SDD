import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_account.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/services/auth_service.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Future<AuthAccount> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _toAccount(credential.user!);
    } on FirebaseAuthException catch (error) {
      throw _mapFailure(error);
    } catch (_) {
      throw const AuthUnknownFailure();
    }
  }

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _toAccount(credential.user!);
    } on FirebaseAuthException catch (error) {
      throw _mapFailure(error);
    } catch (_) {
      throw const AuthUnknownFailure();
    }
  }

  @override
  Future<AuthAccount?> restoreSession() async {
    try {
      final user = _auth.currentUser;
      return user == null ? null : _toAccount(user);
    } on FirebaseAuthException catch (error) {
      throw _mapFailure(error);
    } catch (_) {
      throw const AuthUnknownFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapFailure(error);
    } catch (_) {
      throw const AuthUnknownFailure();
    }
  }

  AuthAccount _toAccount(User user) {
    return AuthAccount(
      id: user.uid,
      email: user.email ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  AuthFailure _mapFailure(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'invalid-credential':
      case 'invalid-email':
      case 'user-disabled':
      case 'user-not-found':
      case 'wrong-password':
        return const InvalidCredentialsFailure();
      case 'network-request-failed':
        return const ServiceUnavailableFailure();
      default:
        return const AuthUnknownFailure();
    }
  }
}
