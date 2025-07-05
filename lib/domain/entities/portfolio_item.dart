// lib/domain/entities/portfolio_item.dart
import 'package:equatable/equatable.dart';
import 'dart:math' as math;

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

/// Transaction type enum
enum TransactionType {
  buy,
  sell,
  dividend,
  split,
  merger,
}

/// Transaction entity
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