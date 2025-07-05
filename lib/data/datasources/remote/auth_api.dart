// lib/data/datasources/remote/auth_api.dart
import 'dart:async';
import '../../../core/constants/api_constants.dart';

abstract class AuthApiDataSource {
  Future<String> login(String email, String password);
  Future<String> register(String email, String password, String name);
  Future<void> logout();
  Future<String> refreshToken(String token);
  Future<bool> validateToken(String token);
}

class AuthApiImpl implements AuthApiDataSource {
  @override
  Future<String> login(String email, String password) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'demo@financialapp.com' && password == 'demo123') {
      return 'mock_jwt_token_12345';
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<String> register(String email, String password, String name) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return 'mock_jwt_token_67890';
  }

  @override
  Future<void> logout() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<String> refreshToken(String token) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return 'refreshed_mock_jwt_token';
  }

  @override
  Future<bool> validateToken(String token) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 200));
    return token.startsWith('mock_jwt_token');
  }
}