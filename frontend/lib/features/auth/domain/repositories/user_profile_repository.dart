import '../entities/user_profile.dart';

/// Contrato para persistência do perfil, independente da infraestrutura.
abstract interface class UserProfileRepository {
  Future<void> create(UserProfile profile);

  Future<UserProfile?> findById(String id);
}
