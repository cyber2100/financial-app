// lib/presentation/widgets/charts/mini_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MiniChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color color;
  final double width;
  final double height;
  final bool showGradient;

  const MiniChart({
    super.key,
    required this.dataPoints,
    required this.color,
    this.width = 60,
    this.height = 30,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            Icons.show_chart,
            size: 16,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(),
              isCurved: true,
              color: color,
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: showGradient,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          minX: 0,
          maxX: (dataPoints.length - 1).toDouble(),
          minY: _getMinY(),
          maxY: _getMaxY(),
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    return dataPoints.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  double _getMinY() {
    if (dataPoints.isEmpty) return 0;
    final min = dataPoints.reduce((a, b) => a < b ? a : b);
    return min - (min * 0.1); // Add 10% padding
  }

  double _getMaxY() {
    if (dataPoints.isEmpty) return 100;
    final max = dataPoints.reduce((a, b) => a > b ? a : b);
    return max + (max * 0.1); // Add 10% padding
  }
}