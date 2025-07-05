// lib/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isEmailVerified;
  final UserPreferences preferences;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.createdAt,
    required this.lastLoginAt,
    required this.isEmailVerified,
    required this.preferences,
  });

  /// Create a copy of the user with updated values
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Get display name (name or email)
  String get displayName => name ?? email;

  /// Get initials for avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final nameParts = name!.trim().split(' ');
      if (nameParts.length >= 2) {
        return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profileImageUrl,
        createdAt,
        lastLoginAt,
        isEmailVerified,
        preferences,
      ];
}

class UserPreferences extends Equatable {
  final String currency;
  final bool darkMode;
  final bool notificationsEnabled;
  final bool priceAlertsEnabled;
  final bool portfolioUpdatesEnabled;
  final String language;
  final String timeZone;

  const UserPreferences({
    this.currency = 'USD',
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.priceAlertsEnabled = true,
    this.portfolioUpdatesEnabled = true,
    this.language = 'en',
    this.timeZone = 'UTC',
  });

  /// Create a copy of the user preferences with updated values
  UserPreferences copyWith({
    String? currency,
    bool? darkMode,
    bool? notificationsEnabled,
    bool? priceAlertsEnabled,
    bool? portfolioUpdatesEnabled,
    String? language,
    String? timeZone,
  }) {
    return UserPreferences(
      currency: currency ?? this.currency,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
      portfolioUpdatesEnabled: portfolioUpdatesEnabled ?? this.portfolioUpdatesEnabled,
      language: language ?? this.language,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  @override
  List<Object> get props => [
        currency,
        darkMode,
        notificationsEnabled,
        priceAlertsEnabled,
        portfolioUpdatesEnabled,
        language,
        timeZone,
      ];
}