// lib/core/themes/dark_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme_constants.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ThemeConstants.primaryBlue,
        onPrimary: Colors.white,
        secondary: ThemeConstants.gray400,
        onSecondary: ThemeConstants.gray900,
        error: ThemeConstants.accentRed,
        onError: Colors.white,
        background: ThemeConstants.gray900,
        onBackground: ThemeConstants.gray50,
        surface: ThemeConstants.gray800,
        onSurface: ThemeConstants.gray200,
        surfaceVariant: ThemeConstants.gray700,
        onSurfaceVariant: ThemeConstants.gray300,
        outline: ThemeConstants.gray600,
      ),
      
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: ThemeConstants.gray800,
        foregroundColor: ThemeConstants.gray200,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        centerTitle: false,
      ),
      
      cardTheme: CardTheme(
        elevation: 2,
        color: ThemeConstants.gray800,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}