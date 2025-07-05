// lib/data/repositories/market_repository_impl.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/instrument.dart';
import '../../domain/repositories/market_repository.dart';
import '../datasources/remote/market_api.dart';
import '../datasources/local/local_storage.dart';
import '../models/instrument_model.dart';

class MarketRepositoryImpl implements MarketRepository {
  final MarketApiDataSource remoteDataSource;
  final LocalStorage localStorage;

  MarketRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<List<Instrument>> getMarketInstruments() async {
    try {
      // Try to get cached data first
      final cachedData = await _getCachedMarketData();
      if (cachedData.isNotEmpty) {
        // Return cached data and fetch fresh data in background
        _fetchAndCacheFreshData();
        return _convertToEntities(cachedData);
      }

      // No cached data, fetch fresh data
      final instruments = await remoteDataSource.getMarketData();
      await _cacheMarketData(instruments);
      return _convertToEntities(instruments);
    } catch (e) {
      debugPrint('Error getting market instruments: $e');
      
      // Try to return cached data as fallback
      final cachedData = await _getCachedMarketData();
      if (cachedData.isNotEmpty) {
        return _convertToEntities(cachedData);
      }
      
      rethrow;
    }
  }

  @override
  Stream<Instrument> getRealTimePrices() async* {
    // Implementation would depend on WebSocket or Server-Sent Events
    // For now, return a mock stream
    yield* Stream.periodic(const Duration(seconds: 5), (count) {
      return const Instrument(
        id: 'aapl',
        symbol: 'AAPL',
        name: 'Apple Inc.',
        price: 178.25,
        change: 2.15,
        changePercent: 1.22,
        volume: 45231567,
        market: 'NASDAQ',
        type: 'stock',
        sector: 'Technology',
        lastUpdated: DateTime.now(),
      );
    });
  }

  @override
  Future<Instrument?> getInstrumentDetails(String instrumentId) async {
    try {
      final instrument = await remoteDataSource.getInstrumentDetails(instrumentId);
      return _convertToEntity(instrument);
    } catch (e) {
      debugPrint('Error getting instrument details: $e');
      return null;
    }
  }

  Future<List<InstrumentModel>> _getCachedMarketData() async {
    try {
      final cachedData = LocalStorage.getCachedData<List<dynamic>>('market_instruments');
      if (cachedData != null) {
        return cachedData
            .map((item) => InstrumentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting cached market data: $e');
      return [];
    }
  }

  Future<void> _cacheMarketData(List<InstrumentModel> instruments) async {
    try {
      final dataToCache = instruments.map((instrument) => instrument.toJson()).toList();
      await LocalStorage.saveCachedData(
        'market_instruments',
        dataToCache,
        expiration: const Duration(minutes: 5),
      );
    } catch (e) {
      debugPrint('Error caching market data: $e');
    }
  }

  Future<void> _fetchAndCacheFreshData() async {
    try {
      final instruments = await remoteDataSource.getMarketData();
      await _cacheMarketData(instruments);
    } catch (e) {
      debugPrint('Error fetching fresh market data: $e');
    }
  }

  List<Instrument> _convertToEntities(List<InstrumentModel> models) {
    return models.map(_convertToEntity).toList();
  }

  Instrument _convertToEntity(InstrumentModel model) {
    return Instrument(
      id: model.id,
      symbol: model.symbol,
      name: model.name,
      price: model.price,
      change: model.change,
      changePercent: model.changePercent,
      volume: model.volume,
      market: model.market,
      type: model.type,
      sector: model.sector,
      lastUpdated: model.lastUpdated ?? DateTime.now(),
      dayHigh: model.dayHigh,
      dayLow: model.dayLow,
      yearHigh: model.weekHigh52,
      yearLow: model.weekLow52,
      marketCap: model.marketCap,
      peRatio: model.peRatio,
      dividendYield: model.dividendYield,
    );
  }
}