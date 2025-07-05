// lib/presentation/widgets/cards/instrument_card.dart
// Example showing how to integrate the AddToPortfolioDialog in an instrument card

import 'package:flutter/material.dart';
import '../../domain/entities/instrument.dart';
import '../../dialogs/add_to_portfolio_dialog.dart';
import '../../../utils/formatters.dart';

class InstrumentCard extends StatelessWidget {
  final Instrument instrument;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const InstrumentCard({
    super.key,
    required this.instrument,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header row with symbol, type, and actions
              Row(
                children: [
                  // Company logo placeholder
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        instrument.symbol.substring(0, 1),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
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
                        Row(
                          children: [
                            Text(
                              instrument.symbol,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getTypeColor(instrument.type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                instrument.typeDisplayName,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _getTypeColor(instrument.type),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          instrument.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Action buttons
                  Row(
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
                        tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      ),
                      
                      // Add to portfolio button
                      IconButton(
                        onPressed: () => _showAddToPortfolioDialog(context),
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: colorScheme.primary,
                        ),
                        tooltip: 'Add to portfolio',
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Price and change information
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Current price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CurrencyFormatter.format(instrument.price),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${instrument.market} • Vol: ${CurrencyFormatter.formatVolume(instrument.volume)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Mini chart placeholder
                  Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: instrument.isGaining 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Icon(
                        instrument.isGaining ? Icons.trending_up : Icons.trending_down,
                        color: instrument.isGaining ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Price change
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.formatPriceChange(instrument.change),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: instrument.isGaining ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatPercentWithSign(instrument.changePercent),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: instrument.isGaining ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
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

  Future<void> _showAddToPortfolioDialog(BuildContext context) async {
    final result = await AddToPortfolioHelper.showAddDialog(
      context,
      instrument,
    );

    if (result == true && context.mounted) {
      // Successfully added to portfolio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Added ${instrument.symbol} to your portfolio',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View Portfolio',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to portfolio screen
              Navigator.of(context).pushNamed('/portfolio');
            },
          ),
        ),
      );
    }
  }
}

// lib/presentation/pages/market/market_page.dart
// Example showing how to use the InstrumentCard in a page

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/market_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/cards/instrument_card.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/filter_tabs.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    super.initState();
    // Load market data when page is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketProvider>().refreshMarketData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          // Real-time indicator
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
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      marketProvider.isRealTimeConnected ? 'Live' : 'Offline',
                      style: Theme.of(context).textTheme.labelSmall,
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
          // Search and filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                Consumer<MarketProvider>(
                  builder: (context, marketProvider, child) {
                    return CustomSearchBar(
                      hintText: 'Search stocks, ETFs, bonds...',
                      onChanged: marketProvider.updateSearchQuery,
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
                      filters: const ['All', 'Stocks', 'ETFs', 'Bonds'],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Instruments list
          Expanded(
            child: Consumer2<MarketProvider, FavoritesProvider>(
              builder: (context, marketProvider, favoritesProvider, child) {
                if (marketProvider.isLoading && marketProvider.instruments.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (marketProvider.filteredInstruments.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No instruments found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Try adjusting your search or filter criteria',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: marketProvider.refreshMarketData,
                  child: ListView.builder(
                    itemCount: marketProvider.filteredInstruments.length,
                    itemBuilder: (context, index) {
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
                            '/instrument-detail',
                            arguments: instrument,
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

// Example of how to call the add dialog from a floating action button
class MarketPageWithFAB extends StatelessWidget {
  const MarketPageWithFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MarketPage(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showQuickAddDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Investment'),
      ),
    );
  }

  Future<void> _showQuickAddDialog(BuildContext context) async {
    // Show a search dialog to select an instrument first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Investment'),
        content: const Text(
          'Search for an instrument in the market list and tap the + button to add it to your portfolio.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}