// lib/data/models/market_data_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'instrument_model.dart';

part 'market_data_model.g.dart';

@JsonSerializable()
class MarketDataModel extends Equatable {
  final List<InstrumentModel> instruments;
  final MarketStatusModel marketStatus;
  final MarketSummaryModel marketSummary;
  final DateTime lastUpdated;

  const MarketDataModel({
    required this.instruments,
    required this.marketStatus,
    required this.marketSummary,
    required this.lastUpdated,
  });

  factory MarketDataModel.fromJson(Map<String, dynamic> json) => 
      _$MarketDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketDataModelToJson(this);

  @override
  List<Object> get props => [instruments, marketStatus, marketSummary, lastUpdated];
}

@JsonSerializable()
class MarketStatusModel extends Equatable {
  final bool isOpen;
  final String status; // 'open', 'closed', 'pre_market', 'after_hours'
  final DateTime? nextOpen;
  final DateTime? nextClose;
  final String timezone;

  const MarketStatusModel({
    required this.isOpen,
    required this.status,
    this.nextOpen,
    this.nextClose,
    required this.timezone,
  });

  factory MarketStatusModel.fromJson(Map<String, dynamic> json) => 
      _$MarketStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketStatusModelToJson(this);

  @override
  List<Object?> get props => [isOpen, status, nextOpen, nextClose, timezone];
}

@JsonSerializable()
class MarketSummaryModel extends Equatable {
  final double totalMarketCap;
  final double totalVolume;
  final int gainers;
  final int losers;
  final int unchanged;
  final List<InstrumentModel> topGainers;
  final List<InstrumentModel> topLosers;
  final List<InstrumentModel> mostActive;

  const MarketSummaryModel({
    required this.totalMarketCap,
    required this.totalVolume,
    required this.gainers,
    required this.losers,
    required this.unchanged,
    required this.topGainers,
    required this.topLosers,
    required this.mostActive,
  });

  factory MarketSummaryModel.fromJson(Map<String, dynamic> json) => 
      _$MarketSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketSummaryModelToJson(this);

  @override
  List<Object> get props => [
        totalMarketCap,
        totalVolume,
        gainers,
        losers,
        unchanged,
        topGainers,
        topLosers,
        mostActive,
      ];
}