// lib/presentation/providers/favorites_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/local/local_storage.dart';

class FavoritesProvider extends ChangeNotifier {
  // Private fields
  List<String> _favorites = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  String _sortBy = 'symbol'; // symbol, price, change, volume
  
  // Dependencies
  dynamic _localStorage;

  // Public getters
  List<String> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _favorites.isEmpty;
  bool get isNotEmpty => _favorites.isNotEmpty;
  int get count => _favorites.length;
  String get sortBy => _sortBy;

  /// Initialize with dependencies
  void initialize({dynamic localStorage}) {
    _localStorage = localStorage;
  }

  /// Load favorites from local storage
  Future<void> loadFavorites() async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      // Load from local storage
      final favoritesList = LocalStorage.getFavorites();
      _favorites = favoritesList;
      
      _isInitialized = true;
      debugPrint('Loaded ${_favorites.length} favorites');
      
    } catch (e) {
      _setError('Error al cargar favoritos: ${e.toString()}');
      debugPrint('Error loading favorites: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh favorites (reload from storage)
  Future<void> refreshFavorites() async {
    try {
      final favoritesList = LocalStorage.getFavorites();
      _favorites = favoritesList;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar favoritos: ${e.toString()}');
    }
  }

  /// Add instrument to favorites
  Future<bool> addFavorite(String instrumentId) async {
    if (_favorites.contains(instrumentId)) {
      return true; // Already in favorites
    }

    try {
      _favorites.add(instrumentId);
      await _saveFavorites();
      notifyListeners();
      
      debugPrint('Added $instrumentId to favorites');
      return true;
    } catch (e) {
      _setError('Error al agregar a favoritos: ${e.toString()}');
      // Revert the change
      _favorites.remove(instrumentId);
      return false;
    }
  }

  /// Remove instrument from favorites
  Future<bool> removeFavorite(String instrumentId) async {
    if (!_favorites.contains(instrumentId)) {
      return true; // Not in favorites
    }

    try {
      _favorites.remove(instrumentId);
      await _saveFavorites();
      notifyListeners();
      
      debugPrint('Removed $instrumentId from favorites');
      return true;
    } catch (e) {
      _setError('Error al quitar de favoritos: ${e.toString()}');
      // Revert the change
      _favorites.add(instrumentId);
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String instrumentId) async {
    if (_favorites.contains(instrumentId)) {
      return await removeFavorite(instrumentId);
    } else {
      return await addFavorite(instrumentId);
    }
  }

  /// Check if instrument is in favorites
  bool isFavorite(String instrumentId) {
    return _favorites.contains(instrumentId);
  }

  /// Clear all favorites
  Future<bool> clearAllFavorites() async {
    if (_favorites.isEmpty) return true;

    final backupFavorites = List<String>.from(_favorites);
    
    try {
      _favorites.clear();
      await _saveFavorites();
      notifyListeners();
      
      debugPrint('Cleared all favorites');
      return true;
    } catch (e) {
      _setError('Error al limpiar favoritos: ${e.toString()}');
      // Revert the change
      _favorites = backupFavorites;
      return false;
    }
  }

  /// Add multiple favorites at once
  Future<bool> addMultipleFavorites(List<String> instrumentIds) async {
    final newFavorites = instrumentIds.where((id) => !_favorites.contains(id)).toList();
    
    if (newFavorites.isEmpty) return true;

    try {
      _favorites.addAll(newFavorites);
      await _saveFavorites();
      notifyListeners();
      
      debugPrint('Added ${newFavorites.length} favorites');
      return true;
    } catch (e) {
      _setError('Error al agregar múltiples favoritos: ${e.toString()}');
      // Revert the changes
      for (final id in newFavorites) {
        _favorites.remove(id);
      }
      return false;
    }
  }

  /// Remove multiple favorites at once
  Future<bool> removeMultipleFavorites(List<String> instrumentIds) async {
    final favoritesToRemove = instrumentIds.where((id) => _favorites.contains(id)).toList();
    
    if (favoritesToRemove.isEmpty) return true;

    try {
      for (final id in favoritesToRemove) {
        _favorites.remove(id);
      }
      await _saveFavorites();
      notifyListeners();
      
      debugPrint('Removed ${favoritesToRemove.length} favorites');
      return true;
    } catch (e) {
      _setError('Error al quitar múltiples favoritos: ${e.toString()}');
      // Revert the changes
      _favorites.addAll(favoritesToRemove);
      return false;
    }
  }

  /// Set sort preference
  void setSortBy(String sortBy) {
    if (_sortBy != sortBy) {
      _sortBy = sortBy;
      notifyListeners();
      
      // Save sort preference
      _saveSortPreference();
    }
  }

  /// Get favorites in chunks for pagination
  List<String> getFavoritesChunk(int offset, int limit) {
    final endIndex = (offset + limit).clamp(0, _favorites.length);
    return _favorites.sublist(offset.clamp(0, _favorites.length), endIndex);
  }

  /// Search within favorites
  List<String> searchFavorites(String query, List<dynamic> allInstruments) {
    if (query.isEmpty) return _favorites;

    final lowercaseQuery = query.toLowerCase();
    return _favorites.where((favoriteId) {
      final instrument = allInstruments.firstWhere(
        (instrument) => instrument.id == favoriteId,
        orElse: () => null,
      );
      
      if (instrument == null) return false;
      
      return instrument.symbol.toLowerCase().contains(lowercaseQuery) ||
             instrument.name.toLowerCase().contains(lowercaseQuery) ||
             instrument.sector.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Import favorites from a list
  Future<bool> importFavorites(List<String> instrumentIds, {bool clearExisting = false}) async {
    final backupFavorites = List<String>.from(_favorites);
    
    try {
      if (clearExisting) {
        _favorites.clear();
      }
      
      // Add new favorites, avoiding duplicates
      for (final id in instrumentIds) {
        if (!_favorites.contains(id)) {
          _favorites.add(id);
        }
      }
      
      await _saveFavorites();
      notifyListeners();
      
      debugPrint('Imported ${instrumentIds.length} favorites (clear existing: $clearExisting)');
      return true;
    } catch (e) {
      _setError('Error al importar favoritos: ${e.toString()}');
      // Revert the changes
      _favorites = backupFavorites;
      return false;
    }
  }

  /// Export favorites as a list
  List<String> exportFavorites() {
    return List<String>.from(_favorites);
  }

  /// Get statistics about favorites
  Map<String, dynamic> getFavoritesStats(List<dynamic> allInstruments) {
    if (_favorites.isEmpty) {
      return {
        'total': 0,
        'byType': <String, int>{},
        'bySector': <String, int>{},
        'byMarket': <String, int>{},
        'avgPrice': 0.0,
        'totalValue': 0.0,
      };
    }

    final favoriteInstruments = allInstruments
        .where((instrument) => _favorites.contains(instrument.id))
        .toList();

    final byType = <String, int>{};
    final bySector = <String, int>{};
    final byMarket = <String, int>{};
    double totalPrice = 0.0;

    for (final instrument in favoriteInstruments) {
      // Count by type
      byType[instrument.type] = (byType[instrument.type] ?? 0) + 1;
      
      // Count by sector
      bySector[instrument.sector] = (bySector[instrument.sector] ?? 0) + 1;
      
      // Count by market
      byMarket[instrument.market] = (byMarket[instrument.market] ?? 0) + 1;
      
      // Sum prices
      totalPrice += instrument.price;
    }

    return {
      'total': _favorites.length,
      'byType': byType,
      'bySector': bySector,
      'byMarket': byMarket,
      'avgPrice': favoriteInstruments.isNotEmpty ? totalPrice / favoriteInstruments.length : 0.0,
      'totalValue': totalPrice,
    };
  }

  /// Save favorites to local storage
  Future<void> _saveFavorites() async {
    try {
      await LocalStorage.saveFavorites(_favorites);
    } catch (e) {
      debugPrint('Error saving favorites to local storage: $e');
      throw Exception('Failed to save favorites: $e');
    }
  }

  /// Save sort preference
  Future<void> _saveSortPreference() async {
    try {
      await LocalStorage.saveString('favorites_sort_by', _sortBy);
    } catch (e) {
      debugPrint('Error saving sort preference: $e');
    }
  }

  /// Load sort preference
  Future<void> _loadSortPreference() async {
    try {
      final sortBy = LocalStorage.getString('favorites_sort_by', defaultValue: 'symbol');
      _sortBy = sortBy;
    } catch (e) {
      debugPrint('Error loading sort preference: $e');
    }
  }

  /// Initialize complete setup
  Future<void> initializeComplete() async {
    await Future.wait([
      loadFavorites(),
      _loadSortPreference(),
    ]);
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