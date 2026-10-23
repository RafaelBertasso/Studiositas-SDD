import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

class FirebaseUserProfileRepository implements UserProfileRepository {
  FirebaseUserProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection('user_profiles');

  @override
  Future<void> create(UserProfile profile) async {
    await _profiles.doc(profile.id).set(_toMap(profile));
  }

  @override
  Future<UserProfile?> findById(String id) async {
    final snapshot = await _profiles.doc(id).get();
    final data = snapshot.data();
    return data == null ? null : _fromMap(snapshot.id, data);
  }

  Map<String, dynamic> _toMap(UserProfile profile) {
    return {
      'name': profile.name,
      'email': profile.email,
      'phone': profile.phone,
      'createdAt': Timestamp.fromDate(profile.createdAt),
    };
  }

  UserProfile _fromMap(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    return UserProfile(
      id: id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String?,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }
}
