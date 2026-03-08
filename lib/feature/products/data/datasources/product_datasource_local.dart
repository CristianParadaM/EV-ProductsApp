import 'dart:convert';

import 'package:ev_products_app/core/storage/sqlite_key_value_cache.dart';
import 'package:ev_products_app/feature/products/data/datasources/product_datasource.dart';
import 'package:ev_products_app/feature/products/data/mappers/category_mapper.dart';
import 'package:ev_products_app/feature/products/data/mappers/product_mapper.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';

/// Datasource local de productos basado en cache SQLite.
///
/// Persiste listado, destacados, categorias y detalle para fallback offline.
class ProductDatasourceLocal extends ProductDatasource {
  final SqliteKeyValueCache _storage;

  ProductDatasourceLocal(this._storage);

  static const _productsPrefix = 'products_page_';
  static const _featuredKey = 'products_featured';
  static const _categoriesKey = 'products_categories';
  static const _detailPrefix = 'products_detail_';

  String _productsPageKey(int limit, int offset) =>
      '$_productsPrefix${limit}_$offset';

  String _detailKey(int productId) => '$_detailPrefix$productId';

  @override
  Future<List<Product>> getListProducts(int limit, int offset) async {
    final raw = await _storage.readString(_productsPageKey(limit, offset));
    if (raw == null || raw.isEmpty) {
      throw Exception('No hay productos en cache');
    }

    return _decodeProducts(raw);
  }

  Future<void> cacheListProducts(
    int limit,
    int offset,
    List<Product> products,
  ) async {
    final encoded = jsonEncode(
      products.map(ProductMapper.productToMap).toList(),
    );
    await _storage.writeString(_productsPageKey(limit, offset), encoded);

    for (final product in products) {
      await cacheProductDetail(product);
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    final raw = await _storage.readString(_categoriesKey);
    if (raw == null || raw.isEmpty) {
      throw Exception('No hay categorias en cache');
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(CategoryMapper.categoryFromMap)
        .toList();
  }

  Future<void> cacheCategories(List<Category> categories) async {
    final encoded = jsonEncode(
      categories.map(CategoryMapper.categoryToMap).toList(),
    );
    await _storage.writeString(_categoriesKey, encoded);
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    final raw = await _storage.readString(_featuredKey);
    if (raw == null || raw.isEmpty) {
      throw Exception('No hay productos destacados en cache');
    }

    return _decodeProducts(raw);
  }

  Future<void> cacheFeaturedProducts(List<Product> products) async {
    final encoded = jsonEncode(
      products.map(ProductMapper.productToMap).toList(),
    );
    await _storage.writeString(_featuredKey, encoded);

    for (final product in products) {
      await cacheProductDetail(product);
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
    int categoryId,
    int limit,
    int offset,
  ) async {
    final products = await getListProducts(limit, offset);
    return products.where((p) => p.category.id == categoryId).toList();
  }

  @override
  Future<Product> getProductDetail(int productId) async {
    final raw = await _storage.readString(_detailKey(productId));

    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return ProductMapper.productFromMap(decoded);
    }

    // Fallback secundario: buscar en destacados si no existe detalle dedicado.
    final featured = await _safeGetProducts(_featuredKey);
    for (final product in featured) {
      if (product.id == productId) {
        return product;
      }
    }

    throw Exception('No hay detalle del producto en cache');
  }

  Future<void> cacheProductDetail(Product product) async {
    final encoded = jsonEncode(ProductMapper.productToMap(product));
    await _storage.writeString(_detailKey(product.id), encoded);
  }

  Future<List<Product>> _safeGetProducts(String key) async {
    final raw = await _storage.readString(key);
    if (raw == null || raw.isEmpty) {
      return const <Product>[];
    }
    return _decodeProducts(raw);
  }

  List<Product> _decodeProducts(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ProductMapper.productFromMap)
        .toList();
  }
}
