// lib/data/repositories/portfolio_repository_impl.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/portfolio_item.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/remote/portfolio_api.dart';
import '../datasources/local/local_storage.dart';
import '../models/portfolio_item_model.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioApiDataSource remoteDataSource;
  final LocalStorage localStorage;

  PortfolioRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<List<PortfolioItem>> getPortfolioItems() async {
    try {
      // Load from local storage first
      final localData = await _getLocalPortfolio();
      
      // Try to sync with remote if available
      try {
        final remoteData = await remoteDataSource.getPortfolioItems();
        await _saveLocalPortfolio(remoteData);
        return _convertToEntities(remoteData);
      } catch (e) {
        debugPrint('Failed to sync with remote, using local data: $e');
        return _convertToEntities(localData);
      }
    } catch (e) {
      debugPrint('Error getting portfolio items: $e');
      rethrow;
    }
  }

  @override
  Future<bool> addPortfolioItem(PortfolioItem item) async {
    try {
      final model = _convertToModel(item);
      
      // Save locally first
      final localItems = await _getLocalPortfolio();
      localItems.add(model);
      await _saveLocalPortfolio(localItems);
      
      // Try to sync with remote
      try {
        await remoteDataSource.addPortfolioItem(model);
      } catch (e) {
        debugPrint('Failed to sync add with remote: $e');
      }
      
      return true;
    } catch (e) {
      debugPrint('Error adding portfolio item: $e');
      return false;
    }
  }

  @override
  Future<bool> updatePortfolioItem(PortfolioItem item) async {
    try {
      final model = _convertToModel(item);
      
      // Update locally first
      final localItems = await _getLocalPortfolio();
      final index = localItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        localItems[index] = model;
        await _saveLocalPortfolio(localItems);
      }
      
      // Try to sync with remote
      try {
        await remoteDataSource.updatePortfolioItem(model);
      } catch (e) {
        debugPrint('Failed to sync update with remote: $e');
      }
      
      return true;
    } catch (e) {
      debugPrint('Error updating portfolio item: $e');
      return false;
    }
  }

  @override
  Future<bool> removePortfolioItem(String itemId) async {
    try {
      // Remove locally first
      final localItems = await _getLocalPortfolio();
      localItems.removeWhere((i) => i.id == itemId);
      await _saveLocalPortfolio(localItems);
      
      // Try to sync with remote
      try {
        await remoteDataSource.removePortfolioItem(itemId);
      } catch (e) {
        debugPrint('Failed to sync removal with remote: $e');
      }
      
      return true;
    } catch (e) {
      debugPrint('Error removing portfolio item: $e');
      return false;
    }
  }

  Future<List<PortfolioItemModel>> _getLocalPortfolio() async {
    try {
      final portfolioData = LocalStorage.getPortfolio();
      return portfolioData
          .map((item) => PortfolioItemModel.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('Error getting local portfolio: $e');
      return [];
    }
  }

  Future<void> _saveLocalPortfolio(List<PortfolioItemModel> items) async {
    try {
      final portfolioData = items.map((item) => item.toJson()).toList();
      await LocalStorage.savePortfolio(portfolioData);
    } catch (e) {
      debugPrint('Error saving local portfolio: $e');
    }
  }

  List<PortfolioItem> _convertToEntities(List<PortfolioItemModel> models) {
    return models.map(_convertToEntity).toList();
  }

  PortfolioItem _convertToEntity(PortfolioItemModel model) {
    return PortfolioItem(
      id: model.id,
      instrumentId: model.instrumentId,
      symbol: model.symbol,
      name: model.name,
      quantity: model.quantity,
      averageCost: model.averageCost,
      currentPrice: model.currentPrice,
      totalCost: model.totalCost,
      currentValue: model.currentValue,
      purchaseDate: model.purchaseDate,
      lastUpdated: model.lastUpdated,
      notes: model.notes,
      transactions: [], // Convert transactions if needed
    );
  }

  PortfolioItemModel _convertToModel(PortfolioItem entity) {
    return PortfolioItemModel(
      id: entity.id,
      instrumentId: entity.instrumentId,
      symbol: entity.symbol,
      name: entity.name,
      quantity: entity.quantity,
      averageCost: entity.averageCost,
      currentPrice: entity.currentPrice,
      totalCost: entity.totalCost,
      currentValue: entity.currentValue,
      purchaseDate: entity.purchaseDate,
      lastUpdated: entity.lastUpdated,
      notes: entity.notes,
      transactions: [], // Convert transactions if needed
    );
  }
}