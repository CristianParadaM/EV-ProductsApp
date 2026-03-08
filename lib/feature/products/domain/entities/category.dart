/// Entidad de dominio para categoria de productos.
class Category {
  final int id;
  final String name;
  final String slug;
  final String image;

  Category({required this.id, required this.name, required this.slug, required this.image});
}
