import 'dart:math';

import 'package:ev_products_app/feature/products/domain/entities/category.dart';

/// Entidad de dominio principal para producto.
class Product {
  final int id;
  final String name;
  final String slug;
  final double price;
  double? pricediscount;
  final Category category;
  final String description;
  final List<String> imagesUrl;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.pricediscount,
    required this.category,
    required this.description,
    required this.imagesUrl,
  });

  void applyRandomDiscount() {
    // Regla de negocio visual: descuento aleatorio entre 30% y 40%.
    final random = Random();
    int discountPercent = 30 + random.nextInt(11);
    pricediscount = price * (1 - discountPercent / 100);
  }
}
