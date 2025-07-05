// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App import
import 'app.dart';

// Services imports
import 'services/notification_service.dart';
import 'services/real_time_service.dart';

// Data imports
import 'data/datasources/local/local_storage.dart';

/// Main entry point of the application
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize system settings and services
  await _initializeApp();
  
  // Run the app
  runApp(const FinancialApp());
}

/// Initialize all required app services and configurations
Future<void> _initializeApp() async {
  try {
    // Initialize system settings
    await _initializeSystemSettings();
    
    // Initialize core services
    await _initializeCoreServices();
    
    debugPrint('✅ App initialization completed successfully');
  } catch (e) {
    debugPrint('❌ Error during app initialization: $e');
    // Continue with app launch even if some services fail
  }
}

/// Configure system UI and device orientation
Future<void> _initializeSystemSettings() async {
  try {
    // Set preferred device orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Configure system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    
    debugPrint('✅ System settings initialized');
  } catch (e) {
    debugPrint('❌ Error initializing system settings: $e');
    rethrow;
  }
}

/// Initialize core application services
Future<void> _initializeCoreServices() async {
  try {
    // Initialize services in parallel for better performance
    await Future.wait([
      _initializeLocalStorage(),
      _initializeNotificationService(),
      _initializeSharedPreferences(),
    ]);
    
    // Initialize real-time service last (may depend on other services)
    _initializeRealTimeService();
    
    debugPrint('✅ Core services initialized');
  } catch (e) {
    debugPrint('❌ Error initializing core services: $e');
    rethrow;
  }
}

/// Initialize local storage (Hive and SharedPreferences)
Future<void> _initializeLocalStorage() async {
  try {
    await LocalStorage.initialize();
    debugPrint('✅ Local storage initialized');
  } catch (e) {
    debugPrint('❌ Error initializing local storage: $e');
    throw Exception('Failed to initialize local storage: $e');
  }
}

/// Initialize notification service for push notifications
Future<void> _initializeNotificationService() async {
  try {
    await NotificationService.initialize();
    
    // Request permissions for notifications (especially important on iOS)
    final hasPermission = await NotificationService.requestPermissions();
    if (hasPermission) {
      debugPrint('✅ Notification service initialized with permissions');
    } else {
      debugPrint('⚠️ Notification service initialized without permissions');
    }
  } catch (e) {
    debugPrint('❌ Error initializing notification service: $e');
    // Don't throw - notifications are not critical for app functionality
  }
}

/// Initialize SharedPreferences
Future<void> _initializeSharedPreferences() async {
  try {
    await SharedPreferences.getInstance();
    debugPrint('✅ SharedPreferences initialized');
  } catch (e) {
    debugPrint('❌ Error initializing SharedPreferences: $e');
    throw Exception('Failed to initialize SharedPreferences: $e');
  }
}

/// Initialize real-time service for market data updates
void _initializeRealTimeService() {
  try {
    RealTimeService.initialize();
    debugPrint('✅ Real-time service initialized');
  } catch (e) {
    debugPrint('❌ Error initializing real-time service: $e');
    // Don't throw - real-time updates are not critical for app functionality
  }
}

/// Handle uncaught errors in the app
void _handleUncaughtErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Uncaught Flutter error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('Uncaught platform error: $error');
    debugPrint('Stack trace: $stack');
    return true;
  };
}