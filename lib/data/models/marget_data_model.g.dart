// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketDataModel _$MarketDataModelFromJson(Map<String, dynamic> json) =>
    MarketDataModel(
      instruments: (json['instruments'] as List<dynamic>)
          .map((e) => InstrumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      marketStatus: MarketStatusModel.fromJson(
          json['marketStatus'] as Map<String, dynamic>),
      marketSummary: MarketSummaryModel.fromJson(
          json['marketSummary'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$MarketDataModelToJson(MarketDataModel instance) =>
    <String, dynamic>{
      'instruments': instance.instruments,
      'marketStatus': instance.marketStatus,
      'marketSummary': instance.marketSummary,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

MarketStatusModel _$MarketStatusModelFromJson(Map<String, dynamic> json) =>
    MarketStatusModel(
      isOpen: json['isOpen'] as bool,
      status: json['status'] as String,
      nextOpen: json['nextOpen'] == null
          ? null
          : DateTime.parse(json['nextOpen'] as String),
      nextClose: json['nextClose'] == null
          ? null
          : DateTime.parse(json['nextClose'] as String),
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$MarketStatusModelToJson(MarketStatusModel instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'status': instance.status,
      'nextOpen': instance.nextOpen?.toIso8601String(),
      'nextClose': instance.nextClose?.toIso8601String(),
      'timezone': instance.timezone,
    };

MarketSummaryModel _$MarketSummaryModelFromJson(Map<String, dynamic> json) =>
    MarketSummaryModel(
      totalMarketCap: (json['totalMarketCap'] as num).toDouble(),
      totalVolume: (json['totalVolume'] as num).toDouble(),
      gainers: json['gainers'] as int,
      losers: json['losers'] as int,
      unchanged: json['unchanged'] as int,
      topGainers: (json['topGainers'] as List<dynamic>)
          .map((e) => InstrumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topLosers: (json['topLosers'] as List<dynamic>)
          .map((e) => InstrumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mostActive: (json['mostActive'] as List<dynamic>)
          .map((e) => InstrumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MarketSummaryModelToJson(MarketSummaryModel instance) =>
    <String, dynamic>{
      'totalMarketCap': instance.totalMarketCap,
      'totalVolume': instance.totalVolume,
      'gainers': instance.gainers,
      'losers': instance.losers,
      'unchanged': instance.unchanged,
      'topGainers': instance.topGainers,
      'topLosers': instance.topLosers,
      'mostActive': instance.mostActive,
    };