// lib/presentation/providers/market_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/instrument_model.dart';
import '../../core/constants/app_constants.dart';
import '../../services/real_time_service.dart';

class MarketProvider extends ChangeNotifier {
  // Private fields
  List<InstrumentModel> _instruments = [];
  List<InstrumentModel> _filteredInstruments = [];
  bool _isLoading = false;
  bool _isRealTimeConnected = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  
  // Stream subscriptions
  StreamSubscription<InstrumentModel>? _instrumentUpdatesSubscription;
  StreamSubscription<ConnectionStatus>? _connectionStatusSubscription;
  
  // Dependencies (would be injected in real implementation)
  dynamic _marketApi;
  dynamic _localStorage;
  dynamic _cacheManager;

  // Public getters
  List<InstrumentModel> get instruments => _instruments;
  List<InstrumentModel> get filteredInstruments => _filteredInstruments;
  bool get isLoading => _isLoading;
  bool get isRealTimeConnected => _isRealTimeConnected;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  bool get hasData => _instruments.isNotEmpty;
  bool get hasError => _errorMessage != null;

  // Constructor
  MarketProvider() {
    _initializeRealTimeUpdates();
  }

  /// Initialize with dependencies
  void initialize({
    dynamic marketApi,
    dynamic localStorage,
    dynamic cacheManager,
  }) {
    _marketApi = marketApi;
    _localStorage = localStorage;
    _cacheManager = cacheManager;
  }

  /// Initialize real-time updates
  void _initializeRealTimeUpdates() {
    // Listen to instrument updates
    _instrumentUpdatesSubscription = RealTimeService.instrumentUpdates.listen(
      _handleInstrumentUpdate,
      onError: (error) {
        debugPrint('Real-time instrument update error: $error');
      },
    );

    // Listen to connection status
    _connectionStatusSubscription = RealTimeService.connectionStatus.listen(
      _handleConnectionStatusChange,
    );
  }

  /// Handle real-time instrument updates
  void _handleInstrumentUpdate(InstrumentModel updatedInstrument) {
    final index = _instruments.indexWhere(
      (instrument) => instrument.id == updatedInstrument.id,
    );

    if (index != -1) {
      _instruments[index] = updatedInstrument;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Handle connection status changes
  void _handleConnectionStatusChange(ConnectionStatus status) {
    final wasConnected = _isRealTimeConnected;
    _isRealTimeConnected = status == ConnectionStatus.connected;
    
    if (wasConnected != _isRealTimeConnected) {
      notifyListeners();
    }
  }

  /// Load initial market data
  Future<void> loadMarketData() async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      // Try to load from cache first
      await _loadFromCache();
      
      // Then fetch fresh data
      await _fetchMarketData();
      
      // Subscribe to real-time updates for loaded instruments
      _subscribeToRealTimeUpdates();
      
    } catch (e) {
      _setError('Error al cargar datos del mercado: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh market data
  Future<void> refreshMarketData() async {
    try {
      await _fetchMarketData();
      _subscribeToRealTimeUpdates();
    } catch (e) {
      _setError('Error al actualizar datos: ${e.toString()}');
    }
  }

  /// Load data from cache
  Future<void> _loadFromCache() async {
    try {
      // In a real implementation, this would load from cache
      // For now, we'll use mock data
      await Future.delayed(const Duration(milliseconds: 500));
      _instruments = InstrumentModelMocks.mockList();
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading from cache: $e');
    }
  }

  /// Fetch fresh market data
  Future<void> _fetchMarketData() async {
    try {
      // In a real implementation, this would call the API
      await Future.delayed(const Duration(seconds: 1));
      
      // Extended mock data for demonstration
      _instruments = [
        ...InstrumentModelMocks.mockList(),
        const InstrumentModel(
          id: 'amzn',
          symbol: 'AMZN',
          name: 'Amazon.com Inc.',
          price: 145.32,
          change: 3.28,
          changePercent: 2.31,
          volume: 45231567,
          market: 'NASDAQ',
          type: 'stock',
          sector: 'Consumer Discretionary',
          previousClose: 142.04,
          dayHigh: 147.50,
          dayLow: 143.20,
          weekHigh52: 188.11,
          weekLow52: 118.35,
          marketCap: 1520000000000,
          peRatio: 45.2,
          dividendYield: 0.0,
          currency: 'USD',
          isMarketOpen: true,
        ),
        const InstrumentModel(
          id: 'nvda',
          symbol: 'NVDA',
          name: 'NVIDIA Corporation',
          price: 875.28,
          change: -12.45,
          changePercent: -1.40,
          volume: 28934512,
          market: 'NASDAQ',
          type: 'stock',
          sector: 'Technology',
          previousClose: 887.73,
          dayHigh: 890.15,
          dayLow: 870.20,
          weekHigh52: 950.02,
          weekLow52: 180.96,
          marketCap: 2156000000000,
          peRatio: 72.8,
          dividendYield: 0.03,
          currency: 'USD',
          isMarketOpen: true,
        ),
        const InstrumentModel(
          id: 'vti',
          symbol: 'VTI',
          name: 'Vanguard Total Stock Market ETF',
          price: 238.45,
          change: 1.23,
          changePercent: 0.52,
          volume: 3456789,
          market: 'NYSE',
          type: 'etf',
          sector: 'Index Fund',
          previousClose: 237.22,
          dayHigh: 239.10,
          dayLow: 237.80,
          weekHigh52: 245.70,
          weekLow52: 195.12,
          marketCap: null,
          peRatio: null,
          dividendYield: 1.45,
          currency: 'USD',
          isMarketOpen: true,
        ),
        const InstrumentModel(
          id: 'jpm',
          symbol: 'JPM',
          name: 'JPMorgan Chase & Co.',
          price: 168.92,
          change: -0.78,
          changePercent: -0.46,
          volume: 12345678,
          market: 'NYSE',
          type: 'stock',
          sector: 'Financial Services',
          previousClose: 169.70,
          dayHigh: 171.25,
          dayLow: 167.50,
          weekHigh52: 180.50,
          weekLow52: 135.19,
          marketCap: 485000000000,
          peRatio: 12.4,
          dividendYield: 2.85,
          currency: 'USD',
          isMarketOpen: true,
        ),
      ];

      _applyFilters();
      _clearError();
      notifyListeners();
      
      // Save to cache
      await _saveToCache();
      
    } catch (e) {
      throw Exception('Failed to fetch market data: $e');
    }
  }

  /// Save data to cache
  Future<void> _saveToCache() async {
    try {
      // In a real implementation, this would save to cache
      debugPrint('Market data saved to cache');
    } catch (e) {
      debugPrint('Error saving to cache: $e');
    }
  }

  /// Subscribe to real-time updates
  void _subscribeToRealTimeUpdates() {
    if (_instruments.isNotEmpty) {
      final symbols = _instruments.map((i) => i.symbol).toList();
      RealTimeService.subscribeToInstruments(symbols);
    }
  }

  /// Update search query and apply filters
  void updateSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Set selected filter and apply filters
  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Apply search and filter criteria
  void _applyFilters() {
    List<InstrumentModel> filtered = List.from(_instruments);

    // Apply type filter
    if (_selectedFilter != 'All') {
      final filterType = _selectedFilter.toLowerCase();
      filtered = filtered.where((instrument) {
        switch (filterType) {
          case 'stocks':
            return instrument.type.toLowerCase() == 'stock';
          case 'etfs':
            return instrument.type.toLowerCase() == 'etf';
          case 'bonds':
            return instrument.type.toLowerCase() == 'bond';
          case 'mutual funds':
            return instrument.type.toLowerCase() == 'mutual_fund';
          default:
            return true;
        }
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((instrument) {
        return instrument.symbol.toLowerCase().contains(query) ||
               instrument.name.toLowerCase().contains(query) ||
               instrument.sector.toLowerCase().contains(query) ||
               instrument.market.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by market cap (largest first), then by symbol
    filtered.sort((a, b) {
      // First, sort by market cap if available
      if (a.marketCap != null && b.marketCap != null) {
        return b.marketCap!.compareTo(a.marketCap!);
      } else if (a.marketCap != null) {
        return -1;
      } else if (b.marketCap != null) {
        return 1;
      }
      
      // If no market cap, sort by symbol
      return a.symbol.compareTo(b.symbol);
    });

    _filteredInstruments = filtered;
  }

  /// Get instrument by ID
  InstrumentModel? getInstrumentById(String id) {
    try {
      return _instruments.firstWhere((instrument) => instrument.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get instruments by symbols
  List<InstrumentModel> getInstrumentsBySymbols(List<String> symbols) {
    return _instruments.where((instrument) => 
        symbols.contains(instrument.symbol)).toList();
  }

  /// Get top gainers
  List<InstrumentModel> getTopGainers({int limit = 5}) {
    final gainers = _instruments
        .where((instrument) => instrument.changePercent > 0)
        .toList();
    gainers.sort((a, b) => b.changePercent.compareTo(a.changePercent));
    return gainers.take(limit).toList();
  }

  /// Get top losers
  List<InstrumentModel> getTopLosers({int limit = 5}) {
    final losers = _instruments
        .where((instrument) => instrument.changePercent < 0)
        .toList();
    losers.sort((a, b) => a.changePercent.compareTo(b.changePercent));
    return losers.take(limit).toList();
  }

  /// Get most active (by volume)
  List<InstrumentModel> getMostActive({int limit = 5}) {
    final active = List.from(_instruments);
    active.sort((a, b) => b.volume.compareTo(a.volume));
    return active.take(limit).toList();
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
    _instrumentUpdatesSubscription?.cancel();
    _connectionStatusSubscription?.cancel();
    super.dispose();
  }
}