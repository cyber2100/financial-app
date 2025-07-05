// lib/domain/repositories/user_repository.dart
import '../entities/user.dart';
import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<bool> updateUserPreferences(UserPreferencesModel preferences);
  Future<bool> updateUserProfile({
    String? name,
    String? email,
    String? profileImageUrl,
  });
  Future<bool> deleteUser();
}