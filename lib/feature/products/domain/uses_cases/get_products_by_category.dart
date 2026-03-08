
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';

/// Caso de uso para listar productos por categoria.
class GetProductsByCategory {
  final ProductsRepository productsRepository;

  GetProductsByCategory({required this.productsRepository});
  
  Future<List<Product>> call(int limit, int offset) {
    return productsRepository.getListProducts(limit, offset);
  }
}