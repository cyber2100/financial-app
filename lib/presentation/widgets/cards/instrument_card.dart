// lib/presentation/widgets/cards/instrument_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/instrument_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../dialogs/add_to_portfolio_dialog.dart';

class InstrumentCard extends StatelessWidget {
  final InstrumentModel instrument;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;
  final bool showAddButton;
  final bool compact;

  const InstrumentCard({
    super.key,
    required this.instrument,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
    this.showAddButton = true,
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
          padding: EdgeInsets.all(compact ? 12 : AppConstants.defaultPadding),
          child: compact ? _buildCompactContent(theme, colorScheme) 
                        : _buildFullContent(theme, colorScheme),
        ),
      ),
    );
  }

  Widget _buildFullContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Header row
        Row(
          children: [
            // Company logo/icon
            _buildCompanyIcon(colorScheme),
            const SizedBox(width: 12),
            
            // Symbol and name
            Expanded(
              child: _buildCompanyInfo(theme, colorScheme),
            ),
            
            // Action buttons
            _buildActionButtons(colorScheme),
          ],
        ),
        
        const SizedBox(height: AppConstants.defaultPadding),
        
        // Price information row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Current price and market info
            Expanded(
              child: _buildPriceInfo(theme, colorScheme),
            ),
            
            // Mini chart placeholder
            _buildMiniChart(),
            
            const SizedBox(width: 12),
            
            // Price change
            _buildPriceChange(theme),
          ],
        ),
        
        // Additional info (market hours, volume, etc.)
        if (!compact) ...[
          const SizedBox(height: 12),
          _buildAdditionalInfo(theme, colorScheme),
        ],
      ],
    );
  }

  Widget _buildCompactContent(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        // Company icon (smaller)
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getTypeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              instrument.symbol.substring(0, 1),
              style: theme.textTheme.labelLarge?.copyWith(
                color: _getTypeColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Symbol and name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                instrument.symbol,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                instrument.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        // Price and change
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              instrument.formattedPrice,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              instrument.formattedChangePercent,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getChangeColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        // Actions
        if (showAddButton) ...[
          const SizedBox(width: 8),
          _buildCompactActions(colorScheme),
        ],
      ],
    );
  }

  Widget _buildCompanyIcon(ColorScheme colorScheme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getTypeColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          instrument.symbol.substring(0, 1),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _getTypeColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              instrument.symbol,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            _buildTypeChip(theme, colorScheme),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          instrument.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTypeChip(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _getTypeColor().withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        instrument.typeDisplayName,
        style: theme.textTheme.labelSmall?.copyWith(
          color: _getTypeColor(),
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Favorite button
        IconButton(
          onPressed: onFavoriteToggle,
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_outline,
            color: isFavorite 
                ? Colors.amber 
                : colorScheme.onSurface.withOpacity(0.5),
          ),
          tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
          splashRadius: 20,
        ),
        
        // Add to portfolio button
        if (showAddButton)
          IconButton(
            onPressed: () => _showAddToPortfolioDialog(colorScheme),
            icon: Icon(
              Icons.add_circle_outline,
              color: colorScheme.primary,
            ),
            tooltip: 'Agregar al portafolio',
            splashRadius: 20,
          ),
      ],
    );
  }

  Widget _buildCompactActions(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFavorite)
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          ),
        if (showAddButton) ...[
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showAddToPortfolioDialog(colorScheme),
            child: Icon(
              Icons.add_circle_outline,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceInfo(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          instrument.formattedPrice,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${instrument.market} • Vol: ${instrument.formattedVolume}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniChart() {
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
        color: _getChangeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(
          instrument.isGaining ? Icons.trending_up : Icons.trending_down,
          color: _getChangeColor(),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPriceChange(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          instrument.formattedChange,
          style: theme.textTheme.titleMedium?.copyWith(
            color: _getChangeColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          instrument.formattedChangePercent,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: _getChangeColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            'Sector',
            instrument.sector,
            theme,
            colorScheme,
          ),
        ),
        if (instrument.marketCap != null)
          Expanded(
            child: _buildInfoItem(
              'Cap. Mercado',
              instrument.formattedMarketCap,
              theme,
              colorScheme,
            ),
          ),
        if (instrument.peRatio != null)
          Expanded(
            child: _buildInfoItem(
              'P/E',
              instrument.peRatio!.toStringAsFixed(1),
              theme,
              colorScheme,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoItem(
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

  Color _getTypeColor() {
    switch (instrument.type.toLowerCase()) {
      case 'stock':
        return Colors.blue;
      case 'etf':
        return Colors.green;
      case 'bond':
        return Colors.purple;
      case 'mutual_fund':
        return Colors.orange;
      case 'crypto':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Color _getChangeColor() {
    if (instrument.changePercent > 0) return Colors.green;
    if (instrument.changePercent < 0) return Colors.red;
    return Colors.grey;
  }

  Future<void> _showAddToPortfolioDialog(ColorScheme colorScheme) async {
    // This would be implemented in the actual dialog
    debugPrint('Show add to portfolio dialog for ${instrument.symbol}');
  }
}