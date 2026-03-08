import 'package:ev_products_app/feature/products/data/datasources/product_datasource.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';

class ProductRepositoryImpl extends ProductsRepository {
  final ProductDatasource remoteDatasource;

  ProductRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Product>> getListProducts(int limit, int offset) async {
    try {
      return  remoteDatasource.getListProducts(limit, offset);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categories = await remoteDatasource.getCategories();
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final featuredProducts = await remoteDatasource.getFeaturedProducts();
      return featuredProducts;
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
      final products = await remoteDatasource.getProductsByCategory(
        categoryId,
        limit,
        offset,
      );
      return products;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product> getProductDetail(int productId) async {
    try {
      final detail = await remoteDatasource.getProductDetail(productId);
      return detail;
    } catch (e) {
      rethrow;
    }
  }
}
