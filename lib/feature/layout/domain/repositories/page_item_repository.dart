
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';

abstract class PageItemRepository {
  Future<List<PageItem>> getPageItems();
}
