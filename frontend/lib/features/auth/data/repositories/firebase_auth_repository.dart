import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/repositories/user_profile_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required AuthService authService,
    required UserProfileRepository profileRepository,
  })  : _authService = authService,
        _profileRepository = profileRepository;

  final AuthService _authService;
  final UserProfileRepository _profileRepository;

  @override
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final account = await _authService.register(
      email: email,
      password: password,
    );
    final profile = UserProfile(
      id: account.id,
      name: name.trim(),
      email: account.email,
      phone: phone?.trim().isEmpty == true ? null : phone?.trim(),
      createdAt: account.createdAt,
    );
    await _profileRepository.create(profile);
    return AuthSession(user: profile);
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final account = await _authService.signIn(email: email, password: password);
    return _sessionFor(account.id, account.email, account.createdAt);
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final account = await _authService.restoreSession();
    if (account == null) return null;
    return _sessionFor(account.id, account.email, account.createdAt);
  }

  @override
  Future<void> signOut() => _authService.signOut();

  Future<AuthSession> _sessionFor(
    String id,
    String email,
    DateTime createdAt,
  ) async {
    final profile = await _profileRepository.findById(id);
    return AuthSession(
      user: profile ??
          UserProfile(
            id: id,
            name: '',
            email: email,
            createdAt: createdAt,
          ),
    );
  }
}
