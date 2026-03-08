
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';

class GetFeaturedProducts {
  final ProductsRepository productsRepository;

  GetFeaturedProducts({required this.productsRepository});

  Future<List<Product>> call() {
    return productsRepository.getFeaturedProducts();
  }
}