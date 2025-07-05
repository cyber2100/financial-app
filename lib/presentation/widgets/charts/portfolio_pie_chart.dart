// lib/presentation/widgets/charts/portfolio_pie_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/portfolio_item_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

class PortfolioPieChart extends StatefulWidget {
  final List<PortfolioItemModel> portfolio;
  final double? size;

  const PortfolioPieChart({
    super.key,
    required this.portfolio,
    this.size,
  });

  @override
  State<PortfolioPieChart> createState() => _PortfolioPieChartState();
}

class _PortfolioPieChartState extends State<PortfolioPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.portfolio.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay datos para mostrar',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        // Pie chart
        Expanded(
          flex: 3,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _generateSections(),
              ),
            ),
          ),
        ),
        
        // Legend
        Expanded(
          flex: 2,
          child: _buildLegend(theme, colorScheme),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    final totalValue = widget.portfolio.fold<double>(
      0.0,
      (sum, position) => sum + position.currentValue,
    );

    return widget.portfolio.asMap().entries.map((entry) {
      final index = entry.key;
      final position = entry.value;
      final percentage = (position.currentValue / totalValue) * 100;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 65.0 : 55.0;
      
      return PieChartSectionData(
        color: _getColorForIndex(index),
        value: percentage,
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        borderSide: isTouched
            ? const BorderSide(color: Colors.white, width: 2)
            : BorderSide.none,
      );
    }).toList();
  }

  Widget _buildLegend(ThemeData theme, ColorScheme colorScheme) {
    final totalValue = widget.portfolio.fold<double>(
      0.0,
      (sum, position) => sum + position.currentValue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.portfolio.asMap().entries.map((entry) {
        final index = entry.key;
        final position = entry.value;
        final percentage = (position.currentValue / totalValue) * 100;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getColorForIndex(index),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.symbol,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}% • ${CurrencyFormatter.format(position.currentValue)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.lime,
    ];
    
    return colors[index % colors.length];
  }
}