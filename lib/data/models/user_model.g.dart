// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool,
      preferences: UserPreferencesModel.fromJson(
          json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt.toIso8601String(),
      'isEmailVerified': instance.isEmailVerified,
      'preferences': instance.preferences,
    };

UserPreferencesModel _$UserPreferencesModelFromJson(
        Map<String, dynamic> json) =>
    UserPreferencesModel(
      currency: json['currency'] as String? ?? 'USD',
      darkMode: json['darkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      priceAlertsEnabled: json['priceAlertsEnabled'] as bool? ?? true,
      portfolioUpdatesEnabled: json['portfolioUpdatesEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      timeZone: json['timeZone'] as String? ?? 'UTC',
    );

Map<String, dynamic> _$UserPreferencesModelToJson(
        UserPreferencesModel instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'darkMode': instance.darkMode,
      'notificationsEnabled': instance.notificationsEnabled,
      'priceAlertsEnabled': instance.priceAlertsEnabled,
      'portfolioUpdatesEnabled': instance.portfolioUpdatesEnabled,
      'language': instance.language,
      'timeZone': instance.timeZone,
    };