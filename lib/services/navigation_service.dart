// lib/services/navigation_service.dart
import 'package:flutter/material.dart';

/// Navigation service for handling app-wide navigation
/// This allows navigation from anywhere in the app without needing BuildContext
class NavigationService {
  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // Get the current navigator state
  static NavigatorState? get _navigator => navigatorKey.currentState;
  
  // Get the current context
  static BuildContext? get context => navigatorKey.currentContext;

  /// Navigate to a named route
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Navigate to a named route and remove all previous routes
  static Future<T?> pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Replace the current route with a named route
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return _navigator!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate back to previous route
  static void pop<T extends Object?>([T? result]) {
    return _navigator!.pop<T>(result);
  }

  /// Navigate back until a specific route
  static void popUntil(String routeName) {
    return _navigator!.popUntil(ModalRoute.withName(routeName));
  }

  /// Check if we can pop (go back)
  static bool canPop() {
    return _navigator!.canPop();
  }

  /// Navigate back and then push a new named route
  static Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return _navigator!.popAndPushNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Push a page widget directly (without named routes)
  static Future<T?> push<T extends Object?>(
    Widget page, {
    bool fullscreenDialog = false,
    RouteSettings? settings,
  }) {
    return _navigator!.push<T>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        fullscreenDialog: fullscreenDialog,
        settings: settings,
      ),
    );
  }

  /// Replace current route with a page widget
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    bool fullscreenDialog = false,
    RouteSettings? settings,
    TO? result,
  }) {
    return _navigator!.pushReplacement<T, TO>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        fullscreenDialog: fullscreenDialog,
        settings: settings,
      ),
      result: result,
    );
  }

  /// Show a dialog
  static Future<T?> showDialogWidget<T>(
    Widget dialog, {
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return showDialog<T>(
      context: context!,
      builder: (_) => dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
    );
  }

  /// Show a modal bottom sheet
  static Future<T?> showBottomSheetWidget<T>(
    Widget bottomSheet, {
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context!,
      builder: (_) => bottomSheet,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
    );
  }

  /// Show a snack bar
  static void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context!);
    
    // Clear any existing snack bars
    scaffoldMessenger.clearSnackBars();
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show success snack bar
  static void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show error snack bar
  static void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  /// Show warning snack bar
  static void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Show info snack bar
  static void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  /// Get current route name
  static String? get currentRouteName {
    String? routeName;
    _navigator!.popUntil((route) {
      routeName = route.settings.name;
      return true;
    });
    return routeName;
  }

  /// Check if a specific route is currently active
  static bool isCurrentRoute(String routeName) {
    return currentRouteName == routeName;
  }

  /// Navigate to route and remove all routes until predicate is true
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return _navigator!.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  /// Navigate with custom page transition
  static Future<T?> pushWithCustomTransition<T extends Object?>(
    Widget page, {
    RouteTransitionsBuilder? transitionsBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    bool fullscreenDialog = false,
  }) {
    return _navigator!.push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: transitionDuration,
        transitionsBuilder: transitionsBuilder ??
            (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  /// Navigate with fade transition
  static Future<T?> pushWithFadeTransition<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return pushWithCustomTransition<T>(
      page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Navigate with slide transition from bottom
  static Future<T?> pushWithSlideFromBottomTransition<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return pushWithCustomTransition<T>(
      page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}