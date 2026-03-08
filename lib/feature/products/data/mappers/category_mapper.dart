
import 'package:ev_products_app/feature/products/data/models/category_model.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';

/// Mapper entre modelo de categoria y entidad de dominio.
class CategoryMapper {

  static Category modelToDomain(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.name,
      slug: model.slug,
      image: model.image,
    );
  }

  static Map<String, dynamic> categoryToMap(Category category) {
    return {
      'id': category.id,
      'name': category.name,
      'slug': category.slug,
      'image': category.image,
    };
  }

  static Category categoryFromMap(Map<String, dynamic> map) {
    return Category(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: (map['name'] ?? '').toString(),
      slug: (map['slug'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
    );
  }
}
