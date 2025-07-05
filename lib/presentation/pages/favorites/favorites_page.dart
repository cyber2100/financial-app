// lib/presentation/pages/favorites/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/market_provider.dart';
import '../../widgets/cards/instrument_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoritesProvider = context.read<FavoritesProvider>();
      if (!favoritesProvider.isInitialized) {
        favoritesProvider.loadFavorites();
      }
    });
  }

  Future<void> _handleRefresh() async {
    final favoritesProvider = context.read<FavoritesProvider>();
    await favoritesProvider.refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              if (favoritesProvider.favorites.isEmpty) return const SizedBox.shrink();
              
              return PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'clear_all':
                      _showClearAllDialog(context);
                      break;
                    case 'sort':
                      _showSortOptions(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'sort',
                    child: Row(
                      children: [
                        Icon(Icons.sort),
                        SizedBox(width: 8),
                        Text('Ordenar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Limpiar Todo', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer2<FavoritesProvider, MarketProvider>(
        builder: (context, favoritesProvider, marketProvider, child) {
          // Loading state
          if (favoritesProvider.isLoading && !favoritesProvider.isInitialized) {
            return const Center(
              child: CustomLoadingIndicator(
                message: 'Cargando favoritos...',
              ),
            );
          }

          // Error state
          if (favoritesProvider.hasError) {
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
                    'Error al cargar favoritos',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    favoritesProvider.errorMessage ?? 'Error desconocido',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: favoritesProvider.loadFavorites,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (favoritesProvider.favorites.isEmpty) {
            return CustomEmptyState(
              icon: Icons.star_outline,
              title: 'Sin favoritos',
              subtitle: 'Agrega instrumentos a favoritos desde la página de mercados para verlos aquí',
              actionText: 'Explorar Mercados',
              onAction: () {
                // Navigate to markets page
                DefaultTabController.of(context)?.animateTo(0);
              },
            );
          }

          // Get favorite instruments from market data
          final favoriteInstruments = marketProvider.instruments
              .where((instrument) => favoritesProvider.isFavorite(instrument.id))
              .toList();

          // Sort based on current sort preference
          _sortInstruments(favoriteInstruments, favoritesProvider.sortBy);

          return Column(
            children: [
              // Summary card
              if (favoriteInstruments.isNotEmpty)
                _buildSummaryCard(favoriteInstruments, theme, colorScheme),
              
              // Favorites list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: favoriteInstruments.isEmpty
                      ? CustomEmptyState(
                          icon: Icons.star_border,
                          title: 'Favoritos no disponibles',
                          subtitle: 'Los instrumentos favoritos no están disponibles en este momento',
                          actionText: 'Actualizar',
                          onAction: _handleRefresh,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.smallPadding,
                          ),
                          itemCount: favoriteInstruments.length,
                          itemBuilder: (context, index) {
                            final instrument = favoriteInstruments[index];
                            
                            return InstrumentCard(
                              instrument: instrument,
                              isFavorite: true,
                              onFavoriteToggle: () {
                                favoritesProvider.removeFavorite(instrument.id);
                              },
                              onTap: () {
                                // Navigate to instrument detail page
                                Navigator.of(context).pushNamed(
                                  AppConstants.instrumentDetailRoute,
                                  arguments: {'instrumentId': instrument.id},
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    List<dynamic> instruments,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final gainers = instruments.where((i) => i.changePercent > 0).length;
    final losers = instruments.where((i) => i.changePercent < 0).length;
    final unchanged = instruments.length - gainers - losers;

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen de Favoritos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${instruments.length} instrumentos',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Subiendo',
                  gainers.toString(),
                  Colors.green,
                  Icons.trending_up,
                  theme,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Bajando',
                  losers.toString(),
                  Colors.red,
                  Icons.trending_down,
                  theme,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Sin cambio',
                  unchanged.toString(),
                  Colors.grey,
                  Icons.trending_flat,
                  theme,
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
    Color color,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  void _sortInstruments(List<dynamic> instruments, String sortBy) {
    switch (sortBy) {
      case 'symbol':
        instruments.sort((a, b) => a.symbol.compareTo(b.symbol));
        break;
      case 'price':
        instruments.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'change':
        instruments.sort((a, b) => b.changePercent.compareTo(a.changePercent));
        break;
      case 'volume':
        instruments.sort((a, b) => b.volume.compareTo(a.volume));
        break;
      default:
        // Keep original order
        break;
    }
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Favoritos'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todos los instrumentos de favoritos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FavoritesProvider>().clearAllFavorites();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Limpiar Todo'),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ordenar favoritos por',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Símbolo (A-Z)'),
              leading: const Icon(Icons.sort_by_alpha),
              onTap: () {
                Navigator.pop(context);
                context.read<FavoritesProvider>().setSortBy('symbol');
              },
            ),
            ListTile(
              title: const Text('Precio (Mayor a Menor)'),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.pop(context);
                context.read<FavoritesProvider>().setSortBy('price');
              },
            ),
            ListTile(
              title: const Text('Cambio (Mayor a Menor)'),
              leading: const Icon(Icons.trending_up),
              onTap: () {
                Navigator.pop(context);
                context.read<FavoritesProvider>().setSortBy('change');
              },
            ),
            ListTile(
              title: const Text('Volumen (Mayor a Menor)'),
              leading: const Icon(Icons.bar_chart),
              onTap: () {
                Navigator.pop(context);
                context.read<FavoritesProvider>().setSortBy('volume');
              },
            ),
          ],
        ),
      ),
    );
  }
}