// lib/utils/formatters.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 1,
  );

  static final NumberFormat _percentFormat = NumberFormat.percentPattern();

  /// Format currency with full precision
  static String format(double value) {
    return _currencyFormat.format(value);
  }

  /// Format currency in compact form (e.g., $1.2K, $1.5M)
  static String formatCompact(double value) {
    if (value.abs() < 1000) {
      return format(value);
    }
    return _compactCurrencyFormat.format(value);
  }

  /// Format percentage
  static String formatPercent(double value) {
    return _percentFormat.format(value / 100);
  }

  /// Format percentage with + sign for positive values
  static String formatPercentWithSign(double value) {
    final formatted = formatPercent(value);
    return value > 0 ? '+$formatted' : formatted;
  }

  /// Format volume (e.g., 1.2M, 543.2K)
  static String formatVolume(int volume) {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toString();
  }

  /// Format price change with + sign for positive values
  static String formatPriceChange(double change) {
    final formatted = format(change.abs());
    return change >= 0 ? '+$formatted' : '-$formatted';
  }
}

// lib/utils/date_formatter.dart
class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _shortDateFormat = DateFormat('MMM dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');

  /// Format date (e.g., "Jan 15, 2024")
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format date in short form (e.g., "Jan 15")
  static String formatDateShort(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format time (e.g., "14:30")
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Format date and time (e.g., "Jan 15, 2024 14:30")
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "Yesterday")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date);
    }
  }

  /// Get market session based on current time
  static String getMarketSession() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 9 && hour < 16) {
      return 'Market Open';
    } else if (hour >= 16 && hour < 20) {
      return 'After Hours';
    } else if (hour >= 4 && hour < 9) {
      return 'Pre Market';
    } else {
      return 'Market Closed';
    }
  }

  /// Check if market is currently open (simplified)
  static bool isMarketOpen() {
    final now = DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday;

    // Weekend check
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return false;
    }

    // Market hours: 9:30 AM to 4:00 PM EST (simplified)
    return hour >= 9 && hour < 16;
  }
}

// lib/utils/validators.dart
class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (value.length > 50) {
      return 'Password must be less than 50 characters';
    }

    return null;
  }

  /// Validate quantity for investment
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final quantity = double.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid number';
    }

    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }

    if (quantity > 1000000) {
      return 'Quantity seems too large';
    }

    return null;
  }

  /// Validate price for investment
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price <= 0) {
      return 'Price must be greater than 0';
    }

    if (price > 1000000) {
      return 'Price seems too high';
    }

    return null;
  }

  /// Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 30) {
      return 'Username must be less than 30 characters';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) {
      return 'Phone number must have at least 10 digits';
    }

    return null;
  }

  /// Validate investment amount
  static String? validateInvestmentAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Investment amount is required';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount < 0.01) {
      return 'Minimum investment is \$0.01';
    }

    if (amount > 10000000) {
      return 'Maximum investment is \$10,000,000';
    }

    return null;
  }

  /// Validate symbol (stock ticker)
  static String? validateSymbol(String? value) {
    if (value == null || value.isEmpty) {
      return 'Symbol is required';
    }

    final symbol = value.toUpperCase();
    
    if (symbol.length < 1 || symbol.length > 5) {
      return 'Symbol must be 1-5 characters';
    }

    final symbolRegex = RegExp(r'^[A-Z]+$');
    if (!symbolRegex.hasMatch(symbol)) {
      return 'Symbol can only contain letters';
    }

    return null;
  }

  /// Validate percentage
  static String? validatePercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Percentage is required';
    }

    final percentage = double.tryParse(value);
    if (percentage == null) {
      return 'Please enter a valid percentage';
    }

    if (percentage < 0 || percentage > 100) {
      return 'Percentage must be between 0 and 100';
    }

    return null;
  }
}

// lib/utils/calculations.dart
class PortfolioCalculations {
  /// Calculate portfolio total value
  static double calculateTotalValue(List<dynamic> portfolioItems) {
    return portfolioItems.fold(0.0, (sum, item) => sum + item.currentValue);
  }

  /// Calculate portfolio total cost
  static double calculateTotalCost(List<dynamic> portfolioItems) {
    return portfolioItems.fold(0.0, (sum, item) => sum + item.totalCost);
  }

  /// Calculate total gain/loss
  static double calculateTotalGainLoss(double totalValue, double totalCost) {
    return totalValue - totalCost;
  }

  /// Calculate total gain/loss percentage
  static double calculateTotalGainLossPercent(double totalValue, double totalCost) {
    if (totalCost == 0) return 0.0;
    return ((totalValue - totalCost) / totalCost) * 100;
  }

  /// Calculate position weight in portfolio
  static double calculatePositionWeight(double positionValue, double totalPortfolioValue) {
    if (totalPortfolioValue == 0) return 0.0;
    return (positionValue / totalPortfolioValue) * 100;
  }

  /// Calculate average cost after adding shares
  static double calculateNewAverageCost({
    required double currentShares,
    required double currentAvgCost,
    required double newShares,
    required double newPrice,
  }) {
    if (currentShares == 0) return newPrice;
    
    final totalValue = (currentShares * currentAvgCost) + (newShares * newPrice);
    final totalShares = currentShares + newShares;
    
    return totalValue / totalShares;
  }

  /// Calculate position gain/loss
  static Map<String, double> calculatePositionProfitLoss({
    required double currentPrice,
    required double averageCost,
    required double quantity,
  }) {
    final currentValue = currentPrice * quantity;
    final totalCost = averageCost * quantity;
    final gainLoss = currentValue - totalCost;
    final gainLossPercent = totalCost > 0 ? (gainLoss / totalCost) * 100 : 0.0;

    return {
      'currentValue': currentValue,
      'totalCost': totalCost,
      'gainLoss': gainLoss,
      'gainLossPercent': gainLossPercent,
    };
  }

  /// Calculate risk metrics
  static Map<String, double> calculateRiskMetrics(List<double> returns) {
    if (returns.isEmpty) {
      return {
        'volatility': 0.0,
        'sharpeRatio': 0.0,
        'maxDrawdown': 0.0,
      };
    }

    // Calculate average return
    final avgReturn = returns.reduce((a, b) => a + b) / returns.length;

    // Calculate volatility (standard deviation)
    final variance = returns.map((r) => (r - avgReturn) * (r - avgReturn))
        .reduce((a, b) => a + b) / returns.length;
    final volatility = variance > 0 ? variance.sqrt() : 0.0;

    // Calculate Sharpe ratio (simplified, assuming risk-free rate = 0)
    final sharpeRatio = volatility > 0 ? avgReturn / volatility : 0.0;

    // Calculate maximum drawdown
    double maxDrawdown = 0.0;
    double peak = returns.first;
    
    for (final returnValue in returns) {
      if (returnValue > peak) {
        peak = returnValue;
      } else {
        final drawdown = (peak - returnValue) / peak;
        if (drawdown > maxDrawdown) {
          maxDrawdown = drawdown;
        }
      }
    }

    return {
      'volatility': volatility * 100, // Convert to percentage
      'sharpeRatio': sharpeRatio,
      'maxDrawdown': maxDrawdown * 100, // Convert to percentage
    };
  }

  /// Calculate compound annual growth rate (CAGR)
  static double calculateCAGR({
    required double beginningValue,
    required double endingValue,
    required double years,
  }) {
    if (beginningValue <= 0 || years <= 0) return 0.0;
    
    return ((endingValue / beginningValue).pow(1 / years) - 1) * 100;
  }
}

// Extension methods for mathematical operations
extension MathExtensions on double {
  double sqrt() => math.sqrt(this);
  double pow(double exponent) => math.pow(this, exponent).toDouble();
}

// Required import for math operations
import 'dart:math' as math;