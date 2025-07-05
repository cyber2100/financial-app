// lib/domain/repositories/portfolio_repository.dart
import '../entities/portfolio_item.dart';

abstract class PortfolioRepository {
  Future<List<PortfolioItem>> getPortfolioItems();
  Future<bool> addPortfolioItem(PortfolioItem item);
  Future<bool> updatePortfolioItem(PortfolioItem item);
  Future<bool> removePortfolioItem(String itemId);
}