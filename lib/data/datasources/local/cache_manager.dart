// lib/data/datasources/local/cache_manager.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static Box? _cacheBox;
  static bool _isInitialized = false;
  static const String _cacheBoxName = 'financial_app_cache';

  /// Initialize cache manager
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _cacheBox = await Hive.openBox(_cacheBoxName);
      _isInitialized = true;
      debugPrint('Cache manager initialized successfully');
    } catch (e) {
      debugPrint('Error initializing cache manager: $e');
      throw Exception('Failed to initialize cache manager');
    }
  }

  /// Save data to cache with expiration
  static Future<void> saveToCache(
    String key,
    dynamic data, {
    Duration? expiration,
  }) async {
    await _ensureInitialized();

    final cacheEntry = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };

    await _cacheBox!.put(key, cacheEntry);
    debugPrint('Data cached with key: $key');
  }

  /// Get data from cache
  static T? getFromCache<T>(String key) {
    _ensureInitializedSync();

    final cacheEntry = _cacheBox!.get(key) as Map<dynamic, dynamic>?;
    if (cacheEntry == null) return null;

    // Check if cache has expired
    if (_isCacheExpired(cacheEntry)) {
      _cacheBox!.delete(key);
      return null;
    }

    return cacheEntry['data'] as T?;
  }

  /// Check if cache entry has expired
  static bool _isCacheExpired(Map<dynamic, dynamic> cacheEntry) {
    final timestamp = cacheEntry['timestamp'] as int?;
    final expiration = cacheEntry['expiration'] as int?;

    if (timestamp == null || expiration == null) {
      return false; // No expiration set
    }

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final expirationTime = cacheTime.add(Duration(milliseconds: expiration));

    return DateTime.now().isAfter(expirationTime);
  }

  /// Remove specific cache entry
  static Future<void> removeFromCache(String key) async {
    await _ensureInitialized();
    await _cacheBox!.delete(key);
    debugPrint('Cache entry removed: $key');
  }

  /// Clear all cache
  static Future<void> clearCache() async {
    await _ensureInitialized();
    await _cacheBox!.clear();
    debugPrint('All cache cleared');
  }

  /// Clear expired cache entries
  static Future<void> clearExpiredCache() async {
    await _ensureInitialized();
    
    final keys = _cacheBox!.keys.toList();
    final expiredKeys = <dynamic>[];

    for (final key in keys) {
      final cacheEntry = _cacheBox!.get(key) as Map<dynamic, dynamic>?;
      if (cacheEntry != null && _isCacheExpired(cacheEntry)) {
        expiredKeys.add(key);
      }
    }

    await _cacheBox!.deleteAll(expiredKeys);
    debugPrint('Cleared ${expiredKeys.length} expired cache entries');
  }

  /// Get cache size information
  static Map<String, dynamic> getCacheInfo() {
    _ensureInitializedSync();
    
    final totalEntries = _cacheBox!.length;
    int expiredEntries = 0;
    
    for (final key in _cacheBox!.keys) {
      final cacheEntry = _cacheBox!.get(key) as Map<dynamic, dynamic>?;
      if (cacheEntry != null && _isCacheExpired(cacheEntry)) {
        expiredEntries++;
      }
    }

    return {
      'totalEntries': totalEntries,
      'expiredEntries': expiredEntries,
      'validEntries': totalEntries - expiredEntries,
      'isInitialized': _isInitialized,
    };
  }

  /// Check if cache contains key
  static bool containsKey(String key) {
    _ensureInitializedSync();
    
    if (!_cacheBox!.containsKey(key)) return false;
    
    final cacheEntry = _cacheBox!.get(key) as Map<dynamic, dynamic>?;
    if (cacheEntry != null && _isCacheExpired(cacheEntry)) {
      _cacheBox!.delete(key);
      return false;
    }
    
    return true;
  }

  /// Save JSON data to cache
  static Future<void> saveJsonToCache(
    String key,
    Map<String, dynamic> data, {
    Duration? expiration,
  }) async {
    await saveToCache(key, data, expiration: expiration);
  }

  /// Get JSON data from cache
  static Map<String, dynamic>? getJsonFromCache(String key) {
    return getFromCache<Map<String, dynamic>>(key);
  }

  /// Save list data to cache
  static Future<void> saveListToCache(
    String key,
    List<dynamic> data, {
    Duration? expiration,
  }) async {
    await saveToCache(key, data, expiration: expiration);
  }

  /// Get list data from cache
  static List<dynamic>? getListFromCache(String key) {
    return getFromCache<List<dynamic>>(key);
  }

  /// Cache market data
  static Future<void> cacheMarketData(
    List<Map<String, dynamic>> instruments, {
    Duration expiration = const Duration(minutes: 5),
  }) async {
    await saveListToCache(
      'market_instruments',
      instruments,
      expiration: expiration,
    );
  }

  /// Get cached market data
  static List<Map<String, dynamic>>? getCachedMarketData() {
    final data = getListFromCache('market_instruments');
    return data?.cast<Map<String, dynamic>>();
  }

  /// Cache portfolio data
  static Future<void> cachePortfolioData(
    List<Map<String, dynamic>> portfolio, {
    Duration expiration = const Duration(hours: 1),
  }) async {
    await saveListToCache(
      'portfolio_data',
      portfolio,
      expiration: expiration,
    );
  }

  /// Get cached portfolio data
  static List<Map<String, dynamic>>? getCachedPortfolioData() {
    final data = getListFromCache('portfolio_data');
    return data?.cast<Map<String, dynamic>>();
  }

  /// Private helper methods
  static Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  static void _ensureInitializedSync() {
    if (!_isInitialized) {
      throw Exception('Cache manager not initialized. Call initialize() first.');
    }
  }

  /// Close cache manager
  static Future<void> close() async {
    if (_cacheBox != null && _cacheBox!.isOpen) {
      await _cacheBox!.close();
    }
    _isInitialized = false;
    debugPrint('Cache manager closed');
  }
}