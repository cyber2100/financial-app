// lib/data/models/portfolio_item_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioItemModel _$PortfolioItemModelFromJson(Map<String, dynamic> json) =>
    PortfolioItemModel(
      id: json['id'] as String,
      instrumentId: json['instrumentId'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      averageCost: (json['averageCost'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      currentValue: (json['currentValue'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      notes: json['notes'] as String?,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PortfolioItemModelToJson(PortfolioItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instrumentId': instance.instrumentId,
      'symbol': instance.symbol,
      'name': instance.name,
      'quantity': instance.quantity,
      'averageCost': instance.averageCost,
      'currentPrice': instance.currentPrice,
      'totalCost': instance.totalCost,
      'currentValue': instance.currentValue,
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'notes': instance.notes,
      'transactions': instance.transactions.map((e) => e.toJson()).toList(),
    };

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      portfolioItemId: json['portfolioItemId'] as String,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      fees: (json['fees'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioItemId': instance.portfolioItemId,
      'type': instance.type,
      'quantity': instance.quantity,
      'price': instance.price,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
      'fees': instance.fees,
    };