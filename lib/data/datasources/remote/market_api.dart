// lib/data/datasources/remote/market_api.dart (complete implementation)
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../models/instrument_model.dart';

abstract class MarketApiDataSource {
  Future<List<InstrumentModel>> getMarketData();
  Future<InstrumentModel> getInstrumentDetails(String symbol);
  Stream<InstrumentModel> getRealTimePrice(String symbol);
}

class MarketApiImpl implements MarketApiDataSource {
  final http.Client _httpClient;
  final String baseUrl;

  MarketApiImpl({
    http.Client? httpClient,
    this.baseUrl = ApiConstants.baseUrl,
  }) : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<InstrumentModel>> getMarketData() async {
    try {
      // In a real implementation, this would make an HTTP request
      // For now, return mock data with some delay to simulate network call
      await Future.delayed(const Duration(seconds: 1));
      
      return _generateMockMarketData();
    } catch (e) {
      debugPrint('Error fetching market data: $e');
      throw Exception('Failed to fetch market data: $e');
    }
  }

  @override
  Future<InstrumentModel> getInstrumentDetails(String symbol) async {
    try {
      // In a real implementation, this would make an HTTP request
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return mock data for the requested symbol
      return _generateMockInstrumentDetail(symbol);
    } catch (e) {
      debugPrint('Error fetching instrument details: $e');
      throw Exception('Failed to fetch instrument details: $e');
    }
  }

  @override
  Stream<InstrumentModel> getRealTimePrice(String symbol) async* {
    // In a real implementation, this would be a WebSocket connection
    // For now, return a mock stream with periodic updates
    await for (final _ in Stream.periodic(const Duration(seconds: 3))) {
      yield _generateMockPriceUpdate(symbol);
    }
  }

  // Mock data generation methods
  List<InstrumentModel> _generateMockMarketData() {
    final random = Random();
    final symbols = ['AAPL', 'GOOGL', 'MSFT', 'TSLA', 'AMZN', 'NVDA', 'META', 'JPM', 'JNJ', 'V'];
    final names = [
      'Apple Inc.',
      'Alphabet Inc.',
      'Microsoft Corporation',
      'Tesla Inc.',
      'Amazon.com Inc.',
      'NVIDIA Corporation',
      'Meta Platforms Inc.',
      'JPMorgan Chase & Co.',
      'Johnson & Johnson',
      'Visa Inc.',
    ];
    final sectors = [
      'Technology',
      'Technology', 
      'Technology',
      'Automotive',
      'Consumer Discretionary',
      'Technology',
      'Technology',
      'Financial Services',
      'Healthcare',
      'Financial Services',
    ];

    return List.generate(symbols.length, (index) {
      final basePrice = 100 + random.nextDouble() * 400;
      final change = (random.nextDouble() - 0.5) * 20;
      final changePercent = (change / basePrice) * 100;

      return InstrumentModel(
        id: symbols[index].toLowerCase(),
        symbol: symbols[index],
        name: names[index],
        price: basePrice + change,
        change: change,
        changePercent: changePercent,
        volume: random.nextInt(100000000) + 1000000,
        market: 'NASDAQ',
        type: 'stock',
        sector: sectors[index],
        previousClose: basePrice,
        dayHigh: basePrice + random.nextDouble() * 10,
        dayLow: basePrice - random.nextDouble() * 10,
        weekHigh52: basePrice + random.nextDouble() * 50,
        weekLow52: basePrice - random.nextDouble() * 50,
        marketCap: (basePrice * (1000000 + random.nextInt(1000000000))),
        peRatio: 15 + random.nextDouble() * 30,
        dividendYield: random.nextDouble() * 3,
        currency: 'USD',
        lastUpdated: DateTime.now(),
        isMarketOpen: true,
      );
    });
  }

  InstrumentModel _generateMockInstrumentDetail(String symbol) {
    final random = Random();
    final basePrice = 100 + random.nextDouble() * 400;
    final change = (random.nextDouble() - 0.5) * 20;

    return InstrumentModel(
      id: symbol.toLowerCase(),
      symbol: symbol,
      name: '$symbol Corporation',
      price: basePrice + change,
      change: change,
      changePercent: (change / basePrice) * 100,
      volume: random.nextInt(100000000) + 1000000,
      market: 'NASDAQ',
      type: 'stock',
      sector: 'Technology',
      previousClose: basePrice,
      dayHigh: basePrice + random.nextDouble() * 10,
      dayLow: basePrice - random.nextDouble() * 10,
      weekHigh52: basePrice + random.nextDouble() * 50,
      weekLow52: basePrice - random.nextDouble() * 50,
      marketCap: basePrice * (1000000 + random.nextInt(1000000000)),
      peRatio: 15 + random.nextDouble() * 30,
      dividendYield: random.nextDouble() * 3,
      currency: 'USD',
      lastUpdated: DateTime.now(),
      isMarketOpen: true,
    );
  }

  InstrumentModel _generateMockPriceUpdate(String symbol) {
    final random = Random();
    final basePrice = 150 + random.nextDouble() * 100;
    final change = (random.nextDouble() - 0.5) * 5;

    return InstrumentModel(
      id: symbol.toLowerCase(),
      symbol: symbol,
      name: '$symbol Corporation',
      price: basePrice + change,
      change: change,
      changePercent: (change / basePrice) * 100,
      volume: random.nextInt(1000000) + 100000,
      market: 'NASDAQ',
      type: 'stock',
      sector: 'Technology',
      lastUpdated: DateTime.now(),
    );
  }

  void dispose() {
    _httpClient.close();
  }
}