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

// lib/domain/entities/portfolio_item.dart
import 'package:equatable/equatable.dart';

class PortfolioItem extends Equatable {
  final String id;
  final String instrumentId;
  final String symbol;
  final String name;
  final double quantity;
  final double averageCost;
  final double currentPrice;
  final double totalCost;
  final double currentValue;
  final DateTime purchaseDate;
  final DateTime lastUpdated;
  final String? notes;
  final List<Transaction> transactions;

  const PortfolioItem({
    required this.id,
    required this.instrumentId,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.averageCost,
    required this.currentPrice,
    required this.totalCost,
    required this.currentValue,
    required this.purchaseDate,
    required this.lastUpdated,
    this.notes,
    this.transactions = const [],
  });

  /// Create a copy of the portfolio item with updated values
  PortfolioItem copyWith({
    String? id,
    String? instrumentId,
    String? symbol,
    String? name,
    double? quantity,
    double? averageCost,
    double? currentPrice,
    double? totalCost,
    double? currentValue,
    DateTime? purchaseDate,
    DateTime? lastUpdated,
    String? notes,
    List<Transaction>? transactions,
  }) {
    return PortfolioItem(
      id: id ?? this.id,
      instrumentId: instrumentId ?? this.instrumentId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      averageCost: averageCost ?? this.averageCost,
      currentPrice: currentPrice ?? this.currentPrice,
      totalCost: totalCost ?? this.totalCost,
      currentValue: currentValue ?? this.currentValue,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      notes: notes ?? this.notes,
      transactions: transactions ?? this.transactions,
    );
  }

  /// Update the current price and recalculate current value
  PortfolioItem updatePrice(double newPrice) {
    return copyWith(
      currentPrice: newPrice,
      currentValue: quantity * newPrice,
      lastUpdated: DateTime.now(),
    );
  }

  /// Calculate gain/loss amount
  double get gainLoss => currentValue - totalCost;

  /// Calculate gain/loss percentage
  double get gainLossPercent => totalCost > 0 ? (gainLoss / totalCost) * 100 : 0.0;

  /// Check if the position is profitable
  bool get isProfitable => gainLoss > 0;

  /// Check if the position is at a loss
  bool get isAtLoss => gainLoss < 0;

  /// Get the total number of buy transactions
  int get buyTransactionCount => transactions.where((t) => t.type == TransactionType.buy).length;

  /// Get the total number of sell transactions
  int get sellTransactionCount => transactions.where((t) => t.type == TransactionType.sell).length;

  /// Get the first purchase date
  DateTime get firstPurchaseDate {
    if (transactions.isEmpty) return purchaseDate;
    final buyTransactions = transactions.where((t) => t.type == TransactionType.buy);
    if (buyTransactions.isEmpty) return purchaseDate;
    return buyTransactions.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b);
  }

  /// Calculate days held
  int get daysHeld => DateTime.now().difference(firstPurchaseDate).inDays;

  /// Calculate annualized return
  double get annualizedReturn {
    if (daysHeld == 0) return 0.0;
    final years = daysHeld / 365.25;
    if (years <= 0) return 0.0;
    
    final totalReturn = gainLossPercent / 100;
    return (math.pow(1 + totalReturn, 1 / years) - 1) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        instrumentId,
        symbol,
        name,
        quantity,
        averageCost,
        currentPrice,
        totalCost,
        currentValue,
        purchaseDate,
        lastUpdated,
        notes,
        transactions,
      ];

  @override
  String toString() {
    return 'PortfolioItem(symbol: $symbol, quantity: $quantity, currentValue: $currentValue)';
  }
}

// lib/domain/entities/transaction.dart
enum TransactionType {
  buy,
  sell,
  dividend,
  split,
  merger,
}

class Transaction extends Equatable {
  final String id;
  final String portfolioItemId;
  final TransactionType type;
  final double quantity;
  final double price;
  final double amount;
  final DateTime date;
  final String? notes;
  final double? fees;

  const Transaction({
    required this.id,
    required this.portfolioItemId,
    required this.type,
    required this.quantity,
    required this.price,
    required this.amount,
    required this.date,
    this.notes,
    this.fees,
  });

  /// Create a copy of the transaction with updated values
  Transaction copyWith({
    String? id,
    String? portfolioItemId,
    TransactionType? type,
    double? quantity,
    double? price,
    double? amount,
    DateTime? date,
    String? notes,
    double? fees,
  }) {
    return Transaction(
      id: id ?? this.id,
      portfolioItemId: portfolioItemId ?? this.portfolioItemId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      fees: fees ?? this.fees,
    );
  }

  /// Get the transaction type display name
  String get typeDisplayName {
    switch (type) {
      case TransactionType.buy:
        return 'Buy';
      case TransactionType.sell:
        return 'Sell';
      case TransactionType.dividend:
        return 'Dividend';
      case TransactionType.split:
        return 'Stock Split';
      case TransactionType.merger:
        return 'Merger';
    }
  }

  /// Check if this is a buy transaction
  bool get isBuy => type == TransactionType.buy;

  /// Check if this is a sell transaction
  bool get isSell => type == TransactionType.sell;

  /// Get the net amount (including fees)
  double get netAmount {
    final feeAmount = fees ?? 0.0;
    return isBuy ? amount + feeAmount : amount - feeAmount;
  }

  @override
  List<Object?> get props => [
        id,
        portfolioItemId,
        type,
        quantity,
        price,
        amount,
        date,
        notes,
        fees,
      ];

  @override
  String toString() {
    return 'Transaction(type: ${typeDisplayName}, quantity: $quantity, price: $price)';
  }
}

// lib/domain/entities/user.dart
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isEmailVerified;
  final UserPreferences preferences;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.createdAt,
    required this.lastLoginAt,
    required this.isEmailVerified,
    required this.preferences,
  });

  /// Create a copy of the user with updated values
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Get display name (name or email)
  String get displayName => name ?? email;

  /// Get initials for avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final nameParts = name!.trim().split(' ');
      if (nameParts.length >= 2) {
        return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profileImageUrl,
        createdAt,
        lastLoginAt,
        isEmailVerified,
        preferences,
      ];
}

// lib/domain/entities/user_preferences.dart
class UserPreferences extends Equatable {
  final String currency;
  final bool darkMode;
  final bool notificationsEnabled;
  final bool priceAlertsEnabled;
  final bool portfolioUpdatesEnabled;
  final String language;
  final String timeZone;

  const UserPreferences({
    this.currency = 'USD',
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.priceAlertsEnabled = true,
    this.portfolioUpdatesEnabled = true,
    this.language = 'en',
    this.timeZone = 'UTC',
  });

  /// Create a copy of the user preferences with updated values
  UserPreferences copyWith({
    String? currency,
    bool? darkMode,
    bool? notificationsEnabled,
    bool? priceAlertsEnabled,
    bool? portfolioUpdatesEnabled,
    String? language,
    String? timeZone,
  }) {
    return UserPreferences(
      currency: currency ?? this.currency,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
      portfolioUpdatesEnabled: portfolioUpdatesEnabled ?? this.portfolioUpdatesEnabled,
      language: language ?? this.language,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  @override
  List<Object> get props => [
        currency,
        darkMode,
        notificationsEnabled,
        priceAlertsEnabled,
        portfolioUpdatesEnabled,
        language,
        timeZone,
      ];
}

// Required imports
import 'package:equatable/equatable.dart';
import 'dart:math' as math;