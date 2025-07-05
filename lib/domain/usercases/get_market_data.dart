// lib/domain/usecases/get_market_data.dart
import '../entities/instrument.dart';
import '../repositories/market_repository.dart';

class GetMarketDataUseCase {
  final MarketRepository repository;

  GetMarketDataUseCase(this.repository);

  Future<List<Instrument>> call() async {
    return await repository.getMarketInstruments();
  }

  Future<Instrument?> getInstrumentDetails(String instrumentId) async {
    return await repository.getInstrumentDetails(instrumentId);
  }

  Stream<Instrument> getRealTimePrices() {
    return repository.getRealTimePrices();
  }
}