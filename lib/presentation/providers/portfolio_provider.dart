// lib/presentation/providers/portfolio_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/portfolio_item_model.dart';
import '../../data/models/instrument_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/calculations.dart';
import '../../data/datasources/local/local_storage.dart';

class PortfolioProvider extends ChangeNotifier {
  // Private fields
  List<PortfolioItemModel> _portfolio = [];
  bool _isLoading = false;
  String? _errorMessage;
  PortfolioSummary? _portfolioSummary;
  
  // Dependencies
  dynamic _portfolioApi;
  dynamic _localStorage;
  dynamic _user;

  // Public getters
  List<PortfolioItemModel> get portfolio => _portfolio;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _portfolio.isNotEmpty;
  bool get hasError => _errorMessage != null;
  PortfolioSummary get portfolioSummary => _portfolioSummary ?? PortfolioSummary.empty();

  /// Initialize with dependencies
  void initialize({
    dynamic portfolioApi,
    dynamic localStorage,
    dynamic user,
  }) {
    _portfolioApi = portfolioApi;
    _localStorage = localStorage;
    _user = user;
  }

  /// Load portfolio from storage/API
  Future<void> loadPortfolio() async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      // Load from local storage first
      await _loadFromLocalStorage();
      
      // Then sync with API if available
      await _syncWithApi();
      
      // Calculate summary
      _calculatePortfolioSummary();
      
    } catch (e) {
      _setError('Error al cargar portafolio: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh portfolio data
  Future<void> refreshPortfolio() async {
    try {
      await _syncWithApi();
      _calculatePortfolioSummary();
    } catch (e) {
      _setError('Error al actualizar portafolio: ${e.toString()}');
    }
  }

  /// Load portfolio from local storage
  Future<void> _loadFromLocalStorage() async {
    try {
      final portfolioData = LocalStorage.getJsonList(AppConstants.portfolioKey);
      _portfolio = portfolioData
          .map((item) => PortfolioItemModel.fromJson(item))
          .toList();
      
      if (_portfolio.isNotEmpty) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading portfolio from local storage: $e');
    }
  }

  /// Sync with API
  Future<void> _syncWithApi() async {
    try {
      // In a real implementation, this would sync with the API
      // For now, we'll just update with mock real-time prices
      await _updateCurrentPrices();
    } catch (e) {
      debugPrint('Error syncing with API: $e');
    }
  }

  /// Update current prices for all positions
  Future<void> _updateCurrentPrices() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock price updates
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    for (int i = 0; i < _portfolio.length; i++) {
      final position = _portfolio[i];
      final priceVariation = (random % 10 - 5) / 100; // -5% to +5%
      final newPrice = position.currentPrice * (1 + priceVariation);
      
      _portfolio[i] = position.updatePrice(newPrice);
    }
    
    notifyListeners();
  }

  /// Add new position to portfolio
  Future<bool> addPosition({
    required String instrumentId,
    required String symbol,
    required String name,
    required double quantity,
    required double averageCost,
    String? notes,
  }) async {
    try {
      final newPosition = PortfolioItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        instrumentId: instrumentId,
        symbol: symbol,
        name: name,
        quantity: quantity,
        averageCost: averageCost,
        currentPrice: averageCost, // Will be updated with real price
        totalCost: quantity * averageCost,
        currentValue: quantity * averageCost,
        purchaseDate: DateTime.now(),
        lastUpdated: DateTime.now(),
        notes: notes,
        transactions: [],
      );

      _portfolio.add(newPosition);
      await _saveToLocalStorage();
      _calculatePortfolioSummary();
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError('Error al agregar posición: ${e.toString()}');
      return false;
    }
  }

  /// Remove position from portfolio
  Future<bool> removePosition(String positionId) async {
    try {
      _portfolio.removeWhere((position) => position.id == positionId);
      await _saveToLocalStorage();
      _calculatePortfolioSummary();
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError('Error al eliminar posición: ${e.toString()}');
      return false;
    }
  }

  /// Update existing position
  Future<bool> updatePosition({
    required String positionId,
    double? quantity,
    double? averageCost,
    String? notes,
  }) async {
    try {
      final index = _portfolio.indexWhere((p) => p.id == positionId);
      if (index == -1) return false;

      final position = _portfolio[index];
      final updatedPosition = position.copyWith(
        quantity: quantity ?? position.quantity,
        averageCost: averageCost ?? position.averageCost,
        notes: notes ?? position.notes,
        lastUpdated: DateTime.now(),
      );

      // Recalculate values
      final newTotalCost = updatedPosition.quantity * updatedPosition.averageCost;
      final newCurrentValue = updatedPosition.quantity * updatedPosition.currentPrice;

      _portfolio[index] = updatedPosition.copyWith(
        totalCost: newTotalCost,
        currentValue: newCurrentValue,
      );

      await _saveToLocalStorage();
      _calculatePortfolioSummary();
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError('Error al actualizar posición: ${e.toString()}');
      return false;
    }
  }

  /// Add shares to existing position
  Future<bool> addShares({
    required String positionId,
    required double quantity,
    required double price,
    String? notes,
  }) async {
    try {
      final index = _portfolio.indexWhere((p) => p.id == positionId);
      if (index == -1) return false;

      final position = _portfolio[index];
      final newQuantity = position.quantity + quantity;
      final newAverageCost = PortfolioCalculations.calculateNewAverageCost(
        currentShares: position.quantity,
        currentAvgCost: position.averageCost,
        newShares: quantity,
        newPrice: price,
      );

      _portfolio[index] = position.copyWith(
        quantity: newQuantity,
        averageCost: newAverageCost,
        totalCost: newQuantity * newAverageCost,
        currentValue: newQuantity * position.currentPrice,
        lastUpdated: DateTime.now(),
      );

      await _saveToLocalStorage();
      _calculatePortfolioSummary();
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError('Error al agregar acciones: ${e.toString()}');
      return false;
    }
  }

  /// Save portfolio to local storage
  Future<void> _saveToLocalStorage() async {
    try {
      final portfolioData = _portfolio.map((item) => item.toJson()).toList();
      await LocalStorage.saveJsonList(AppConstants.portfolioKey, portfolioData);
    } catch (e) {
      debugPrint('Error saving portfolio to local storage: $e');
    }
  }

  /// Calculate portfolio summary
  void _calculatePortfolioSummary() {
    if (_portfolio.isEmpty) {
      _portfolioSummary = PortfolioSummary.empty();
      return;
    }

    final totalValue = _portfolio.fold<double>(
      0.0, 
      (sum, position) => sum + position.currentValue,
    );

    final totalCost = _portfolio.fold<double>(
      0.0, 
      (sum, position) => sum + position.totalCost,
    );

    final totalGainLoss = totalValue - totalCost;
    final totalGainLossPercent = totalCost > 0 ? (totalGainLoss / totalCost) * 100 : 0.0;

    _portfolioSummary = PortfolioSummary(
      totalValue: totalValue,
      totalCost: totalCost,
      totalGainLoss: totalGainLoss,
      totalGainLossPercent: totalGainLossPercent,
      totalPositions: _portfolio.length,
    );
  }

  /// Sort portfolio by value
  void sortByValue() {
    _portfolio.sort((a, b) => b.currentValue.compareTo(a.currentValue));
    notifyListeners();
  }

  /// Sort portfolio by gain/loss
  void sortByGainLoss() {
    _portfolio.sort((a, b) => b.gainLoss.compareTo(a.gainLoss));
    notifyListeners();
  }

  /// Sort portfolio by symbol
  void sortBySymbol() {
    _portfolio.sort((a, b) => a.symbol.compareTo(b.symbol));
    notifyListeners();
  }

  /// Get position by ID
  PortfolioItemModel? getPositionById(String id) {
    try {
      return _portfolio.firstWhere((position) => position.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get position by instrument ID
  PortfolioItemModel? getPositionByInstrumentId(String instrumentId) {
    try {
      return _portfolio.firstWhere(
        (position) => position.instrumentId == instrumentId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if instrument is in portfolio
  bool isInPortfolio(String instrumentId) {
    return _portfolio.any((position) => position.instrumentId == instrumentId);
  }

  /// Get portfolio performance metrics
  Map<String, double> getPerformanceMetrics() {
    if (_portfolio.isEmpty) {
      return {
        'totalReturn': 0.0,
        'dailyReturn': 0.0,
        'volatility': 0.0,
        'sharpeRatio': 0.0,
      };
    }

    // Calculate basic metrics
    final totalReturn = portfolioSummary.totalGainLossPercent;
    
    // Mock daily return (in a real app, this would be calculated from historical data)
    final dailyReturn = 0.5; // Mock value
    
    // Mock volatility and Sharpe ratio
    final volatility = 15.0; // Mock value
    final sharpeRatio = totalReturn / volatility;

    return {
      'totalReturn': totalReturn,
      'dailyReturn': dailyReturn,
      'volatility': volatility,
      'sharpeRatio': sharpeRatio,
    };
  }

  /// Get top performers
  List<PortfolioItemModel> getTopPerformers({int limit = 3}) {
    final performers = List<PortfolioItemModel>.from(_portfolio);
    performers.sort((a, b) => b.gainLossPercent.compareTo(a.gainLossPercent));
    return performers.take(limit).toList();
  }

  /// Get worst performers
  List<PortfolioItemModel> getWorstPerformers({int limit = 3}) {
    final performers = List<PortfolioItemModel>.from(_portfolio);
    performers.sort((a, b) => a.gainLossPercent.compareTo(b.gainLossPercent));
    return performers.take(limit).toList();
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Portfolio summary data class
class PortfolioSummary {
  final double totalValue;
  final double totalCost;
  final double totalGainLoss;
  final double totalGainLossPercent;
  final int totalPositions;

  const PortfolioSummary({
    required this.totalValue,
    required this.totalCost,
    required this.totalGainLoss,
    required this.totalGainLossPercent,
    required this.totalPositions,
  });

  factory PortfolioSummary.empty() {
    return const PortfolioSummary(
      totalValue: 0.0,
      totalCost: 0.0,
      totalGainLoss: 0.0,
      totalGainLossPercent: 0.0,
      totalPositions: 0,
    );
  }

  bool get isPositive => totalGainLoss >= 0;
}