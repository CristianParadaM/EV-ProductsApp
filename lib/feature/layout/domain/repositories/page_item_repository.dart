
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';

/// Contrato de acceso a items de navegacion.
abstract class PageItemRepository {
  Future<List<PageItem>> getPageItems();
}
