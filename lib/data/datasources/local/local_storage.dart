// lib/data/datasources/local/local_storage.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';

/// Local storage service for persisting app data
class LocalStorage {
  static SharedPreferences? _prefs;
  static Box? _hiveBox;
  static bool _isInitialized = false;

  /// Initialize local storage
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Initialize Hive
      await Hive.initFlutter();
      _hiveBox = await Hive.openBox('financial_app_data');

      _isInitialized = true;
      debugPrint('Local storage initialized successfully');
    } catch (e) {
      debugPrint('Error initializing local storage: $e');
      throw Exception('Failed to initialize local storage');
    }
  }

  /// Check if storage is initialized
  static bool get isInitialized => _isInitialized;

  // ===== SharedPreferences Methods =====

  /// Save string value
  static Future<bool> saveString(String key, String value) async {
    await _ensureInitialized();
    return await _prefs!.setString(key, value);
  }

  /// Get string value
  static String? getString(String key, {String? defaultValue}) {
    _ensureInitializedSync();
    return _prefs!.getString(key) ?? defaultValue;
  }

  /// Save boolean value
  static Future<bool> saveBool(String key, bool value) async {
    await _ensureInitialized();
    return await _prefs!.setBool(key, value);
  }

  /// Get boolean value
  static bool getBool(String key, {bool defaultValue = false}) {
    _ensureInitializedSync();
    return _prefs!.getBool(key) ?? defaultValue;
  }

  /// Save integer value
  static Future<bool> saveInt(String key, int value) async {
    await _ensureInitialized();
    return await _prefs!.setInt(key, value);
  }

  /// Get integer value
  static int getInt(String key, {int defaultValue = 0}) {
    _ensureInitializedSync();
    return _prefs!.getInt(key) ?? defaultValue;
  }

  /// Save double value
  static Future<bool> saveDouble(String key, double value) async {
    await _ensureInitialized();
    return await _prefs!.setDouble(key, value);
  }

  /// Get double value
  static double getDouble(String key, {double defaultValue = 0.0}) {
    _ensureInitializedSync();
    return _prefs!.getDouble(key) ?? defaultValue;
  }

  /// Save list of strings
  static Future<bool> saveStringList(String key, List<String> value) async {
    await _ensureInitialized();
    return await _prefs!.setStringList(key, value);
  }

  /// Get list of strings
  static List<String> getStringList(String key, {List<String>? defaultValue}) {
    _ensureInitializedSync();
    return _prefs!.getStringList(key) ?? defaultValue ?? [];
  }

  /// Remove key from SharedPreferences
  static Future<bool> remove(String key) async {
    await _ensureInitialized();
    return await _prefs!.remove(key);
  }

  /// Clear all SharedPreferences data
  static Future<bool> clear() async {
    await _ensureInitialized();
    return await _prefs!.clear();
  }

  /// Check if key exists in SharedPreferences
  static bool containsKey(String key) {
    _ensureInitializedSync();
    return _prefs!.containsKey(key);
  }

  // ===== JSON Storage Methods =====

  /// Save JSON object
  static Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await saveString(key, jsonString);
    } catch (e) {
      debugPrint('Error saving JSON: $e');
      return false;
    }
  }

  /// Get JSON object
  static Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting JSON: $e');
      return null;
    }
  }

  /// Save list of JSON objects
  static Future<bool> saveJsonList(String key, List<Map<String, dynamic>> value) async {
    try {
      final jsonString = json.encode(value);
      return await saveString(key, jsonString);
    } catch (e) {
      debugPrint('Error saving JSON list: $e');
      return false;
    }
  }

  /// Get list of JSON objects
  static List<Map<String, dynamic>> getJsonList(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString != null) {
        final List<dynamic> decoded = json.decode(jsonString);
        return decoded.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting JSON list: $e');
      return [];
    }
  }

  // ===== Hive Methods (for complex data) =====

  /// Save to Hive box
  static Future<void> saveToHive(String key, dynamic value) async {
    await _ensureInitialized();
    await _hiveBox!.put(key, value);
  }

  /// Get from Hive box
  static T? getFromHive<T>(String key, {T? defaultValue}) {
    _ensureInitializedSync();
    return _hiveBox!.get(key, defaultValue: defaultValue) as T?;
  }

  /// Remove from Hive box
  static Future<void> removeFromHive(String key) async {
    await _ensureInitialized();
    await _hiveBox!.delete(key);
  }

  /// Clear Hive box
  static Future<void> clearHive() async {
    await _ensureInitialized();
    await _hiveBox!.clear();
  }

  /// Check if key exists in Hive
  static bool containsKeyInHive(String key) {
    _ensureInitializedSync();
    return _hiveBox!.containsKey(key);
  }

  // ===== App-specific Methods =====

  /// Save user preferences
  static Future<bool> saveUserPreferences(Map<String, dynamic> preferences) async {
    return await saveJson(AppConstants.userPreferencesKey, preferences);
  }

  /// Get user preferences
  static Map<String, dynamic> getUserPreferences() {
    return getJson(AppConstants.userPreferencesKey) ?? {};
  }

  /// Save favorites list
  static Future<bool> saveFavorites(List<String> favorites) async {
    return await saveStringList(AppConstants.favoritesKey, favorites);
  }

  /// Get favorites list
  static List<String> getFavorites() {
    return getStringList(AppConstants.favoritesKey);
  }

  /// Add to favorites
  static Future<bool> addToFavorites(String instrumentId) async {
    final favorites = getFavorites();
    if (!favorites.contains(instrumentId)) {
      favorites.add(instrumentId);
      return await saveFavorites(favorites);
    }
    return true;
  }

  /// Remove from favorites
  static Future<bool> removeFromFavorites(String instrumentId) async {
    final favorites = getFavorites();
    if (favorites.contains(instrumentId)) {
      favorites.remove(instrumentId);
      return await saveFavorites(favorites);
    }
    return true;
  }

  /// Check if instrument is favorite
  static bool isFavorite(String instrumentId) {
    return getFavorites().contains(instrumentId);
  }

  /// Save portfolio data
  static Future<bool> savePortfolio(List<Map<String, dynamic>> portfolio) async {
    return await saveJsonList(AppConstants.portfolioKey, portfolio);
  }

  /// Get portfolio data
  static List<Map<String, dynamic>> getPortfolio() {
    return getJsonList(AppConstants.portfolioKey);
  }

  /// Save user token
  static Future<bool> saveUserToken(String token) async {
    return await saveString(AppConstants.userTokenKey, token);
  }

  /// Get user token
  static String? getUserToken() {
    return getString(AppConstants.userTokenKey);
  }

  /// Remove user token (logout)
  static Future<bool> removeUserToken() async {
    return await remove(AppConstants.userTokenKey);
  }

  /// Check if user is logged in
  static bool isUserLoggedIn() {
    return getUserToken() != null;
  }

  /// Save last sync timestamp
  static Future<bool> saveLastSync(DateTime timestamp) async {
    return await saveString(AppConstants.lastSyncKey, timestamp.toIso8601String());
  }

  /// Get last sync timestamp
  static DateTime? getLastSync() {
    final syncString = getString(AppConstants.lastSyncKey);
    if (syncString != null) {
      try {
        return DateTime.parse(syncString);
      } catch (e) {
        debugPrint('Error parsing last sync date: $e');
      }
    }
    return null;
  }

  // ===== Cache Methods =====

  /// Save cached data with expiration
  static Future<void> saveCachedData(
    String key,
    dynamic data, {
    Duration? expiration,
  }) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };
    await saveToHive('cache_$key', cacheData);
  }

  /// Get cached data if not expired
  static T? getCachedData<T>(String key) {
    final cacheData = getFromHive<Map<dynamic, dynamic>>('cache_$key');
    if (cacheData == null) return null;

    final timestamp = cacheData['timestamp'] as int?;
    final expiration = cacheData['expiration'] as int?;

    if (timestamp != null && expiration != null) {
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final expirationTime = cacheTime.add(Duration(milliseconds: expiration));
      
      if (DateTime.now().isAfter(expirationTime)) {
        // Cache expired, remove it
        removeFromHive('cache_$key');
        return null;
      }
    }

    return cacheData['data'] as T?;
  }

  /// Clear expired cache entries
  static Future<void> clearExpiredCache() async {
    await _ensureInitialized();
    final keys = _hiveBox!.keys.where((key) => key.toString().startsWith('cache_')).toList();
    
    for (final key in keys) {
      final cacheData = _hiveBox!.get(key) as Map<dynamic, dynamic>?;
      if (cacheData != null) {
        final timestamp = cacheData['timestamp'] as int?;
        final expiration = cacheData['expiration'] as int?;

        if (timestamp != null && expiration != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final expirationTime = cacheTime.add(Duration(milliseconds: expiration));
          
          if (DateTime.now().isAfter(expirationTime)) {
            await _hiveBox!.delete(key);
          }
        }
      }
    }
  }

  // ===== Private Methods =====

  /// Ensure storage is initialized (async)
  static Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Ensure storage is initialized (sync)
  static void _ensureInitializedSync() {
    if (!_isInitialized) {
      throw Exception('Local storage not initialized. Call initialize() first.');
    }
  }

  /// Get storage size information
  static Map<String, dynamic> getStorageInfo() {
    _ensureInitializedSync();
    
    return {
      'sharedPreferencesKeys': _prefs!.getKeys().length,
      'hiveBoxLength': _hiveBox!.length,
      'hiveBoxKeys': _hiveBox!.keys.length,
      'isInitialized': _isInitialized,
    };
  }

  /// Close storage connections
  static Future<void> close() async {
    if (_hiveBox != null && _hiveBox!.isOpen) {
      await _hiveBox!.close();
    }
    _isInitialized = false;
    debugPrint('Local storage closed');
  }
}