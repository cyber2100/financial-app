// lib/core/themes/light_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme_constants.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ThemeConstants.primaryBlue,
        onPrimary: Colors.white,
        secondary: ThemeConstants.gray500,
        onSecondary: Colors.white,
        error: ThemeConstants.accentRed,
        onError: Colors.white,
        background: ThemeConstants.gray50,
        onBackground: ThemeConstants.gray900,
        surface: Colors.white,
        onSurface: ThemeConstants.gray700,
        surfaceVariant: ThemeConstants.gray100,
        onSurfaceVariant: ThemeConstants.gray600,
        outline: ThemeConstants.gray300,
      ),
      
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: ThemeConstants.gray700,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        centerTitle: false,
      ),
      
      cardTheme: CardTheme(
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
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