class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final Map<String, dynamic> category;
  final List<String> images;
  final String creationAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  static List<ProductModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .whereType<Map>()
        .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: (json['description'] ?? '').toString(),
      category: Map<String, dynamic>.from(
        (json['category'] as Map?) ?? const {},
      ),
      images:
          (json['images'] as List?)?.map((item) => item.toString()).toList() ??
          const [],
      creationAt: (json['creationAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
    );
  }
}
