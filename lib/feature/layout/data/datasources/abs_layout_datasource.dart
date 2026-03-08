
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';

/// Contrato para proveer items de navegacion del layout.
abstract class AbsLayoutDatasource {
  Future<List<PageItem>> getPageItems();
}
