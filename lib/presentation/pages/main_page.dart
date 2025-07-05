// lib/presentation/pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../providers/theme_provider.dart';
import 'market/market_page.dart';
import 'portfolio/portfolio_page.dart';
import 'favorites/favorites_page.dart';
import 'settings/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    MarketPage(),
    PortfolioPage(),
    FavoritesPage(),
    SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.candlestick_chart),
      activeIcon: Icon(Icons.candlestick_chart),
      label: 'Mercados',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.pie_chart_outline),
      activeIcon: Icon(Icons.pie_chart),
      label: 'Portafolio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star_outline),
      activeIcon: Icon(Icons.star),
      label: 'Favoritos',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      activeIcon: Icon(Icons.settings),
      label: 'Configuración',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: AppConstants.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
          selectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: theme.textTheme.labelMedium,
          elevation: 0,
          items: _bottomNavItems,
        ),
      ),
    );
  }
}