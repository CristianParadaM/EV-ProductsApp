
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';

abstract class AbsLayoutDatasource {
  Future<List<PageItem>> getPageItems();
}
