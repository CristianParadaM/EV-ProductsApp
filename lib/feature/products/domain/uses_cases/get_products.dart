
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';

class GetProducts {
  final ProductsRepository productsRepository;

  GetProducts({required this.productsRepository});
  
  Future<List<Product>> call(int limit, int offset) {
    return productsRepository.getListProducts(limit, offset);
  }
}