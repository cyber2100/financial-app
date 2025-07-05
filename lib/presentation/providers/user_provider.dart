// lib/presentation/providers/user_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../data/datasources/local/local_storage.dart';
import '../../data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  // Private fields
  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  
  // Dependencies
  dynamic _authApi;
  dynamic _localStorage;

  // Public getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Initialize with dependencies
  void initialize({
    dynamic authApi,
    dynamic localStorage,
  }) {
    _authApi = authApi;
    _localStorage = localStorage;
    _checkAuthenticationStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthenticationStatus() async {
    try {
      final token = LocalStorage.getUserToken();
      if (token != null) {
        // Validate token with API
        final isValid = await _authApi?.validateToken(token) ?? false;
        if (isValid) {
          _isAuthenticated = true;
          await _loadUserProfile();
        } else {
          await logout();
        }
      }
    } catch (e) {
      debugPrint('Error checking authentication status: $e');
    }
    notifyListeners();
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final token = await _authApi?.login(email, password);
      if (token != null) {
        await LocalStorage.saveUserToken(token);
        _isAuthenticated = true;
        await _loadUserProfile();
        return true;
      } else {
        _setError('Invalid credentials');
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    _clearError();

    try {
      final token = await _authApi?.register(email, password, name);
      if (token != null) {
        await LocalStorage.saveUserToken(token);
        _isAuthenticated = true;
        
        // Create user profile
        _user = UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          name: name,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          isEmailVerified: false,
          preferences: const UserPreferencesModel(),
        );
        
        await _saveUserProfile();
        return true;
      } else {
        _setError('Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _authApi?.logout();
      await LocalStorage.removeUserToken();
      _user = null;
      _isAuthenticated = false;
      _clearError();
      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  /// Load user profile
  Future<void> _loadUserProfile() async {
    try {
      final userData = LocalStorage.getUserPreferences();
      if (userData.isNotEmpty) {
        _user = UserModel.fromJson(userData);
      } else {
        // Create default user for demo
        _user = UserModel(
          id: 'demo_user',
          email: 'demo@financialapp.com',
          name: 'Usuario Demo',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          lastLoginAt: DateTime.now(),
          isEmailVerified: true,
          preferences: const UserPreferencesModel(),
        );
        await _saveUserProfile();
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  /// Save user profile
  Future<void> _saveUserProfile() async {
    if (_user != null) {
      try {
        await LocalStorage.saveUserPreferences(_user!.toJson());
      } catch (e) {
        debugPrint('Error saving user profile: $e');
      }
    }
  }

  /// Update user preferences
  Future<bool> updatePreferences(UserPreferencesModel preferences) async {
    if (_user == null) return false;

    try {
      _user = _user!.copyWith(preferences: preferences);
      await _saveUserProfile();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update preferences: ${e.toString()}');
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? profileImageUrl,
  }) async {
    if (_user == null) return false;

    try {
      _user = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        profileImageUrl: profileImageUrl ?? _user!.profileImageUrl,
      );
      await _saveUserProfile();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      // In a real implementation, this would call the API
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _setError('Failed to change password: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearError();

    try {
      // In a real implementation, this would call the API
      await Future.delayed(const Duration(seconds: 1));
      await logout();
      return true;
    } catch (e) {
      _setError('Failed to delete account: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
    
    // Auto-clear error after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (_errorMessage == error) {
        _clearError();
      }
    });
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}