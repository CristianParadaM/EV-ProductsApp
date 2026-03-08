import 'dart:async';

import 'package:ev_products_app/core/http/client_api.dart';
import 'package:ev_products_app/feature/products/data/datasources/product_datasource.dart';
import 'package:ev_products_app/feature/products/data/mappers/category_mapper.dart';
import 'package:ev_products_app/feature/products/data/mappers/product_mapper.dart';
import 'package:ev_products_app/feature/products/data/models/category_model.dart';
import 'package:ev_products_app/feature/products/data/models/product_model.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';

class ProductDatasourceAPI extends ProductDatasource {
  final ClientApi clientApi;

  ProductDatasourceAPI(this.clientApi);

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
      return data
          .map((category) => CategoryMapper.modelToDomain(category))
          .toList();
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
      final products = data.map((product) {
        final productDomain = ProductMapper.modelToDomain(product);
        productDomain.applyRandomDiscount();
        return productDomain;
      }).toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
    int categoryId,
    int limit,
    int offset,
  ) async {
    try {
      final response = await clientApi.get(
        '/api/v1/categories/$categoryId/products',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = ProductModel.fromListJson(response.data);
      final products = data
          .map((product) => ProductMapper.modelToDomain(product))
          .toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product> getProductDetail(int productId) async {
    try {
      final response = await clientApi.get('/api/v1/products/$productId');
      final data = ProductModel.fromJson(response.data);
      final product = ProductMapper.modelToDomain(data);
      return product;
    } catch (e) {
      rethrow;
    }
  }
}
