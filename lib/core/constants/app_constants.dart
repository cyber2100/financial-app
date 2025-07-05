// lib/core/constants/app_constants.dart
class AppConstants {
  // App Information
  static const String appName = 'Financial Portfolio';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Gestión de portafolio financiero';
  
  // Route Names
  static const String splashRoute = '/splash';
  static const String mainRoute = '/main';
  static const String marketRoute = '/market';
  static const String portfolioRoute = '/portfolio';
  static const String favoritesRoute = '/favorites';
  static const String settingsRoute = '/settings';
  static const String instrumentDetailRoute = '/instrument-detail';
  static const String addToPortfolioRoute = '/add-to-portfolio';
  
  // API Configuration
  static const String baseUrl = 'https://api.financialapp.com/v1';
  static const String websocketUrl = 'wss://ws.financialapp.com';
  static const int apiTimeoutSeconds = 30;
  static const int websocketReconnectDelay = 5;
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userTokenKey = 'user_token';
  static const String favoritesKey = 'favorites';
  static const String portfolioKey = 'portfolio';
  static const String userPreferencesKey = 'user_preferences';
  static const String lastSyncKey = 'last_sync';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Update Intervals
  static const Duration realTimeUpdateInterval = Duration(seconds: 3);
  static const Duration portfolioUpdateInterval = Duration(seconds: 10);
  static const Duration cacheValidityDuration = Duration(minutes: 5);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Chart Configuration
  static const int miniChartDataPoints = 12;
  static const double chartStrokeWidth = 1.5;
  static const Duration chartAnimationDuration = Duration(milliseconds: 1000);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Financial Constants
  static const int priceDecimalPlaces = 2;
  static const int percentageDecimalPlaces = 2;
  static const int volumeDecimalPlaces = 0;
  
  // Filter Options
  static const List<String> instrumentTypes = [
    'All',
    'Stocks',
    'ETFs',
    'Bonds',
    'Mutual Funds',
  ];
  
  static const List<String> markets = [
    'All',
    'NASDAQ',
    'NYSE',
    'AMEX',
    'OTC',
  ];
  
  static const List<String> sectors = [
    'All',
    'Technology',
    'Healthcare',
    'Financial Services',
    'Consumer Discretionary',
    'Communication Services',
    'Industrials',
    'Consumer Staples',
    'Energy',
    'Utilities',
    'Real Estate',
    'Materials',
  ];
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String noDataMessage = 'No data available.';
  static const String loadingMessage = 'Loading...';
  
  // Success Messages
  static const String portfolioAddedMessage = 'Added to portfolio successfully';
  static const String favoritesAddedMessage = 'Added to favorites';
  static const String favoritesRemovedMessage = 'Removed from favorites';
  static const String settingsSavedMessage = 'Settings saved successfully';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  
  // Chart Colors
  static const List<String> chartColorPalette = [
    '#3b82f6', // Blue
    '#10b981', // Green
    '#f59e0b', // Yellow
    '#ef4444', // Red
    '#8b5cf6', // Purple
    '#06b6d4', // Cyan
    '#f97316', // Orange
    '#84cc16', // Lime
    '#ec4899', // Pink
    '#6366f1', // Indigo
  ];
}