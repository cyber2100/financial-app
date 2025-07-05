// lib/domain/repositories/market_repository.dart
import '../entities/instrument.dart';

abstract class MarketRepository {
  Future<List<Instrument>> getMarketInstruments();
  Future<Instrument?> getInstrumentDetails(String instrumentId);
  Stream<Instrument> getRealTimePrices();
}