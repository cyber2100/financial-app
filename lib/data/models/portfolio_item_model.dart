// lib/data/models/portfolio_item_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portfolio_item_model.g.dart';

@JsonSerializable()
class PortfolioItemModel extends Equatable {
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
  final List<TransactionModel> transactions;

  const PortfolioItemModel({
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

  factory PortfolioItemModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioItemModelToJson(this);

  PortfolioItemModel copyWith({
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
    List<TransactionModel>? transactions,
  }) {
    return PortfolioItemModel(
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

  PortfolioItemModel updatePrice(double newPrice) {
    return copyWith(
      currentPrice: newPrice,
      currentValue: quantity * newPrice,
      lastUpdated: DateTime.now(),
    );
  }

  double get gainLoss => currentValue - totalCost;
  double get gainLossPercent => totalCost > 0 ? (gainLoss / totalCost) * 100 : 0.0;
  bool get isProfitable => gainLoss > 0;
  bool get isAtLoss => gainLoss < 0;

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
}

@JsonSerializable()
class TransactionModel extends Equatable {
  final String id;
  final String portfolioItemId;
  final String type; // 'buy', 'sell', 'dividend'
  final double quantity;
  final double price;
  final double amount;
  final DateTime date;
  final String? notes;
  final double? fees;

  const TransactionModel({
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

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

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
}