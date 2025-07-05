// lib/data/models/instrument_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instrument_model.g.dart';

@JsonSerializable()
class InstrumentModel extends Equatable {
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
  final double? previousClose;
  final double? dayHigh;
  final double? dayLow;
  final double? weekHigh52;
  final double? weekLow52;
  final double? marketCap;
  final double? peRatio;
  final double? dividendYield;
  final String currency;
  final DateTime? lastUpdated;
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

  factory InstrumentModel.fromJson(Map<String, dynamic> json) =>
      _$InstrumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstrumentModelToJson(this);

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
}