import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';

/// Contrato de datasource para catalogo de productos.
abstract class ProductDatasource {
  Future<List<Product>> getListProducts(int limit, int offset);
  Future<List<Product>> getFeaturedProducts();
  Future<List<Category>> getCategories();
  Future<List<Product>> getProductsByCategory(int categoryId, int limit, int offset);
  Future<Product> getProductDetail(int productId);
}
