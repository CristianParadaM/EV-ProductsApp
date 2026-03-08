
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/repositories/products_repository.dart';

/// Caso de uso para obtener categorias del catalogo.
class GetCategories {
  final ProductsRepository productsRepository;

  GetCategories({required this.productsRepository});
  
  Future<List<Category>> call() {
    return productsRepository.getCategories();
  }
}