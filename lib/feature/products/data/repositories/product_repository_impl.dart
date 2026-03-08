import 'package:ev_products_app/feature/products/data/datasources/product_datasource.dart';
import 'package:ev_products_app/feature/products/data/datasources/product_datasource_local.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';

class ProductRepositoryImpl extends ProductsRepository {
  ProductRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final ProductDatasource remoteDatasource;
  final ProductDatasourceLocal localDatasource;

  @override
  Future<List<Product>> getListProducts(int limit, int offset) async {
    try {
      final products = await remoteDatasource.getListProducts(limit, offset);
      await localDatasource.cacheListProducts(limit, offset, products);
      return products;
    } catch (_) {
      return localDatasource.getListProducts(limit, offset);
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categories = await remoteDatasource.getCategories();
      await localDatasource.cacheCategories(categories);
      return categories;
    } catch (_) {
      return localDatasource.getCategories();
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final featuredProducts = await remoteDatasource.getFeaturedProducts();
      await localDatasource.cacheFeaturedProducts(featuredProducts);
      return featuredProducts;
    } catch (_) {
      return localDatasource.getFeaturedProducts();
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
    int categoryId,
    int limit,
    int offset,
  ) async {
    try {
      final products = await remoteDatasource.getProductsByCategory(
        categoryId,
        limit,
        offset,
      );
      return products;
    } catch (_) {
      return localDatasource.getProductsByCategory(categoryId, limit, offset);
    }
  }
  
  @override
  Future<Product> getProductDetail(int productId) async {
    try {
      final detail = await remoteDatasource.getProductDetail(productId);
      await localDatasource.cacheProductDetail(detail);
      return detail;
    } catch (_) {
      return localDatasource.getProductDetail(productId);
    }
  }
}
