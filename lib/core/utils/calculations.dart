// lib/core/utils/calculations.dart
import 'dart:math' as math;

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
    final volatility = variance > 0 ? math.sqrt(variance) : 0.0;

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
    
    return (math.pow(endingValue / beginningValue, 1 / years) - 1) * 100;
  }
}