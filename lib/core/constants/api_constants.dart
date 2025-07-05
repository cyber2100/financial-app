// lib/core/constants/api_constants.dart
class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.financialapp.com/v1';
  static const String websocketUrl = 'wss://ws.financialapp.com';
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  
  static const String marketDataEndpoint = '/market';
  static const String instrumentsEndpoint = '/market/instruments';
  static const String instrumentDetailEndpoint = '/market/instruments/';
  static const String topGainersEndpoint = '/market/gainers';
  static const String topLosersEndpoint = '/market/losers';
  static const String mostActiveEndpoint = '/market/most-active';
  
  static const String portfolioEndpoint = '/portfolio';
  static const String addPositionEndpoint = '/portfolio/positions';
  static const String updatePositionEndpoint = '/portfolio/positions/';
  static const String deletePositionEndpoint = '/portfolio/positions/';
  static const String portfolioSummaryEndpoint = '/portfolio/summary';
  
  static const String userEndpoint = '/user';
  static const String userProfileEndpoint = '/user/profile';
  static const String userPreferencesEndpoint = '/user/preferences';
  static const String userFavoritesEndpoint = '/user/favorites';
  
  static const String newsEndpoint = '/news';
  static const String marketNewsEndpoint = '/news/market';
  static const String instrumentNewsEndpoint = '/news/instruments/';
  
  // API Keys and Headers
  static const String apiKeyHeader = 'X-API-Key';
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  
  // Content Types
  static const String jsonContentType = 'application/json';
  static const String formDataContentType = 'multipart/form-data';
  
  // Timeout values
  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int sendTimeoutSeconds = 30;
  
  // Rate limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxRequestsPerHour = 1000;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const String pageQueryParam = 'page';
  static const String limitQueryParam = 'limit';
  static const String offsetQueryParam = 'offset';
  
  // Sorting and filtering
  static const String sortByQueryParam = 'sort_by';
  static const String sortOrderQueryParam = 'sort_order';
  static const String filterQueryParam = 'filter';
  static const String searchQueryParam = 'search';
  
  // WebSocket channels
  static const String marketDataChannel = 'market_data';
  static const String priceUpdatesChannel = 'price_updates';
  static const String portfolioUpdatesChannel = 'portfolio_updates';
  static const String newsChannel = 'news';
  
  // Error codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int conflictCode = 409;
  static const int tooManyRequestsCode = 429;
  static const int internalServerErrorCode = 500;
  static const int serviceUnavailableCode = 503;
  
  // Cache durations (in minutes)
  static const int marketDataCacheDuration = 1;
  static const int instrumentDetailCacheDuration = 5;
  static const int portfolioCacheDuration = 10;
  static const int newsCacheDuration = 30;
  static const int userProfileCacheDuration = 60;
  
  // Data sources
  static const String alphaVantageSource = 'alpha_vantage';
  static const String yahooFinanceSource = 'yahoo_finance';
  static const String iexCloudSource = 'iex_cloud';
  static const String finnhubSource = 'finnhub';
  
  // Market status
  static const String marketOpenStatus = 'open';
  static const String marketClosedStatus = 'closed';
  static const String preMarketStatus = 'pre_market';
  static const String afterHoursStatus = 'after_hours';
  
  // Currency codes
  static const String usdCurrency = 'USD';
  static const String eurCurrency = 'EUR';
  static const String gbpCurrency = 'GBP';
  static const String jpyCurrency = 'JPY';
  
  // Instrument types
  static const String stockType = 'stock';
  static const String etfType = 'etf';
  static const String bondType = 'bond';
  static const String mutualFundType = 'mutual_fund';
  static const String cryptoType = 'crypto';
  
  // Market exchanges
  static const String nasdaqExchange = 'NASDAQ';
  static const String nyseExchange = 'NYSE';
  static const String amexExchange = 'AMEX';
  static const String otcExchange = 'OTC';
  
  // Transaction types
  static const String buyTransaction = 'buy';
  static const String sellTransaction = 'sell';
  static const String dividendTransaction = 'dividend';
  static const String splitTransaction = 'split';
  static const String mergerTransaction = 'merger';
}