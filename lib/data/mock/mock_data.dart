import 'dart:math';
import '../models/instrument_model.dart';

class MockData {
  static final Random _random = Random();

  /// Generate mock instruments list
  static List<InstrumentModel> generateMockInstruments({int count = 50}) {
    final List<InstrumentModel> instruments = [];
    
    // Add predefined major stocks
    instruments.addAll(_getMajorStocks());
    
    // Add additional random instruments if needed
    while (instruments.length < count) {
      instruments.add(_generateRandomInstrument());
    }
    
    return instruments.take(count).toList();
  }

  /// Get major well-known stocks
  static List<InstrumentModel> _getMajorStocks() {
    return [
      const InstrumentModel(
        id: 'aapl',
        symbol: 'AAPL',
        name: 'Apple Inc.',
        price: 178.25,
        change: 2.15,
        changePercent: 1.22,
        volume: 45231567,
        market: 'NASDAQ',
        type: 'stock',
        sector: 'Technology',
        previousClose: 176.10,
        dayHigh: 179.50,
        dayLow: 176.20,
        weekHigh52: 199.62,
        weekLow52: 124.17,
        marketCap: 2850000000000,
        peRatio: 28.5,
        dividendYield: 0.46,
        currency: 'USD',
        isMarketOpen: true,
      ),
      const InstrumentModel(
        id: 'googl',
        symbol: 'GOOGL',
        name: 'Alphabet Inc.',
        price: 142.87,
        change: -1.23,
        changePercent: -0.85,
        volume: 23456789,
        market: 'NASDAQ',
        type: 'stock',
        sector: 'Technology',
        previousClose: 144.10,
        dayHigh: 145.30,
        dayLow: 141.50,
        weekHigh52: 151.55,
        weekLow52: 83.34,
        marketCap: 1800000000000,
        peRatio: 24.8,
        dividendYield: 0.0,
        currency: 'USD',
        isMarketOpen: true,
      ),
      const InstrumentModel(
        id: 'msft',
        symbol: 'MSFT',
        name: 'Microsoft Corporation',
        price: 384.52,
        change: 5.67,
        changePercent: 1.50,
        volume: 19234567,
        market: 'NASDAQ',
        type: 'stock',
        sector: 'Technology',
        previousClose: 378.85,
        dayHigh: 386.20,
        dayLow: 380.15,
        weekHigh52: 468.35,
        weekLow52: 213.43,
        marketCap: 2860000000000,
        peRatio: 32.1,
        dividendYield: 0.72,
        currency: 'USD',
        isMarketOpen: true,
      ),
      const InstrumentModel(
        id: 'tsla',
        symbol: 'TSLA',
        name: 'Tesla, Inc.',
        price: 248.91,
        change: -8.45,
        changePercent: -3.28,
        volume: 89234567,
        market: 'NASDAQ',
        type: 'stock',
        sector: 'Consumer Discretionary',
        previousClose: 257.36,
        dayHigh: 260.15,
        dayLow: 245.80,
        weekHigh52: 384.29,
        weekLow52: 101.81,
        marketCap: 790000000000,
        peRatio: 65.2,
        dividendYield: 0.0,
        currency: 'USD',
        isMarketOpen: true,
      ),
      const InstrumentModel(
        id: 'amzn',
        symbol: 'AMZN',
        name: 'Amazon.com, Inc.',
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
    ];
  }

  /// Generate a random instrument
  static InstrumentModel _generateRandomInstrument() {
    final symbols = _getRandomSymbols();
    final symbol = symbols[_random.nextInt(symbols.length)];
    final basePrice = 50 + _random.nextDouble() * 500;
    final change = (_random.nextDouble() - 0.5) * 20;
    final changePercent = (change / basePrice) * 100;

    return InstrumentModel(
      id: symbol.toLowerCase(),
      symbol: symbol,
      name: '${symbol} Corporation',
      price: basePrice + change,
      change: change,
      changePercent: changePercent,
      volume: _random.nextInt(100000000) + 1000000,
      market: _getRandomMarket(),
      type: _getRandomType(),
      sector: _getRandomSector(),
      previousClose: basePrice,
      dayHigh: basePrice + _random.nextDouble() * 10,
      dayLow: basePrice - _random.nextDouble() * 10,
      weekHigh52: basePrice + _random.nextDouble() * 50,
      weekLow52: basePrice - _random.nextDouble() * 50,
      marketCap: basePrice * (_random.nextInt(1000000000) + 1000000),
      peRatio: 10 + _random.nextDouble() * 40,
      dividendYield: _random.nextDouble() * 5,
      currency: 'USD',
      isMarketOpen: true,
    );
  }

  static List<String> _getRandomSymbols() {
    return [
      'NVDA', 'META', 'JPM', 'JNJ', 'V', 'WMT', 'PG', 'UNH', 'HD', 'MA',
      'DIS', 'BAC', 'ADBE', 'CRM', 'NFLX', 'KO', 'PEP', 'TMO', 'COST', 'ABBV',
      'MRK', 'ACN', 'LIN', 'DHR', 'TXN', 'VZ', 'QCOM', 'PM', 'HON', 'UPS',
      'AMGN', 'LOW', 'IBM', 'SPGI', 'CAT', 'GS', 'CVX', 'BLK', 'NEE', 'RTX',
      'SBUX', 'AMD', 'INTU', 'GILD', 'MDT', 'ISRG', 'NOW', 'PLD', 'TJX', 'AXP'
    ];
  }

  static String _getRandomMarket() {
    const markets = ['NASDAQ', 'NYSE', 'AMEX'];
    return markets[_random.nextInt(markets.length)];
  }

  static String _getRandomType() {
    const types = ['stock', 'etf'];
    return types[_random.nextInt(types.length)];
  }

  static String _getRandomSector() {
    const sectors = [
      'Technology', 'Healthcare', 'Financial Services', 'Consumer Discretionary',
      'Communication Services', 'Industrials', 'Consumer Staples', 'Energy',
      'Utilities', 'Real Estate', 'Materials'
    ];
    return sectors[_random.nextInt(sectors.length)];
  }

  /// Generate mock portfolio items
  static List<Map<String, dynamic>> generateMockPortfolio() {
    final portfolio = <Map<String, dynamic>>[];
    final instruments = _getMajorStocks().take(3).toList();

    for (final instrument in instruments) {
      final quantity = (_random.nextDouble() * 100) + 1;
      final averageCost = instrument.price * (0.8 + _random.nextDouble() * 0.4);
      
      portfolio.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString() + _random.nextInt(1000).toString(),
        'instrumentId': instrument.id,
        'symbol': instrument.symbol,
        'name': instrument.name,
        'quantity': quantity,
        'averageCost': averageCost,
        'currentPrice': instrument.price,
        'totalCost': quantity * averageCost,
        'currentValue': quantity * instrument.price,
        'purchaseDate': DateTime.now().subtract(Duration(days: _random.nextInt(365))).toIso8601String(),
        'lastUpdated': DateTime.now().toIso8601String(),
        'notes': null,
        'transactions': [],
      });
    }

    return portfolio;
  }
}

// Extension methods for InstrumentModel
extension InstrumentModelHelpers on InstrumentModel {
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedChange => '${change >= 0 ? '+' : ''}\$${change.toStringAsFixed(2)}';
  String get formattedChangePercent => '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
  String get formattedVolume => _formatVolume(volume);
  
  bool get isGaining => changePercent > 0;
  bool get isLosing => changePercent < 0;
  bool get isStock => type.toLowerCase() == 'stock';
  bool get isETF => type.toLowerCase() == 'etf';
  
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'stock': return 'Stock';
      case 'etf': return 'ETF';
      case 'bond': return 'Bond';
      case 'mutual_fund': return 'Mutual Fund';
      case 'crypto': return 'Crypto';
      default: return type.toUpperCase();
    }
  }
  
  String get formattedMarketCap {
    if (marketCap == null) return 'N/A';
    if (marketCap! >= 1e12) {
      return '\$${(marketCap! / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap! >= 1e9) {
      return '\$${(marketCap! / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap! >= 1e6) {
      return '\$${(marketCap! / 1e6).toStringAsFixed(2)}M';
    }
    return '\$${marketCap!.toStringAsFixed(0)}';
  }
  
  static String _formatVolume(int volume) {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toString();
  }
}