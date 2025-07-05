// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instrument_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstrumentModel _$InstrumentModelFromJson(Map<String, dynamic> json) =>
    InstrumentModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      volume: json['volume'] as int,
      market: json['market'] as String,
      type: json['type'] as String,
      sector: json['sector'] as String,
      previousClose: (json['previousClose'] as num?)?.toDouble(),
      dayHigh: (json['dayHigh'] as num?)?.toDouble(),
      dayLow: (json['dayLow'] as num?)?.toDouble(),
      weekHigh52: (json['weekHigh52'] as num?)?.toDouble(),
      weekLow52: (json['weekLow52'] as num?)?.toDouble(),
      marketCap: (json['marketCap'] as num?)?.toDouble(),
      peRatio: (json['peRatio'] as num?)?.toDouble(),
      dividendYield: (json['dividendYield'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      isMarketOpen: json['isMarketOpen'] as bool?,
    );

Map<String, dynamic> _$InstrumentModelToJson(InstrumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'price': instance.price,
      'change': instance.change,
      'changePercent': instance.changePercent,
      'volume': instance.volume,
      'market': instance.market,
      'type': instance.type,
      'sector': instance.sector,
      'previousClose': instance.previousClose,
      'dayHigh': instance.dayHigh,
      'dayLow': instance.dayLow,
      'weekHigh52': instance.weekHigh52,
      'weekLow52': instance.weekLow52,
      'marketCap': instance.marketCap,
      'peRatio': instance.peRatio,
      'dividendYield': instance.dividendYield,
      'currency': instance.currency,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'isMarketOpen': instance.isMarketOpen,
    };