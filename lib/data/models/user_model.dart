// lib/data/models/user_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isEmailVerified;
  final UserPreferencesModel preferences;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.createdAt,
    required this.lastLoginAt,
    required this.isEmailVerified,
    required this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    UserPreferencesModel? preferences,
  }) {
    return UserModel(
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

  String get displayName => name ?? email;

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

@JsonSerializable()
class UserPreferencesModel extends Equatable {
  final String currency;
  final bool darkMode;
  final bool notificationsEnabled;
  final bool priceAlertsEnabled;
  final bool portfolioUpdatesEnabled;
  final String language;
  final String timeZone;

  const UserPreferencesModel({
    this.currency = 'USD',
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.priceAlertsEnabled = true,
    this.portfolioUpdatesEnabled = true,
    this.language = 'en',
    this.timeZone = 'UTC',
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) => 
      _$UserPreferencesModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesModelToJson(this);

  UserPreferencesModel copyWith({
    String? currency,
    bool? darkMode,
    bool? notificationsEnabled,
    bool? priceAlertsEnabled,
    bool? portfolioUpdatesEnabled,
    String? language,
    String? timeZone,
  }) {
    return UserPreferencesModel(
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