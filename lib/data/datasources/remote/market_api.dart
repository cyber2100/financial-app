abstract class MarketApiDataSource {
  Future<List<InstrumentModel>> getMarketData();
  Future<InstrumentModel> getInstrumentDetails(String symbol);
  Stream<InstrumentModel> getRealTimePrice(String symbol);
}