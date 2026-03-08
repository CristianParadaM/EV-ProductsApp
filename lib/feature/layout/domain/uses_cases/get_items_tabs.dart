
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';
import 'package:ev_products_app/feature/layout/domain/repositories/page_item_repository.dart';

/// Caso de uso para cargar las tabs disponibles en el layout principal.
class GetItemsTabsUseCase {
  final PageItemRepository repository;

  GetItemsTabsUseCase({required this.repository});

  Future<List<PageItem>> call() async {
    return await repository.getPageItems();
  }
}