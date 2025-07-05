// lib/services/real_time_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../core/constants/app_constants.dart';
import '../data/models/instrument_model.dart';

/// Service for handling real-time data updates via WebSocket
class RealTimeService {
  static WebSocketChannel? _channel;
  static StreamSubscription? _subscription;
  static bool _isConnected = false;
  static bool _isInitialized = false;
  static Timer? _reconnectTimer;
  static Timer? _heartbeatTimer;
  static int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  
  // Stream controllers for different data types
  static final StreamController<InstrumentModel> _instrumentUpdatesController =
      StreamController<InstrumentModel>.broadcast();
  static final StreamController<List<InstrumentModel>> _marketDataController =
      StreamController<List<InstrumentModel>>.broadcast();
  static final StreamController<ConnectionStatus> _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();

  // Public streams
  static Stream<InstrumentModel> get instrumentUpdates =>
      _instrumentUpdatesController.stream;
  static Stream<List<InstrumentModel>> get marketDataUpdates =>
      _marketDataController.stream;
  static Stream<ConnectionStatus> get connectionStatus =>
      _connectionStatusController.stream;

  // Connection status
  static bool get isConnected => _isConnected;
  static bool get isInitialized => _isInitialized;

  /// Initialize the real-time service
  static void initialize() {
    if (_isInitialized) return;

    _isInitialized = true;
    debugPrint('Real-time service initialized');
    
    // Start connection
    connect();
  }

  /// Connect to WebSocket server
  static Future<void> connect() async {
    if (_isConnected) return;

    try {
      debugPrint('Connecting to WebSocket server...');
      _updateConnectionStatus(ConnectionStatus.connecting);

      // In production, use actual WebSocket URL
      // For now, simulate connection
      await _simulateConnection();
      
      _isConnected = true;
      _reconnectAttempts = 0;
      _updateConnectionStatus(ConnectionStatus.connected);
      
      // Start heartbeat
      _startHeartbeat();
      
      // Start mock data updates (remove this in production)
      _startMockDataUpdates();
      
      debugPrint('WebSocket connected successfully');
      
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      _isConnected = false;
      _updateConnectionStatus(ConnectionStatus.disconnected);
      _scheduleReconnect();
    }
  }

  /// Simulate connection for development
  static Future<void> _simulateConnection() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate successful connection
  }

  /// Real WebSocket connection (use in production)
  static Future<void> _connectWebSocket() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(AppConstants.websocketUrl),
      );

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnection,
      );

      // Send authentication or subscription messages
      _sendSubscriptionMessage();
      
    } catch (e) {
      throw Exception('Failed to connect to WebSocket: $e');
    }
  }

  /// Handle incoming WebSocket messages
  static void _handleMessage(dynamic message) {
    try {
      final Map<String, dynamic> data = json.decode(message);
      final String type = data['type'] ?? '';

      switch (type) {
        case 'price_update':
          _handlePriceUpdate(data);
          break;
        case 'market_data':
          _handleMarketData(data);
          break;
        case 'heartbeat':
          debugPrint('Heartbeat received');
          break;
        default:
          debugPrint('Unknown message type: $type');
      }
    } catch (e) {
      debugPrint('Error handling WebSocket message: $e');
    }
  }

  /// Handle price update messages
  static void _handlePriceUpdate(Map<String, dynamic> data) {
    try {
      final instrument = InstrumentModel.fromJson(data['instrument']);
      _instrumentUpdatesController.add(instrument);
    } catch (e) {
      debugPrint('Error processing price update: $e');
    }
  }

  /// Handle market data messages
  static void _handleMarketData(Map<String, dynamic> data) {
    try {
      final List<dynamic> instrumentsData = data['instruments'] ?? [];
      final List<InstrumentModel> instruments = instrumentsData
          .map((item) => InstrumentModel.fromJson(item))
          .toList();
      _marketDataController.add(instruments);
    } catch (e) {
      debugPrint('Error processing market data: $e');
    }
  }

  /// Handle WebSocket errors
  static void _handleError(error) {
    debugPrint('WebSocket error: $error');
    _isConnected = false;
    _updateConnectionStatus(ConnectionStatus.error);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  static void _handleDisconnection() {
    debugPrint('WebSocket disconnected');
    _isConnected = false;
    _updateConnectionStatus(ConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  /// Send subscription message to server
  static void _sendSubscriptionMessage() {
    if (_channel == null) return;

    final subscription = {
      'type': 'subscribe',
      'channels': ['market_data', 'price_updates'],
      'symbols': ['AAPL', 'GOOGL', 'MSFT', 'TSLA', 'AMZN'], // Subscribe to specific symbols
    };

    _channel!.sink.add(json.encode(subscription));
  }

  /// Start heartbeat to keep connection alive
  static void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (_isConnected && _channel != null) {
          _channel!.sink.add(json.encode({'type': 'heartbeat'}));
        } else {
          timer.cancel();
        }
      },
    );
  }

  /// Schedule reconnection attempt
  static void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('Max reconnection attempts reached');
      _updateConnectionStatus(ConnectionStatus.failed);
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectAttempts++;
    
    final delay = Duration(
      seconds: AppConstants.websocketReconnectDelay * _reconnectAttempts,
    );

    debugPrint('Scheduling reconnection attempt $_reconnectAttempts in ${delay.inSeconds}s');
    
    _reconnectTimer = Timer(delay, () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  /// Update connection status
  static void _updateConnectionStatus(ConnectionStatus status) {
    _connectionStatusController.add(status);
  }

  /// Disconnect from WebSocket
  static Future<void> disconnect() async {
    debugPrint('Disconnecting from WebSocket...');
    
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _subscription?.cancel();
    
    if (_channel != null) {
      await _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    
    _isConnected = false;
    _updateConnectionStatus(ConnectionStatus.disconnected);
    
    debugPrint('WebSocket disconnected');
  }

  /// Subscribe to specific instruments
  static void subscribeToInstruments(List<String> symbols) {
    if (!_isConnected || _channel == null) return;

    final message = {
      'type': 'subscribe',
      'symbols': symbols,
    };

    _channel!.sink.add(json.encode(message));
    debugPrint('Subscribed to instruments: $symbols');
  }

  /// Unsubscribe from specific instruments
  static void unsubscribeFromInstruments(List<String> symbols) {
    if (!_isConnected || _channel == null) return;

    final message = {
      'type': 'unsubscribe',
      'symbols': symbols,
    };

    _channel!.sink.add(json.encode(message));
    debugPrint('Unsubscribed from instruments: $symbols');
  }

  /// Start mock data updates for development
  static void _startMockDataUpdates() {
    Timer.periodic(AppConstants.realTimeUpdateInterval, (timer) {
      if (!_isConnected) {
        timer.cancel();
        return;
      }

      // Generate mock price updates
      _generateMockPriceUpdate();
    });
  }

  /// Generate mock price updates for development
  static void _generateMockPriceUpdate() {
    final random = Random();
    final symbols = ['AAPL', 'GOOGL', 'MSFT', 'TSLA', 'AMZN'];
    final symbol = symbols[random.nextInt(symbols.length)];
    
    // Generate random price change
    final basePrice = 150.0 + random.nextDouble() * 100;
    final change = (random.nextDouble() - 0.5) * 10;
    final newPrice = basePrice + change;
    final changePercent = (change / basePrice) * 100;

    final mockInstrument = InstrumentModel(
      id: symbol.toLowerCase(),
      symbol: symbol,
      name: _getCompanyName(symbol),
      price: newPrice,
      change: change,
      changePercent: changePercent,
      volume: random.nextInt(100000000),
      market: 'NASDAQ',
      type: 'stock',
      sector: 'Technology',
    );

    _instrumentUpdatesController.add(mockInstrument);
  }

  /// Get company name for symbol (mock data)
  static String _getCompanyName(String symbol) {
    const names = {
      'AAPL': 'Apple Inc.',
      'GOOGL': 'Alphabet Inc.',
      'MSFT': 'Microsoft Corp.',
      'TSLA': 'Tesla Inc.',
      'AMZN': 'Amazon.com Inc.',
    };
    return names[symbol] ?? '$symbol Company';
  }

  /// Dispose of the service
  static void dispose() {
    disconnect();
    _instrumentUpdatesController.close();
    _marketDataController.close();
    _connectionStatusController.close();
    _isInitialized = false;
    debugPrint('Real-time service disposed');
  }

  /// Force reconnection
  static void forceReconnect() {
    _reconnectAttempts = 0;
    disconnect().then((_) => connect());
  }

  /// Get connection statistics
  static Map<String, dynamic> getConnectionStats() {
    return {
      'isConnected': _isConnected,
      'isInitialized': _isInitialized,
      'reconnectAttempts': _reconnectAttempts,
      'maxReconnectAttempts': _maxReconnectAttempts,
    };
  }
}

/// Connection status enum
enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
  failed,
}