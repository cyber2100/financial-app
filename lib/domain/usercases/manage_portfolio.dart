// lib/domain/usecases/manage_portfolio.dart
import '../entities/portfolio_item.dart';
import '../repositories/portfolio_repository.dart';

class ManagePortfolioUseCase {
  final PortfolioRepository repository;

  ManagePortfolioUseCase(this.repository);

  Future<List<PortfolioItem>> getPortfolioItems() async {
    return await repository.getPortfolioItems();
  }

  Future<bool> addPosition({
    required String instrumentId,
    required String symbol,
    required String name,
    required double quantity,
    required double averageCost,
    String? notes,
  }) async {
    final portfolioItem = PortfolioItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      instrumentId: instrumentId,
      symbol: symbol,
      name: name,
      quantity: quantity,
      averageCost: averageCost,
      currentPrice: averageCost,
      totalCost: quantity * averageCost,
      currentValue: quantity * averageCost,
      purchaseDate: DateTime.now(),
      lastUpdated: DateTime.now(),
      notes: notes,
      transactions: [],
    );

    return await repository.addPortfolioItem(portfolioItem);
  }

  Future<bool> updatePosition(PortfolioItem item) async {
    return await repository.updatePortfolioItem(item);
  }

  Future<bool> removePosition(String itemId) async {
    return await repository.removePortfolioItem(itemId);
  }
}