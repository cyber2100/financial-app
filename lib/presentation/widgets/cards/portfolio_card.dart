
// lib/presentation/widgets/cards/portfolio_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/portfolio_item_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

class PortfolioCard extends StatelessWidget {
  final PortfolioItemModel position;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final bool compact;

  const PortfolioCard({
    super.key,
    required this.position,
    this.onTap,
    this.onEdit,
    this.onRemove,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding / 2,
      ),
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              // Header row
              Row(
                children: [
                  // Position icon
                  _buildPositionIcon(colorScheme),
                  const SizedBox(width: 12),
                  
                  // Symbol and name
                  Expanded(
                    child: _buildPositionInfo(theme, colorScheme),
                  ),
                  
                  // Actions menu
                  _buildActionsMenu(colorScheme),
                ],
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Position details
              Row(
                children: [
                  // Quantity and average cost
                  Expanded(
                    child: _buildQuantityInfo(theme, colorScheme),
                  ),
                  
                  // Current value and change
                  Expanded(
                    child: _buildValueInfo(theme),
                  ),
                ],
              ),
              
              if (!compact) ...[
                const SizedBox(height: 12),
                _buildPerformanceBar(colorScheme),
                
                const SizedBox(height: 12),
                _buildAdditionalMetrics(theme, colorScheme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionIcon(ColorScheme colorScheme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: position.isProfitable 
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: position.isProfitable 
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          position.symbol.length >= 2 
              ? position.symbol.substring(0, 2).toUpperCase()
              : position.symbol.toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: position.isProfitable ? Colors.green[700] : Colors.red[700],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionInfo(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              position.symbol,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: position.isProfitable 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                position.isProfitable ? 'GANANCIA' : 'PÉRDIDA',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: position.isProfitable ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          position.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionsMenu(ColorScheme colorScheme) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'remove':
            onRemove?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'remove',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Eliminar', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        color: colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  Widget _buildQuantityInfo(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cantidad',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          '${position.quantity.toStringAsFixed(position.quantity.truncateToDouble() == position.quantity ? 0 : 2)} acciones',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Costo Promedio',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          CurrencyFormatter.format(position.averageCost),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildValueInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          CurrencyFormatter.format(position.currentValue),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          CurrencyFormatter.formatPriceChange(position.gainLoss),
          style: theme.textTheme.titleMedium?.copyWith(
            color: position.isProfitable ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '(${CurrencyFormatter.formatPercentWithSign(position.gainLossPercent)})',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: position.isProfitable ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceBar(ColorScheme colorScheme) {
    final performance = position.gainLossPercent;
    final isPositive = performance >= 0;
    final barWidth = (performance.abs() / 100).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rendimiento',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              '${performance.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: barWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalMetrics(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricItem(
            'Precio Actual',
            CurrencyFormatter.format(position.currentPrice),
            theme,
            colorScheme,
          ),
        ),
        Expanded(
          child: _buildMetricItem(
            'Inversión Total',
            CurrencyFormatter.format(position.totalCost),
            theme,
            colorScheme,
          ),
        ),
        Expanded(
          child: _buildMetricItem(
            'Actualizado',
            _formatLastUpdated(position.lastUpdated),
            theme,
            colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }
}