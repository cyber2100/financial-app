// lib/presentation/pages/market/market_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/market_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/cards/instrument_card.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/filter_tabs.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Load initial market data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final marketProvider = context.read<MarketProvider>();
      if (!marketProvider.hasData) {
        marketProvider.loadMarketData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final marketProvider = context.read<MarketProvider>();
    await marketProvider.refreshMarketData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Mercados'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          // Market status indicator
          Consumer<MarketProvider>(
            builder: (context, marketProvider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: marketProvider.isRealTimeConnected 
                            ? Colors.green 
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      marketProvider.isRealTimeConnected ? 'En vivo' : 'Diferido',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Search bar
                Consumer<MarketProvider>(
                  builder: (context, marketProvider, child) {
                    return CustomSearchBar(
                      hintText: 'Buscar acciones, ETFs, bonos...',
                      onChanged: marketProvider.updateSearchQuery,
                      value: marketProvider.searchQuery,
                    );
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Filter tabs
                Consumer<MarketProvider>(
                  builder: (context, marketProvider, child) {
                    return FilterTabs(
                      selectedFilter: marketProvider.selectedFilter,
                      onFilterChanged: marketProvider.setFilter,
                      filters: AppConstants.instrumentTypes,
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 1,
            color: colorScheme.outline.withOpacity(0.2),
          ),
          
          // Instruments list
          Expanded(
            child: Consumer2<MarketProvider, FavoritesProvider>(
              builder: (context, marketProvider, favoritesProvider, child) {
                // Loading state
                if (marketProvider.isLoading && !marketProvider.hasData) {
                  return const Center(
                    child: CustomLoadingIndicator(
                      message: 'Cargando datos del mercado...',
                    ),
                  );
                }

                // Error state
                if (marketProvider.hasError) {
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
                          'Error al cargar datos',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          marketProvider.errorMessage ?? 'Error desconocido',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: marketProvider.loadMarketData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty state
                if (marketProvider.filteredInstruments.isEmpty) {
                  return CustomEmptyState(
                    icon: marketProvider.searchQuery.isNotEmpty 
                        ? Icons.search_off 
                        : Icons.trending_up,
                    title: marketProvider.searchQuery.isNotEmpty
                        ? 'No se encontraron resultados'
                        : 'No hay instrumentos disponibles',
                    subtitle: marketProvider.searchQuery.isNotEmpty
                        ? 'Intenta ajustar tu búsqueda o filtros'
                        : 'Los datos del mercado no están disponibles',
                    actionText: 'Actualizar',
                    onAction: marketProvider.loadMarketData,
                  );
                }

                // Instruments list
                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.smallPadding,
                    ),
                    itemCount: marketProvider.filteredInstruments.length + 
                               (marketProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Loading indicator at the bottom
                      if (index == marketProvider.filteredInstruments.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppConstants.defaultPadding),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final instrument = marketProvider.filteredInstruments[index];
                      
                      return InstrumentCard(
                        instrument: instrument,
                        isFavorite: favoritesProvider.isFavorite(instrument.id),
                        onFavoriteToggle: () {
                          favoritesProvider.toggleFavorite(instrument.id);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}