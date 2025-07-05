// lib/domain/usecases/update_user_settings.dart
import '../../data/models/user_model.dart';
import '../../data/datasources/local/local_storage.dart';
import '../repositories/user_repository.dart';

class UpdateUserSettingsUseCase {
  final UserRepository userRepository;

  UpdateUserSettingsUseCase(this.userRepository);

  /// Update user preferences
  Future<bool> updatePreferences(UserPreferencesModel preferences) async {
    try {
      return await userRepository.updateUserPreferences(preferences);
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    }
  }

  /// Update notification settings
  Future<bool> updateNotificationSettings({
    bool? notificationsEnabled,
    bool? priceAlertsEnabled,
    bool? portfolioUpdatesEnabled,
  }) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser == null) return false;

      final updatedPreferences = currentUser.preferences.copyWith(
        notificationsEnabled: notificationsEnabled ?? currentUser.preferences.notificationsEnabled,
        priceAlertsEnabled: priceAlertsEnabled ?? currentUser.preferences.priceAlertsEnabled,
        portfolioUpdatesEnabled: portfolioUpdatesEnabled ?? currentUser.preferences.portfolioUpdatesEnabled,
      );

      return await updatePreferences(updatedPreferences);
    } catch (e) {
      throw Exception('Failed to update notification settings: $e');
    }
  }

  /// Update theme settings
  Future<bool> updateThemeSettings({
    bool? darkMode,
  }) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser == null) return false;

      final updatedPreferences = currentUser.preferences.copyWith(
        darkMode: darkMode ?? currentUser.preferences.darkMode,
      );

      return await updatePreferences(updatedPreferences);
    } catch (e) {
      throw Exception('Failed to update theme settings: $e');
    }
  }

  /// Update language settings
  Future<bool> updateLanguageSettings({
    String? language,
    String? timeZone,
  }) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser == null) return false;

      final updatedPreferences = currentUser.preferences.copyWith(
        language: language ?? currentUser.preferences.language,
        timeZone: timeZone ?? currentUser.preferences.timeZone,
      );

      return await updatePreferences(updatedPreferences);
    } catch (e) {
      throw Exception('Failed to update language settings: $e');
    }
  }

  /// Update currency settings
  Future<bool> updateCurrencySettings(String currency) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser == null) return false;

      final updatedPreferences = currentUser.preferences.copyWith(
        currency: currency,
      );

      return await updatePreferences(updatedPreferences);
    } catch (e) {
      throw Exception('Failed to update currency settings: $e');
    }
  }

  /// Reset settings to defaults
  Future<bool> resetToDefaults() async {
    try {
      const defaultPreferences = UserPreferencesModel();
      return await updatePreferences(defaultPreferences);
    } catch (e) {
      throw Exception('Failed to reset settings: $e');
    }
  }

  /// Export user settings
  Future<Map<String, dynamic>?> exportSettings() async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      return currentUser?.preferences.toJson();
    } catch (e) {
      throw Exception('Failed to export settings: $e');
    }
  }

  /// Import user settings
  Future<bool> importSettings(Map<String, dynamic> settingsJson) async {
    try {
      final preferences = UserPreferencesModel.fromJson(settingsJson);
      return await updatePreferences(preferences);
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }
}