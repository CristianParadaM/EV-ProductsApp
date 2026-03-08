
import 'package:ev_products_app/feature/products/data/mappers/category_mapper.dart';
import 'package:ev_products_app/feature/products/data/models/product_model.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';

class ProductMapper {
  static Product modelToDomain(ProductModel model) {
    return Product(
      id: model.id,
      name: model.title,
      slug: model.slug,
      price: model.price,
      pricediscount: null,
      category: Category(
        id: (model.category['id'] as int?) ?? 0,
        name: model.category['name'] ?? '',
        slug: model.category['slug'] ?? '',
        image: model.category['image'] ?? '',
      ),
      description: model.description,
      imagesUrl: model.images,
    );
  }

  static Map<String, dynamic> productToMap(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'slug': product.slug,
      'price': product.price,
      'pricediscount': product.pricediscount,
      'description': product.description,
      'imagesUrl': product.imagesUrl,
      'category': CategoryMapper.categoryToMap(product.category),
    };
  }

  static Product productFromMap(Map<String, dynamic> map) {
    return Product(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: (map['name'] ?? '').toString(),
      slug: (map['slug'] ?? '').toString(),
      price: (map['price'] as num?)?.toDouble() ?? 0,
      pricediscount: (map['pricediscount'] as num?)?.toDouble(),
      category: CategoryMapper.categoryFromMap(
        Map<String, dynamic>.from((map['category'] as Map?) ?? const {}),
      ),
      description: (map['description'] ?? '').toString(),
      imagesUrl:
          (map['imagesUrl'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          const <String>[],
    );
  }

}
