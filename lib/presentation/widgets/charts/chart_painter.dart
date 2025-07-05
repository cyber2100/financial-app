// lib/presentation/widgets/charts/chart_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;
  final double strokeWidth;
  final bool showFill;

  ChartPainter({
    required this.dataPoints,
    required this.lineColor,
    required this.fillColor,
    this.strokeWidth = 2.0,
    this.showFill = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Calculate dimensions
    final double stepX = size.width / (dataPoints.length - 1);
    final double minY = dataPoints.reduce(math.min);
    final double maxY = dataPoints.reduce(math.max);
    final double range = maxY - minY;

    // Create path
    for (int i = 0; i < dataPoints.length; i++) {
      final double x = i * stepX;
      final double y = size.height - ((dataPoints[i] - minY) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        if (showFill) {
          fillPath.moveTo(x, size.height);
          fillPath.lineTo(x, y);
        }
      } else {
        path.lineTo(x, y);
        if (showFill) {
          fillPath.lineTo(x, y);
        }
      }
    }

    // Complete fill path
    if (showFill) {
      fillPath.lineTo(size.width, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
           oldDelegate.lineColor != lineColor ||
           oldDelegate.fillColor != fillColor ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.showFill != showFill;
  }
}