// lib/domain/usecases/manage_favorites.dart
import '../entities/instrument.dart';
import '../repositories/market_repository.dart';
import '../../data/datasources/local/local_storage.dart';

class ManageFavoritesUseCase {
  final MarketRepository marketRepository;

  ManageFavoritesUseCase(this.marketRepository);

  /// Get all favorite instruments
  Future<List<Instrument>> getFavoriteInstruments() async {
    try {
      final favoriteIds = LocalStorage.getFavorites();
      if (favoriteIds.isEmpty) return [];

      final allInstruments = await marketRepository.getMarketInstruments();
      return allInstruments
          .where((instrument) => favoriteIds.contains(instrument.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite instruments: $e');
    }
  }

  /// Add instrument to favorites
  Future<bool> addToFavorites(String instrumentId) async {
    try {
      return await LocalStorage.addToFavorites(instrumentId);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  /// Remove instrument from favorites
  Future<bool> removeFromFavorites(String instrumentId) async {
    try {
      return await LocalStorage.removeFromFavorites(instrumentId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String instrumentId) async {
    try {
      if (LocalStorage.isFavorite(instrumentId)) {
        return await removeFromFavorites(instrumentId);
      } else {
        return await addToFavorites(instrumentId);
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  /// Check if instrument is favorite
  bool isFavorite(String instrumentId) {
    return LocalStorage.isFavorite(instrumentId);
  }

  /// Get favorites count
  int getFavoritesCount() {
    return LocalStorage.getFavorites().length;
  }

  /// Clear all favorites
  Future<bool> clearAllFavorites() async {
    try {
      final favorites = LocalStorage.getFavorites();
      return await LocalStorage.saveStringList('favorites', []);
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }

  /// Import favorites
  Future<bool> importFavorites(List<String> instrumentIds) async {
    try {
      return await LocalStorage.saveStringList('favorites', instrumentIds);
    } catch (e) {
      throw Exception('Failed to import favorites: $e');
    }
  }

  /// Export favorites
  List<String> exportFavorites() {
    return LocalStorage.getFavorites();
  }
}