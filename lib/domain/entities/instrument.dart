// lib/domain/entities/instrument.dart
import 'package:equatable/equatable.dart';

class Instrument extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final int volume;
  final String market;
  final String type;
  final String sector;
  final DateTime lastUpdated;
  final double? dayHigh;
  final double? dayLow;
  final double? yearHigh;
  final double? yearLow;
  final double? marketCap;
  final double? peRatio;
  final double? dividendYield;

  const Instrument({
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
    required this.lastUpdated,
    this.dayHigh,
    this.dayLow,
    this.yearHigh,
    this.yearLow,
    this.marketCap,
    this.peRatio,
    this.dividendYield,
  });

  /// Create a copy of the instrument with updated values
  Instrument copyWith({
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
    DateTime? lastUpdated,
    double? dayHigh,
    double? dayLow,
    double? yearHigh,
    double? yearLow,
    double? marketCap,
    double? peRatio,
    double? dividendYield,
  }) {
    return Instrument(
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
      lastUpdated: lastUpdated ?? this.lastUpdated,
      dayHigh: dayHigh ?? this.dayHigh,
      dayLow: dayLow ?? this.dayLow,
      yearHigh: yearHigh ?? this.yearHigh,
      yearLow: yearLow ?? this.yearLow,
      marketCap: marketCap ?? this.marketCap,
      peRatio: peRatio ?? this.peRatio,
      dividendYield: dividendYield ?? this.dividendYield,
    );
  }

  /// Check if the instrument is gaining value
  bool get isGaining => changePercent > 0;

  /// Check if the instrument is losing value
  bool get isLosing => changePercent < 0;

  /// Check if the instrument is a stock
  bool get isStock => type.toLowerCase() == 'stock';

  /// Check if the instrument is an ETF
  bool get isETF => type.toLowerCase() == 'etf';

  /// Check if the instrument is a bond
  bool get isBond => type.toLowerCase() == 'bond';

  /// Get the instrument type display name
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

  /// Get formatted market cap
  String get formattedMarketCap {
    if (marketCap == null) return 'N/A';
    
    if (marketCap! >= 1e12) {
      return '\$${(marketCap! / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap! >= 1e9) {
      return '\$${(marketCap! / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap! >= 1e6) {
      return '\$${(marketCap! / 1e6).toStringAsFixed(2)}M';
    } else {
      return '\$${marketCap!.toStringAsFixed(0)}';
    }
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
        lastUpdated,
        dayHigh,
        dayLow,
        yearHigh,
        yearLow,
        marketCap,
        peRatio,
        dividendYield,
      ];

  @override
  String toString() {
    return 'Instrument(symbol: $symbol, name: $name, price: $price)';
  }
}