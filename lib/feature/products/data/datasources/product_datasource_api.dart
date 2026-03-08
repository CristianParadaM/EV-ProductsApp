import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ev_products_app/core/http/client_api.dart';
import 'package:ev_products_app/feature/products/data/datasources/product_datasource.dart';
import 'package:ev_products_app/feature/products/data/mappers/category_mapper.dart';
import 'package:ev_products_app/feature/products/data/mappers/product_mapper.dart';
import 'package:ev_products_app/feature/products/data/models/category_model.dart';
import 'package:ev_products_app/feature/products/data/models/product_model.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';

/// Datasource remoto de productos sobre API HTTP.
///
/// Incluye pre-calentamiento de imagenes en cache para mejorar UX en scroll.
class ProductDatasourceAPI extends ProductDatasource {
  final ClientApi clientApi;
  final BaseCacheManager _cacheManager;

  ProductDatasourceAPI(this.clientApi) : _cacheManager = DefaultCacheManager();

  Future<void> _primeImage(String url) async {
    if (url.isEmpty) {
      return;
    }

    try {
      await _cacheManager.downloadFile(url, force: false);
    } catch (_) {
      // Si falla la descarga del cache, no bloqueamos la carga principal.
    }
  }

  void _primeProductImages(List<Product> products) {
    // Se deduplican URLs para evitar descargas repetidas innecesarias.
    final urls = <String>{
      for (final product in products) ...product.imagesUrl.where((url) => url.isNotEmpty),
    };

    for (final url in urls) {
      unawaited(_primeImage(url));
    }
  }

  void _primeCategoryImages(List<Category> categories) {
    for (final category in categories) {
      unawaited(_primeImage(category.image));
    }
  }

  @override
  Future<List<Product>> getListProducts(int limit, int offset) async {
    try {
      final response = await clientApi.get(
        '/api/v1/products',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = ProductModel.fromListJson(response.data);
      final products = data
          .map((product) => ProductMapper.modelToDomain(product))
          .toList();
      _primeProductImages(products);
      return products;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await clientApi.get(
        '/api/v1/categories',
        queryParameters: {'limit': 5},
      );
      final data = CategoryModel.fromJson(response.data);
      final categories = data
          .map((category) => CategoryMapper.modelToDomain(category))
          .toList();
      _primeCategoryImages(categories);
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await clientApi.get(
        '/api/v1/products',
        queryParameters: {'limit': 10, 'offset': 30},
      );
      final data = ProductModel.fromListJson(response.data);
      final products = data
          .map((product){
            final productDomain = ProductMapper.modelToDomain(product);
            productDomain.applyRandomDiscount(); 
            return productDomain;
          })
          .toList();
      _primeProductImages(products);
      return products;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(int categoryId, int limit, int offset) async {
    try {
      final response = await clientApi.get(
        '/api/v1/categories/$categoryId/products',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = ProductModel.fromListJson(response.data);
      final products = data
          .map((product) => ProductMapper.modelToDomain(product))
          .toList();
      _primeProductImages(products);
      return products;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<Product> getProductDetail(int productId) async {
   try {
      final response = await clientApi.get(
        '/api/v1/products/$productId',
      );
      final data = ProductModel.fromJson(response.data);
      final product = ProductMapper.modelToDomain(data);
      _primeProductImages([product]);
      return product;
    } catch (e) {
      rethrow;
    }
  }
}
