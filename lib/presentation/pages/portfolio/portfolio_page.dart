// lib/presentation/pages/portfolio/portfolio_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/portfolio_provider.dart';
import '../../widgets/cards/portfolio_card.dart';
import '../../widgets/charts/portfolio_pie_chart.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final portfolioProvider = context.read<PortfolioProvider>();
      if (!portfolioProvider.hasData) {
        portfolioProvider.loadPortfolio();
      }
    });
  }

  Future<void> _handleRefresh() async {
    final portfolioProvider = context.read<PortfolioProvider>();
    await portfolioProvider.refreshPortfolio();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Mi Portafolio'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Show portfolio analytics
              _showPortfolioAnalytics(context);
            },
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Análisis del portafolio',
          ),
          IconButton(
            onPressed: () {
              // Show portfolio settings
              _showPortfolioSettings(context);
            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'Más opciones',
          ),
        ],
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, portfolioProvider, child) {
          // Loading state
          if (portfolioProvider.isLoading && !portfolioProvider.hasData) {
            return const Center(
              child: CustomLoadingIndicator(
                message: 'Cargando tu portafolio...',
              ),
            );
          }

          // Error state
          if (portfolioProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar portafolio',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    portfolioProvider.errorMessage ?? 'Error desconocido',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: portfolioProvider.loadPortfolio,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (portfolioProvider.portfolio.isEmpty) {
            return CustomEmptyState(
              icon: Icons.pie_chart_outline,
              title: 'Tu portafolio está vacío',
              subtitle: 'Comienza agregando instrumentos financieros desde la página de mercados',
              actionText: 'Explorar Mercados',
              onAction: () {
                // Navigate to markets page
                DefaultTabController.of(context)?.animateTo(0);
              },
            );
          }

          // Portfolio content
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              slivers: [
                // Portfolio summary
                SliverToBoxAdapter(
                  child: _buildPortfolioSummary(portfolioProvider, theme, colorScheme),
                ),
                
                // Portfolio chart
                SliverToBoxAdapter(
                  child: _buildPortfolioChart(portfolioProvider, theme, colorScheme),
                ),
                
                // Portfolio positions header
                SliverToBoxAdapter(
                  child: _buildPositionsHeader(theme, colorScheme),
                ),
                
                // Portfolio positions list
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == portfolioProvider.portfolio.length) {
                        return portfolioProvider.isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(AppConstants.defaultPadding),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }

                      final position = portfolioProvider.portfolio[index];
                      return PortfolioCard(
                        position: position,
                        onTap: () => _showPositionDetails(context, position),
                        onEdit: () => _editPosition(context, position),
                        onRemove: () => _removePosition(context, position),
                      );
                    },
                    childCount: portfolioProvider.portfolio.length + 
                               (portfolioProvider.isLoading ? 1 : 0),
                  ),
                ),
                
                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.largePadding),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortfolioSummary(
    PortfolioProvider portfolioProvider,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final summary = portfolioProvider.portfolioSummary;

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valor Total',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
              Icon(
                summary.isPositive ? Icons.trending_up : Icons.trending_down,
                color: colorScheme.onPrimary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(summary.totalValue),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                CurrencyFormatter.formatPriceChange(summary.totalGainLoss),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${CurrencyFormatter.formatPercentWithSign(summary.totalGainLossPercent)})',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Invertido',
                  CurrencyFormatter.format(summary.totalCost),
                  theme,
                  colorScheme,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Posiciones',
                  summary.totalPositions.toString(),
                  theme,
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
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
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimary.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioChart(
    PortfolioProvider portfolioProvider,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distribución del Portafolio',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PortfolioPieChart(
                  portfolio: portfolioProvider.portfolio,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionsHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mis Posiciones',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _sortPositions(context),
                icon: const Icon(Icons.sort),
                tooltip: 'Ordenar',
              ),
              IconButton(
                onPressed: () => _filterPositions(context),
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filtrar',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPortfolioAnalytics(BuildContext context) {
    // Implementation for portfolio analytics
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Análisis del Portafolio'),
        content: const Text('Funcionalidad de análisis en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showPortfolioSettings(BuildContext context) {
    // Implementation for portfolio settings
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Exportar Portafolio'),
              onTap: () {
                Navigator.pop(context);
                // Export functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                // Settings functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda'),
              onTap: () {
                Navigator.pop(context);
                // Help functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPositionDetails(BuildContext context, dynamic position) {
    // Implementation for showing position details
    Navigator.pushNamed(
      context,
      '/position-detail',
      arguments: position,
    );
  }

  void _editPosition(BuildContext context, dynamic position) {
    // Implementation for editing position
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Posición'),
        content: const Text('Funcionalidad de edición en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _removePosition(BuildContext context, dynamic position) {
    // Implementation for removing position
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Posición'),
        content: Text('¿Estás seguro de que quieres eliminar ${position.symbol}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PortfolioProvider>().removePosition(position.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _sortPositions(BuildContext context) {
    // Implementation for sorting positions
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ordenar por',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Valor (Mayor a Menor)'),
              onTap: () {
                Navigator.pop(context);
                context.read<PortfolioProvider>().sortByValue();
              },
            ),
            ListTile(
              title: const Text('Ganancia/Pérdida'),
              onTap: () {
                Navigator.pop(context);
                context.read<PortfolioProvider>().sortByGainLoss();
              },
            ),
            ListTile(
              title: const Text('Símbolo (A-Z)'),
              onTap: () {
                Navigator.pop(context);
                context.read<PortfolioProvider>().sortBySymbol();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _filterPositions(BuildContext context) {
    // Implementation for filtering positions
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar Posiciones'),
        content: const Text('Funcionalidad de filtros en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}