// lib/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../data/datasources/local/local_storage.dart';
import '../providers/theme_provider.dart';

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
    
    _animationController = AnimationController(
      duration: AppConstants.longAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Start animations
    _animationController.forward();

    // Initialize app components
    await Future.wait([
      _loadTheme(),
      _loadUserData(),
      _initializeServices(),
      Future.delayed(const Duration(seconds: 2)), // Minimum splash time
    ]);

    // Navigate to main page
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppConstants.mainRoute);
    }
  }

  Future<void> _loadTheme() async {
    final themeProvider = context.read<ThemeProvider>();
    if (!themeProvider.isInitialized) {
      // Theme will be loaded in ThemeProvider constructor
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _loadUserData() async {
    try {
      // Load user preferences and cached data
      final hasData = LocalStorage.containsKey(AppConstants.userPreferencesKey);
      if (hasData) {
        debugPrint('User data loaded from cache');
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _initializeServices() async {
    try {
      // Services are already initialized in main.dart
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('Services initialized');
    } catch (e) {
      debugPrint('Error initializing services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                
                // App logo and title
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            // App icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.trending_up,
                                size: 60,
                                color: colorScheme.primary,
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // App name
                            Text(
                              AppConstants.appName,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // App description
                            Text(
                              AppConstants.appDescription,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onPrimary.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const Spacer(flex: 2),
                
                // Loading indicator
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Text(
                            'Cargando datos del mercado...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Version info
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'v${AppConstants.appVersion}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary.withOpacity(0.6),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}