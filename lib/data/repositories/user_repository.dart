// lib/data/repositories/user_repository_impl.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/auth_api.dart';
import '../datasources/local/local_storage.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApiDataSource remoteDataSource;
  final LocalStorage localStorage;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userData = LocalStorage.getUserPreferences();
      if (userData.isNotEmpty) {
        final userModel = UserModel.fromJson(userData);
        return _convertToEntity(userModel);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<bool> updateUserPreferences(UserPreferencesModel preferences) async {
    try {
      final currentUserData = LocalStorage.getUserPreferences();
      if (currentUserData.isEmpty) return false;

      final currentUser = UserModel.fromJson(currentUserData);
      final updatedUser = currentUser.copyWith(preferences: preferences);
      
      await LocalStorage.saveUserPreferences(updatedUser.toJson());
      return true;
    } catch (e) {
      debugPrint('Error updating user preferences: $e');
      return false;
    }
  }

  @override
  Future<bool> updateUserProfile({
    String? name,
    String? email,
    String? profileImageUrl,
  }) async {
    try {
      final currentUserData = LocalStorage.getUserPreferences();
      if (currentUserData.isEmpty) return false;

      final currentUser = UserModel.fromJson(currentUserData);
      final updatedUser = currentUser.copyWith(
        name: name ?? currentUser.name,
        email: email ?? currentUser.email,
        profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
      );
      
      await LocalStorage.saveUserPreferences(updatedUser.toJson());
      return true;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteUser() async {
    try {
      await LocalStorage.clear();
      return true;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }

  /// Convert UserModel to User entity
  User _convertToEntity(UserModel model) {
    return User(
      id: model.id,
      email: model.email,
      name: model.name,
      profileImageUrl: model.profileImageUrl,
      createdAt: model.createdAt,
      lastLoginAt: model.lastLoginAt,
      isEmailVerified: model.isEmailVerified,
      preferences: UserPreferences(
        currency: model.preferences.currency,
        darkMode: model.preferences.darkMode,
        notificationsEnabled: model.preferences.notificationsEnabled,
        priceAlertsEnabled: model.preferences.priceAlertsEnabled,
        portfolioUpdatesEnabled: model.preferences.portfolioUpdatesEnabled,
        language: model.preferences.language,
        timeZone: model.preferences.timeZone,
      ),
    );
  }
}