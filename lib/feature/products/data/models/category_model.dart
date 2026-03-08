class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String image;
  final String creationAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  static List<CategoryModel> fromJson(List<dynamic> jsonList) {
    return jsonList
        .whereType<Map>()
        .map(
          (json) => CategoryModel(
            id: (json['id'] as num?)?.toInt() ?? 0,
            name: (json['name'] ?? '').toString(),
            slug: (json['slug'] ?? '').toString(),
            image: (json['image'] ?? '').toString(),
            creationAt: (json['creationAt'] ?? '').toString(),
            updatedAt: (json['updatedAt'] ?? '').toString(),
          ),
        )
        .toList();
  }

}