// lib/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../services/navigation_service.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../providers/market_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/favorites_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for theme to initialize
      final themeProvider = context.read<ThemeProvider>();
      if (!themeProvider.isInitialized) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Initialize providers in parallel
      await Future.wait([
        _initializeUser(),
        _initializeMarketData(),
        _initializePortfolio(),
        _initializeFavorites(),
        Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
      ]);

      // Navigate to main page
      if (mounted) {
        NavigationService.pushReplacementNamed(AppConstants.mainRoute);
      }
    } catch (error) {
      debugPrint('Error during app initialization: $error');
      _handleInitializationError();
    }
  }

  Future<void> _initializeUser() async {
    try {
      final userProvider = context.read<UserProvider>();
      await userProvider.initializeUser();
    } catch (e) {
      debugPrint('Error initializing user: $e');
    }
  }

  Future<void> _initializeMarketData() async {
    try {
      final marketProvider = context.read<MarketProvider>();
      await marketProvider.loadInitialData();
    } catch (e) {
      debugPrint('Error initializing market data: $e');
    }
  }

  Future<void> _initializePortfolio() async {
    try {
      final portfolioProvider = context.read<PortfolioProvider>();
      await portfolioProvider.loadPortfolio();
    } catch (e) {
      debugPrint('Error initializing portfolio: $e');
    }
  }

  Future<void> _initializeFavorites() async {
    try {
      final favoritesProvider = context.read<FavoritesProvider>();
      await favoritesProvider.loadFavorites();
    } catch (e) {
      debugPrint('Error initializing favorites: $e');
    }
  }

  void _handleInitializationError() {
    // Show error dialog or navigate to error page
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: const Text(
          'There was an error starting the app. Please check your connection and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp(); // Retry initialization
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.background,
              colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.trending_up,
                          size: 60,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // App Name
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // App Description
                      Text(
                        AppConstants.appDescription,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Loading Indicator
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Loading Text
                      Text(
                        'Cargando datos del mercado...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}