import '../entities/user_profile.dart';

/// Contrato para persistência do perfil, independente da infraestrutura.
abstract interface class UserProfileRepository {
  Future<UserProfile> create(UserProfile profile);

  Future<UserProfile?> findById(String id);
}
