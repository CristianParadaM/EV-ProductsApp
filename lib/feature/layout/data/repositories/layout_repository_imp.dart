
import 'package:ev_products_app/feature/layout/data/datasources/abs_layout_datasource.dart';
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';
import 'package:ev_products_app/feature/layout/domain/repositories/page_item_repository.dart';

/// Implementacion de repositorio para items del layout.
class LayoutRepositoryImp implements PageItemRepository{
  final AbsLayoutDatasource datasource;

  LayoutRepositoryImp({required this.datasource});

  @override
  Future<List<PageItem>> getPageItems() async {
    return await datasource.getPageItems();
  }
}