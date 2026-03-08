import 'package:ev_products_app/feature/layout/data/datasources/abs_layout_datasource.dart';
import 'package:ev_products_app/feature/layout/domain/entities/page_item.dart';
import 'package:flutter/material.dart';

/// Fuente local de tabs de navegacion.
///
/// Mantiene un catalogo estatico de rutas para que la UI no dependa de red.
class LayoutDatasourceLocal extends AbsLayoutDatasource {

  @override
  Future<List<PageItem>> getPageItems() async {
    return [
      PageItem(
        index: 0,
        name: 'products',
        icon: Icons.shopping_bag,
        path: '/products',
      ),
      PageItem(
        index: 1,
        name: 'cart',
        icon: Icons.shopping_cart,
        path: '/cart',
      ),
      PageItem(
        index: 2,
        name: 'settings',
        icon: Icons.settings,
        path: '/settings',
      ),
    ];
  }
}
