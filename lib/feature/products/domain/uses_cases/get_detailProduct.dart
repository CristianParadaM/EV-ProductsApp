
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';

/// Caso de uso para consultar detalle de un producto.
class GetProductDetail {
  final ProductsRepository productsRepository;

  GetProductDetail({required this.productsRepository});

  Future<Product> call(int productId) {
    return productsRepository.getProductDetail(productId);
  }
}