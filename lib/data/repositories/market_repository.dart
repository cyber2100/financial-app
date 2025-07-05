class MarketRepositoryImpl implements MarketRepository {
  final MarketApiDataSource remoteDataSource;
  final MarketLocalDataSource localDataSource;
  
  Future<List<Instrument>> getMarketInstruments();
  Stream<Instrument> getRealTimePrices();
}