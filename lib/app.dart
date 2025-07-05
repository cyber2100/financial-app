// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core imports
import 'core/themes/app_theme.dart';
import 'core/constants/app_constants.dart';

// Services imports
import 'services/navigation_service.dart';

// Providers imports
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/market_provider.dart';
import 'presentation/providers/portfolio_provider.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/providers/user_provider.dart';

// Pages imports
import 'presentation/pages/main_page.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/market/market_page.dart';
import 'presentation/pages/portfolio/portfolio_page.dart';
import 'presentation/pages/favorites/favorites_page.dart';
import 'presentation/pages/settings/settings_page.dart';

// Data layer imports
import 'data/repositories/market_repository_impl.dart';
import 'data/repositories/portfolio_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/datasources/remote/market_api.dart';
import 'data/datasources/remote/portfolio_api.dart';
import 'data/datasources/remote/auth_api.dart';
import 'data/datasources/local/local_storage.dart';
import 'data/datasources/local/cache_manager.dart';

class FinancialApp extends StatelessWidget {
  const FinancialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _buildProviders(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            // App configuration
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            
            // Navigation configuration
            navigatorKey: NavigationService.navigatorKey,
            onGenerateRoute: _generateRoute,
            initialRoute: AppConstants.splashRoute,
            
            // Localization configuration
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('es', 'ES'), // Spanish
              Locale('pt', 'BR'), // Portuguese
            ],
            
            // App builder for global configurations
            builder: (context, child) {
              return MediaQuery(
                // Prevent system font scaling to maintain UI consistency
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  /// Build all providers for dependency injection
  List<ChangeNotifierProvider> _buildProviders() {
    return [
      // Core providers
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
      ),
      
      // Data source providers (these would be implemented as singletons)
      ChangeNotifierProvider<MarketApiProvider>(
        create: (_) => MarketApiProvider(),
      ),
      ChangeNotifierProvider<PortfolioApiProvider>(
        create: (_) => PortfolioApiProvider(),
      ),
      ChangeNotifierProvider<AuthApiProvider>(
        create: (_) => AuthApiProvider(),
      ),
      ChangeNotifierProvider<LocalStorageProvider>(
        create: (_) => LocalStorageProvider(),
      ),
      ChangeNotifierProvider<CacheManagerProvider>(
        create: (_) => CacheManagerProvider(),
      ),
      
      // Repository providers
      ChangeNotifierProxyProvider5<MarketApiProvider, LocalStorageProvider, 
          CacheManagerProvider, ThemeProvider, UserProvider, MarketProvider>(
        create: (context) => MarketProvider(),
        update: (context, marketApi, localStorage, cacheManager, theme, user, previous) =>
            previous ?? MarketProvider()
              ..initialize(
                marketApi: marketApi,
                localStorage: localStorage,
                cacheManager: cacheManager,
              ),
      ),
      
      ChangeNotifierProxyProvider3<PortfolioApiProvider, LocalStorageProvider, 
          UserProvider, PortfolioProvider>(
        create: (context) => PortfolioProvider(),
        update: (context, portfolioApi, localStorage, user, previous) =>
            previous ?? PortfolioProvider()
              ..initialize(
                portfolioApi: portfolioApi,
                localStorage: localStorage,
                user: user,
              ),
      ),
      
      ChangeNotifierProxyProvider<LocalStorageProvider, FavoritesProvider>(
        create: (context) => FavoritesProvider(),
        update: (context, localStorage, previous) =>
            previous ?? FavoritesProvider()
              ..initialize(localStorage: localStorage),
      ),
      
      ChangeNotifierProxyProvider2<AuthApiProvider, LocalStorageProvider, UserProvider>(
        create: (context) => UserProvider(),
        update: (context, authApi, localStorage, previous) =>
            previous ?? UserProvider()
              ..initialize(
                authApi: authApi,
                localStorage: localStorage,
              ),
      ),
    ];
  }

  /// Generate routes for navigation
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash route
      case AppConstants.splashRoute:
        return _buildRoute(
          const SplashPage(),
          settings,
          isFullscreenDialog: true,
        );
      
      // Main application routes
      case AppConstants.mainRoute:
        return _buildRoute(const MainPage(), settings);
      
      // Individual page routes (can be used for deep linking)
      case AppConstants.marketRoute:
        return _buildRoute(const MarketPage(), settings);
      
      case AppConstants.portfolioRoute:
        return _buildRoute(const PortfolioPage(), settings);
      
      case AppConstants.favoritesRoute:
        return _buildRoute(const FavoritesPage(), settings);
      
      case AppConstants.settingsRoute:
        return _buildRoute(const SettingsPage(), settings);
      
      // Instrument detail route with arguments
      case AppConstants.instrumentDetailRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args['instrumentId'] != null) {
          return _buildRoute(
            InstrumentDetailPage(instrumentId: args['instrumentId']),
            settings,
          );
        }
        return _buildNotFoundRoute(settings);
      
      // Add to portfolio route with arguments
      case AppConstants.addToPortfolioRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args['instrument'] != null) {
          return _buildRoute(
            AddToPortfolioPage(instrument: args['instrument']),
            settings,
            isFullscreenDialog: true,
          );
        }
        return _buildNotFoundRoute(settings);
      
      // Default case - 404 page
      default:
        return _buildNotFoundRoute(settings);
    }
  }

  /// Build a material page route with custom transitions
  Route<dynamic> _buildRoute(
    Widget page, 
    RouteSettings settings, {
    bool isFullscreenDialog = false,
  }) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      fullscreenDialog: isFullscreenDialog,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: AppConstants.mediumAnimationDuration,
      reverseTransitionDuration: AppConstants.shortAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Custom slide transition
        if (isFullscreenDialog) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        }
        
        // Fade transition for regular pages
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Build 404 not found route
  Route<dynamic> _buildNotFoundRoute(RouteSettings settings) {
    return _buildRoute(
      const NotFoundPage(),
      settings,
    );
  }
}

/// Provider wrappers for data sources (these would contain the actual implementations)
class MarketApiProvider extends ChangeNotifier {
  MarketApiImpl? _marketApi;
  
  MarketApiImpl get marketApi {
    _marketApi ??= MarketApiImpl();
    return _marketApi!;
  }
}

class PortfolioApiProvider extends ChangeNotifier {
  PortfolioApiImpl? _portfolioApi;
  
  PortfolioApiImpl get portfolioApi {
    _portfolioApi ??= PortfolioApiImpl();
    return _portfolioApi!;
  }
}

class AuthApiProvider extends ChangeNotifier {
  AuthApiImpl? _authApi;
  
  AuthApiImpl get authApi {
    _authApi ??= AuthApiImpl();
    return _authApi!;
  }
}

class LocalStorageProvider extends ChangeNotifier {
  LocalStorage? _localStorage;
  
  LocalStorage get localStorage {
    _localStorage ??= LocalStorage();
    return _localStorage!;
  }
}

class CacheManagerProvider extends ChangeNotifier {
  CacheManager? _cacheManager;
  
  CacheManager get cacheManager {
    _cacheManager ??= CacheManager();
    return _cacheManager!;
  }
}

/// 404 Not Found Page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página no encontrada'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: colorScheme.error,
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // 404 text
              Text(
                '404',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              
              const SizedBox(height: AppConstants.smallPadding),
              
              // Error message
              Text(
                'Página no encontrada',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.smallPadding),
              
              // Description
              Text(
                'La página que buscas no existe o ha sido movida.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Action buttons
              Column(
                children: [
                  // Go back button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        NavigationService.pushReplacementNamed(AppConstants.mainRoute);
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                  ),
                  
                  const SizedBox(height: AppConstants.smallPadding),
                  
                  // Go to home button
                  TextButton.icon(
                    onPressed: () {
                      NavigationService.pushReplacementNamed(AppConstants.mainRoute);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Ir al inicio'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder pages (these would be implemented in their respective files)
class InstrumentDetailPage extends StatelessWidget {
  final String instrumentId;
  
  const InstrumentDetailPage({
    super.key,
    required this.instrumentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Instrumento'),
      ),
      body: Center(
        child: Text('Instrumento ID: $instrumentId'),
      ),
    );
  }
}

/// Placeholder for Add to Portfolio page
class AddToPortfolioPage extends StatelessWidget {
  final dynamic instrument;
  
  const AddToPortfolioPage({
    super.key,
    required this.instrument,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar al Portafolio'),
      ),
      body: const Center(
        child: Text('Agregar al Portafolio'),
      ),
    );
  }
}