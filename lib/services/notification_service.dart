// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Service for handling local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _isInitialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );
      
      _isInitialized = true;
      debugPrint('Notification service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  /// Handle notification response
  static void _onNotificationResponse(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle notification tap here
    // You can navigate to specific pages based on the payload
  }

  /// Request notification permissions (especially for iOS)
  static Future<bool> requestPermissions() async {
    if (!_isInitialized) await initialize();

    final bool? result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? false;
  }

  /// Show a simple notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'financial_app_channel',
      'Financial App Notifications',
      channelDescription: 'Notifications for financial app updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Show price alert notification
  static Future<void> showPriceAlert({
    required String symbol,
    required double price,
    required double targetPrice,
    required bool isAbove,
  }) async {
    final String title = 'Price Alert: $symbol';
    final String body = isAbove
        ? '$symbol has reached \$${price.toStringAsFixed(2)} (above target \$${targetPrice.toStringAsFixed(2)})'
        : '$symbol has dropped to \$${price.toStringAsFixed(2)} (below target \$${targetPrice.toStringAsFixed(2)})';

    await showNotification(
      id: symbol.hashCode,
      title: title,
      body: body,
      payload: 'price_alert:$symbol',
    );
  }

  /// Show portfolio update notification
  static Future<void> showPortfolioUpdate({
    required double totalValue,
    required double change,
    required double changePercent,
  }) async {
    final String title = 'Portfolio Update';
    final String changeText = change >= 0 ? '+' : '';
    final String body = 
        'Total: \$${totalValue.toStringAsFixed(2)} (${changeText}${change.toStringAsFixed(2)}, ${changeText}${changePercent.toStringAsFixed(2)}%)';

    await showNotification(
      id: 999, // Fixed ID for portfolio notifications
      title: title,
      body: body,
      payload: 'portfolio_update',
    );
  }

  /// Show market news notification
  static Future<void> showMarketNews({
    required String headline,
    required String summary,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Market News',
      body: headline,
      payload: 'market_news',
    );
  }

  /// Schedule a notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'financial_app_scheduled',
      'Scheduled Notifications',
      channelDescription: 'Scheduled notifications for financial app',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        _convertToTZDateTime(scheduledDate),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Cancel a notification
  static Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      debugPrint('Error canceling all notifications: $e');
    }
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Error getting pending notifications: $e');
      return [];
    }
  }

  /// Helper method to convert DateTime to TZDateTime
  static dynamic _convertToTZDateTime(DateTime dateTime) {
    // This would typically use timezone package
    // For now, returning the datetime as-is
    // In a real implementation, you'd use: tz.TZDateTime.from(dateTime, tz.local)
    return dateTime;
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (!_isInitialized) await initialize();

    // For Android
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }

    // For iOS, we assume they're enabled if we've initialized successfully
    return _isInitialized;
  }

  /// Open notification settings
  static Future<void> openNotificationSettings() async {
    if (!_isInitialized) await initialize();

    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      await androidImplementation.requestPermission();
    }
  }
}