// lib/data/models/instrument_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instrument_model.g.dart';

/// Model representing a financial instrument (stock, bond, ETF, etc.)
@JsonSerializable()
class InstrumentModel extends Equatable {
  /// Unique identifier for the instrument
  final String id;
  
  /// Trading symbol (e.g., AAPL, GOOGL)
  final String symbol;
  
  /// Full company/instrument name
  final String name;
  
  /// Current price
  final double price;
  
  /// Price change since last close
  final double change;
  
  /// Percentage change since last close
  final double changePercent;
  
  /// Trading volume
  final int volume;
  
  /// Market exchange (NYSE, NASDAQ, etc.)
  final String market;
  
  /// Instrument type (stock, bond, etf, etc.)
  final String type;
  
  /// Industry sector
  final String sector;
  
  /// Previous close price (optional)
  final double? previousClose;
  
  /// Day's high price (optional)
  final double? dayHigh;
  
  /// Day's low price (optional)
  final double? dayLow;
  
  /// 52-week high (optional)
  final double? weekHigh52;
  
  /// 52-week low (optional)
  final double? weekLow52;
  
  /// Market capitalization (optional)
  final double? marketCap;
  
  /// Price-to-earnings ratio (optional)
  final double? peRatio;
  
  /// Dividend yield (optional)
  final double? dividendYield;
  
  /// Currency code (USD, EUR, etc.)
  final String? currency;
  
  /// Timestamp of last update
  final DateTime? lastUpdated;
  
  /// Whether market is currently open
  final bool? isMarketOpen;

  const InstrumentModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.volume,
    required this.market,
    required this.type,
    required this.sector,
    this.previousClose,
    this.dayHigh,
    this.dayLow,
    this.weekHigh52,
    this.weekLow52,
    this.marketCap,
    this.peRatio,
    this.dividendYield,
    this.currency = 'USD',
    this.lastUpdated,
    this.isMarketOpen,
  });

  /// Create InstrumentModel from JSON
  factory InstrumentModel.fromJson(Map<String, dynamic> json) =>
      _$InstrumentModelFromJson(json);

  /// Convert InstrumentModel to JSON
  Map<String, dynamic> toJson() => _$InstrumentModelToJson(this);

  /// Create a copy with updated values
  InstrumentModel copyWith({
    String? id,
    String? symbol,
    String? name,
    double? price,
    double? change,
    double? changePercent,
    int? volume,
    String? market,
    String? type,
    String? sector,
    double? previousClose,
    double? dayHigh,
    double? dayLow,
    double? weekHigh52,
    double? weekLow52,
    double? marketCap,
    double? peRatio,
    double? dividendYield,
    String? currency,
    DateTime? lastUpdated,
    bool? isMarketOpen,
  }) {
    return InstrumentModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      volume: volume ?? this.volume,
      market: market ?? this.market,
      type: type ?? this.type,
      sector: sector ?? this.sector,
      previousClose: previousClose ?? this.previousClose,
      dayHigh: dayHigh ?? this.dayHigh,
      dayLow: dayLow ?? this.dayLow,
      weekHigh52: weekHigh52 ?? this.weekHigh52,
      weekLow52: weekLow52 ?? this.weekLow52,
      marketCap: marketCap ?? this.marketCap,
      peRatio: peRatio ?? this.peRatio,
      dividendYield: dividendYield ?? this.dividendYield,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isMarketOpen: isMarketOpen ?? this.isMarketOpen,
    );
  }

  /// Update price-related fields
  InstrumentModel updatePrice({
    required double newPrice,
    required int newVolume,
    DateTime? timestamp,
  }) {
    final newChange = newPrice - (previousClose ?? price);
    final newChangePercent = previousClose != null && previousClose! > 0
        ? (newChange / previousClose!) * 100
        : 0.0;

    return copyWith(
      price: newPrice,
      change: newChange,
      changePercent: newChangePercent,
      volume: newVolume,
      lastUpdated: timestamp ?? DateTime.now(),
    );
  }

  /// Check if instrument is gaining value
  bool get isGaining => changePercent > 0;

  /// Check if instrument is losing value
  bool get isLosing => changePercent < 0;

  /// Check if instrument is stable (no change)
  bool get isStable => changePercent == 0;

  /// Get formatted price string
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get formatted change string
  String get formattedChange {
    final prefix = change >= 0 ? '+' : '';
    return '$prefix\$${change.toStringAsFixed(2)}';
  }

  /// Get formatted change percent string
  String get formattedChangePercent {
    final prefix = changePercent >= 0 ? '+' : '';
    return '$prefix${changePercent.toStringAsFixed(2)}%';
  }

  /// Get formatted volume string
  String get formattedVolume {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    } else {
      return volume.toString();
    }
  }

  /// Get formatted market cap string
  String get formattedMarketCap {
    if (marketCap == null) return 'N/A';
    
    if (marketCap! >= 1000000000000) {
      return '\$${(marketCap! / 1000000000000).toStringAsFixed(2)}T';
    } else if (marketCap! >= 1000000000) {
      return '\$${(marketCap! / 1000000000).toStringAsFixed(2)}B';
    } else if (marketCap! >= 1000000) {
      return '\$${(marketCap! / 1000000).toStringAsFixed(2)}M';
    } else {
      return '\$${marketCap!.toStringAsFixed(0)}';
    }
  }

  /// Get instrument type display name
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'stock':
        return 'Stock';
      case 'etf':
        return 'ETF';
      case 'bond':
        return 'Bond';
      case 'mutual_fund':
        return 'Mutual Fund';
      case 'crypto':
        return 'Cryptocurrency';
      default:
        return type.toUpperCase();
    }
  }

  /// Check if instrument is a stock
  bool get isStock => type.toLowerCase() == 'stock';

  /// Check if instrument is an ETF
  bool get isETF => type.toLowerCase() == 'etf';

  /// Check if instrument is a bond
  bool get isBond => type.toLowerCase() == 'bond';

  /// Check if instrument is a mutual fund
  bool get isMutualFund => type.toLowerCase() == 'mutual_fund';

  /// Check if instrument is cryptocurrency
  bool get isCrypto => type.toLowerCase() == 'crypto';

  /// Get change color based on value
  /// Returns appropriate color for UI based on positive/negative change
  String get changeColorHex {
    if (changePercent > 0) return '#22c55e'; // Green
    if (changePercent < 0) return '#ef4444'; // Red
    return '#6b7280'; // Gray for no change
  }

  /// Check if instrument data is recent (within last 5 minutes)
  bool get isDataFresh {
    if (lastUpdated == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastUpdated!);
    return difference.inMinutes <= 5;
  }

  /// Validate instrument data
  bool get isValid {
    return id.isNotEmpty &&
           symbol.isNotEmpty &&
           name.isNotEmpty &&
           price >= 0 &&
           volume >= 0 &&
           market.isNotEmpty &&
           type.isNotEmpty &&
           sector.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        name,
        price,
        change,
        changePercent,
        volume,
        market,
        type,
        sector,
        previousClose,
        dayHigh,
        dayLow,
        weekHigh52,
        weekLow52,
        marketCap,
        peRatio,
        dividendYield,
        currency,
        lastUpdated,
        isMarketOpen,
      ];

  @override
  String toString() {
    return 'InstrumentModel('
           'id: $id, '
           'symbol: $symbol, '
           'name: $name, '
           'price: $price, '
           'change: $change, '
           'changePercent: $changePercent%, '
           'volume: $volume, '
           'market: $market, '
           'type: $type'
           ')';
  }
}

/// Extension for creating mock instruments (for development)
extension InstrumentModelMocks on InstrumentModel {
  /// Create a mock Apple stock
  static InstrumentModel mockApple() {
    return const InstrumentModel(
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
      dayHigh: 180.50,
      dayLow: 175.80,
      weekHigh52: 198.23,
      weekLow52: 124.17,
      marketCap: 2800000000000, // $2.8T
      peRatio: 29.5,
      dividendYield: 0.52,
      currency: 'USD',
      isMarketOpen: true,
    );
  }

  /// Create a mock Google stock
  static InstrumentModel mockGoogle() {
    return const InstrumentModel(
      id: 'googl',
      symbol: 'GOOGL',
      name: 'Alphabet Inc.',
      price: 138.45,
      change: -1.85,
      changePercent: -1.32,
      volume: 23467890,
      market: 'NASDAQ',
      type: 'stock',
      sector: 'Technology',
      previousClose: 140.30,
      dayHigh: 142.15,
      dayLow: 137.20,
      weekHigh52: 152.10,
      weekLow52: 101.88,
      marketCap: 1750000000000, // $1.75T
      peRatio: 25.8,
      dividendYield: 0.0,
      currency: 'USD',
      isMarketOpen: true,
    );
  }

  /// Create a list of mock instruments
  static List<InstrumentModel> mockList() {
    return [
      mockApple(),
      mockGoogle(),
      const InstrumentModel(
        id: 'msft',
        symbol: 'MSFT',
        name: 'Microsoft Corp.',
        price: 345.67,
        change: 4.32,
        changePercent: 1.27,
        volume: 18945623,
        market: 'NASDAQ',
        type: 'stock',
        sector: 'Technology',
      ),
      const InstrumentModel(
        id: 'tsla',
        symbol: 'TSLA',
        name: 'Tesla Inc.',
        price: 248.91,
        change: -5.67,
        changePercent: -2.23,
        volume: 67234891,
        market: 'NASDAQ',
        type: 'stock',
        sector: 'Automotive',
      ),
      const InstrumentModel(
        id: 'spy',
        symbol: 'SPY',
        name: 'SPDR S&P 500 ETF',
        price: 421.35,
        change: 1.89,
        changePercent: 0.45,
        volume: 78456123,
        market: 'NYSE',
        type: 'etf',
        sector: 'Index Fund',
      ),
    ];
  }
}